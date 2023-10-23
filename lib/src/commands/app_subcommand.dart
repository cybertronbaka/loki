part of commands;

class AppSubcommand extends BaseCommand {
  Project app;
  AppSubcommand(this.app) {
    addOptions();
  }

  @override
  String get description => 'Run app (${app.name})';

  @override
  String get name => app.name;

  @override
  FutureOr<void> run() async {
    cache.configGenerator.fetch.showAppInfo();
    cache.projectFilter.fetch.printProjects();
    cache.devicesFilter.fetch.printDevices();
    String device = argResults!['device'];
    String? flavor = argResults!['flavor'];
    var args = ['run', '-d', device, '--${argResults!['environment']}'];
    if(flavor != null){
      args += ['--flavor', flavor, '-t', 'lib/main_$flavor.dart'];
    }
    stdout.writeln(chalk.greenBright('Launching app ${chalk.cyan(app.name)}${flavor != null ? ' with flavor ${chalk.cyan(flavor)}' : ''} 🚀 '));
    if(argResults!['verbose'] as bool){
      args.add('-v');
    }
    await Process.start(
      'flutter', args,
      mode: ProcessStartMode.inheritStdio,
      runInShell: Platform.isWindows,
      workingDirectory: app.dir.path
    );
  }

  void addOptions(){
    final devices = cache.devicesFilter.fetch.devices;
    if(devices.isNotEmpty){
      Map<String, String> allowedHelp = {};
      for (var d in devices) {
        allowedHelp[d.id] = 'id: ${d.id}, name: ${d.name}, platform: ${d.targetPlatform}';
      }
      argParser.addOption(
        'device',
        abbr: 'd',
        defaultsTo: devices.first.id,
        help: 'Choose a device to run. Defaults to ${devices.first.id}',
        allowed: devices.map((e) => e.id),
        allowedHelp: allowedHelp
      );
    }
    argParser.addOption(
      'flavor',
      abbr: 'f',
      help: 'Run app into a flavor (optional)',
    );
    argParser.addOption(
      'environment',
      abbr: 'e',
      defaultsTo: 'debug',
      help: 'Run in debug, profile or release. Defaults to debug.',
      allowed: ['debug', 'release', 'profile'],
      allowedHelp: {
        'debug': 'Build a debug version of your app (default mode).',
        'profile': 'Build a version of your app specialized for performance profiling.',
        'release': ' Build a release version of your app.'
      }
    );
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      defaultsTo: false,
      help: 'Noisy logging, including all shell commands executed (optional)'
    );
  }
}
