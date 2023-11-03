class Json2YamlStr {
  String _json2YamlList(List value, [int level = 0]) {
    return value.map((e) {
      String res = '${' ' * level * 2}- ';
      if (_isMap(e)) {
        final map = e as Map;

        res += '${_json2YamlMap({map.keys.first: map[map.keys.first]}, 0)}\n';
        map.remove(map.keys.first);
        res += _json2YamlMap(map, level + 1);
      } else if (_isList(e)) {
        final list = e as List;

        res += '${_json2YamlList([list[0]], 0)}\n';
        list.removeAt(0);
        res += _json2YamlList(list, level + 1);
      } else {
        res += '$e';
      }
      return res;
    }).join('\n');
  }

  String _json2YamlMap(Map value, [int level = 0]) {
    return value.keys.map((key) {
      final val = value[key];
      String res = '${' ' * level * 2}$key:';
      if (_isMap(val)) {
        res += '\n${_json2YamlMap(val, level + 1)}';
      } else if (_isList(val)) {
        res += '\n${_json2YamlList(val, level + 1)}';
      } else {
        res += ' $val';
      }
      return res;
    }).join('\n');
  }

  String run(dynamic json) {
    if (_isMap(json)) {
      return _json2YamlMap(json);
    } else if (_isList(json)) {
      return _json2YamlList(json);
    } else {
      return json;
    }
  }

  bool _isMap(dynamic val) {
    final tString = val.runtimeType.toString();
    return ['Map', '_Map', '_ConstMap'].any((e) => tString.startsWith(e));
  }

  bool _isList(dynamic val) {
    final tString = val.runtimeType.toString();
    return ['List', '_List'].any((e) => tString.startsWith(e));
  }
}
