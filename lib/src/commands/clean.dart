part of commands;

class CleanCommand extends BaseCommand{
  Future<void> run() async {
    loadConfig();
    var filter = ProjectFilter().run(config);
    var projects = filter.packages + filter.apps;
    for (var p in projects) {
      await _clean(p);
    }
  }

  Future<void> _clean(Project pro) async {
    stdout.writeln('Loki: ${chalk.yellowBright('Cleaning for ${chalk.blueBright(pro.name)}${chalk.cyan(' @ ')}${chalk.blueBright(pro.dir.path)} (${chalk.cyan(pro.type.name)})')}');
    final p = await Process.start('flutter', ['clean'], workingDirectory: pro.dir.path, runInShell: true);
    await stdout.addStream(p.stdout);
    await stderr.addStream(p.stderr);
    stdout.writeln();
  }
}