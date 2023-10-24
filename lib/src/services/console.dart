part of services;

/// A class providing utility methods for interacting with the console.
class Console {
  StringSink sink;
  Console(this.sink);

  void write(Object? object) {
    sink.write(object);
  }

  void writeln([Object? object = ""]) {
    sink.writeln(object);
  }

  void moveUpAndClear() {
    moveUp();
    clearLine();
  }

  void moveUp() {
    sink.write('\u001B[1A');
  }

  void clearLine() {
    sink.write('\u001B[2K');
  }

  void printAllDone() {
    sink.writeln(allDoneText);
  }

  void printAttribution() {
    sink.writeln(attributionText);
  }

  String get attributionText =>
      'Made with ❤️  by ${chalk.cyan('Dorji Gyeltshen ( ${chalk.red('@cybertronbaka')} )')}';

  String get allDoneText => 'Loki: ${chalk.green('All done, mate! 🍺🍺')}';
}

/// An instance of the [Console] class providing utility methods for interacting with the console.
var console = Console(stdout);
