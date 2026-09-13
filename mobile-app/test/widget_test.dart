import 'package:flutter_test/flutter_test.dart';
import 'package:jawan_flutter/main.dart';

void main() {
  test('vehicle labels are mapped correctly', () {
    expect(vehicleLabel('motorcycle'), 'موتر');
    expect(vehicleLabel('rickshaw'), 'ركشة');
    expect(vehicleLabel('lorry'), 'لوري');
  });

  test('order status labels are mapped correctly', () {
    expect(statusLabel('pending'), 'بانتظار سائق');
    expect(statusLabel('completed'), 'مكتمل');
    expect(statusLabel('cancelled'), 'ملغي');
  });
}
