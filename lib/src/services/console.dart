part of services;

/// A class providing utility methods for interacting with the console.
class Console {
  StringSink sink;
  Stdin iSink;
  Console(this.sink, this.iSink);

  void write(Object? object) {
    sink.write(_prependSpaces(object));
  }

  void writeln([Object? object = ""]) {
    sink.writeln(_prependSpaces(object));
  }

  void moveUpAndClear([int n = 1]) {
    for (var i = 0; i < n; i++) {
      moveUp();
      clearLine();
    }
  }

  void moveUp() {
    sink.write('\u001B[1A');
  }

  void clearLine() {
    sink.write('\u001B[2K');
  }

  void printAllDone() {
    writeln(allDoneText);
  }

  void printAttribution() {
    writeln(attributionText);
  }

  String _prependSpaces(Object? object) {
    var str = object.toString();
    str = str.split('\n').join('\n$_lSpaces').split('\r').join('\r$_lSpaces');
    return '$_lSpaces$str';
  }

  String get _lSpaces {
    return '  ' * cache.loopCount.fetch;
  }

  String? readLineSync() {
    return iSink.readLineSync();
  }

  String get attributionText =>
      'Made with ❤️  by ${chalk.cyan('Dorji Gyeltshen ( ${chalk.red('@cybertronbaka')} )')}';

  String get allDoneText => 'Loki: ${chalk.green('All done, mate! 🍺🍺')}';
}

/// An instance of the [Console] class providing utility methods for interacting with the console.
var console = Console(stdout, stdin);
