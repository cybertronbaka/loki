import 'dart:io';

import 'package:chalkdart/chalk.dart';
import 'package:chalkdart/chalk_x11.dart';
import 'package:loki/src/models/models.dart';
import 'package:yaml/yaml.dart';

class ProjectFilter {
  final List<Project> apps = [];
  final List<Project> packages = [];

  List<Project> get all => packages + apps;

  ProjectFilter run(LokiConfig config){
    final pwd = Directory.current;
    if(_isProject(pwd)){
      final yaml = _readPubspecYaml(pwd);
      _addToCache(Directory('.'), yaml);
    }
    for (var e in config.packages) {
      Directory dir = Directory(e);
      if (!dir.existsSync()) {
        throw ArgumentError('Directory does not exist: ${dir.path}');
      } else if(_isProject(dir)){
        final yaml = _readPubspecYaml(dir);
        _addToCache(dir, yaml);
      } else {
        final projects = _findProjects(dir);
        if(projects.isEmpty){
          throw Exception('nothing is at ${dir.path}');
        }
      }
    }
    return this;
  }

  void printProjects(){
    if(packages.isNotEmpty){
      stdout.writeln(chalk.yellowBright('Packages Found 📦 (${packages.length}):'));
      for(var pack in packages){
        stdout.writeln('    - ${chalk.cyan(pack.name)}${chalk.pink(' @ ')}${pack.dir.path}');
      }
      stdout.writeln();
    }

    if(apps.isNotEmpty){
      stdout.writeln(chalk.yellowBright('Apps Found 💿 (${packages.length}):'));
      for(var app in apps){
        stdout.writeln('    - ${chalk.cyan(app.name)}${chalk.pink(' @ ')}${app.dir.path}');
      }
      stdout.writeln();
    }
  }

  bool _isApp(Directory dir, Map yaml) {
    bool isIt = File('${dir.path}/pubspec.yaml').existsSync();
    if(!isIt) return false;

    return isIt && yaml['dependencies']?['flutter'] != null;
  }

  bool _isProject(dir){
    return File('${dir.path}/pubspec.yaml').existsSync();
  }

  List<Project> _findProjects(Directory dir) {
    List<Project> flutterProjects = [];

    if (!dir.existsSync()) {
      throw ArgumentError('Directory does not exist: ${dir.path}');
    }

    dir.listSync(recursive: true, followLinks: false).forEach((FileSystemEntity entity) {
      if (entity is Directory) {
        if(_isProject(entity)){
          final yaml = _readPubspecYaml(entity);
          final p = _addToCache(entity, yaml);
          if(p == null) return;

          flutterProjects.add(p);
        }
      }
    });

    return flutterProjects;
  }

  Project? _addToCache(Directory dir, Map yaml){
    if(apps.any((e) => e.dir.absolute.path == dir.absolute.path) || packages.any((e) => e.dir.absolute.path == dir.absolute.path)) return null;

    Project p = Project(
        name: _getProjectName(yaml),
        pubspec: yaml,
        dir: dir,
        type: _isApp(dir, yaml) ?  ProjectType.app : ProjectType.package
    );
    p.type == ProjectType.app ? apps.add(p) : packages.add(p);
    return p;
  }

  Map _readPubspecYaml(Directory dir){
    File file = File('${dir.path}/pubspec.yaml');
    String content = file.readAsStringSync();
    Map pubspecYaml = loadYaml(content);
    return pubspecYaml;
  }

  String _getProjectName(Map yaml) {
    return yaml['name'];
  }
}