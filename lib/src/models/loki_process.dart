part of models;

class LokiProcess {
  String command;
  List<String> args;
  String workingDir;
  bool hasStdin;
  bool clearStdOut;

  LokiProcess(
      {required this.command,
      this.args = const [],
      this.workingDir = '.',
      this.hasStdin = false,
      this.clearStdOut = false})
      : assert((!hasStdin && !clearStdOut) ||
            (hasStdin && !clearStdOut) ||
            (!hasStdin && clearStdOut));
}
