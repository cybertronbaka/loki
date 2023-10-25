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
    console.writeln(
        'Loki: ${chalk.green('Launching 🚀 script ${chalk.cyan(script.name ?? script.exec)} @ ${chalk.cyan(script.workingDir ?? '.')}')}\n');

    final execs = script.exec.split('&&').map((e) => e.trim());
    _currentDir = Directory(script.workingDir ?? '.');

    for (var exec in execs) {
      final all = exec.split(' ').map((e) => e.trim()).toList();
      _command = all.first;
      _args = all.sublist(1, all.length);
      _exec = exec;
      if (_handleCD() || await _handleLoki() || await _handleLKR()) continue;

      // script.stdin != null && script.stdin!
      final process = LokiProcess(
        command: _command,
        args: _args,
        workingDir: _currentDir.path,
        hasStdin: script.stdin != null && script.stdin!,
        clearStdOut: false,
      );
      await cache.processManager.fetch.run(process,
          // coverage:ignore-start
          onError: () {
        console.writeln(
            'Loki: ${chalk.green('Failed ❌  while running exec ${chalk.cyan(_exec)} @ ${chalk.cyan(script.workingDir ?? '.')}')}');
      }
          // coverage:ignore-end
          );
    }
    console.printAllDone();
  }

  /// Handle cd commands
  ///
  /// Returns true if cd is to be executed and otherwise
  bool _handleCD() {
    if (_command != 'cd') return false;

    if (_command == 'cd' && _args.isEmpty) {
      throw LokiError('Cannot cd into nothing!');
    }
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

    await LokiBase(false).run(_args);
    return true;
  }

  /// Handle lkr commands (lkr: Short for loki run)
  ///
  /// Returns true if loki is to be executed and otherwise
  Future<bool> _handleLKR() async {
    if (_command != 'lkr') return false;

    await LokiBase(false).run(['run'] + _args);
    return true;
  }

  /// Displays information about the script.
  void showScriptInfo() {
    console.writeln(chalk.yellowBright(
        'Running Script (${chalk.cyan(script.name ?? script.exec)})\n'
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

  @override
  FutureOr<void>? run() {
    console.writeln(usage);
  }

  /// Adds options based on the configured scripts. Adds scripts from loki.yaml to subcommands.
  void addOptions() {
    loadConfig();
    for (var e in config.scripts) {
      addSubcommand(RunSubcommand(e));
    }
  }
}
