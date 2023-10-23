part of commands;

abstract class BaseCommand extends Command<void>{
  @override
  String get description;

  @override
  String get name;

  late LokiConfig config;

  @override
  FutureOr<void>? run();

  void loadConfig(){
    config = cache.configGenerator.fetch.config;
  }
}