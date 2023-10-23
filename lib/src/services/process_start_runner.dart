import 'dart:io';

import '../errors/errors.dart';
import 'console.dart';

class ProcessStartRunner{
  bool clearStdOut;
  void Function()? onError;
  void Function()? onSuccess;
  
  Future<Process> Function() runner;
  ProcessStartRunner({
    required this.runner,
    this.clearStdOut = false,
    this.onError,
    this.onSuccess
  });
  
  Future<void> run() async {
    int stdOutLines = 0;
    int stdErrLines = 0;
    final p = await runner();
    await p.stdout.listen((event) {
      var str = event.map((e){
        final ch = String.fromCharCode(e);
        if(ch == '\n') stdOutLines++;
        return ch;
      }).join('');
      stdout.write(str);
    }).asFuture();
    StringBuffer stdErr = StringBuffer();
    await p.stderr.listen((event) async {
      stdErr.write(event.map((e){
        final ch = String.fromCharCode(e);
        if(ch == '\n') stdErrLines++;
        return ch;
      }).join(''));
    }).asFuture();
    if(clearStdOut && stdOutLines != 0){
      List.generate(stdOutLines, (i) => console.moveUpAndClear());
    }
    if(stdErrLines != 0) {
      console.moveUpAndClear();
      if(onError != null) onError!();
      throw LokiError(stdErr.toString());
    } else {
      if(clearStdOut) console.moveUpAndClear();
      if(onSuccess != null) onSuccess!();
    }
  }
}