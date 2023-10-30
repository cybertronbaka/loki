import 'package:loki/src/commands/commands.dart';
import 'package:loki/src/models/models.dart';
import 'package:loki/src/services/services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks/mocks.dart';
import '../test_utils/flutter_lock_runner.dart';
import '../test_utils/project_creator.dart';

void main() {
  group('FetchCommand', () {
    test('loads config, shows app info, and fetches dependencies for projects',
        () async {
      final buffer = StringBuffer();
      console = Console(buffer, MockStdin());
      cache = LokiCache();
      final projectsPath = 'test/.tmp_fetch';
      DirectoryUtils.mkdir(projectsPath);
      var configParser = MockConfigParser();
      when(() => configParser.config).thenReturn(
          LokiConfig(name: 'fetch test', packages: ['test/.tmp_fetch']));
      cache.configParser = CacheObject(load: () => configParser);

      final appCreator = ProjectCreator(
          path: projectsPath, name: 'app1', type: ProjectType.app);
      final packageCreator = ProjectCreator(
          path: projectsPath, name: 'package1', type: ProjectType.package);

      try {
        appCreator.run();
        packageCreator.run();
        await FlutterLockRunner.run(() async {
          final command = FetchCommand(['fetch']);
          await command.run();
          expect(command.name, 'fetch');
          expect(
              command.description, 'Install dependencies in packages and apps');
          expect(buffer.toString(), contains('Resolving dependencies...'));
          expect(buffer.toString(), contains('All done'));
        });
      } finally {
        DirectoryUtils.rmdir(projectsPath);
        // appCreator.clean();
        // packageCreator.clean();
      }
    });
  });
}
