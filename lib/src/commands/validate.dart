part of commands;

class ValidateCommand extends BaseCommand{
  Future<void>  run() async {
    stdout.write('Validating...');
    loadConfig();
    stdout.write('\r\rLoki: ${chalk.greenBright('All good!')}\n');
  }
}