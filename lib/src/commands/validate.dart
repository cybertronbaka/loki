part of commands;

class ValidateCommand extends BaseCommand{
  @override
  String get description => 'Validate loki.yaml config file.';

  @override
  String get name => 'validate';

  @override
  FutureOr<void> run() async {
    stdout.write('Validating...');
    try{
      loadConfig();
    } catch(e) {
      stdout.write('\r');
      rethrow;
    }
    stdout.write('\r\rLoki: ${chalk.greenBright('All good!')}\n');
  }
}