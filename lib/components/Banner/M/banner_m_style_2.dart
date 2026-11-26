import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../banner_discount_tag.dart';
import '../banner_moto_decorations.dart' show MotoActionButton, MotoAmberBadge;
import 'banner_m.dart';

class BannerMStyle2 extends StatelessWidget {
  const BannerMStyle2({
    super.key,
    this.image = "https://i.imgur.com/J1Qjut7.png",
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
    return BannerM(
      image: image ?? "https://i.imgur.com/J1Qjut7.png",
      press: press,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding + 4,
            vertical: defaultPadding,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MotoAmberBadge(label: "SERIE 2026"),
                    const SizedBox(height: 8),
                    Text(
                      title.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: grandisExtendedFont,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: whiteColor,
                        height: 1.04,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        subtitle!.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: whiteColor.withOpacity(0.85),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: defaultPadding),
              MotoActionButton(press: press),
            ],
          ),
        ),
        if (discountParcent > 0)
          Positioned(
            top: 0,
            right: defaultPadding * 4.5,
            child: BannerDiscountTag(percentage: discountParcent),
          ),
      ],
    );
  }
}
