import 'dart:io';

import 'package:chalkdart/chalk.dart';
import 'package:loki/src/models/models.dart';
import 'package:loki/src/services/config_generator.dart';
import 'package:loki/src/services/devices_filter.dart';
import 'package:loki/src/services/project_filter.dart';

class CacheObject<T>{
  late T _data;
  bool _loaded = false;
  T Function() load;

  CacheObject({
    required this.load
  });

  T get fetch {
    if(_loaded) return _data;

    this._data = load();
    _loaded = true;
    return _data;
  }
}

class LokiCache{
  late CacheObject<ConfigGenerator> configGenerator;
  late CacheObject<ProjectFilter> projectFilter;
  late CacheObject<DevicesFilter> devicesFilter;

  LokiCache(){
    configGenerator = CacheObject<ConfigGenerator>(
      load: () {
        // stdout.writeln(chalk.yellowBright('Loading config!'));
        String path = '${Directory.current.absolute.path}/loki.yaml';
        return ConfigGenerator.fromYaml(path)..generate();
      }
    );
    projectFilter = CacheObject<ProjectFilter>(
      load: () {
        // stdout.writeln(chalk.yellowBright('Loading Projects!'));
        return ProjectFilter().run(configGenerator.fetch.config);
      }
    );
    devicesFilter = CacheObject<DevicesFilter>(
      load: (){
        // stdout.writeln(chalk.yellowBright('Loading Devices!'));
        return DevicesFilter()..run();
      }
    );
  }
}

final cache = LokiCache();