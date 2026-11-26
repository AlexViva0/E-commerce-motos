import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../banner_discount_tag.dart';
import '../banner_moto_decorations.dart' show MotoActionButton, MotoAmberBadge;
import 'banner_s.dart';

class BannerSStyle1 extends StatelessWidget {
  const BannerSStyle1({
    super.key,
    this.image = "https://i.imgur.com/K41Mj7C.png",
    required this.title,
    required this.press,
    this.subtitle,
    required this.discountParcent,
  });
  final String? image;
  final String title;
  final String? subtitle;
  final int discountParcent;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return BannerS(
      image: image ?? "https://i.imgur.com/K41Mj7C.png",
      press: press,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding + 4,
            vertical: 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MotoAmberBadge(
                      label: (subtitle ?? "NUEVO • 2026").toUpperCase(),
                      compact: true,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: grandisExtendedFont,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: whiteColor,
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: discountParcent > 0 ? 48 : defaultPadding),
              MotoActionButton(
                press: press,
                size: 42,
              ),
            ],
          ),
        ),
        if (discountParcent > 0)
          Positioned(
            top: 0,
            right: defaultPadding * 4.2,
            child: BannerDiscountTag(
              percentage: discountParcent,
              height: 52,
              width: 38,
              percentageFontSize: 9.5,
            ),
          ),
      ],
    );
  }
}
