import 'package:loki/src/services/services.dart';
import 'package:test/test.dart';

import '../mocks/mocks.dart';

void main() {
  group('services::console', () {
    test('write should write', () {
      final output = StringBuffer();
      Console console = Console(output, MockStdin());
      console.write('Hello');
      expect(output.toString(), 'Hello');
    });

    test('writeln should write and \\n', () {
      final output = StringBuffer();
      Console console = Console(output, MockStdin());
      console.writeln('Hello');
      expect(output.toString(), 'Hello\n');
    });

    test('moveUpAndClear should move up and clear the line', () {
      final output = StringBuffer();
      Console console = Console(output, MockStdin());
      console.moveUpAndClear();
      expect(output.toString(), '\u001B[1A\u001B[2K');
    });

    test('moveUp should move up', () {
      final output = StringBuffer();
      Console console = Console(output, MockStdin());
      console.moveUp();
      expect(output.toString(), '\u001B[1A');
    });

    test('clearLine should clear line', () {
      final output = StringBuffer();
      Console console = Console(output, MockStdin());
      console.clearLine();
      expect(output.toString(), '\u001B[2K');
    });

    test('printAllDone should print all done message', () {
      final output = StringBuffer();
      Console console = Console(output, MockStdin());
      console.printAllDone();
      expect(output.toString().contains('All done'), true);
    });

    test('printAttribution should print attributions', () {
      final output = StringBuffer();
      Console console = Console(output, MockStdin());
      console.printAttribution();
      expect(output.toString().contains('Made with'), true);
    });

    test('console should be of type Console', () {
      expect(console.runtimeType, Console);
    });
  });
}
