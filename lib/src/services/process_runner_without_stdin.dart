part of services;

/// A utility class for running processes and handling their output. It should only be used with Process.start and without inheritStdio
class ProcessRunnerWithoutStdin extends ProcessRunner {
  ProcessRunnerWithoutStdin(
      {required super.config, super.onSuccess, super.onError});

  /// Runs the process, handles its output, and performs specified callbacks.
  ///
  /// The method listens to the standard output and standard error streams of the process, processes the output, and handles errors if any.
  ///
  /// The method then handles the standard output and standard error based on the provided options.
  Future<void> run() async {
    int stdOutLines = 0;
    final p = await Process.start(config.command, config.args,
        workingDirectory: config.workingDir, runInShell: true);
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
        return ch;
      }).join('');
      stdErr.write(str);
    }).asFuture();
    final exitCode = await p.exitCode;
    if (config.clearStdOut && stdOutLines != 0) _clearNLines(stdOutLines);
    if (exitCode != 0) {
      console.moveUpAndClear();
      if (onError != null) onError!();
      throw LokiError(stdErr.toString());
    } else {
      if (config.clearStdOut) console.moveUpAndClear();
      if (onSuccess != null) onSuccess!();
    }
  }

  void _clearNLines(int n) {
    List.generate(n, (i) => console.moveUpAndClear());
  }
}
