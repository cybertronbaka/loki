import 'dart:io';

import 'package:loki/src/errors/errors.dart';
import 'package:loki/src/services/services.dart';
import 'package:test/test.dart';

void main() {
  group('services::process_start_runner', () {
    console = Console(StringBuffer());

    test('runs successfully with no output or errors', () async {
      bool success = false;
      final processRunner = ProcessStartRunner(
          runner: () async => DummyProcess(), onSuccess: () => success = true);
      await processRunner.run();
      expect(success, true);
    });

    test('handles error and calls onError callback', () async {
      bool error = false;
      final processRunner = ProcessStartRunner(
          runner: () async => DummyProcess(shouldThrowError: true),
          onError: () => error = true);
      try {
        await processRunner.run();
      } catch (e) {
        expect(error, true);
        expect(e.runtimeType, LokiError);
      }
    });

    test('clears standard output if clearStdOut is true', () async {
      final processRunner = ProcessStartRunner(
        runner: () async => DummyProcess(shouldHaveOutput: true),
        clearStdOut: true,
      );
      await processRunner.run();
    });

    test('clears standard output if clearStdOut is true', () async {
      bool error = false;
      final processRunner = ProcessStartRunner(
          runner: () async => DummyProcess(shouldHaveStdErr: true),
          clearStdOut: true,
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

class DummyProcess implements Process {
  final bool shouldThrowError;
  final bool shouldHaveOutput;
  final bool shouldHaveStdErr;

  DummyProcess(
      {this.shouldThrowError = false,
      this.shouldHaveOutput = false,
      this.shouldHaveStdErr = false});

  @override
  Stream<List<int>> get stdout => shouldHaveOutput
      ? Stream.fromIterable([
          [1, 2, 3, ...'\n'.codeUnits]
        ])
      : Stream.empty();

  @override
  Stream<List<int>> get stderr => shouldHaveStdErr
      ? Stream.fromIterable([
          [1, 2, 3, ...'\n'.codeUnits]
        ])
      : Stream.empty();

  @override
  Future<int> get exitCode => Future.value(shouldThrowError ? 1 : 0);

  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) {
    throw UnimplementedError();
  }

  @override
  int get pid => throw UnimplementedError();

  @override
  IOSink get stdin => throw UnimplementedError();
}
