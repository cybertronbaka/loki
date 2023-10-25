part of services;

class ProcessRunner {
  LokiProcess config;
  void Function()? onSuccess;
  void Function()? onError;
  void Function(Process process)? onStart;

  ProcessRunner(
      {required this.config, this.onSuccess, this.onError, this.onStart});
}
