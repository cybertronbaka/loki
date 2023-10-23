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
    final apps = _getApps();
    for (var app in apps) {
      addSubcommand(AppSubcommand(app));
    }
  }

  List<Project> _getApps() {
    try {
      loadConfig();
      return cache.projectFilter.data.apps;
    } catch (e) {
      return [];
    }
  }
}