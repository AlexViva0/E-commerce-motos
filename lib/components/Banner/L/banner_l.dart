import 'package:flutter/material.dart';

import '../banner_moto_decorations.dart' show MotoBannerShell;

class BannerL extends StatelessWidget {
  const BannerL({
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
    return MotoBannerShell(
      aspectRatio: 1.1,
      image: image,
      press: press,
      children: children,
    );
  }
}
