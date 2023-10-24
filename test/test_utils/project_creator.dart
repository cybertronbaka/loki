import 'dart:io';

import 'package:loki/src/models/models.dart';

class ProjectCreator {
  String path;
  ProjectType type;
  String name;
  ProjectCreator({
    required this.path,
    required this.name,
    required this.type,
  });

  void run() {
    DirectoryUtils.mkdir(path);
    type == ProjectType.app ? _createApp() : _createPackage();
  }

  void _createApp() {
    _createProject('flutter create --platforms=web $name');
  }

  void _createPackage() {
    _createProject('dart create -t package $name');
  }

  void _createProject(String command) {
    final all = command.split(' ');
    final result = Process.runSync(all.first, all.sublist(1, all.length),
        workingDirectory: path);
    if (result.exitCode != 0) {
      throw Exception('Could not create ${type.name} $name');
    }
  }

  void clean() {
    DirectoryUtils.rmdir('$path/$name');
  }
}

class DirectoryUtils {
  static void mkdir(String path) {
    final dir = Directory(path);
    if (dir.existsSync()) return;

    dir.createSync(recursive: true);
  }

  static void rmdir(String path) {
    final dir = Directory(path);
    if (!dir.existsSync()) return;

    dir.deleteSync(recursive: true);
  }
}
