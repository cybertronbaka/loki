import 'package:loki/src/models/models.dart';
import 'package:loki/src/services/services.dart';
import 'package:test/test.dart';

void main() {
  group('ProcessManager', () {
    test('with stdin', () async {
      var manager = ProcessManager();
      await manager
          .run(LokiProcess(command: 'echo', args: ['hello'], hasStdin: true));
      expect(manager.processes, hasLength(1));
    });
    test('without stdin', () async {
      var manager = ProcessManager();
      await manager
          .run(LokiProcess(command: 'echo', args: ['hello'], hasStdin: false));
      expect(manager.processes, hasLength(1));
    });
  });
}
