import 'dart:io';

import 'package:chalkdart/chalk.dart';

/// A class providing utility methods for interacting with the console.
class Console {
  void moveUpAndClear(){
    moveUp();
    clearLine();
  }

  void moveUp(){
    stdout.write('\u001B[1A');
  }

  void clearLine(){
    stdout.write('\u001B[2K');
  }

  void printAllDone(){
    stdout.writeln(allDoneText);
  }

  void printAttribution(){
    stdout.writeln(attributionText);
  }

  String get attributionText => 'Made with ❤️  by ${chalk.cyan('Dorji Gyeltshen ( ${chalk.red('@cybertronbaka')} )')}';

  String get allDoneText => 'Loki: ${chalk.green('All done, mate! 🍺🍺')}';
}

/// An instance of the [Console] class providing utility methods for interacting with the console.
final console = Console();