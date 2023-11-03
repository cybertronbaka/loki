import 'dart:io';

import 'package:loki/src/errors/errors.dart';
import 'package:loki/src/models/models.dart';

import 'json_2_yaml_str.dart';

class ProjectCreator {
  String path;
  ProjectType type;
  String name;
  Map<String, dynamic> dependencies;
  Map<String, dynamic> devDependencies;
  Map<String, dynamic> pubspecOverrides;
  bool createPubspecOverridesFile;
  ProjectCreator(
      {required this.path,
      required this.name,
      required this.type,
      this.dependencies = const {},
      this.devDependencies = const {},
      this.pubspecOverrides = const {},
      this.createPubspecOverridesFile = false});

  void run() {
    DirectoryUtils.mkdir(path);
    _createProject();
  }

  void _createProject() {
    final pDir = Directory('$path/$name');
    if (!pDir.existsSync()) pDir.createSync(recursive: true);
    final pubspec = File('$path/$name/pubspec.yaml');
    if (!pubspec.existsSync()) pubspec.createSync(recursive: true);
    final json = {
      'name': name,
      'description': 'description',
      'version': '1.0.0',
      'environment': {'sdk': '^3.1.3'},
      ...buildDependencies(),
      ...buildDevDependencies()
    };
    final contents = Json2YamlStr().run(json);
    pubspec.writeAsStringSync(contents);
    _createPubspecOverrides();
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

  void _createPubspecOverrides() {
    if (createPubspecOverridesFile || pubspecOverrides.isNotEmpty) {
      FileUtils.create('$path/$name/pubspec_overrides.yaml',
          Json2YamlStr().run(pubspecOverrides));
    }
  }

  Map buildDependencies() {
    final flutterDependencies = {
      'flutter': {'sdk': 'flutter'}
    };
    if (dependencies.isEmpty) {
      return type == ProjectType.app
          ? {'dependencies': flutterDependencies}
          : {};
    }

    return {
      'dependencies': {
        ...(type == ProjectType.app ? flutterDependencies : {}),
        ...dependencies
      }
    };
  }

  Map buildDevDependencies() {
    final flutterDependencies = {
      'flutter_test': {'sdk': 'flutter'}
    };
    Map res = {
      'dev_dependencies': {
        ...(type == ProjectType.app ? flutterDependencies : {}),
        'lints': '^2.0.0',
        'test': '^1.21.0',
      }
    };
    if (devDependencies.isNotEmpty) {
      res['dev_dependencies'] = {
        ...res['dev_dependencies'],
        ...devDependencies
      };
    }
    return res;
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
