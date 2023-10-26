part of commands;

/// An abstract class representing a base command with common functionality. All commands must extend from this.
abstract class BaseCommand extends Command<void> {
  final List<String> arguments;
  BaseCommand(this.arguments);

  @override
  String get description;

  @override
  String get name;

  late LokiConfig config;

  @override
  FutureOr<void>? run();

  /// Loads the Loki configuration from the cache.
  void loadConfig() {
    config = cache.configParser.fetch.config;
  }
}
