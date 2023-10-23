part of commands;

class VersionCommand extends BaseCommand{
  Future<void>  run() async {
    stdout.writeln('Loki: ${chalk.greenBright('v$version')}');
  }
}