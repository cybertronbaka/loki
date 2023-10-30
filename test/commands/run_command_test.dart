import 'package:loki/src/commands/commands.dart';
import 'package:loki/src/models/models.dart';
import 'package:loki/src/services/services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks/mocks.dart';

void main() {
  group('RunCommand', () {
    setUp(() {
      registerFallbackValue(LokiProcess(command: 'echo'));
    });

    test('adds scripts keys as subcommands', () async {
      final buffer = StringBuffer();
      console = Console(buffer, MockStdin());
      cache = LokiCache();

      var configParser = MockConfigParser();
      when(() => configParser.config)
          .thenReturn(LokiConfig(name: 'Run Command Test', scripts: [
        LokiScriptConfig(command: 'echo', exec: 'hi'),
      ]));
      cache.configParser.set(configParser);

      final command = RunCommand(['run']);
      try {
        await command.run();
      } catch (e) {
        expect(e.toString(), 'Null check operator used on a null value');
      }
      expect(command.name, 'run');
      expect(command.description,
          'Run a script by name defined in the workspace loki.yaml config file.\n\nTo run a script in sequence join the scripts using &&.');
      expect(command.subcommands.keys, ['echo']);
      expect(command.aliases, ['r']);
    });

    test('adds scripts keys as subcommands', () async {
      final buffer = StringBuffer();
      console = Console(buffer, MockStdin());
      cache = LokiCache();

      final command = RunCommand(['list']);
      expect(command.subcommands, {});
    });
  });
}
