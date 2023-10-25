import 'dart:io';

import 'package:loki/src/models/models.dart';
import 'package:loki/src/services/services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks/mocks.dart';
import '../test_utils/project_creator.dart';

void main() {
  group('ProjectFilter', () {
    test('run - Directory does not exist', () {
      final projectsPath = 'test/.tmp_project_filter0';
      DirectoryUtils.rmdir(projectsPath);
      var configParser = MockConfigParser();
      when(() => configParser.config).thenReturn(LokiConfig(
          name: 'Project Filter Test',
          packages: ['test/.tmp_project_filter0']));
      cache.configParser = CacheObject(load: () => configParser);
      final filter = ProjectFilter();
      expect(() => filter.run(configParser.config), throwsArgumentError);
    });

    test('run - nothing at dir', () {
      final projectsPath = 'test/.tmp_project_filter1';
      DirectoryUtils.mkdir('$projectsPath/app1');

      var configParser = MockConfigParser();
      when(() => configParser.config).thenReturn(LokiConfig(
          name: 'Project Filter Test',
          packages: ['test/.tmp_project_filter1']));
      cache.configParser = CacheObject(load: () => configParser);

      final filter = ProjectFilter();
      try {
        expect(() => filter.run(configParser.config), throwsException);
      } finally {
        DirectoryUtils.rmdir(projectsPath);
        // DirectoryUtils.rmdir('$projectsPath/app1');
      }
    });

    test('printProjects - prints information to the console', () {
      final filter = ProjectFilter();
      filter.apps.add(Project(
          name: 'App1',
          pubspec: {},
          dir: Directory('/path/to/app1'),
          type: ProjectType.app));
      filter.packages.add(Project(
          name: 'Package1',
          pubspec: {},
          dir: Directory('/path/to/package1'),
          type: ProjectType.package));
      console = Console(StringBuffer());
      filter.printProjects();
    });

    test('run - filters and adds projects correctly', () {
      final projectsPath = 'test/.tmp_project_filter2';
      DirectoryUtils.mkdir(projectsPath);

      var configParser = MockConfigParser();
      when(() => configParser.config).thenReturn(LokiConfig(
          name: 'Project Filter Test',
          packages: ['test/.tmp_project_filter2']));
      cache.configParser = CacheObject(load: () => configParser);

      final appCreator = ProjectCreator(
          path: projectsPath, name: 'app1', type: ProjectType.app);
      final packageCreator = ProjectCreator(
          path: projectsPath, name: 'package1', type: ProjectType.package);
      try {
        appCreator.run();
        packageCreator.run();
        final filter = ProjectFilter();
        final result = filter.run(configParser.config);
        expect(result.apps, hasLength(1));
        expect(result.packages, hasLength(2)); // including this very project
        expect(result.all, hasLength(3));
      } finally {
        DirectoryUtils.rmdir(projectsPath);
        // appCreator.clean();
        // packageCreator.clean();
      }
    });
  });
}
