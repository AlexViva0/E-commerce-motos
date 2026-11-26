import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../banner_moto_decorations.dart'
    show MotoActionButton, MotoAmberBadge, MotoDiscountPill;
import 'banner_m.dart';

class BannerMStyle3 extends StatelessWidget {
  const BannerMStyle3({
    super.key,
    this.image = "https://i.imgur.com/8REExBV.png",
    required this.title,
    required this.press,
    required this.discountParcent,
  });
  final String? image;
  final String title;
  final int discountParcent;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return BannerM(
      image: image ?? "https://i.imgur.com/8REExBV.png",
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
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const MotoAmberBadge(label: "2026"),
                        if (discountParcent > 0)
                          MotoDiscountPill(
                            label: "-$discountParcent% DTO.",
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: grandisExtendedFont,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: whiteColor,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "VER ESPECIFICACIONES",
                      style: TextStyle(
                        color: whiteColor.withOpacity(0.82),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: defaultPadding),
              MotoActionButton(press: press),
            ],
          ),
        ),
      ],
    );
  }
}
