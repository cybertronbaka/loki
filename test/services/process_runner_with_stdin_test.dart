import 'dart:convert';

import 'package:loki/src/models/models.dart';
import 'package:loki/src/services/services.dart';
import 'package:test/test.dart';

void main() {
  group('ProcessRunnerWithStdin', () {
    /// If this fails it is probably because test/fixtures/stdin.sh
    /// is not executable
    /// To fix that in your terminal run
    /// chmod +x test/fixtures/stdin.sh
    test('success', () async {
      StringBuffer buffer = StringBuffer();
      console = Console(buffer);
      int lines = 0;
      await ProcessRunnerWithStdin(
          isTest: true,
          config: LokiProcess(
              command: 'bash',
              args: ['stdin.sh'],
              workingDir: 'test/fixtures',
              hasStdin: true),
          onError: () {
            console.writeln('Error');
          },
          onSuccess: () {
            console.writeln('Success');
          },
          onStart: (p) {
            p.stdout.transform(utf8.decoder).listen((data) {
              console.write(data);
              lines++;
              if (lines == 1) p.stdin.write('Dorji\n');
            });
            p.stderr.transform(utf8.decoder).listen((data) {
              console.write(data);
            });
          }).run();
      expect(buffer.toString(), contains("It's nice to meet you Dorji"));
      expect(buffer.toString(), contains("Success"));
    });

    test('success', () async {
      StringBuffer buffer = StringBuffer();
      console = Console(buffer);
      bool error = false;
      try {
        await ProcessRunnerWithStdin(
                isTest: true,
                config: LokiProcess(
                    command: 'sdfsadf',
                    args: ['stdin.sh'],
                    workingDir: 'test/fixtures',
                    hasStdin: true),
                onError: () {
                  error = true;
                  console.writeln('Error');
                },
                onSuccess: () {
                  console.writeln('Success');
                },
                onStart: (p) {})
            .run();
      } catch (e) {
        expect(error, true);
        expect(buffer.toString(), contains('Error'));
      }
    });
  });
}
