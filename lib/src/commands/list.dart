part of commands;

class ListCommand extends BaseCommand{
  Future<void> run() async {
    loadConfig();
    ProjectFilter().run(config);
  }
}