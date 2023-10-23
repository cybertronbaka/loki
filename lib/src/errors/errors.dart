library errors;

import 'package:chalkdart/chalk.dart';

class LokiError extends Error {
  String message;
  LokiError([this.message = '']);

  @override
  String toString() {
    return chalk.normal('Loki:') + chalk.red(' [Error] $message');
  }
}

class UnexpectedTypeError extends LokiError{
  Type type;
  String key;
  dynamic value;

  UnexpectedTypeError(this.type, this.key, this.value);

  @override
  String toString() {
    return chalk.normal('Loki:') + chalk.red(' [Error] \'$key\' is of wrong type. Expected type is \'$type\'. Got \'${value.runtimeType}\'');
  }
}

class EmptyYamlFileError extends LokiError {
  @override
  String toString() {
    return chalk.normal('Loki:') + chalk.red(' [Error] No contents found in loki.yaml.\n') + chalk.normal('Please add \'name: <App name>\'');
  }
}
