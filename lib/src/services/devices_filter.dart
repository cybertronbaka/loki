import 'dart:convert';
import 'dart:io';

import 'package:chalkdart/chalk.dart';
import 'package:loki/src/errors/errors.dart';
import 'package:loki/src/models/models.dart';

/// A class for filtering and retrieving information about available Flutter devices.
class DevicesFilter {
  /// A list of Flutter devices after applying filtering.
  late List<FlutterDevice> devices;

  /// Retrieves a list of Flutter devices and applies filtering.
  ///
  /// Returns a list of supported Flutter devices.
  ///
  /// Throws a [LokiError] if an error occurs during the process.
  List<FlutterDevice> run() {
    try {
      final result = Process.runSync('flutter', ['devices', '--machine'],
          workingDirectory: Directory('.').path);
      List json = jsonDecode(result.stdout);
      devices = json.map((e) => FlutterDevice.fromJson(e)).where((e) => e.isSupported).toList();
      return devices;
    } catch (e) {
      throw LokiError('Something went wrong when getting devices.');
    }
  }

  /// Prints information about the available Flutter devices to the console.
  void printDevices(){
    stdout.writeln(chalk.yellowBright('Devices available 💻 (${devices.length}):'));
    for (var d in devices) {
      stdout.writeln('    - { id: ${chalk.cyan(d.id)}, name: ${d.name}, platform: ${d.targetPlatform} }');
    }
    stdout.writeln();
  }
}