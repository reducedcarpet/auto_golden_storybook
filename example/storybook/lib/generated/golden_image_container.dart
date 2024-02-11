import 'package:flutter/material.dart';

class GoldenImageContainer extends StatelessWidget {
  const GoldenImageContainer({
    super.key,
    required this.image,
  });

  final AssetImage image;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Transform.scale(
        scaleX: 1.045,
        scaleY: 1.03,
        child: Center(
            child: Image(
          image: image,
          fit: BoxFit.fitWidth,
        )),
      )
    ]);
  }
}
