part of models;

class LokiScriptConfig {
  final String command;
  final String exec;
  final String? name;
  final String? description;
  final bool? flutterRun;
  final String? workingDir;

  const LokiScriptConfig({
    required this.command,
    required this.exec,
    this.name,
    this.description,
    this.flutterRun = false,
    this.workingDir = '.'
  });
}