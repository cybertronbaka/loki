import 'package:loki/src/errors/errors.dart';
import 'package:loki/src/models/models.dart';
import 'package:loki/src/services/services.dart';
import 'package:test/test.dart';

void main() {
  group('ProcessRunnerWithoutStdin', () {
    console = Console(StringBuffer());

    test('runs successfully with no output or errors', () async {
      bool success = false;
      final processRunner = ProcessRunnerWithoutStdin(
          config: LokiProcess(command: 'echo', args: ['Hello Test']),
          onSuccess: () => success = true);
      await processRunner.run();
      expect(success, true);
    });

    test('handles error and calls onError callback', () async {
      bool error = false;
      final processRunner = ProcessRunnerWithoutStdin(
          config: LokiProcess(
            command: 'sdlkfjslfdj',
          ),
          onError: () => error = true);
      try {
        await processRunner.run();
      } catch (e) {
        expect(error, true);
        expect(e.runtimeType, LokiError);
      }
    });

    test('clears standard output if clearStdOut is true', () async {
      final processRunner = ProcessRunnerWithoutStdin(
        config: LokiProcess(
            command: 'echo', args: ['hello test'], clearStdOut: true),
      );
      await processRunner.run();
    });

    test('clears standard output if clearStdOut is true', () async {
      bool error = false;
      final processRunner = ProcessRunnerWithoutStdin(
          config: LokiProcess(
              command: 'asdfsadfsaf', args: ['hello test'], clearStdOut: true),
          onError: () => error = true);
      try {
        await processRunner.run();
      } catch (e) {
        expect(error, true);
        expect(e.runtimeType, LokiError);
      }
    });
  });
}
