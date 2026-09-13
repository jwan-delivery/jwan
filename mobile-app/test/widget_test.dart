import 'package:flutter_test/flutter_test.dart';
import 'package:jawan_flutter/main.dart';

void main() {
  test('vehicle labels are mapped correctly', () {
    expect(vehicleAr('motorcycle'), 'موتر');
    expect(vehicleAr('rickshaw'), 'ركشة');
    expect(vehicleAr('lorry'), 'لوري');
  });

  test('order status labels are mapped correctly', () {
    expect(statusLabel('pending'), 'بانتظار سائق');
    expect(statusLabel('completed'), 'مكتمل');
    expect(statusLabel('cancelled'), 'ملغي');
  });
}
