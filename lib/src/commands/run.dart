part of commands;

class RunCommand extends BaseCommand{
  Future<void> run(List<String> args) async {
    if(args.length > 2){
      throw LokiError('${chalk.yellowBright('loki run')} doesn\'t accept arguments yet');
    }
    if(args.length <= 1) {
      throw LokiError('No command passed to ${chalk.yellowBright('loki run')}\n${chalk.normal('Usage: ${chalk.cyan('loki run <command>')}')}');
    }

    loadConfig();
    final parser = ArgParser();
    final commands = config.scripts.map((e) => e.command);
    for (var e in commands) {
      parser.addCommand(e);
    }
    final argsResult = parser.parse(args.sublist(1));
    final command = argsResult.command?.name;
    if(command == null) {
      final message= 'command ${chalk.yellowBright(args[1])} not found.\n'
          '${chalk.normal('Usage: ${chalk.cyan('loki run <command>')}')}\n'
          '${chalk.yellowBright('AvailableCommands:')}'
          '${config.scripts.map((e) {
            return '  ${chalk.blueBright(e.command)}\t${chalk.normal(e.name)}';
          }).join('\n')}';
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
}