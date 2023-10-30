import 'package:loki/src/commands/commands.dart';
import 'package:loki/src/services/services.dart';
import 'package:loki/src/version.dart';
import 'package:test/test.dart';

void main() {
  group('VersionCommand', () {
    test('prints version information', () {
      final command = VersionCommand(['version']);
      final buffer = StringBuffer();
      console = Console(buffer);
      command.run();
      expect(buffer.toString(), contains('v$version'));
      expect(command.name, 'version');
      expect(command.description, 'Print version information');
    });

    test('prints attribution information', () {
      final command = VersionCommand(['version']);
      final buffer = StringBuffer();
      console = Console(buffer);
      command.run();
      expect(
        buffer.toString(),
        contains('Made with'),
      );
    });
  });
}
