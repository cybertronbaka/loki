import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:loki/src/commands/commands.dart';
import 'package:loki/src/models/models.dart';
import 'package:loki/src/services/services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks/mocks.dart';
import '../test_utils/project_creator.dart';

void main() {
  group('AppSubcommand', () {
    setUp(() {
      registerFallbackValue(LokiProcess(command: 'echo'));
    });

    test('runs successfully', () async {
      final buffer = StringBuffer();
      console = Console(buffer);
      cache = LokiCache();
      final projectsPath = 'test/.tmp_app_sub';
      DirectoryUtils.mkdir(projectsPath);

      final app = Project(
        name: 'app1',
        dir: Directory('$projectsPath/app1'),
        type: ProjectType.app,
        pubspec: {},
      );
      List<LokiProcess> processes = [];
      var processManager = MockProcessManager();
      when(() => processManager.run(any<LokiProcess>()))
          .thenAnswer((inv) async {
        processes.add(inv.positionalArguments[0]);
      });
      when(() => processManager.processes).thenReturn(processes);
      cache.processManager.set(processManager);
      final appCreator = ProjectCreator(
          path: projectsPath, name: 'app1', type: ProjectType.app);

      try {
        appCreator.run();
        final command = AppSubcommand(app);
        final runner = CommandRunner('loki', 'testing')..addCommand(command);
        await runner.run([app.name, '-f', 'dev', '-v']);
        expect(command.name, app.name);
        expect(command.description, 'Run app (${app.name})');
        expect(processManager.processes, hasLength(1));
        expect(processManager.processes.first.command, 'flutter');
        expect(processManager.processes.first.args.join(' '),
            'run -d linux --debug --flavor dev -t lib/main_dev.dart -v');
      } finally {
        DirectoryUtils.rmdir(projectsPath);
        // appCreator.clean();
      }
    });
  });
}
