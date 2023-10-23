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

  T get data {
    if(_loaded) return _data;

    this._data = load();
    _loaded = true;
    return _data;
  }
}

class LokiCache{
  late CacheObject<LokiConfig> config;
  late CacheObject<ProjectFilter> projectFilter;
  late CacheObject<List<FlutterDevice>> devices;

  LokiCache(){
    config = CacheObject<LokiConfig>(
      load: () {
        // stdout.writeln(chalk.yellowBright('Loading config!'));
        String path = '${Directory.current.absolute.path}/loki.yaml';
        return ConfigGenerator.fromYaml(path).generate();
      }
    );
    projectFilter = CacheObject<ProjectFilter>(
      load: () {
        // stdout.writeln(chalk.yellowBright('Loading Projects!'));
        return ProjectFilter().run(config.data);
      }
    );
    devices = CacheObject<List<FlutterDevice>>(
      load: (){
        // stdout.writeln(chalk.yellowBright('Loading Devices!'));
        return DevicesFilter().run();
      }
    );
  }
}

final cache = LokiCache();