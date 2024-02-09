import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:storybook/generated/goldens__about_screen.g.dart';

final List<Story> stories = <Story>[
  Story(
    name: 'goldens/AboutScreen',
    builder: (_) => const GoldensAboutScreenStorybookScreen(),
  )
];
