part of services;

/// A class responsible for filtering and managing Flutter projects within a given directory.
class ProjectFilter {
  /// List of Flutter apps discovered in the workspace.
  final List<Project> apps = [];

  /// List of Flutter packages discovered in the workspace.
  final List<Project> packages = [];

  /// Gets all projects (both apps and packages).
  List<Project> get all => packages + apps;

  /// Runs the project filtering process based on the provided [config].
  ///
  /// Returns the instance of [ProjectFilter] after filtering.
  ProjectFilter run(LokiConfig config) {
    final pwd = Directory.current;
    if (_isProject(pwd)) {
      final yaml = _readPubspecYaml(pwd);
      _addToCache(Directory('.'), yaml);
    }
    for (var e in config.packages) {
      Directory dir = Directory(e);
      if (!dir.existsSync()) {
        throw LokiError('Directory does not exist: ${dir.path}');
      } else if (_isProject(dir)) {
        final yaml = _readPubspecYaml(dir);
        _addToCache(dir, yaml);
      } else {
        final projects = _findProjects(dir);
        if (projects.isEmpty) {
          throw Exception('nothing is at ${dir.path}');
        }
      }
    }
    return this;
  }

  /// Prints information about the discovered projects to the console.
  void printProjects() {
    if (!cache.firstTime.fetch) return;

    if (packages.isNotEmpty) {
      console.writeln(
          chalk.yellowBright('Packages Found 📦 (${packages.length}):'));
      for (var pack in packages) {
        console.writeln(
            '    - ${chalk.cyan(pack.name)}${chalk.pink(' @ ')}${pack.dir.path}');
      }
      console.writeln();
    }

    if (apps.isNotEmpty) {
      console.writeln(chalk.yellowBright('Apps Found 💿 (${apps.length}):'));
      for (var app in apps) {
        console.writeln(
            '    - ${chalk.cyan(app.name)}${chalk.pink(' @ ')}${app.dir.path}');
      }
      console.writeln();
    }
  }

  /// Checks if the directory at [dir] contains a Flutter app.
  bool _isApp(Directory dir, Map yaml) {
    bool isIt = File('${dir.path}/pubspec.yaml').existsSync();
    if (!isIt) return false;
    final platforms = ['ios','android','windows','linux','macos','web'];
    return isIt && platforms.any((e) => Directory('${dir.path}/$e').existsSync());
  }

  /// Checks if the directory at [dir] contains a valid project.
  bool _isProject(dir) {
    return File('${dir.path}/pubspec.yaml').existsSync();
  }

  /// Finds Flutter projects within a given [dir] and returns a list of them.
  List<Project> _findProjects(Directory dir) {
    List<Project> flutterProjects = [];

    dir
        .listSync(recursive: true, followLinks: false)
        .forEach((FileSystemEntity entity) {
      if (entity is Directory) {
        if (_isProject(entity)) {
          final yaml = _readPubspecYaml(entity);
          final p = _addToCache(entity, yaml);
          if (p == null) return;

          flutterProjects.add(p);
        }
      }
    });

    return flutterProjects;
  }

  /// Adds a [Project] to the cache based on the provided [dir] and [yaml].
  Project? _addToCache(Directory dir, Map yaml) {
    if (apps.any((e) => e.dir.absolute.path == dir.absolute.path) ||
        packages.any((e) => e.dir.absolute.path == dir.absolute.path)) {
      return null;
    }

    Project p = Project(
        name: _getProjectName(yaml),
        pubspec: yaml,
        dir: dir,
        type: _isApp(dir, yaml) ? ProjectType.app : ProjectType.package);
    p.type == ProjectType.app ? apps.add(p) : packages.add(p);
    return p;
  }

  /// Reads the content of pubspec.yaml file in a given [dir] and returns it as a Map.
  Map _readPubspecYaml(Directory dir) {
    File file = File('${dir.path}/pubspec.yaml');
    String content = file.readAsStringSync();
    Map pubspecYaml = loadYaml(content);
    return pubspecYaml;
  }

  /// Retrieves the name of a project based on its [yaml].
  String _getProjectName(Map yaml) {
    return yaml['name'];
  }
}
