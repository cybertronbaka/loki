part of commands;

/// A subcommand to run a specific script.
///
/// Accepts [LokiScriptConfig]
class RunSubcommand extends BaseCommand {
  LokiScriptConfig script;
  RunSubcommand(this.script);

  @override
  String get name => script.command;

  @override
  String get description => script.description ?? 'Runs ${script.description}';

  @override
  FutureOr<void>? run() async {
    showScriptInfo();
    stdout.writeln(
        'Loki: ${chalk.green('Launching 🚀 script ${chalk.cyan(script.name)} @ ${chalk.cyan(script.workingDir)}')}\n');

    if (script.stdin != null && script.stdin!) {
      final split = script.exec.split(' ');
      await Process.start(split.first, split.sublist(1, split.length),
          mode: ProcessStartMode.inheritStdio,
          runInShell: Platform.isWindows,
          workingDirectory: Directory(script.workingDir ?? '.').path);
    } else {
      final split = script.exec.split(' ');
      final runner = ProcessStartRunner(
          runner: () => Process.start(
              split.first, split.sublist(1, split.length),
              runInShell: Platform.isWindows,
              workingDirectory: Directory(script.workingDir ?? '.').path),
          onError: () {
            stdout.writeln(
                'Loki: ${chalk.green('Failed ❌  while running script ${chalk.cyan(script.name)} @ ${chalk.cyan(script.workingDir)}')}');
          });
      await runner.run();
      console.printAllDone();
    }
  }

  /// Displays information about the script.
  void showScriptInfo() {
    stdout.writeln(
        chalk.yellowBright('Running Script (${chalk.cyan(script.name)})\n'
            'Working Directory: ${chalk.cyan(script.workingDir ?? '.')}\n'
            'Description: ${chalk.cyan(script.description ?? '-')}\n'));
  }
}

/// A command to run a script by name defined in the workspace loki.yaml config file.
class RunCommand extends BaseCommand {
  RunCommand() {
    addOptions();
  }
  @override
  String get description =>
      'Run a script by name defined in the workspace loki.yaml config file.';

  @override
  String get name => 'run';

  /// Adds options based on the configured scripts. Adds scripts from loki.yaml to subcommands.
  void addOptions() {
    loadConfig();
    for (var e in config.scripts) {
      addSubcommand(RunSubcommand(e));
    }
  }
}
