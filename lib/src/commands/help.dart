part of commands;

// A CLI tool for managing Dart & Flutter projects with multiple packages.
//
// Usage: loki <command> [arguments]
//
// Global Options
// -h, --help    Print this usage information.
// -V, --version Print version information
//
// Available commands:
// fetch         Install dependencies in packages and apps
// clean         Runs `flutter clean` in all packages and apps
// list          List all local packages in apps.
// run           Run a script by name defined in the workspace loki.yaml config file.
// validate      Validate loki.yaml config file.
class HelpCommand extends BaseCommand{
  @override
  String get description => 'Print this usage information.';

  @override
  String get name => 'help';

  @override
  FutureOr<void> run() async {
    stdout.writeln('${chalk.greenBright('A CLI tool for managing Dart & Flutter projects with multiple packages.')}\n\n'
        'Usage: ${chalk.cyan('loki <command> [arguments]')}\n\n'
        '${chalk.yellowBright('Global Options')}\n'
        '  ${chalk.blueBright('-h, --help')}    Print this usage information.\n'
        '  ${chalk.blueBright('-V, --version')} Print version information\n\n'

        '${chalk.yellowBright('Available commands:')}\n'
        '  ${chalk.blueBright('fetch')}         Install dependencies in packages and apps\n'
        '  ${chalk.blueBright('clean')}         Runs `flutter clean` in all packages and apps\n'
        '  ${chalk.blueBright('list')}          List all local packages in apps.\n'
        '  ${chalk.blueBright('run')}           Run a script by name defined in the workspace loki.yaml config file.\n'
        '  ${chalk.blueBright('validate')}      Validate loki.yaml config file.');
  }
}