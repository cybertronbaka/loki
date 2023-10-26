part of commands;

/// A command to clean all packages and apps using `flutter clean`.
class CleanCommand extends BaseCommand {
  bool cleanOnRoot;
  CleanCommand(super.arguments, {this.cleanOnRoot = true});

  @override
  String get description => 'Runs `flutter clean` in all packages and apps';

  @override
  String get name => 'clean';

  @override
  List<String> get aliases => ['c'];

  @override
  FutureOr<void> run() async {
    loadConfig();
    cache.configParser.fetch.showAppInfo();
    var projects = cache.projectFilter.fetch.all;
    cache.projectFilter.fetch.printProjects();
    for (var p in projects) {
      if (!cleanOnRoot && p.dir.path == '.') {
        continue;
      }
      await _clean(p);
    }
    console.printAllDone();
  }

  /// Performs the clean operation for a specific project.
  Future<void> _clean(Project pro) async {
    console.writeln(
        'Loki: ${chalk.blueBright('Cleaning 🚦 for ${chalk.cyan(pro.name)} @ ${chalk.cyan(pro.dir.path)}  (${chalk.cyan(pro.type.name)})')}');
    final process = LokiProcess(
      command: 'flutter',
      args: ['clean'],
      workingDir: pro.dir.path,
      hasStdin: false,
      clearStdOut: true,
    );
    await cache.processManager.fetch.run(
      process,
      onSuccess: () {
        console.writeln(
            'Loki: ${chalk.blueBright('Cleaned 🍕 in ${chalk.cyan(pro.name)} @ ${chalk.cyan(pro.dir.path)}  (${chalk.cyan(pro.type.name)})')}');
      },
      // coverage:ignore-start
      onError: () {
        console.writeln(
            'Loki: ${chalk.red('Failed ❌ to clean in ${chalk.cyan(pro.name)} @ ${chalk.cyan(pro.dir.path)} (${chalk.cyan(pro.type.name)})')}');
      },
      // coverage:ignore-end
    );
    console.writeln();
  }
}
