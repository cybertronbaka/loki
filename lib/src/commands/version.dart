part of commands;

class VersionCommand extends BaseCommand{
  @override
  String get description => 'Print version information';

  @override
  String get name => 'version';

  @override
  List<String> get aliases => ['V'];

  @override
  FutureOr<void> run() async {
    stdout.writeln('Loki: ${chalk.greenBright('v$version')}');
  }
}