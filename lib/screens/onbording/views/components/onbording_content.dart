import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';

class OnbordingContent extends StatelessWidget {
  const OnbordingContent({
    super.key,
    this.isTextOnTop = false,
    required this.title,
    required this.description,
    required this.image,
    this.tag,
    this.highlights = const [],
  });

  final bool isTextOnTop;
  final String title, description, image;
  final String? tag;
  final List<String> highlights;

  static const Color _amberAccent = Color(0xFFFFB020);

  @override
  Widget build(BuildContext context) {
    final Widget illustrationCard = _IllustrationStage(
      image: image,
      tag: tag,
      amberAccent: _amberAccent,
    );

    final Widget textSection = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OnbordTitleDescription(
          title: title,
          description: description,
        ),
        if (highlights.isNotEmpty) ...[
          const SizedBox(height: defaultPadding),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: highlights
                .asMap()
                .entries
                .map(
                  (entry) => _HighlightChip(
                    label: entry.value,
                    isHighlighted: entry.key == 0,
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxHeight < 480;

        return Column(
          children: [
            if (isTextOnTop) ...[
              const SizedBox(height: defaultPadding / 2),
              textSection,
              SizedBox(
                  height: isCompact ? defaultPadding * 0.75 : defaultPadding),
              Expanded(child: illustrationCard),
            ] else ...[
              Expanded(child: illustrationCard),
              SizedBox(
                  height: isCompact
                      ? defaultPadding * 0.75
                      : defaultPadding * 1.25),
              textSection,
            ],
            SizedBox(height: isCompact ? defaultPadding * 0.5 : defaultPadding),
          ],
        );
      },
    );
  }
}

class _IllustrationStage extends StatelessWidget {
  const _IllustrationStage({
    required this.image,
    required this.amberAccent,
    this.tag,
  });

  final String image;
  final String? tag;
  final Color amberAccent;

  @override
  Widget build(BuildContext context) {
    final bool isSvg = image.toLowerCase().endsWith('.svg');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: blackColor10, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.07),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Acento diagonal sutil dentro de la card
          Positioned(
            right: -12,
            bottom: -12,
            child: Transform.rotate(
              angle: -0.35,
              child: Container(
                width: 110,
                height: 28,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: tag != null ? 24 : 4),
              child: isSvg
                  ? SvgPicture.asset(
                      image,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      image,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
          if (tag != null)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: blackColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: amberAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tag!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HighlightChip extends StatelessWidget {
  const _HighlightChip({
    required this.label,
    this.isHighlighted = false,
  });

  final String label;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final bool hasDigit = RegExp(r'\d').hasMatch(label);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isHighlighted ? primaryColor.withOpacity(0.10) : lightGreyColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted ? primaryColor.withOpacity(0.32) : blackColor10,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: hasDigit ? grandisExtendedFont : null,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isHighlighted ? primaryColor : blackColor80,
        ),
      ),
    );
  }
}

class OnbordTitleDescription extends StatelessWidget {
  const OnbordTitleDescription({
    super.key,
    required this.title,
    required this.description,
  });

  final String title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontFamily: grandisExtendedFont,
                fontWeight: FontWeight.w700,
                fontSize: 22,
                height: 1.2,
                letterSpacing: -0.3,
                color: blackColor,
              ),
        ),
        const SizedBox(height: defaultPadding * 0.65),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 0.5),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.5,
                  height: 1.45,
                  color: blackColor60,
                ),
          ),
        ),
      ],
    );
  }
}
