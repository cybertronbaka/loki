import 'dart:io';

import 'package:args/args.dart';
import 'package:chalkdart/chalk.dart';
import 'package:loki/src/commands/commands.dart';
import 'package:loki/src/errors/errors.dart';
import 'package:loki/src/version.dart';
import 'package:yaml/yaml.dart';


Map<String, Future<void> Function(List<String> args)> _commands = {
  'fetch': (_) => FetchCommand().run(),
  'list': (_) => ListCommand().run(),
  'clean': (_) => CleanCommand().run(),
  'help': (_) => HelpCommand().run(),
  'h': (_) => HelpCommand().run(),
  'V': (_) => VersionCommand().run(),
  'version': (_) => VersionCommand().run(),
  'validate': (_) => ValidateCommand().run(),
  'run': (List<String> args) => RunCommand().run(args)
};

Future<void> runLoki(List<String> arguments) async {
  _drawLogo();

  try {
    final parser = ArgParser()
      ..addCommand('fetch')
      ..addCommand('clean')
      ..addCommand('list')
      ..addCommand('run')
      ..addCommand('help')
      ..addCommand('validate')
      ..addCommand('version')
    ;

    ArgResults argResults = parser.parse(arguments);

    final command = argResults.command?.name;
    if((command == null || command == 'fetch') && argResults.rest.isEmpty && argResults.options.isEmpty){
      await FetchCommand().run();
    } else if(command != null){
      await _commands[command]!(arguments);
    } else if(argResults.options.isNotEmpty){
      for (var e in argResults.options) {
        await _commands[e]!([]);
      }
    }
  } on PathNotFoundException catch (e, _) {
    stdout.writeln(LokiError('Could not find loki.yaml').toString());
    exit(1);
  } on LokiError catch (e, _) {
    stdout.writeln(e.toString());
    exit(1);
  } on YamlException catch (e) {
    stdout.writeln(LokiError('Could not parse Yaml.${chalk.normal(
        '\nPlease check the file and try again')}').toString());
    exit(1);
  } on ArgParserException catch(e){
    stdout.writeln(LokiError(e.message).toString());
    exit(1);
  }
}

void _drawLogo(){
  stdout.write(chalk.greenBright('''
 _     ____  _  __ _ 
/ \\   /  _ \\/ |/ // \\
| |   | / \\||   / | |
| |_/\\| \\_/||   \\ | |
\\____/\\____/\\_|\\_\\\\_/
                 v$version\n                     
'''));
}