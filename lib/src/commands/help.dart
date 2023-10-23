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
// list          List local packages in various output formats. Supports all package filtering options.
// run           Run a script by name defined in the workspace loki.yaml config file.
// validate      Validate loky.yaml config file.
class HelpCommand extends BaseCommand{
  Future<void>  run() async {
    stdout.write('''
${chalk.greenBright('A CLI tool for managing Dart & Flutter projects with multiple packages.')}

Usage: ${chalk.cyan('loki <command> [arguments]')}

${chalk.yellowBright('Global Options')}
 ${chalk.blueBright('-h, --help')}    Print this usage information.
 ${chalk.blueBright('-V, --version')} Print version information

${chalk.yellowBright('Available commands:')}
 ${chalk.blueBright('fetch')}         Install dependencies in packages and apps
 ${chalk.blueBright('clean')}         Runs `flutter clean` in all packages and apps
 ${chalk.blueBright('list')}          List local packages in various output formats. Supports all package filtering options.
 ${chalk.blueBright('run')}           Run a script by name defined in the workspace loki.yaml config file.
 ${chalk.blueBright('validate')}      Validate loky.yaml config file.
\n''');
  }
}