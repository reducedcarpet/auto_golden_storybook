import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

final allDevices = [
  const Device(
    name: 'iPhone13ProMax',
    size: Size(414, 896),
  ),
];

void main() {
  Widget buildTestWidget() {
    return const MyApp();
  }

  group('About Screen Golden Builder', () {
    testGoldens('About Screen golden test', (tester) async {
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(
          devices: allDevices,
        )
        ..addScenario(
          widget: buildTestWidget(),
          name: 'Default',
        );

      await tester.pumpDeviceBuilder(builder);

      await screenMatchesGolden(tester, 'about_screen');
    });
  });
}
