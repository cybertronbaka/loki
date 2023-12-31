// coverage:ignore-file
import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:chalkdart/chalk.dart';
import 'package:loki/src/commands/commands.dart';
import 'package:loki/src/errors/errors.dart';
import 'package:loki/src/services/services.dart';
import 'package:loki/src/version.dart';
import 'package:yaml/yaml.dart';

/// The name of the executable.
const _executableName = 'loki';

/// The description of the CLI tool.
final _description =
    'A CLI tool for managing Dart & Flutter projects with multiple packages.\n\n'
    'Made only because running flutter apps with melos was had an issue with stdin.\n\n'
    '${console.attributionText}';

/// A base class for the Loki CLI tool, which manages Dart & Flutter projects
/// with multiple packages. Loki is designed to address issues related to stdin
/// when running Flutter apps with Melos.
class LokiBase {
  /// If it is being run for first time or not
  int loopCount;

  LokiBase([this.loopCount = 0]);

  /// Runs the Loki CLI tool with the provided arguments.
  ///
  /// It initializes a [CommandRunner] and adds various commands for different
  /// functionalities, such as fetching, cleaning, listing, running, validating,
  /// viewing version, and managing applications.
  ///
  /// Exits with code 1 on [PathNotFoundException] if loki.yaml is not found.
  /// Exits with code 1 on [LokiError] for other Loki-specific errors.
  /// Exits with code 1 on [YamlException] if there is an issue parsing Yaml.
  /// Exits with code 1 on [ArgParserException] if there is an issue parsing command-line arguments.
  /// Exits with code 1 on [UsageException] if there is an issue with command usage.
  Future<void> run(List<String> arguments) async {
    cache.loopCount.set(loopCount);
    // final t1 = DateTime.timestamp();
    _drawLogo();

    try {
      final runner = CommandRunner<void>(_executableName, _description)
        ..addCommand(InitCommand(arguments))
        ..addCommand(FetchCommand(arguments))
        ..addCommand(CleanCommand(arguments))
        ..addCommand(ListCommand(arguments))
        ..addCommand(RunCommand(arguments))
        ..addCommand(ValidateCommand(arguments))
        ..addCommand(VersionCommand(arguments))
        ..addCommand(AppCommand(arguments));

      await runner.run(arguments);
    } on PathNotFoundException catch (e, _) {
      console.writeln(LokiError('Could not find loki.yaml').toString());
      exit(1);
    } on LokiError catch (e, _) {
      console.writeln(e.toString());
      exit(1);
    } on YamlException catch (_) {
      console.writeln(LokiError(
              'Could not parse Yaml.${chalk.normal('\nPlease check the file and try again')}')
          .toString());
      exit(1);
    } on ArgParserException catch (e) {
      console.writeln(LokiError(e.message).toString());
      exit(1);
    } on UsageException catch (e) {
      console.writeln(e.toString());
      exit(1);
    } finally {
      // final t2 = DateTime.timestamp();
      // console.writeln('\n\nTook ${t2.microsecondsSinceEpoch - t1.microsecondsSinceEpoch} micro-secs');
      // console.writeln('Took ${t2.millisecondsSinceEpoch - t1.millisecondsSinceEpoch} milli-secs');
    }
  }

  /// Draws the Loki logo to the console.
  void _drawLogo() {
    if (cache.loopCount.fetch != 0) {
      console.writeln(
          '\nLoki: ${chalk.blueBright('Running another instance of loki...')}\n');
      return;
    }

    console.write(chalk.cyan(''
        ' _     ____  _  __ _ \n'
        '/ \\   /  _ \\/ |/ // \\\n'
        '| |   | / \\||   / | |\n'
        '| |_/\\| \\_/||   \\ | |\n'
        '\\____/\\____/\\_|\\_\\\\_/\n'
        '                 v$version\n\n'
        ''));
  }
}
