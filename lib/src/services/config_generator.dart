import 'dart:io';

import 'package:chalkdart/chalk.dart';
import 'package:loki/src/errors/errors.dart';
import 'package:loki/src/models/models.dart';
import 'package:loki/src/services/cache.dart';
import 'package:loki/src/services/validator.dart';
import 'package:yaml/yaml.dart';

class _RootConfigValidationRules {
  Validator name;
  Validator description;
  Validator packages;
  Validator scripts;
  _RootConfigValidationRules(
      {required this.name,
      required this.description,
      required this.packages,
      required this.scripts});
}

class _ScriptConfigValidationRules {
  Validator root;
  Validator command;
  Validator name;
  Validator description;
  Validator exec;
  Validator workingDir;
  Validator stdin;
  _ScriptConfigValidationRules(
      {required this.root,
      required this.command,
      required this.name,
      required this.description,
      required this.exec,
      required this.stdin,
      required this.workingDir});
}

var _isRequired = (data) => data != null;
var _isString = (data) => data.runtimeType == String;
var _isNullOrString = (data) => data == null || data.runtimeType == String;
var _isNullOrYamlList = (data) => data == null || data.runtimeType == YamlList;
var _isYamlMap = (data) => data.runtimeType == YamlMap;
var _isNullOrYamlMap = (data) => data == null || data.runtimeType == YamlMap;
var _isNullOrBool = (data) => data == null || data.runtimeType == bool;

var _vIsRequired =
    ValidationRules(check: _isRequired, message: ([_]) => 'is required');
var _vIsString =
    ValidationRules(check: _isString, message: ([_]) => 'should be string');

var _vIsNullOrString = ValidationRules(
    check: _isNullOrString, message: ([_]) => 'should be string');

var _vIsNullOrYamlList = ValidationRules(
    check: _isNullOrYamlList, message: ([_]) => 'should be a list');

var _vIsNullOrListOfString = ValidationRules(
    check: (data) =>
        data == null ||
        (data.runtimeType == YamlList &&
            (data as YamlList).every((e) => e.runtimeType == String)),
    message: ([_]) => 'should be a list of strings');

var _vIsNullOrYamlMap = ValidationRules(
    check: _isNullOrYamlMap, message: ([_]) => 'should be a map');

var _vIsYamlMap =
    ValidationRules(check: _isYamlMap, message: ([_]) => 'should be a map');

var _vIsNullOrBool =
    ValidationRules(check: _isNullOrBool, message: ([_]) => 'should be bool');

_RootConfigValidationRules _rootRules = _RootConfigValidationRules(
    name: Validator(
        messagePrefix: ([_]) => chalk.yellowBright('name'),
        rules: [_vIsRequired, _vIsString]),
    description: Validator(
        messagePrefix: ([_]) => chalk.yellowBright('description'),
        rules: [_vIsNullOrString]),
    packages: Validator(
        messagePrefix: ([_]) => chalk.yellowBright('packages'),
        rules: [_vIsNullOrYamlList, _vIsNullOrListOfString]),
    scripts: Validator(
        messagePrefix: ([_]) => chalk.yellowBright('scripts'),
        rules: [_vIsNullOrYamlMap]));

_ScriptConfigValidationRules _scriptsConfigRules = _ScriptConfigValidationRules(
    root: Validator(
        messagePrefix: ([command]) =>
            chalk.yellowBright('scripts:$command (value)'),
        rules: [_vIsRequired, _vIsYamlMap]),
    name: Validator(
        messagePrefix: ([command]) =>
            chalk.yellowBright('scripts:$command:name'),
        rules: [_vIsNullOrString]),
    description: Validator(
        messagePrefix: ([command]) =>
            chalk.yellowBright('scripts:$command:description'),
        rules: [_vIsNullOrString]),
    exec: Validator(
        messagePrefix: ([command]) =>
            chalk.yellowBright('scripts:$command:exec'),
        rules: [_vIsRequired, _vIsString]),
    command: Validator(
        messagePrefix: ([command]) => chalk.yellowBright('scripts:$command (key)'),
        rules: [_vIsRequired, _vIsString]),
    stdin: Validator(messagePrefix: ([command]) => chalk.yellowBright('scripts:$command:flutter_run'), rules: [_vIsNullOrBool]),
    workingDir: Validator(messagePrefix: ([command]) => chalk.yellowBright('scripts:$command:working_dir'), rules: [_vIsNullOrString]));

/// Class responsible for generating Loki configurations from YAML data.
class ConfigGenerator {
  Map yaml;
  ConfigGenerator(this.yaml);
  late LokiConfig config;

  /// Factory method to create a [ConfigGenerator] from a YAML file path.
  /// [path] The file path of the YAML file.
  factory ConfigGenerator.fromYaml(String path) {
    File file = File(path);
    String yamlString = file.readAsStringSync();
    Map? yaml = loadYaml(yamlString);
    if (yaml == null) throw EmptyYamlFileError();

    return ConfigGenerator(yaml);
  }

  /// Generates a LokiConfig based on the provided YAML data.
  LokiConfig generate() {
    config = LokiConfig(
        name: _rootRules.name.run(yaml['name']),
        description: _rootRules.description.run(yaml['description']),
        packages: _rootRules.packages
                .run<YamlList?>(yaml['packages'])
                ?.map((e) => e as String)
                .toList() ??
            [],
        scripts: _generateScriptsConfig());
    return config;
  }

  /// Displays information about the Loki workspace.
  void showAppInfo() {
    if (!cache.firstTime) return;

    stdout.write('${chalk.yellowBright('Loki Workspace Info 🎉🎉 :\n')}'
        ' Name: ${chalk.cyan(config.name)}\n'
        ' Description: ${chalk.cyan(config.description ?? '-')}\n\n'
        '');
  }

  /// Generates a list of LokiScriptConfig objects based on the provided YAML data.
  List<LokiScriptConfig> _generateScriptsConfig() {
    _rootRules.scripts.run(yaml['scripts']);
    if (yaml['scripts'] == null) return [];

    final scripts = yaml['scripts'] as YamlMap;
    List<LokiScriptConfig> configs = [];
    scripts.forEach((key, value) {
      _scriptsConfigRules.root.run(value, args: key);

      var config = LokiScriptConfig(
          command: _scriptsConfigRules.command.run(key, args: key),
          exec: _scriptsConfigRules.exec.run(value['exec'], args: key),
          name: _scriptsConfigRules.name.run(value['name'], args: key),
          description: _scriptsConfigRules.description
              .run(value['description'], args: key),
          stdin: _scriptsConfigRules.stdin.run(value['stdin'], args: key),
          workingDir: _scriptsConfigRules.workingDir
              .run(value['working_dir'], args: key));
      configs.add(config);
    });
    return configs;
  }
}
