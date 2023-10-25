class FlutterLockRunner {
  static Future<void> run(Future<void> Function() method) async {
    try {
      await method();
    } catch (e) {
      if (e.toString().contains('Waiting for another flutter command')) {
        await run(method);
        return;
      }

      rethrow;
    }
  }
}
