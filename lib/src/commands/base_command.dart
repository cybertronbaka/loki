part of commands;

abstract class BaseCommand extends Command<void>{
  bool _configLoaded = false;
  @override
  String get description;

  @override
  String get name;

  late LokiConfig config;

  @override
  FutureOr<void>? run();

  void loadConfig([bool showInfo = true]){
    if(_configLoaded) return;

    String path = '${Directory.current.absolute.path}/loki.yaml';
    config = ConfigGenerator.fromYaml(path).generate();
    _configLoaded = true;
    if(showInfo) showAppInfo();
  }

  void showAppInfo(){
    stdout.write('${chalk.yellowBright('App Info:\n')}'
      ' ${chalk.blueBright('Name:')} ${chalk.greenBright(config.name)}\n'
      ' ${chalk.blueBright('Description:')} ${chalk.greenBright(config.description ?? '-')}\n\n'
    '');
  }
}