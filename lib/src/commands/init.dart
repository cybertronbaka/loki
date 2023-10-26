part of commands;

class InitCommand extends BaseCommand {
  InitCommand(super.arguments);

  @override
  String get description => 'Creates loki.yaml.';

  @override
  String get name => 'init';

  @override
  FutureOr<void>? run() async {
    final file = File('loki.yaml');
    if (file.existsSync()) {
      console.writeln('Loki: loki.yaml detected!');
      console.writeln(
          '      Continuing would replace your configuration file (loki.yaml)');
      console.write('      Are you sure you want to continue? (y/[n]):');
      final choice = _getChoice();
      if (choice.toLowerCase() == 'y') {
        file.writeAsStringSync(_exampleYamlString);
      }
    } else {
      file.createSync();
      file.writeAsStringSync(_exampleYamlString);
    }
    console.printAllDone();
  }

  String _getChoice() {
    final choice = stdin.readLineSync();
    if (choice == null) return 'n';

    return choice;
  }

  String get _exampleYamlString =>
      '# This is an example configuration for loki\n'
      '# Please edit or replace it with your configuration\n\n'
      '# Disclaimer: This configuration might not work for your workspace\n'
      'name: loki\n'
      'description: description\n'
      'packages:\n'
      '  - path-to-packages # Multiple packages can be inside this directory. Loki doesn\'t support nested packages.\n'
      'scripts:\n'
      '  sample: # To run this simple you can simply use `loki run sample`\n'
      '    name: script name\n'
      '    description: script description\n'
      '    exec: echo "command to execute" # Replace this with your own command\n'
      '    stdin: false # true if you need user input (such as hot reload/hot restart)\n'
      '    working_dir: . # working directory of the script. relative or absolute\n';
}
