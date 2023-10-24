part of commands;

/// An abstract class representing a base command with common functionality. All commands must extend from this.
abstract class BaseCommand extends Command<void> {
  @override
  String get description;

  @override
  String get name;

  late LokiConfig config;

  @override
  FutureOr<void>? run();

  /// Loads the Loki configuration from the cache.
  void loadConfig() {
    config = cache.configGenerator.fetch.config;
  }
}
