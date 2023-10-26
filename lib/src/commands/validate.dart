part of commands;

/// A command for validating the loki.yaml config file.
class ValidateCommand extends BaseCommand {
  ValidateCommand(super.arguments);

  @override
  String get description => 'Validate loki.yaml config file.';

  @override
  String get name => 'validate';

  @override
  FutureOr<void> run() async {
    loadConfig();
    cache.configParser.fetch.showAppInfo();
    console.printAllDone();
  }
}
