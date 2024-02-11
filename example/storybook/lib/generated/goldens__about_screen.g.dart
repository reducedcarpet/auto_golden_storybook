import 'package:flutter/material.dart';
import 'package:storybook/generated/golden_image_container.dart';

class GoldensAboutScreenStorybookScreen extends StatelessWidget {
  const GoldensAboutScreenStorybookScreen({Key? super.key});

  @override
  Widget build(BuildContext context) {
    return const GoldenImageContainer(
        image: AssetImage('assets/goldens__about_screen.png'));
  }
}
