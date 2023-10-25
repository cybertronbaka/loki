import 'package:loki/src/commands/commands.dart';
import 'package:loki/src/models/models.dart';
import 'package:loki/src/services/services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks/mocks.dart';
import '../test_utils/project_creator.dart';

void main() {
  group('AppCommand', () {
    setUp(() {
      registerFallbackValue(LokiProcess(command: 'echo'));
    });

    test('adds apps as subcommands', () async {
      final buffer = StringBuffer();
      console = Console(buffer);
      cache = LokiCache();
      final projectsPath = 'test/.tmp_app';
      DirectoryUtils.mkdir(projectsPath);

      var configParser = MockConfigParser();
      when(() => configParser.config).thenReturn(
          LokiConfig(name: 'App Command Test', packages: ['test/.tmp_app']));
      cache.configParser.set(configParser);
      final appCreator = ProjectCreator(
          path: projectsPath, name: 'app1', type: ProjectType.app);

      try {
        appCreator.run();
        final command = AppCommand();
        expect(command.name, 'app');
        expect(command.description, 'Runs a flutter app in the workspace');
        expect(command.subcommands.keys, ['app1']);
      } finally {
        DirectoryUtils.rmdir(projectsPath);
        // appCreator.clean();
      }
    });
  });
}
