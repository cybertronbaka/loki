part of models;

/// Enum representing types of projects: app or package.
enum ProjectType {
  /// Represents a Flutter application project.
  app,
  /// Represents a Dart package project.
  package
}

/// Represents a project with specific properties.
class Project {
  /// The directory containing the project.
  Directory dir;
  /// The name of the project.
  String name;
  /// The content of the pubspec.yaml file as a Map.
  Map pubspec;
  /// The type of project (app or package).
  ProjectType type;

  Project({
    required this.dir,
    required this.type,
    required this.name,
    required this.pubspec
  });
}