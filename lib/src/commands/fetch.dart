part of commands;

class FetchCommand extends BaseCommand {

  Future<void> run() async {
    loadConfig();
    var filter = ProjectFilter().run(config);
    var projects = filter.packages + filter.apps;
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