import 'package:loki/src/commands/commands.dart';
import 'package:loki/src/services/services.dart';
import 'package:test/test.dart';

void main() {
  group('ValidateCommand', () {
    test('loads config, shows app info, and prints "All Done"', () async {
      final command = ValidateCommand(['validate']);
      final buffer = StringBuffer();
      console = Console(buffer);
      final path = 'test/fixtures/valid2.yaml';
      cache.lokiYamlPath.set(path);
      cache.firstTime.set(true);
      await command.run();
      expect(command.name, contains('validate'));
      expect(command.description, contains('Validate loki.yaml config file.'));
      expect(
        buffer.toString(),
        contains('Loki Workspace Info'),
      );
      expect(
        buffer.toString(),
        contains('All done'),
      );
    });
  });

  tearDown(() {
    cache = LokiCache();
  });
}
