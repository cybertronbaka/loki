part of services;

class ProcessManager {
  late List<LokiProcess> processes;
  ProcessManager() {
    processes = [];
  }

  Future<void> run(LokiProcess config,
      {void Function()? onSuccess, void Function()? onError}) async {
    processes.add(config);
    config.hasStdin
        ? await runWithStdin(config, onSuccess: onSuccess, onError: onError)
        : await runWithoutStdin(config, onSuccess: onSuccess, onError: onError);
  }

  Future<void> runWithStdin(LokiProcess config,
      {void Function()? onSuccess, void Function()? onError}) async {
    await ProcessRunnerWithStdin(
            config: config, onSuccess: onSuccess, onError: onError)
        .run();
  }

  Future<void> runWithoutStdin(LokiProcess config,
      {void Function()? onSuccess, void Function()? onError}) async {
    await ProcessRunnerWithoutStdin(
            config: config, onSuccess: onSuccess, onError: onError)
        .run();
  }
}
