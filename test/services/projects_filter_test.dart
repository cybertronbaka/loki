import 'dart:io';

import 'package:loki/src/models/models.dart';
import 'package:loki/src/services/services.dart';
import 'package:test/test.dart';

import '../test_utils/project_creator.dart';

void main() {
  group('ProjectFilter', () {
    test('run - Directory does not exist', () {
      final path = Directory('test/fixtures/valid3.yaml').path;
      final projectsPath = 'test/fixtures/.tmp';
      DirectoryUtils.rmdir(projectsPath);
      final config = ConfigParser.fromYaml(path).generate();
      final filter = ProjectFilter();
      expect(() => filter.run(config), throwsArgumentError);
    });

    test('run - nothing at dir', () {
      final path = Directory('test/fixtures/valid3.yaml').path;
      final projectsPath = 'test/fixtures/.tmp';
      DirectoryUtils.mkdir('$projectsPath/app1');
      final config = ConfigParser.fromYaml(path).generate();
      final filter = ProjectFilter();
      try {
        expect(() => filter.run(config), throwsException);
      } finally {
        DirectoryUtils.rmdir(projectsPath);
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
      final path = Directory('test/fixtures/valid3.yaml').path;
      final projectsPath = 'test/fixtures/.tmp';
      final appCreator = ProjectCreator(
          path: projectsPath, name: 'app1', type: ProjectType.app);
      final packageCreator = ProjectCreator(
          path: projectsPath, name: 'package1', type: ProjectType.package);
      try {
        appCreator.run();
        packageCreator.run();
        final config = ConfigParser.fromYaml(path).generate();
        final filter = ProjectFilter();
        final result = filter.run(config);
        expect(result.apps, hasLength(1));
        expect(result.packages, hasLength(2)); // including this very project
        expect(result.all, hasLength(3));
      } finally {
        DirectoryUtils.rmdir(projectsPath);
        appCreator.clean();
        packageCreator.clean();
      }
    });
  });
}
