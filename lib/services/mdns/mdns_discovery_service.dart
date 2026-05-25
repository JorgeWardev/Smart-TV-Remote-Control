import 'dart:async';
import 'dart:developer';

import 'package:multicast_dns/multicast_dns.dart';
import 'package:remote/core/models/tv_device.dart';

/// Discovers TVs via mDNS / Bonjour services that newer Samsung,
/// LG and Cast-enabled TVs typically advertise.
class MdnsDiscoveryService {
  /// Names of mDNS service types to scan. Each entry is a fully-qualified
  /// service type. We probe several so a single sweep covers Samsung, LG
  /// WebOS, AirPlay, and Cast devices.
  static const List<_ServiceQuery> _queries = [
    _ServiceQuery(
      type: '_googlecast._tcp.local',
      manufacturer: 'Cast',
    ),
    _ServiceQuery(
      type: '_airplay._tcp.local',
      manufacturer: 'AirPlay',
    ),
    _ServiceQuery(
      type: '_samsungmsf._tcp.local',
      manufacturer: 'Samsung',
    ),
    _ServiceQuery(
      type: '_lg-mrt._tcp.local',
      manufacturer: 'LG',
    ),
  ];

  Future<List<TVDevice>> discoverAll({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final found = <String, TVDevice>{};
    final client = MDnsClient();

    try {
      await client.start();

      for (final query in _queries) {
        try {
          final query0 = ResourceRecordQuery.serverPointer(query.type);
          await for (final ptr in client
              .lookup<PtrResourceRecord>(query0)
              .timeout(timeout, onTimeout: (sink) => sink.close())) {
            await for (final srv in client
                .lookup<SrvResourceRecord>(
                  ResourceRecordQuery.service(ptr.domainName),
                )
                .timeout(timeout, onTimeout: (sink) => sink.close())) {
              await for (final ip in client
                  .lookup<IPAddressResourceRecord>(
                    ResourceRecordQuery.addressIPv4(srv.target),
                  )
                  .timeout(timeout, onTimeout: (sink) => sink.close())) {
                final host = ip.address.address;
                if (found.containsKey(host)) continue;
                found[host] = TVDevice(
                  host: host,
                  deviceName: _friendlyName(ptr.domainName),
                  manufacturer: query.manufacturer,
                );
              }
            }
          }
        } catch (e) {
          log('mDNS query ${query.type} failed: $e');
        }
      }
    } catch (e) {
      log('mDNS client failed to start: $e');
    } finally {
      client.stop();
    }

    return found.values.toList(growable: false);
  }

  String _friendlyName(String ptrName) {
    final firstDot = ptrName.indexOf('.');
    if (firstDot <= 0) return ptrName;
    return ptrName.substring(0, firstDot);
  }
}

class _ServiceQuery {
  const _ServiceQuery({required this.type, required this.manufacturer});
  final String type;
  final String manufacturer;
}
