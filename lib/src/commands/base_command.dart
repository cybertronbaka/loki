part of commands;

class BaseCommand {
  late LokiConfig config;

  void loadConfig(){
    String path = '${Directory.current.absolute.path}/loki.yaml';
    config = ConfigGenerator.fromYaml(path).generate();
    showAppInfo();
  }

  void showAppInfo(){
    stdout.writeln('''${chalk.yellowBright('App Info:')}
  ${chalk.blueBright('Name:')} ${chalk.greenBright(config.name)}
  ${chalk.blueBright('Description:')} ${chalk.greenBright(config.description ?? '-')}
''');
  }
}