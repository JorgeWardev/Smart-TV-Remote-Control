import 'dart:developer';

import 'package:wake_on_lan/wake_on_lan.dart';

/// Sends Wake-on-LAN magic packets.
///
/// Most Samsung TVs from 2018+ support WoL on the same subnet — useful
/// when the user picks a known TV that the OS reports as offline.
class WakeOnLanService {
  Future<bool> wake({
    required String mac,
    String broadcastIp = '255.255.255.255',
  }) async {
    final macValidation = MACAddress.validate(mac);
    if (!macValidation.state) {
      log('WoL: invalid MAC $mac (${macValidation.error})');
      return false;
    }
    final ipValidation = IPAddress.validate(broadcastIp);
    if (!ipValidation.state) {
      log('WoL: invalid broadcast $broadcastIp (${ipValidation.error})');
      return false;
    }

    try {
      await WakeOnLAN(IPAddress(broadcastIp), MACAddress(mac)).wake();
      log('WoL: magic packet sent to $mac via $broadcastIp');
      return true;
    } catch (e) {
      log('WoL: send failed: $e');
      return false;
    }
  }
}
