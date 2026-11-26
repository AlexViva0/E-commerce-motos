import 'package:flutter/material.dart';

import '../banner_moto_decorations.dart' show MotoBannerShell;

class BannerM extends StatelessWidget {
  const BannerM({
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
      aspectRatio: 1.87,
      image: image,
      press: press,
      showShadow: false,
      children: children,
    );
  }
}
