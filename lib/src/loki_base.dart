import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:chalkdart/chalk.dart';
import 'package:loki/src/commands/commands.dart';
import 'package:loki/src/errors/errors.dart';
import 'package:loki/src/version.dart';
import 'package:yaml/yaml.dart';

const _executableName = 'loki';
final _description = 'A CLI tool for managing Dart & Flutter projects with multiple packages.\n\n'
    'Made only because running flutter apps with melos was had an issue with stdin.\n\n'
    'Made with ❤️  by ${chalk.cyan('Dorji Gyeltshen ( ${chalk.red('@cybertronbaka')} )')}';

class LokiBase {


  Future<void> run(List<String> arguments) async {
    _drawLogo();

    try {
      final runner = CommandRunner<void>(_executableName, _description)
        ..addCommand(FetchCommand())
        ..addCommand(CleanCommand())
        ..addCommand(ListCommand())
        ..addCommand(RunCommand())
        ..addCommand(ValidateCommand())
        ..addCommand(VersionCommand())
        ..addCommand(AppCommand())
      ;

      await runner.run(arguments);
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
    } on UsageException catch(e){
      stdout.writeln(e.toString());
      exit(1);
    }
  }

  void _drawLogo(){
    stdout.write(chalk.greenBright(''
      ' _     ____  _  __ _ \n'
      '/ \\   /  _ \\/ |/ // \\\n'
      '| |   | / \\||   / | |\n'
      '| |_/\\| \\_/||   \\ | |\n'
      '\\____/\\____/\\_|\\_\\\\_/\n'
      '                 v$version\n\n'
    ''));
  }
}