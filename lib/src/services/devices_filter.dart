import 'dart:convert';
import 'dart:io';

import 'package:loki/src/errors/errors.dart';
import 'package:loki/src/models/models.dart';

class DevicesFilter {
  late List<FlutterDevice> devices;

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
}