import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';
import '../network_image_with_loader.dart';

const Color accentColor = Color(0xFFFFB020);

/// Contenedor base con estética de motociclismo para los banners S, M y L.
/// Aplica esquinas redondeadas de 16 px, overlay degradado grafito->transparente
/// y líneas diagonales decorativas tipo pista.
class MotoBannerShell extends StatelessWidget {
  const MotoBannerShell({
    super.key,
    required this.aspectRatio,
    required this.image,
    required this.press,
    required this.children,
    this.borderRadius = 16.0,
    this.showShadow = true,
  });

  final double aspectRatio;
  final String image;
  final VoidCallback press;
  final List<Widget> children;
  final double borderRadius;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final Color darkRacingRed =
        Color.lerp(primaryColor, blackColor, 0.28) ?? primaryColor;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: blackColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: blackColor.withOpacity(0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: press,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Fondo base oscuro mientras carga la imagen
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [blackColor, darkRacingRed.withOpacity(0.55)],
                      ),
                    ),
                  ),
                  // Imagen principal
                  NetworkImageWithLoader(image, radius: 0),
                  // Overlay degradado grafito -> transparente
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const [0.0, 0.56, 1.0],
                        colors: [
                          blackColor.withOpacity(0.92),
                          blackColor.withOpacity(0.68),
                          blackColor.withOpacity(0.16),
                        ],
                      ),
                    ),
                  ),
                  // Viñeta inferior sutil para reforzar legibilidad
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0.0, 0.55],
                        colors: [
                          blackColor.withOpacity(0.52),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Líneas diagonales decorativas tipo pista
                  IgnorePointer(
                    child: CustomPaint(
                      painter: _MotoTrackStripesPainter(
                        primary: primaryColor,
                        accent: accentColor,
                        highlight: whiteColor,
                      ),
                    ),
                  ),
                  // Franja vertical lateral rojo carrera -> ámbar
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            accentColor,
                            primaryColor,
                            darkRacingRed,
                          ],
                        ),
                      ),
                    ),
                  ),
                  ...children,
                  // Borde sutil de acabado metálico
                  IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        border: Border.all(
                          color: whiteColor.withOpacity(0.10),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Etiqueta ámbar de alto contraste tipo "NUEVO" / "2026".
class MotoAmberBadge extends StatelessWidget {
  const MotoAmberBadge({
    super.key,
    required this.label,
    this.compact = false,
  });

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.28),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: blackColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: grandisExtendedFont,
                color: blackColor,
                fontWeight: FontWeight.w800,
                fontSize: compact ? 9.5 : 10.5,
                letterSpacing: 0.9,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Etiqueta secundaria en rojo carrera para porcentajes o destacados.
class MotoDiscountPill extends StatelessWidget {
  const MotoDiscountPill({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontFamily: grandisExtendedFont,
          color: whiteColor,
          fontWeight: FontWeight.w700,
          fontSize: 10,
          letterSpacing: 0.7,
          height: 1.1,
        ),
      ),
    );
  }
}

/// Botón de acción deportivo con esquinas redondeadas de 12 px.
class MotoActionButton extends StatelessWidget {
  const MotoActionButton({
    super.key,
    required this.press,
    this.size = 44,
    this.iconPath = "assets/icons/Arrow - Right.svg",
    this.usePrimaryBackground = true,
  });

  final VoidCallback press;
  final double size;
  final String iconPath;
  final bool usePrimaryBackground;

  @override
  Widget build(BuildContext context) {
    final Color bg = usePrimaryBackground ? primaryColor : whiteColor;
    final Color fg = usePrimaryBackground ? whiteColor : blackColor;

    return SizedBox(
      height: size,
      width: size,
      child: ElevatedButton(
        onPressed: press,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: 4,
          shadowColor: (usePrimaryBackground ? primaryColor : blackColor)
              .withOpacity(0.45),
          backgroundColor: bg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadious),
          ),
        ),
        child: SvgPicture.asset(
          iconPath,
          height: 20,
          width: 20,
          colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
        ),
      ),
    );
  }
}

/// Botón CTA tipo píldora deportiva de 12 px con texto e icono.
class MotoPrimaryPill extends StatelessWidget {
  const MotoPrimaryPill({
    super.key,
    required this.label,
    required this.press,
  });

  final String label;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
        elevation: 4,
        shadowColor: primaryColor.withOpacity(0.45),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        minimumSize: const Size(0, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadious),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: grandisExtendedFont,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.9,
              color: whiteColor,
            ),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            "assets/icons/Arrow - Right.svg",
            height: 16,
            width: 16,
            colorFilter: const ColorFilter.mode(whiteColor, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }
}

class _MotoTrackStripesPainter extends CustomPainter {
  const _MotoTrackStripesPainter({
    required this.primary,
    required this.accent,
    required this.highlight,
  });

  final Color primary;
  final Color accent;
  final Color highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Bandas anchas translúcidas simulando trazada de circuito
    final Paint wideBandPaint = Paint()
      ..color = highlight.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    Path createSkewBand(double startX, double width) {
      final double skew = h * 0.48;
      return Path()
        ..moveTo(startX, h)
        ..lineTo(startX + width, h)
        ..lineTo(startX + width + skew, 0)
        ..lineTo(startX + skew, 0)
        ..close();
    }

    canvas.drawPath(createSkewBand(w * 0.62, w * 0.09), wideBandPaint);
    canvas.drawPath(createSkewBand(w * 0.75, w * 0.045), wideBandPaint);

    // Líneas finas de velocidad en rojo carrera y ámbar
    final Paint redLinePaint = Paint()
      ..color = primary.withOpacity(0.75)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke;

    final Paint amberLinePaint = Paint()
      ..color = accent.withOpacity(0.85)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    final double skew = h * 0.48;
    canvas.drawLine(
      Offset(w * 0.72, h),
      Offset(w * 0.72 + skew, 0),
      redLinePaint,
    );
    canvas.drawLine(
      Offset(w * 0.72 + 9, h),
      Offset(w * 0.72 + 9 + skew, 0),
      amberLinePaint,
    );

    // Marcas de telemetría sutiles en esquina superior derecha
    final Paint tickPaint = Paint()
      ..color = highlight.withOpacity(0.22)
      ..strokeWidth = 1.5;

    for (int i = 0; i < 4; i++) {
      final double dx = w - 20 - (i * 8);
      canvas.drawLine(Offset(dx, 12), Offset(dx + 4, 6), tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MotoTrackStripesPainter oldDelegate) {
    return oldDelegate.primary != primary ||
        oldDelegate.accent != accent ||
        oldDelegate.highlight != highlight;
  }
}
