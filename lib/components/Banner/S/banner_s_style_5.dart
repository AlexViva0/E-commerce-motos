import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../banner_moto_decorations.dart' show MotoActionButton, MotoAmberBadge;
import 'banner_s.dart';

class BannerSStyle5 extends StatelessWidget {
  const BannerSStyle5({
    super.key,
    this.image = "https://i.imgur.com/wQ0sNHT.png",
    required this.title,
    required this.press,
    this.subtitle,
    this.bottomText,
  });
  final String? image;
  final String title;
  final String? subtitle, bottomText;

  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return BannerS(
      image: image ?? "https://i.imgur.com/wQ0sNHT.png",
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
                      label: (subtitle ?? "2026").toUpperCase(),
                      compact: true,
                    ),
                    const SizedBox(height: 5),
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
                    if (bottomText != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 2.5,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              bottomText!.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: grandisExtendedFont,
                                color: whiteColor.withOpacity(0.9),
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: defaultPadding),
              MotoActionButton(
                press: press,
                size: 42,
                iconPath: "assets/icons/miniRight.svg",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
