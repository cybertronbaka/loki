part of commands;

/// A command for printing version information.
class VersionCommand extends BaseCommand {
  VersionCommand(super.arguments);

  @override
  String get description => 'Print version information';

  @override
  String get name => 'version';

  @override
  FutureOr<void> run() async {
    console.writeln('Loki: ${chalk.cyan('v$version')}');
    console.printAttribution();
  }
}
