part of commands;

class FetchCommand extends BaseCommand {
  @override
  String get description => 'Install dependencies in packages and apps';

  @override
  String get name => 'fetch';

  @override
  FutureOr<void> run() async {
    loadConfig();
    var projects = cache.projectFilter.data.all;
    for (var p in projects) {
      await _fetch(p);
    }
  }

  Future<void> _fetch(Project pro) async {
    int stdOutLines = 0;
    int stdErrLines = 0;
    stdout.writeln('Loki: ${chalk.yellowBright('Fetching dependencies in ${chalk.blueBright(pro.name)}${chalk.cyan(' @ ')}${chalk.blueBright(pro.dir.path)} (${chalk.cyan(pro.type.name)})')}');
    final p = await Process.start('flutter', ['pub', 'get'], workingDirectory: pro.dir.path, runInShell: true);
    await stdout.addStream(p.stdout.map((event){
      stdOutLines++;
      return event;
    }));
    stdout.write('\r'*stdOutLines);
    await stderr.addStream(p.stderr.map((event){
      stdErrLines++;
      return event;
    }));
    stderr.write('\r'*stdErrLines);
    stdout.writeln();
  }
}