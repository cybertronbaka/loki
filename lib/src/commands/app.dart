part of commands;

/// A command to run a Flutter app in the workspace.
///
/// Invoked with
/// ```sh
/// loki app
/// ```
class AppCommand extends BaseCommand {
  AppCommand(super.arguments) {
    addOptions();
  }

  @override
  String get description => 'Runs a flutter app in the workspace';

  @override
  String get name => 'app';

  @override
  FutureOr<void>? run() {
    console.writeln(usage);
  }

  /// Adds subcommands to app command. Subcommands include apps found under packages
  void addOptions() {
    if (!arguments.contains(name)) return;

    loadConfig();
    final apps = cache.projectFilter.fetch.apps;
    for (var app in apps) {
      addSubcommand(AppSubcommand(app, super.arguments));
    }
  }
}
