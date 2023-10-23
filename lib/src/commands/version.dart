part of commands;

class VersionCommand extends BaseCommand{
  @override
  String get description => 'Print version information';

  @override
  String get name => 'version';

  @override
  FutureOr<void> run() async {
    stdout.writeln('Loki: ${chalk.greenBright('v$version')}');
    stdout.writeln('Made with ❤️  by ${chalk.cyan('Dorji Gyeltshen ( ${chalk.red('@cybertronbaka')} )')}');
  }
}