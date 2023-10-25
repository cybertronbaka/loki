import 'package:loki/src/services/services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks/mocks.dart';

void main() {
  group('CacheObject', () {
    test('fetch - loads and returns data if not loaded', () {
      bool loadedData = false;
      CacheObject<bool> cacheObject = CacheObject<bool>(load: () {
        loadedData = true;
        return true;
      });
      bool data = cacheObject.fetch;
      expect(data, true);
      expect(loadedData, true);
    });

    test('fetch - returns cached data if already loaded', () {
      bool loadedData = false;
      CacheObject<bool> cacheObject = CacheObject<bool>(load: () {
        loadedData = true;
        return true;
      });
      bool cachedData = cacheObject.fetch;
      expect(cachedData, true);
      expect(loadedData, true);
    });

    test('set - sets data in cache', () {
      CacheObject<int> cacheObject = CacheObject<int>(load: () => 42);
      cacheObject.set(10);
      expect(cacheObject.fetch, 10);
    });
  });

  group('LokiCache', () {
    late MockConfigParser mockConfigParser;
    late MockProjectFilter mockProjectFilter;
    late MockDevicesFilter mockDevicesFilter;

    setUp(() {
      cache = LokiCache();
      mockConfigParser = MockConfigParser();
      mockProjectFilter = MockProjectFilter();
      mockDevicesFilter = MockDevicesFilter();
    });

    test('cache objects are initialized correctly', () {
      cache.configParser.set(mockConfigParser);
      cache.projectFilter.set(mockProjectFilter);
      cache.devicesFilter.set(mockDevicesFilter);

      ConfigParser configParser = cache.configParser.fetch;
      ProjectFilter projectFilter = cache.projectFilter.fetch;
      DevicesFilter devicesFilter = cache.devicesFilter.fetch;
      bool firstTime = cache.firstTime.fetch;

      expect(configParser, isA<ConfigParser>());
      expect(projectFilter, isA<ProjectFilter>());
      expect(devicesFilter, isA<DevicesFilter>());
      expect(cache.processManager.fetch, isA<ProcessManager>());
      expect(firstTime, true);
    });

    test('cache objects are initialized correctly', () {
      cache.lokiYamlPath.fetch;
      cache.lokiYamlPath.set('test/fixtures/valid2.yaml');
      ConfigParser configParser = cache.configParser.fetch;
      ProjectFilter projectFilter = cache.projectFilter.fetch;
      DevicesFilter devicesFilter = cache.devicesFilter.fetch;
      bool firstTime = cache.firstTime.fetch;

      expect(configParser, isA<ConfigParser>());
      expect(projectFilter, isA<ProjectFilter>());
      expect(devicesFilter, isA<DevicesFilter>());
      expect(cache.processManager.fetch, isA<ProcessManager>());
      expect(firstTime, true);
    });

    tearDown(() {
      cache = LokiCache();
      reset(mockConfigParser);
      reset(mockProjectFilter);
      reset(mockDevicesFilter);
    });
  });
}
