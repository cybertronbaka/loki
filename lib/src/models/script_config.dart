part of models;

/// Represents the configuration of a Loki script.
class LokiScriptConfig {
  /// The command used to invoke the script.
  final String command;

  /// The command to execute the script.
  final String exec;

  /// The optional name of the script.
  final String? name;

  /// The optional description of the script.
  final String? description;

  /// Indicates whether the script accepts standard input.
  final bool? stdin;

  /// The optional working directory for the script.
  final String? workingDir;

  const LokiScriptConfig(
      {required this.command,
      required this.exec,
      this.name,
      this.description,
      this.stdin = false,
      this.workingDir = '.'});
}
