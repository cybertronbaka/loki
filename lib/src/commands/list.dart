part of commands;

class ListCommand extends BaseCommand{
  @override
  String get description => 'List all local packages in apps.';

  @override
  String get name => 'list';

  @override
  FutureOr<void> run() async {
    loadConfig();
    cache.configGenerator.fetch.showAppInfo();
    cache.projectFilter.fetch.printProjects();
    console.printAllDone();
  }
}