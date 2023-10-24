part of commands;

/// A subcommand to run a specific Flutter app.
class AppSubcommand extends BaseCommand {
  /// The Flutter project associated with this subcommand.
  Project app;

  AppSubcommand(this.app) {
    addOptions();
  }

  @override
  String get description => 'Run app (${app.name})';

  @override
  String get name => app.name;

  /// Executes the subcommand, running the associated app.
  @override
  FutureOr<void> run() async {
    cache.configParser.fetch.showAppInfo();
    cache.projectFilter.fetch.printProjects();
    cache.devicesFilter.fetch.printDevices();

    // Get device and flavor options
    String device = argResults!['device'];
    String? flavor = argResults!['flavor'];

    // Prepare arguments for running the app
    var args = ['run', '-d', device, '--${argResults!['environment']}'];
    if (flavor != null) {
      args += ['--flavor', flavor, '-t', 'lib/main_$flavor.dart'];
    }

    // Print launch message
    console.writeln(chalk.green(
        'Launching app ${chalk.cyan(app.name)}${flavor != null ? ' with flavor ${chalk.cyan(flavor)}' : ''} 🚀 '));

    // Add verbose flag if specified
    if (argResults!['verbose'] as bool) {
      args.add('-v');
    }
    // Start the Flutter process
    await Process.start('flutter', args,
        mode: ProcessStartMode.inheritStdio,
        runInShell: Platform.isWindows,
        workingDirectory: app.dir.path);
  }

  /// Adds options to the subcommand.
  void addOptions() {
    final devices = cache.devicesFilter.fetch.devices;
    if (devices.isNotEmpty) {
      Map<String, String> allowedHelp = {};
      for (var d in devices) {
        allowedHelp[d.id] =
            'id: ${d.id}, name: ${d.name}, platform: ${d.targetPlatform}';
      }
      // Add an option for choosing a device
      argParser.addOption('device',
          abbr: 'd',
          defaultsTo: devices.first.id,
          help: 'Choose a device to run. Defaults to ${devices.first.id}',
          allowed: devices.map((e) => e.id),
          allowedHelp: allowedHelp);
    }
    // Add an option for specifying a flavor
    argParser.addOption(
      'flavor',
      abbr: 'f',
      help: 'Run app into a flavor (optional)',
    );
    // Add an option for choosing the environment (debug, profile, or release)
    argParser.addOption('environment',
        abbr: 'e',
        defaultsTo: 'debug',
        help: 'Run in debug, profile or release. Defaults to debug.',
        allowed: [
          'debug',
          'release',
          'profile'
        ],
        allowedHelp: {
          'debug': 'Build a debug version of your app (default mode).',
          'profile':
              'Build a version of your app specialized for performance profiling.',
          'release': ' Build a release version of your app.'
        });
    // Add a flag for verbose logging
    argParser.addFlag('verbose',
        abbr: 'v',
        negatable: false,
        defaultsTo: false,
        help:
            'Noisy logging, including all shell commands executed (optional)');
  }
}
