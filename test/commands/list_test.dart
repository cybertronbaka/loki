import 'package:loki/src/commands/commands.dart';
import 'package:loki/src/models/models.dart';
import 'package:loki/src/services/services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks/mocks.dart';
import '../test_utils/flutter_lock_runner.dart';
import '../test_utils/project_creator.dart';

void main() {
  group('ListCommand', () {
    test('loads config, shows app info, and prints "All Done"', () async {
      final buffer = StringBuffer();
      console = Console(buffer);
      cache = LokiCache();
      final projectsPath = 'test/.tmp_list';
      DirectoryUtils.mkdir(projectsPath);

      var configParser = MockConfigParser();
      when(() => configParser.config).thenReturn(
          LokiConfig(name: 'list Test', packages: ['test/.tmp_fetch']));
      cache.configParser = CacheObject(load: () => configParser);

      final appCreator = ProjectCreator(
          path: projectsPath, name: 'app1', type: ProjectType.app);
      final packageCreator = ProjectCreator(
          path: projectsPath, name: 'package1', type: ProjectType.package);

      try {
        appCreator.run();
        packageCreator.run();
        await FlutterLockRunner.run(() async {
          final command = ListCommand();
          await command.run();
          expect(command.name, contains('list'));
          expect(command.description,
              contains('List all local packages in apps.'));
          expect(buffer.toString(), contains('All done'));
          expect(buffer.toString(), contains('Packages Found'));
          expect(buffer.toString(), contains('Apps Found'));
        });
      } finally {
        DirectoryUtils.rmdir(projectsPath);
        // appCreator.clean();
        // packageCreator.clean();
      }
    });
  });

  tearDown(() {
    cache = LokiCache();
  });
}
