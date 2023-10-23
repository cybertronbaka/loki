import 'package:loki/src/errors/errors.dart';

class Validator{
  String Function([dynamic args])? messagePrefix;
  List<ValidationRules> rules;

  Validator({this.rules = const [], this.messagePrefix});

  bool validate(data, {bool throwErrors = false, args}){
    bool valid = true;
    valid = valid && rules.every((rule){
      bool v = rule.check(data);
      if(throwErrors && !v) {
        String pre = '';
        if(messagePrefix != null) pre += messagePrefix!(args);
        if(pre.isNotEmpty) pre += ' ';
        throw LokiError(pre + rule.message(args));
      }
      return v;
    });
    return valid;
  }

  T run<T>(data, {args}){
    validate(data, throwErrors: true, args: args);
    return data as T;
  }
}

class ValidationRules{
  bool Function(dynamic data) check;
  String Function([dynamic args]) message;
  ValidationRules({required this.check, required this.message,});
}