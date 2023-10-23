part of commands;

class FetchCommand extends BaseCommand {

  @override
  String get description => 'Install dependencies in packages and apps';

  @override
  String get name => 'fetch';

  @override
  FutureOr<void> run() async {
    loadConfig();
    cache.configGenerator.fetch.showAppInfo();
    var projects = cache.projectFilter.fetch.all;
    cache.projectFilter.fetch.printProjects();
    for (var p in projects) {
      await _fetch(p);
    }
    console.printAllDone();
  }

  Future<void> _fetch(Project pro) async {
    stdout.writeln('Loki: ${chalk.yellowBright('Fetching ⌛ dependencies in ${chalk.cyan(pro.name)}${chalk.pink(' @ ')}${pro.dir.path} (${chalk.cyan(pro.type.name)})')}');
    final runner = ProcessStartRunner(
      runner: () => Process.start('flutter', ['pub', 'get'], workingDirectory: pro.dir.path, runInShell: true),
      clearStdOut: true,
      onError: (){
        stdout.writeln('Loki: ${chalk.red('Failed ❌ to fetch dependencies in ${chalk.cyan(pro.name)} @ ${pro.dir.path} (${chalk.cyan(pro.type.name)})')}');
      },
      onSuccess: (){
        stdout.writeln('Loki: ${chalk.green('Fetched 🍕 dependencies in ${chalk.yellowBright(pro.name)}${chalk.pink(' @ ')}${pro.dir.path} (${chalk.yellowBright(pro.type.name)})')}');
      }
    );
    await runner.run();
    stdout.writeln();
  }
}