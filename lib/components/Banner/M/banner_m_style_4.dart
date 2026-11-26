import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../banner_moto_decorations.dart' show MotoActionButton, MotoAmberBadge;
import 'banner_m.dart';

class BannerMStyle4 extends StatelessWidget {
  const BannerMStyle4({
    super.key,
    this.image = "https://i.imgur.com/R4iKkDD.png",
    required this.title,
    required this.press,
    required this.discountParcent,
    this.subtitle,
  });
  final String? image;
  final String title;
  final String? subtitle;
  final int discountParcent;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return BannerM(
      image: image ?? "https://i.imgur.com/R4iKkDD.png",
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
                    MotoAmberBadge(
                      label: (subtitle ?? "NUEVO • 2026").toUpperCase(),
                    ),
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
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 14,
                          height: 2.5,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            discountParcent > 0
                                ? "HASTA $discountParcent% DTO."
                                : "COLECCIÓN 2026",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: grandisExtendedFont,
                              color: whiteColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
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
