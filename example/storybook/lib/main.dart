import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:flutter/material.dart';
import 'package:storybook/generated/stories.dart';
import 'package:storybook/generated/device_frame.dart';

void main() {
  runApp(const StorybookApp());
}


class StorybookApp extends StatelessWidget {
  const StorybookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Storybook(
      plugins: [
        DeviceFramePlugin(initialData: (
          device: device,
          orientation: Orientation.portrait,
          isFrameVisible: true,
        ))
      ],
      stories: stories,
    );
  }
}
