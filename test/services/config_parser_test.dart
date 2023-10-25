import 'dart:io';

import 'package:loki/src/errors/errors.dart';
import 'package:loki/src/services/services.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('services::config_parser', () {
    test('fromYaml', () {
      final path = Directory('test/fixtures/valid1.yaml').path;
      final parser = ConfigParser.fromYaml(path);
      expect(parser.runtimeType, ConfigParser);
    });

    test('fromYaml throws error', () {
      String path = Directory('test/fixtures/asdflkj.yaml').path;
      expect(() => ConfigParser.fromYaml(path),
          throwsA(TypeMatcher<PathNotFoundException>()));
      path = Directory('test/fixtures/empty.yaml').path;
      expect(() => ConfigParser.fromYaml(path),
          throwsA(TypeMatcher<EmptyYamlFileError>()));
    });

    test('all ok', () {
      final path = Directory('test/fixtures/valid1.yaml').path;
      final parser = ConfigParser.fromYaml(path);
      final config = parser.generate();
      expect(config.name, 'test');
      expect(config.description, 'This is for testing purposes');
      expect(config.packages, ['packages']);
      expect(config.scripts.length, 1);
      expect(config.scripts.first.name, 'test 1 name');
      expect(config.scripts.first.description, 'test1 description');
      expect(config.scripts.first.description, 'test1 description');
      expect(config.scripts.first.workingDir, 'packages/package1');
      expect(config.scripts.first.exec, 'dart pub get');
      expect(config.scripts.first.stdin, false);
    });

    test('no packages', () {
      final path = Directory('test/fixtures/valid2.yaml').path;
      final parser = ConfigParser.fromYaml(path);
      final config = parser.generate();
      expect(config.packages.length, 0);
    });

    group('errors', () {
      final invalids = [
        'name',
        'description',
        'packages',
        'scripts',
        'script_root',
        'script_name',
        'script_description',
        'script_working_dir',
        'script_exec',
        'script_stdin',
        'script_command'
      ];
      for (var e in invalids) {
        test('invalid ${e.split('_').join(' ')}', () {
          final path = Directory('test/fixtures/invalid_$e.yaml').path;
          expect(() => ConfigParser.fromYaml(path).generate(),
              throwsA(TypeMatcher<LokiError>()));
        });
      }
    });

    test('showAppInfo', () {
      console = Console(StringBuffer());
      final path = Directory('test/fixtures/valid1.yaml').path;
      final parser = ConfigParser.fromYaml(path)..generate();
      parser.showAppInfo();
    });
  });
}
