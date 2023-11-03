import 'dart:io';

import 'package:loki/src/models/models.dart';
import 'package:loki/src/services/services.dart';
import 'package:test/test.dart';
import 'package:yaml_edit/yaml_edit.dart';

import '../mocks/mocks.dart';
import '../test_utils/project_creator.dart';

void main() {
  group('services:bootstrapper', () {
    test('bootstraps (case 1: doesn\'t depend on local packages)', () {
      final root = 'test/.tmp_bootstrapper1';
      final buffer = StringBuffer();
      console = Console(buffer, MockStdin());
      ProjectCreator(
        path: root,
        name: 'p1',
        type: ProjectType.package,
      ).run();
      var config = LokiConfig(name: 'App Command Test', packages: [root]);
      cache.projectFilter.set(ProjectFilter().run(config));
      final projects = cache.projectFilter.fetch.all;
      final bootstrapper = Bootstrapper(projects);
      try {
        for (var p in projects) {
          bootstrapper.run(p);
        }
        expect(File('$root/p1/pubspec_overrides.yaml').existsSync(), false);
      } finally {
        DirectoryUtils.rmdir(root);
      }
    });

    test('bootstraps (case 2: depend on local packages & no override file)',
        () {
      final root = 'test/.tmp_bootstrapper2';
      final buffer = StringBuffer();
      console = Console(buffer, MockStdin());
      ProjectCreator(
        path: root,
        name: 'used',
        type: ProjectType.package,
      ).run();
      ProjectCreator(
        path: root,
        name: 'user',
        type: ProjectType.package,
        dependencies: {
          'used': {'path': '../used'}
        },
      ).run();
      var config = LokiConfig(name: 'App Command Test', packages: [root]);
      cache.projectFilter.set(ProjectFilter().run(config));
      final projects = cache.projectFilter.fetch.all;
      final bootstrapper = Bootstrapper(projects);
      try {
        for (var p in projects) {
          bootstrapper.run(p);
        }
        expect(File('$root/used/pubspec_overrides.yaml').existsSync(), false);
        final overrideFile = File('$root/user/pubspec_overrides.yaml');
        expect(overrideFile.existsSync(), true);
        var node = YamlEditor(overrideFile.readAsStringSync()).parseAt(
            ['dependency_overrides', 'used', 'path'],
            orElse: () => wrapAsYamlNode(null));
        expect(node.value != null, true);
        expect(node.value, '../used');
        node = YamlEditor(File('$root/user/pubspec.yaml').readAsStringSync())
            .parseAt(['dependencies', 'used'],
                orElse: () => wrapAsYamlNode(null));
        expect(node.value != null, true);
        expect(node.value, 'any');
      } finally {
        DirectoryUtils.rmdir(root);
      }
    });

    test('bootstraps (case 3: depend on local packages & empty override file)',
        () {
      final root = 'test/.tmp_bootstrapper3';
      final buffer = StringBuffer();
      console = Console(buffer, MockStdin());
      ProjectCreator(
        path: root,
        name: 'used',
        type: ProjectType.package,
      ).run();
      ProjectCreator(
              path: root,
              name: 'user',
              type: ProjectType.package,
              dependencies: {
                'used': {'path': '../used'}
              },
              createPubspecOverridesFile: true)
          .run();
      var config = LokiConfig(name: 'App Command Test', packages: [root]);
      cache.projectFilter.set(ProjectFilter().run(config));
      final projects = cache.projectFilter.fetch.all;
      final bootstrapper = Bootstrapper(projects);
      try {
        for (var p in projects) {
          bootstrapper.run(p);
        }
        expect(File('$root/used/pubspec_overrides.yaml').existsSync(), false);
        final overrideFile = File('$root/user/pubspec_overrides.yaml');
        expect(overrideFile.existsSync(), true);
        var node = YamlEditor(overrideFile.readAsStringSync()).parseAt(
            ['dependency_overrides', 'used', 'path'],
            orElse: () => wrapAsYamlNode(null));
        expect(node.value != null, true);
        expect(node.value, '../used');
        node = YamlEditor(File('$root/user/pubspec.yaml').readAsStringSync())
            .parseAt(['dependencies', 'used'],
                orElse: () => wrapAsYamlNode(null));
        expect(node.value != null, true);
        expect(node.value, 'any');
      } finally {
        DirectoryUtils.rmdir(root);
      }
    });

    test('bootstraps (case 4: depend on local packages & empty override file)',
        () {
      final root = 'test/.tmp_bootstrapper4';
      final buffer = StringBuffer();
      console = Console(buffer, MockStdin());
      ProjectCreator(
        path: root,
        name: 'used',
        type: ProjectType.package,
      ).run();
      ProjectCreator(
        path: root,
        name: 'used1',
        type: ProjectType.package,
      ).run();
      ProjectCreator(
          path: root,
          name: 'user',
          type: ProjectType.package,
          dependencies: {
            'used': {'path': '../used'},
            'used1': {'path': '../used1'}
          },
          createPubspecOverridesFile: true,
          pubspecOverrides: {
            'dependency_overrides': {
              'used': {'path': '../used'}
            }
          }).run();
      var config = LokiConfig(name: 'App Command Test', packages: [root]);
      cache.projectFilter.set(ProjectFilter().run(config));
      final projects = cache.projectFilter.fetch.all;
      final bootstrapper = Bootstrapper(projects);
      try {
        for (var p in projects) {
          bootstrapper.run(p);
        }
        expect(File('$root/used/pubspec_overrides.yaml').existsSync(), false);
        final overrideFile = File('$root/user/pubspec_overrides.yaml');
        expect(overrideFile.existsSync(), true);
        var node = YamlEditor(overrideFile.readAsStringSync()).parseAt(
            ['dependency_overrides', 'used', 'path'],
            orElse: () => wrapAsYamlNode(null));
        expect(node.value != null, true);
        expect(node.value, '../used');
        node = YamlEditor(File('$root/user/pubspec.yaml').readAsStringSync())
            .parseAt(['dependencies', 'used'],
                orElse: () => wrapAsYamlNode(null));
        expect(node.value != null, true);
        expect(node.value, 'any');
      } finally {
        DirectoryUtils.rmdir(root);
      }
    });
  });
}
