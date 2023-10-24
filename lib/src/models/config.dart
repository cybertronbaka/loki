part of models;

/// Represents the configuration of a Loki workspace.
class LokiConfig {
  /// The name of the Loki workspace.
  final String? name;

  /// A description of the Loki workspace.
  final String? description;

  /// List of package paths within the Loki workspace.
  final List<String> packages;

  /// List of script configurations within the Loki workspace.
  final List<LokiScriptConfig> scripts;

  const LokiConfig(
      {this.name,
      this.description,
      this.packages = const [],
      this.scripts = const []});
}
