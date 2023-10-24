part of services;

/// A utility class for running processes and handling their output. It should only be used with Process.start and without inheritStdio
class ProcessStartRunner {
  /// Indicates whether to clear standard output before running the process.
  bool clearStdOut;

  /// A callback function to be executed in case of an error.
  void Function()? onError;

  /// A callback function to be executed upon successful completion of the process.
  void Function()? onSuccess;

  /// A function that starts a process and returns a `Future<Process>`.
  Future<Process> Function() runner;

  ProcessStartRunner(
      {required this.runner,
      this.clearStdOut = false,
      this.onError,
      this.onSuccess});

  /// Runs the process, handles its output, and performs specified callbacks.
  ///
  /// The method listens to the standard output and standard error streams of the process, processes the output, and handles errors if any.
  ///
  /// The method then handles the standard output and standard error based on the provided options.
  Future<void> run() async {
    int stdOutLines = 0;
    int stdErrLines = 0;
    final p = await runner();
    p.stdout.listen((event) {
      var str = event.map((e) {
        final ch = String.fromCharCode(e);
        if (ch == '\n') stdOutLines++;
        return ch;
      }).join('');
      console.write(str);
    }).asFuture();
    StringBuffer stdErr = StringBuffer();
    await p.stderr.listen((event) async {
      var str = event.map((e) {
        final ch = String.fromCharCode(e);
        if (ch == '\n') stdErrLines++;
        return ch;
      }).join('');
      stdErr.write(str);
    }).asFuture();
    await p.exitCode;
    if (clearStdOut && stdOutLines != 0) _clearNLines(stdOutLines);
    if (stdErrLines != 0) {
      console.moveUpAndClear();
      if (onError != null) onError!();
      throw LokiError(stdErr.toString());
    } else {
      if (clearStdOut) console.moveUpAndClear();
      if (onSuccess != null) onSuccess!();
    }
  }

  void _clearNLines(int n) {
    List.generate(n, (i) => console.moveUpAndClear());
  }
}
