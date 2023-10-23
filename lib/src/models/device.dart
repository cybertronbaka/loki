part of models;

class FlutterDevice{
  String name;
  String id;
  bool isSupported;
  String targetPlatform;
  bool emulator;
  String sdk;

  FlutterDevice({
    required this.name,
    required this.id,
    required this.isSupported,
    required this.targetPlatform,
    required this.emulator,
    required this.sdk
  });

  factory FlutterDevice.fromJson(Map<String, dynamic> json){
    return FlutterDevice(
        name: json['name'] as String,
        id: json['id'] as String,
        isSupported: json['isSupported'] as bool,
        targetPlatform: json['targetPlatform'] as String,
        emulator: json['emulator'] as bool,
        sdk: json['sdk'] as String
    );
  }
}
