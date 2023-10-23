part of commands;

// TODO: Can be written better
class RunCommand extends BaseCommand{
  @override
  ArgParser get argParser => ArgParser.allowAnything();

  @override
  String get description => 'Run a script by name defined in the workspace loki.yaml config file.';

  @override
  String get name => 'run';

  @override
  FutureOr<void> run() async {
    if(argResults!.arguments.length > 1){
      throw LokiError('${chalk.yellowBright('loki run')} doesn\'t accept arguments yet');
    }
    if(argResults!.arguments.isEmpty) {
      throw LokiError('No command passed to ${chalk.yellowBright('loki run')}\n\n${chalk.normal(usage)}');
    }

    loadConfig();
    final parser = ArgParser();
    final commands = config.scripts.map((e) => e.command);
    for (var e in commands) {
      parser.addCommand(e);
    }
    final argsResult = parser.parse(argResults!.arguments);
    final command = argsResult.command?.name;
    if(command == null) {
      final message= 'command ${chalk.yellowBright(argResults!.arguments[0])} not found.\n\n'
        '${chalk.normal(usage)}';
      throw LokiError(message);
    }
    final scriptConfig = config.scripts.singleWhere((e) => e.command == command);
    showScriptInfo(scriptConfig);
    if(scriptConfig.flutterRun != null && scriptConfig.flutterRun!){
      final split = scriptConfig.exec.split(' ');
      await Process.start(
        split.first, split.sublist(1, split.length),
        mode: ProcessStartMode.inheritStdio,
        runInShell: Platform.isWindows,
        workingDirectory: Directory(scriptConfig.workingDir ?? '.').path
      );
    } else {
      final split = scriptConfig.exec.split(' ');
      final process = await Process.start(
        split.first, split.sublist(1, split.length),
        runInShell: Platform.isWindows,
        workingDirectory: Directory(scriptConfig.workingDir ?? '.').path
      );
      await stdout.addStream(process.stdout);
      await stderr.addStream(process.stderr);
    }
  }

  void showScriptInfo(LokiScriptConfig scriptConfig){
    stdout.writeln(chalk.yellowBright('Running Script (${chalk.greenBright(scriptConfig.name)})\n'
        'Working Directory: ${chalk.greenBright(scriptConfig.workingDir ?? '.')}\n'
        'Description: ${chalk.greenBright(scriptConfig.description ?? '-')}\n'));
  }

  @override
  String get usage {
    late String availableScripts;
    try {
      loadConfig();
      availableScripts= 'Available Scripts:\n'
          '${config.scripts.map((e) {
        return '  ${e.command}\t\t${e.name}';
      }).join('\n')}\n';
    } catch(e) {
      availableScripts = '';
    }
    return '$description\n\n'
        'Usage: loki $name [script_name]\n'
        '${argParser.usage}\n'
        'Run "loki help" to see global options.'
        '${availableScripts.isEmpty ? '' : '\n\n'}'
        '$availableScripts'
    ;
  }
}