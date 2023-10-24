import 'dart:io';

import 'package:loki/src/services/config_parser.dart';
import 'package:loki/src/services/devices_filter.dart';
import 'package:loki/src/services/project_filter.dart';

/// A generic cache object that can store and lazily load data of type [T].
class CacheObject<T> {
  late T _data;
  bool _loaded = false;
  T Function() load;

  CacheObject({required this.load});

  /// Retrieves the cached data. Loads and caches if not already loaded.
  T get fetch {
    if (_loaded) return _data;

    this._data = load();
    _loaded = true;
    return _data;
  }
}

/// A cache manager for Loki related objects.
class LokiCache {
  /// Cache instance of [ConfigParser]
  ///
  /// Usage:
  /// ```dart
  /// ConfigParser configParser = cache.configParser.fetch
  /// ```
  late CacheObject<ConfigParser> configParser;

  /// Cache instance of [ProjectFilter]
  ///
  /// Usage:
  /// ```dart
  /// ProjectFilter projectFilter = cache.projectFilter.fetch
  /// ```
  late CacheObject<ProjectFilter> projectFilter;

  /// Cache instance of [DevicesFilter]
  ///
  /// Usage:
  /// ```dart
  /// DevicesFilter devicesFilter = cache.devicesFilter.fetch
  /// ```
  late CacheObject<DevicesFilter> devicesFilter;
  bool firstTime = true;

  /// Constructs a [LokiCache] and initializes cache objects.
  LokiCache() {
    configParser = CacheObject<ConfigParser>(load: () {
      String path = '${Directory.current.absolute.path}/loki.yaml';
      return ConfigParser.fromYaml(path)..generate();
    });
    projectFilter = CacheObject<ProjectFilter>(load: () {
      return ProjectFilter().run(configParser.fetch.config);
    });
    devicesFilter = CacheObject<DevicesFilter>(load: () {
      return DevicesFilter()..run();
    });
  }
}

/// Singleton instance of [LokiCache] for easy access.
final cache = LokiCache();
