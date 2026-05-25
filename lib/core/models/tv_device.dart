import 'package:remote/core/models/connection_state.dart';

/// Domain model for a TV device discovered on the network or persisted from
/// a previous session.
class TVDevice {
  TVDevice({
    this.host,
    this.mac,
    this.deviceName,
    this.modelName,
    this.manufacturer,
    this.serialNumber,
    Map<String, dynamic>? additionalInfo,
  }) : additionalInfo = additionalInfo ?? <String, dynamic>{};

  final String? host;
  final String? mac;
  final String? deviceName;
  final String? modelName;
  final String? manufacturer;
  final String? serialNumber;
  final Map<String, dynamic> additionalInfo;

  ConnectionState _connectionState = ConnectionState.disconnected;
  ConnectionState get connectionState => _connectionState;

  void updateConnectionState(ConnectionState state) {
    _connectionState = state;
  }

  bool get isConnected => _connectionState.isConnected;
  bool get isConnecting => _connectionState.isConnecting;
  bool get isDisconnected => _connectionState.isDisconnected;

  String get displayName => deviceName ?? modelName ?? 'Unknown TV';

  TVDevice copyWith({
    String? host,
    String? mac,
    String? deviceName,
    String? modelName,
    String? manufacturer,
    String? serialNumber,
    Map<String, dynamic>? additionalInfo,
  }) {
    return TVDevice(
      host: host ?? this.host,
      mac: mac ?? this.mac,
      deviceName: deviceName ?? this.deviceName,
      modelName: modelName ?? this.modelName,
      manufacturer: manufacturer ?? this.manufacturer,
      serialNumber: serialNumber ?? this.serialNumber,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  @override
  String toString() =>
      'TVDevice(host: $host, name: $displayName, state: ${_connectionState.displayName})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TVDevice && other.host == host && other.mac == mac;
  }

  @override
  int get hashCode => Object.hash(host, mac);
}
