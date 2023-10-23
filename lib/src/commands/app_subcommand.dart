part of commands;

class AppSubcommand extends BaseCommand {
  Project app;
  AppSubcommand(this.app) {
    addOptions();
  }

  @override
  String get description => 'App Located @ ${app.dir}';

  @override
  String get name => app.name;

  @override
  FutureOr<void> run() async {
    String device = argResults!['device'];
    String? flavor = argResults!['flavor'];
    var args = ['run', '-d', device];
    if(flavor != null){
      args += ['--flavor', flavor, '-t', 'lib/main_$flavor.dart'];
    }
    await Process.start(
      'flutter', args,
      mode: ProcessStartMode.inheritStdio,
      runInShell: Platform.isWindows,
      workingDirectory: app.dir.path
    );
  }

  void addOptions(){
    final devices = cache.devices.data;
    if(devices.isNotEmpty){
      Map<String, String> allowedHelp = {};
      for (var d in devices) {
        allowedHelp[d.id] = 'id: ${d.id}, name: ${d.name}, platform: ${d.targetPlatform}';
      }
      argParser.addOption(
        'device',
        abbr: 'd',
        defaultsTo: devices.first.id,
        help: 'Choose a device to run default is ${devices.first.id}',
        allowed: devices.map((e) => e.id),
        allowedHelp: allowedHelp
      );
    }
    argParser.addOption(
      'flavor',
      abbr: 'f',
      help: 'Run app into a flavor',
    );
  }
}
