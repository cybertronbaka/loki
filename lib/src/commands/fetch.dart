part of commands;

/// A command to install dependencies in packages and apps.
class FetchCommand extends BaseCommand {
  FetchCommand(super.arguments);

  @override
  String get description => 'Install dependencies in packages and apps';

  @override
  String get name => 'fetch';

  @override
  FutureOr<void> run() async {
    loadConfig();
    cache.configParser.fetch.showAppInfo();
    var projects = cache.projectFilter.fetch.all;
    cache.projectFilter.fetch.printProjects();
    for (var p in projects) {
      await _fetch(p);
    }
    console.printAllDone();
  }

  /// Performs the fetch operation for a specific project.
  Future<void> _fetch(Project pro) async {
    console.writeln(
        'Loki: ${chalk.blueBright('Fetching ⌛ dependencies in ${chalk.cyan(pro.name)} @ ${chalk.cyan(pro.dir.path)} (${chalk.cyan(pro.type.name)})')}');
    final process = LokiProcess(
      command: 'flutter',
      args: ['pub', 'get'],
      workingDir: pro.dir.path,
      hasStdin: false,
      clearStdOut: true,
    );
    await cache.processManager.fetch.run(
      process,
      onSuccess: () {
        console.writeln(
            'Loki: ${chalk.green('Fetched 🍕 dependencies in ${chalk.cyan(pro.name)} @ ${chalk.cyan(pro.dir.path)} (${chalk.cyan(pro.type.name)})')}');
      },
      // coverage:ignore-start
      onError: () {
        console.writeln(
            'Loki: ${chalk.red('Failed ❌ to fetch dependencies in ${chalk.cyan(pro.name)} @ ${chalk.cyan(pro.dir.path)} (${chalk.cyan(pro.type.name)})')}');
      },
      // coverage:ignore-end
    );
    console.writeln();
  }
}
