part of commands;

/// A command to list all local packages in apps.
class ListCommand extends BaseCommand {
  ListCommand(super.arguments);

  @override
  String get description => 'List all local packages in apps.';

  @override
  String get name => 'list';

  @override
  FutureOr<void> run() async {
    loadConfig();
    cache.configParser.fetch.showAppInfo();
    cache.projectFilter.fetch.printProjects();
    console.printAllDone();
  }
}
