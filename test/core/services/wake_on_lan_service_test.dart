import 'package:flutter_test/flutter_test.dart';
import 'package:remote/core/services/wake_on_lan_service.dart';

void main() {
  group('WakeOnLanService', () {
    final service = WakeOnLanService();

    test('returns false for invalid MAC address', () async {
      final ok = await service.wake(mac: 'not-a-mac');
      expect(ok, isFalse);
    });

    test('returns false for invalid broadcast IP', () async {
      final ok = await service.wake(
        mac: 'AA:BB:CC:DD:EE:FF',
        broadcastIp: 'not-an-ip',
      );
      expect(ok, isFalse);
    });
  });
}
