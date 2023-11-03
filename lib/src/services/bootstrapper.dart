part of services;

class Bootstrapper {
  // Constants
  static const _overridesHeader = '#managed_with_loki: true';
  static const _depsKey = 'dependencies';
  static const _depsOverrideKey = 'dependency_overrides';

  // Instance variables
  late Project _project;
  List<Project> projects;
  late File _pubspecYamlFile;
  late File _overridesYamlFile;
  late YamlEditor _pubspecYaml;
  late YamlEditor _overridesYaml;
  late String _overridesYamlStr;
  late bool _overridesExists;
  int _lines = 0;

  Bootstrapper(this.projects);

  // Entry point for bootstrapping process
  void run(Project project) {
    _load(project);
    _writeln(
        'Loki: ${chalk.blueBright('Bootstrapping ⌛ for ${chalk.cyan(project.name)} @ ${chalk.cyan(project.dir.path)} (${chalk.cyan(project.type.name)})')}');
    _bootstrap();
    console.moveUpAndClear(_lines);
    console.writeln(
        'Loki: ${chalk.green('Bootstrapped 🍕 ${chalk.cyan(project.name)} @ ${chalk.cyan(project.dir.path)} (${chalk.cyan(project.type.name)})')}');
  }

  // Load project and related files and editors
  void _load(Project project) {
    _lines = 0;
    _project = project;
    _pubspecYamlFile = File('${_project.dir.path}/pubspec.yaml');
    _pubspecYaml = YamlEditor(_pubspecYamlFile.readAsStringSync());
    _overridesYamlFile = File('${_project.dir.path}/pubspec_overrides.yaml');
    _loadOverridesYamlStr();
    _overridesYaml = YamlEditor(_overridesYamlStr);
  }

  // Load content of pubspec_overrides.yaml file
  void _loadOverridesYamlStr() {
    _overridesYamlStr = '';
    _overridesExists = _overridesYamlFile.existsSync();
    if (_overridesExists) {
      _overridesYamlStr += _overridesYamlFile.readAsStringSync();
      if (!_overridesYamlStr.contains(_overridesHeader)) {
        _overridesYamlStr = '$_overridesHeader\n$_overridesYamlStr';
      }
    } else {
      _overridesYamlStr = _overridesHeader;
    }
  }

  // Main bootstrapping logic
  void _bootstrap() {
    var deps = _project.pubspec[_depsKey];
    if (!(deps != null && deps.runtimeType == YamlMap)) return;

    var dependencies = deps as YamlMap;
    for (var used in projects) {
      if (dependencies[used.name] == null) continue;

      _bootstrapFor(used);
    }
    _savePubspec();
    _saveOverrides();
  }

  // Bootstrap process for a specific project
  void _bootstrapFor(Project used) {
    _pubspecYaml.update([_depsKey, used.name], 'any');
    _createOverridesFile();
    final relPath = path_lib.relative(used.dir.path, from: _project.dir.path);
    final node = _overridesYaml
        .parseAt([_depsOverrideKey], orElse: () => wrapAsYamlNode(null));
    if (_isOverrideValid(node, used, relPath)) {
      _writeln(
          '  - Valid override exists for ${used.name} @ pubspec_overrides.yaml for ${_project.name}');
    } else {
      _updateOverrides(node, {
        used.name: {'path': relPath}
      });
    }
  }

  // Create pubspec_overrides.yaml file if it doesn't exist
  void _createOverridesFile() {
    if (_overridesExists) return;

    _writeln('  - Creating pubspec_overrides.yaml');
    _overridesYamlFile.createSync();
    _overridesExists = true;
  }

  // Check if the override in pubspec_overrides.yaml is valid
  bool _isOverrideValid(YamlNode node, Project used, String relPath) {
    return node.value != null &&
        node.value.runtimeType == YamlMap &&
        (node.value as YamlMap)[used.name] != null &&
        (node.value as YamlMap)[used.name].runtimeType == YamlMap &&
        (node.value as YamlMap)[used.name]['path'] == relPath;
  }

  // Update overrides in pubspec_overrides.yaml
  void _updateOverrides(YamlNode node, Map json) {
    if (node.value == null) {
      _writeln(
          '  - Empty pubspec_overrides.yaml detected! Adding default contents for it.');
      _overridesYaml =
          YamlEditor('$_overridesYamlStr\n$_depsOverrideKey: placeholder');
      _overridesYaml.update([_depsOverrideKey], json);
    } else {
      _writeln('  - Updating dependency_overrides!');
      _overridesYaml.update([_depsOverrideKey], {...node.value, ...json});
    }
  }

  // Save changes to pubspec.yaml
  void _savePubspec() {
    if (_pubspecYaml.edits.isEmpty) return;

    _writeln('  - Saving to pubspec.yaml!');
    _pubspecYamlFile.writeAsStringSync(_pubspecYaml.toString());
  }

  // Save changes to pubspec_overrides.yaml
  void _saveOverrides() {
    if (_overridesYaml.edits.isEmpty) return;

    _writeln('  - Saving to pubspec_overrides.yaml!');
    _overridesYamlFile.writeAsStringSync(_overridesYaml.toString());
  }

  // Helper method to print a message to the console
  void _writeln([Object? object = '']) {
    console.writeln(object);
    _lines++;
  }
}
