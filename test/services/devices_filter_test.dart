import 'package:loki/src/models/models.dart';
import 'package:loki/src/services/services.dart';
import 'package:test/test.dart';

void main() {
  group('DevicesFilter', () {
    test('run - returns a list of supported devices', () {
      final filter = DevicesFilter();
      final devices = filter.run();
      expect(devices, isNotEmpty);
      expect(devices.every((device) => device.isSupported), isTrue);
    });

    test('printDevices - prints information to the console', () {
      final filter = DevicesFilter();
      filter.devices = [
        FlutterDevice(
            id: '1',
            name: 'Device 1',
            targetPlatform: 'iOS',
            isSupported: true,
            emulator: true,
            sdk: ''),
        FlutterDevice(
            id: '2',
            name: 'Device 2',
            targetPlatform: 'Android',
            isSupported: true,
            emulator: true,
            sdk: ''),
      ];
      console = Console(StringBuffer());
      filter.printDevices();
    });
  });
}
