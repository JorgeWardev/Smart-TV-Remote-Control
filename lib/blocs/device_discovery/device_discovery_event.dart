import 'package:equatable/equatable.dart';

sealed class DeviceDiscoveryEvent extends Equatable {
  const DeviceDiscoveryEvent();

  @override
  List<Object?> get props => const [];
}

final class DiscoveryStarted extends DeviceDiscoveryEvent {
  const DiscoveryStarted();
}

final class DiscoveryRefreshRequested extends DeviceDiscoveryEvent {
  const DiscoveryRefreshRequested();
}

final class ManualDeviceAdded extends DeviceDiscoveryEvent {
  const ManualDeviceAdded({required this.host, this.name});
  final String host;
  final String? name;

  @override
  List<Object?> get props => [host, name];
}
