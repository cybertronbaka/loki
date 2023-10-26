import 'package:loki/src/commands/commands.dart';
import 'package:loki/src/errors/errors.dart';
import 'package:loki/src/models/models.dart';
import 'package:loki/src/services/services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks/mocks.dart';

void main() {
  group('RunSubCommand', () {
    List<LokiProcess> processes = [];

    setUp(() {
      final buffer = StringBuffer();
      console = Console(buffer);
      cache = LokiCache();

      registerFallbackValue(LokiProcess(command: 'echo'));
      processes = [];
      var processManager = MockProcessManager();
      when(() => processManager.run(any<LokiProcess>(),
          onError: any(named: 'onError'))).thenAnswer((inv) async {
        processes.add(inv.positionalArguments[0]);
      });
      when(() => processManager.processes).thenReturn(processes);
      cache.processManager.set(processManager);
    });

    test('runs without &&', () async {
      final script = LokiScriptConfig(
          command: 'echo',
          exec: 'echo hello',
          name: 'echo',
          description: 'desc');

      final command = RunSubcommand(script, ['run', 'echo']);
      await command.run();
      expect(command.name, script.command);
      expect(command.description, contains(script.description));
      expect(processes, hasLength(1));
      expect(processes.first.command, 'echo');
      expect(processes.first.args.join(' '), 'hello');
    });

    test('runs with &&', () async {
      final script = LokiScriptConfig(
          command: 'echo',
          exec: 'echo hello && flutter run',
          name: 'echo',
          description: 'desc');

      final command = RunSubcommand(script, ['run', 'echo']);
      await command.run();
      expect(command.name, script.command);
      expect(command.description, contains(script.description));
      expect(processes, hasLength(2));
      expect(processes[1].command, 'flutter');
      expect(processes[1].args.join(' '), 'run');
    });

    test('no process is created with cd', () async {
      final script = LokiScriptConfig(
          command: 'echo', exec: 'cd ../', name: 'echo', description: 'desc');

      final command = RunSubcommand(script, ['run', 'echo']);
      await command.run();
      expect(command.name, script.command);
      expect(command.description, contains(script.description));
      expect(processes, hasLength(0));
    });

    test('Cannot cd into nothing!', () async {
      final script = LokiScriptConfig(
          command: 'echo', exec: 'cd', name: 'echo', description: 'desc');

      final command = RunSubcommand(script, ['run', 'echo']);
      try {
        await command.run();
      } catch (e) {
        expect(e, isA<LokiError>());
        expect(e.toString(), contains('Cannot cd into nothing!'));
      }
    });

    // TODO: Write tests for calling loki base directly from run-subcommand
  });
}
