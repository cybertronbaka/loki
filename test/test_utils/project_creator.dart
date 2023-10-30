import 'dart:io';

import 'package:loki/src/errors/errors.dart';
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
    _createProject();
  }

  void _createProject() {
    final pDir = Directory('$path/$name');
    if (!pDir.existsSync()) pDir.createSync(recursive: true);
    final pubspec = File('$path/$name/pubspec.yaml');
    if (!pubspec.existsSync()) pubspec.createSync(recursive: true);
    final flutterDeps = type == ProjectType.app
        ? 'dependencies:\n'
            '  flutter:\n'
            '    sdk: flutter\n'
        : '';
    final flutterDevDeps = type == ProjectType.app
        ? '  flutter_test:\n'
            '    sdk: flutter\n'
        : '';
    final contents = 'name: $name\n'
        'description: description\n'
        'version: 1.0.0\n'
        'environment:\n'
        '  sdk: ^3.1.3\n'
        '$flutterDeps\n'
        'dev_dependencies:\n'
        '$flutterDevDeps'
        '  lints: ^2.0.0\n'
        '  test: ^1.21.0\n';
    pubspec.writeAsStringSync(contents);
    if (type == ProjectType.app) {
      final d = Directory('${pDir.path}/android');
      if (!d.existsSync()) d.createSync(recursive: true);
    }
    final copyProcess = Process.runSync(
        'cp', ['-r', '.dart_tool', '${pDir.path}/.dart_tool'],
        workingDirectory: Directory('.').path, runInShell: true);
    if (copyProcess.exitCode != 0) {
      throw LokiError('Failed to copy: ${copyProcess.stderr}');
    }
    // final process = Process.runSync(
    //   type == ProjectType.app ? 'flutter' : 'dart', ['pub', 'get'],
    //   runInShell: true,
    //   workingDirectory: '$path/$name'
    // );
    // if(process.exitCode != 0){
    //   throw LokiError('Failed to pub get ${process.stderr}');
    // }
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

class FileUtils {
  static void create(String path, String contents) {
    final file = File(path);
    if (file.existsSync()) return;

    file.createSync(recursive: true);
    file.writeAsStringSync(contents);
  }

  static void remove(String path) {
    final file = File(path);
    if (!file.existsSync()) return;

    file.deleteSync(recursive: true);
  }
}
