part of services;

/// A class for defining validation rules and applying them to data.
class Validator {
  String Function([dynamic args])? messagePrefix;
  List<ValidationRules> rules;

  Validator({this.rules = const [], this.messagePrefix});

  /// Validates the provided [data] against the defined rules.
  ///
  /// Optionally, [throwErrors] can be set to true to throw a [LokiError] on validation failure.
  bool validate(data, {bool throwErrors = false, args}) {
    bool valid = true;
    valid = valid &&
        rules.every((rule) {
          bool v = rule.check(data);
          if (throwErrors && !v) {
            String pre = '';
            if (messagePrefix != null) pre += messagePrefix!(args);
            if (pre.isNotEmpty) pre += ' ';
            throw LokiError(pre + rule.message(args));
          }
          return v;
        });
    return valid;
  }

  /// Runs the validation process and returns the validated data.
  ///
  /// Throws a [LokiError] if validation fails.
  T run<T>(data, {args}) {
    validate(data, throwErrors: true, args: args);
    return data as T;
  }
}

/// A class for defining individual validation rules.
class ValidationRules {
  bool Function(dynamic data) check;
  String Function([dynamic args]) message;
  ValidationRules({
    required this.check,
    required this.message,
  });
}
