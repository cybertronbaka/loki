part of commands;

class AppCommand extends BaseCommand {
  AppCommand(){
    addOptions();
  }

  @override
  String get description => 'Runs a flutter app in the workspace';

  @override
  String get name => 'app';

  void addOptions() {
    loadConfig();
    final apps = cache.projectFilter.fetch.apps;
    for (var app in apps) {
      addSubcommand(AppSubcommand(app));
    }
  }
}