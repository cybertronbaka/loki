part of services;

class ProcessRunnerWithStdin extends ProcessRunner {
  bool isTest;
  ProcessRunnerWithStdin(
      {required super.config,
      super.onSuccess,
      super.onError,
      super.onStart,
      this.isTest = false});

  Future<void> run() async {
    final process = await Process.start(
      config.command,
      config.args,
      workingDirectory: config.workingDir,
      runInShell: true,
      mode: isTest ? ProcessStartMode.normal : ProcessStartMode.inheritStdio,
    );
    if (onStart != null) onStart!(process);
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      if (onError != null) onError!();
      throw LokiError(
          'Failed executing `${config.command} ${config.args.join(' ')}`!');
    } else {
      if (onSuccess != null) onSuccess!();
    }
  }
}
