import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../banner_moto_decorations.dart' show MotoBannerShell;

class BannerS extends StatelessWidget {
  const BannerS({
    super.key,
    required this.image,
    required this.press,
    required this.children,
  });

  final String image;
  final VoidCallback press;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: MotoBannerShell(
        aspectRatio: 2.38,
        image: image,
        press: press,
        children: children,
      ),
    );
  }
}
