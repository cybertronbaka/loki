part of models;

enum ProjectType { app, package }
class Project {
  Directory dir;
  String name;
  Map pubspec;
  ProjectType type;
  Project({
    required this.dir,
    required this.type,
    required this.name,
    required this.pubspec
  });
}