part of commands;

/// A command to clean all packages and apps using `flutter clean`.
class CleanCommand extends BaseCommand {
  bool cleanOnRoot;
  CleanCommand({this.cleanOnRoot = true});

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
        'Loki: ${chalk.yellowBright('Cleaning 🚦 for ${chalk.blueBright(pro.name)}${chalk.cyan(' @ ')}${chalk.blueBright(pro.dir.path)} (${chalk.cyan(pro.type.name)})')}');
    final runner = ProcessStartRunner(
        runner: () => Process.start('flutter', ['clean'],
            workingDirectory: pro.dir.path, runInShell: true),
        clearStdOut: true,
        // coverage:ignore-start
        onError: () {
          console.writeln(
              'Loki: ${chalk.red('Failed ❌ to clean in ${chalk.cyan(pro.name)} @ ${pro.dir.path} (${chalk.cyan(pro.type.name)})')}');
        },
        // coverage:ignore-end
        onSuccess: () {
          console.writeln(
              'Loki: ${chalk.green('Cleaned 🍕 in ${chalk.yellowBright(pro.name)}${chalk.pink(' @ ')}${pro.dir.path} (${chalk.yellowBright(pro.type.name)})')}');
        });
    await runner.run();
    console.writeln();
  }
}
