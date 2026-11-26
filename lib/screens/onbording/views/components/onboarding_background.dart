import 'package:flutter/material.dart';
import 'package:shop/constants.dart';

/// Fondo deportivo con degradado sutil y formas diagonales dinámicas
/// para la experiencia de onboarding del catálogo de motocicletas.
class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  static const Color _amberAccent = Color(0xFFFFB020);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                whiteColor,
                lightGreyColor,
                whiteColor.withOpacity(0.96),
              ],
              stops: const [0.0, 0.58, 1.0],
            ),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _MotorsportBackdropPainter(
              primary: primaryColor,
              graphite: blackColor,
              amber: _amberAccent,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _MotorsportBackdropPainter extends CustomPainter {
  _MotorsportBackdropPainter({
    required this.primary,
    required this.graphite,
    required this.amber,
  });

  final Color primary;
  final Color graphite;
  final Color amber;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Franja diagonal superior derecha en rojo carrera suave
    final Path topRedSlash = Path()
      ..moveTo(w * 0.42, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h * 0.34)
      ..lineTo(w * 0.16, h * 0.12)
      ..close();
    canvas.drawPath(
      topRedSlash,
      Paint()..color = primary.withOpacity(0.065),
    );

    // Cuña diagonal grafito superpuesta para contraste técnico
    final Path upperGraphiteSlash = Path()
      ..moveTo(w * 0.64, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h * 0.22)
      ..lineTo(w * 0.46, h * 0.08)
      ..close();
    canvas.drawPath(
      upperGraphiteSlash,
      Paint()..color = graphite.withOpacity(0.04),
    );

    // Línea de acento diagonal fina
    final Paint accentLinePaint = Paint()
      ..color = primary.withOpacity(0.22)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(w * 0.22, h * 0.09),
      Offset(w * 0.94, h * 0.31),
      accentLinePaint,
    );

    // Franja diagonal inferior izquierda sutil
    final Path bottomSlash = Path()
      ..moveTo(0, h * 0.72)
      ..lineTo(w * 0.48, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      bottomSlash,
      Paint()..color = graphite.withOpacity(0.03),
    );

    // Detalle de micro-telemetría ámbar en esquina superior derecha
    final Paint dotPaint = Paint()..color = amber.withOpacity(0.32);
    const int cols = 4;
    const int rows = 3;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        canvas.drawCircle(
          Offset(w - 28 - c * 10.0, h * 0.11 + r * 10.0),
          1.6,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MotorsportBackdropPainter oldDelegate) {
    return oldDelegate.primary != primary ||
        oldDelegate.graphite != graphite ||
        oldDelegate.amber != amber;
  }
}
