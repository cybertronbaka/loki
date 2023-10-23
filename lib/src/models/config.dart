part of models;

class LokiConfig {
  final String? name;
  final String? description;
  final List<String> packages;
  final List<LokiScriptConfig> scripts;

  const LokiConfig({
    this.name,
    this.description,
    this.packages = const [],
    this.scripts = const []
  });
}