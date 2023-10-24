part of models;

/// Represents a Flutter device with specific properties.
class FlutterDevice{
  /// The name of the Flutter device.
  String name;
  /// The unique identifier of the Flutter device.
  String id;
  /// Indicates if the device is supported.
  bool isSupported;
  /// The target platform of the device.
  String targetPlatform;
  /// Indicates if the device is an emulator.
  bool emulator;
  /// The software development kit (SDK) version of the device.
  String sdk;

  FlutterDevice({
    required this.name,
    required this.id,
    required this.isSupported,
    required this.targetPlatform,
    required this.emulator,
    required this.sdk
  });

  /// Constructs a [FlutterDevice] from a JSON map.
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
