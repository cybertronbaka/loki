import 'package:loki/src/commands/commands.dart';
import 'package:loki/src/models/models.dart';
import 'package:loki/src/services/services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks/mocks.dart';
import '../test_utils/flutter_lock_runner.dart';
import '../test_utils/project_creator.dart';

void main() {
  group('CleanCommand', () {
    test('cleans on projects', () async {
      final buffer = StringBuffer();
      console = Console(buffer, MockStdin());
      cache = LokiCache();
      final projectsPath = 'test/.tmp_clean';
      DirectoryUtils.mkdir(projectsPath);

      var configParser = MockConfigParser();
      when(() => configParser.config).thenReturn(
          LokiConfig(name: 'Clean Test', packages: ['test/.tmp_clean']));
      cache.configParser = CacheObject(load: () => configParser);

      final appCreator = ProjectCreator(
          path: projectsPath, name: 'app1', type: ProjectType.app);
      final packageCreator = ProjectCreator(
          path: projectsPath, name: 'package1', type: ProjectType.package);

      try {
        appCreator.run();
        packageCreator.run();
        await FlutterLockRunner.run(() async {
          final command = CleanCommand(['clean'], cleanOnRoot: false);
          await command.run();
          expect(command.name, 'clean');
          expect(command.description,
              'Runs `flutter clean` in all packages and apps');
          expect(command.aliases, ['c']);
          expect(buffer.toString(), contains('Cleaning'));
          expect(buffer.toString(), contains('Cleaned'));
        });
      } finally {
        DirectoryUtils.rmdir(projectsPath);
        // appCreator.clean();
        // packageCreator.clean();
      }
    });

    tearDown(() {});
  });
}
