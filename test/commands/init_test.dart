import 'dart:io';

import 'package:loki/src/commands/commands.dart';
import 'package:loki/src/services/services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks/mocks.dart';
import '../test_utils/project_creator.dart';

void main(){
  group('commands:init', (){
    test('creates a loki.yaml file', () async {
      final stdin = MockStdin();
      console = Console(StringBuffer(), stdin);
      final path = 'test/.tmp_init';
      final yamlPath = '$path/loki.yaml';
      DirectoryUtils.mkdir(path);

      try {
        final command = InitCommand(['init'], path);
        await command.run();
        expect(command.name, 'init');
        expect(command.description, 'Creates loki.yaml.');
        expect(File(yamlPath).existsSync(), true);
      } finally {
        DirectoryUtils.rmdir(path);
      }
    });

    test('overrides existing loki.yaml file (y)', () async {
      final iSink = MockStdin();
      console = Console(StringBuffer(), iSink);
      final path = 'test/.tmp_init1';
      DirectoryUtils.mkdir(path);
      final yamlPath = '$path/loki.yaml';
      FileUtils.create(yamlPath, 'hi');
      when(() => iSink.readLineSync()).thenReturn('y');

      try {
        final command = InitCommand(['init'], path);
        await command.run();
        expect(File(yamlPath).existsSync(), true);
        expect(File(yamlPath).readAsStringSync(), isNot(equals('hi')));
      } finally {
        DirectoryUtils.rmdir(path);
      }
    });

    test('overrides existing loki.yaml file (n)', () async {
      final iSink = MockStdin();
      console = Console(StringBuffer(), iSink);
      final path = 'test/.tmp_init2';
      final yamlPath = '$path/loki.yaml';
      DirectoryUtils.mkdir(path);
      FileUtils.create(yamlPath, 'hi');
      when(() => iSink.readLineSync()).thenReturn('n');

      try {
        final command = InitCommand(['init'], path);
        await command.run();
        expect(File(yamlPath).existsSync(), true);
        expect(File(yamlPath).readAsStringSync(), equals('hi'));
      } finally {
        DirectoryUtils.rmdir(path);
      }
    });
  });
}