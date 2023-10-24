part of commands;

/// A subcommand to run a specific script.
///
/// Accepts [LokiScriptConfig]
class RunSubcommand extends BaseCommand {
  LokiScriptConfig script;
  RunSubcommand(this.script);

  late Directory _currentDir;

  late String _exec;
  late String _command;
  late List<String> _args;

  @override
  String get name => script.command;

  @override
  String get description =>
      '${script.description ?? 'Runs ${script.exec}'}\n\nTo run a script in sequence join the scripts using &&&.';

  @override
  FutureOr<void>? run() async {
    showScriptInfo();
    stdout.writeln(
        'Loki: ${chalk.green('Launching 🚀 script ${chalk.cyan(script.name)} @ ${chalk.cyan(script.workingDir)}')}\n');

    final execs = script.exec.split('&&').map((e) => e.trim());
    _currentDir = Directory(script.workingDir ?? '.');

    for (var exec in execs) {
      final all = exec.split(' ').map((e) => e.trim()).toList();
      _command = all.first;
      _args = all.sublist(1, all.length);
      _exec = exec;
      if (_handleCD() || await _handleLoki()) continue;

      script.stdin != null && script.stdin!
          ? await _runWithStdin()
          : await _runWithoutStdin();
    }
    console.printAllDone();
  }

  /// Run without standard input
  Future<void> _runWithStdin() async {
    final process = await Process.start(_command, _args,
        mode: ProcessStartMode.inheritStdio,
        runInShell: Platform.isWindows,
        workingDirectory: _currentDir.path);
    final exitCode = await process.exitCode;
    if (exitCode != 0)
      throw LokiError('Failed ❌ running script ${chalk.cyan(script.name)}');
  }

  Future<void> _runWithoutStdin() async {
    final runner = ProcessStartRunner(
        runner: () => Process.start(_command, _args,
            runInShell: true, workingDirectory: _currentDir.path),
        onError: () {
          stdout.writeln(
              'Loki: ${chalk.green('Failed ❌  while running exec ${chalk.cyan(_exec)} @ ${chalk.cyan(script.workingDir)}')}');
          throw LokiError('Failed ❌ running ${chalk.cyan(script.name)}');
        });
    await runner.run();
  }

  /// Handle cd commands
  ///
  /// Returns true if cd is to be executed and otherwise
  bool _handleCD() {
    if (_command != 'cd') return false;

    if (_command == 'cd' && _args.isEmpty)
      throw LokiError('Cannot cd into nothing!');
    if (_command == 'cd') {
      _currentDir = Directory('${_currentDir.path}/${_args[0]}');
      return true;
    }
    return false;
  }

  /// Handle loki commands
  ///
  /// Returns true if loki is to be executed and otherwise
  Future<bool> _handleLoki() async {
    if (_command != 'loki') return false;

    await LokiBase().run(_args);
    return true;
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
      'Run a script by name defined in the workspace loki.yaml config file.\n\nTo run a script in sequence join the scripts using &&&.';

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
