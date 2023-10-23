part of commands;

class VersionCommand extends BaseCommand{
  @override
  String get description => 'Print version information';

  @override
  String get name => 'version';

  @override
  FutureOr<void> run() async {
    stdout.writeln('Loki: ${chalk.cyan('v$version')}');
    console.printAttribution();
  }
}