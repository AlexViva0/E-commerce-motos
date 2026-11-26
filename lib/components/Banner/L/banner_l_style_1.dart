import 'package:flutter/material.dart';
import 'package:catalogo_motos/components/Banner/L/banner_l.dart';

import '../../../constants.dart';
import '../banner_moto_decorations.dart' show MotoAmberBadge, MotoPrimaryPill;

class BannerLStyle1 extends StatelessWidget {
  const BannerLStyle1({
    super.key,
    this.image = "https://i.imgur.com/wpl37Kz.png",
    required this.title,
    required this.press,
    this.subtitle,
    required this.discountPercent,
  });
  final String? image;
  final String title;
  final String? subtitle;
  final int discountPercent;

  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return BannerL(
      image: image ?? "https://i.imgur.com/wpl37Kz.png",
      press: press,
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding + 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MotoAmberBadge(label: "TEMPORADA • 2026"),
              const Spacer(),
              DefaultTextStyle(
                style: const TextStyle(
                  fontFamily: grandisExtendedFont,
                  fontSize: 54,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                  color: whiteColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Text(
                          discountPercent.toString(),
                          style: TextStyle(
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2.0
                              ..color = primaryColor.withOpacity(0.7),
                          ),
                        ),
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Text(discountPercent.toString()),
                        ),
                      ],
                    ),
                    const SizedBox(width: defaultPadding / 3),
                    const Text(
                      "%",
                      style: TextStyle(color: primaryColor),
                    ),
                  ],
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: blackColor.withOpacity(0.72),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.7),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    subtitle!.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: defaultPadding),
              Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: grandisExtendedFont,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: whiteColor,
                  height: 1.05,
                ),
              ),
              const Spacer(),
              MotoPrimaryPill(
                label: "Explorar modelos",
                press: press,
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}
