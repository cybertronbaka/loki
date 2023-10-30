import 'dart:io';

import 'package:loki/src/services/services.dart';
import 'package:mocktail/mocktail.dart';

class MockConfigParser extends Mock implements ConfigParser {}

class MockProjectFilter extends Mock implements ProjectFilter {}

class MockDevicesFilter extends Mock implements DevicesFilter {}

class MockProcessManager extends Mock implements ProcessManager {}

class MockStdin extends Mock implements Stdin {}