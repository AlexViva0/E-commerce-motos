import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/moto_model.dart';

/// Regla para decidir qué valor gana en una métrica numérica.
enum CriterioGanador { mayor, menor, ninguno }

/// Resultado de comparar dos valores numéricos.
class ResultadoComparacion {
  const ResultadoComparacion({
    required this.ganaA,
    required this.ganaB,
    required this.empate,
  });

  final bool ganaA;
  final bool ganaB;
  final bool empate;

  static ResultadoComparacion evaluar(
    double? a,
    double? b,
    CriterioGanador criterio,
  ) {
    if (criterio == CriterioGanador.ninguno || a == null || b == null) {
      return const ResultadoComparacion(
        ganaA: false,
        ganaB: false,
        empate: false,
      );
    }
    if ((a - b).abs() < 0.001) {
      return const ResultadoComparacion(
        ganaA: false,
        ganaB: false,
        empate: true,
      );
    }
    if (criterio == CriterioGanador.mayor) {
      return ResultadoComparacion(ganaA: a > b, ganaB: b > a, empate: false);
    }
    return ResultadoComparacion(ganaA: a < b, ganaB: b < a, empate: false);
  }
}

/// Cuenta cuántas ventajas técnicas tiene cada moto sobre las métricas con
/// criterio de ganador (potencia, torque, peso, peso/potencia, tanque, precio).
({int ventajasA, int ventajasB}) calcularMarcadorComparacion(
  Moto motoA,
  Moto motoB,
) {
  final pares = <(double?, double?, CriterioGanador)>[
    (motoA.potencia, motoB.potencia, CriterioGanador.mayor),
    (motoA.torque, motoB.torque, CriterioGanador.mayor),
    (motoA.peso?.toDouble(), motoB.peso?.toDouble(), CriterioGanador.menor),
    (motoA.pesoPorHp, motoB.pesoPorHp, CriterioGanador.menor),
    (motoA.tanque, motoB.tanque, CriterioGanador.mayor),
    (motoA.precio, motoB.precio, CriterioGanador.menor),
  ];

  var ventajasA = 0;
  var ventajasB = 0;
  for (final (a, b, criterio) in pares) {
    final res = ResultadoComparacion.evaluar(a, b, criterio);
    if (res.ganaA) ventajasA++;
    if (res.ganaB) ventajasB++;
  }
  return (ventajasA: ventajasA, ventajasB: ventajasB);
}

/// Fila comparativa numérica con valores lado a lado, barras proporcionales
/// animadas y resaltado del valor ganador con [primaryColor].
class CompareNumericRow extends StatelessWidget {
  const CompareNumericRow({
    super.key,
    required this.etiqueta,
    required this.icono,
    required this.valorA,
    required this.valorB,
    required this.textoA,
    required this.textoB,
    required this.criterio,
    this.subtituloA,
    this.subtituloB,
  });

  final String etiqueta;
  final IconData icono;
  final double? valorA;
  final double? valorB;
  final String textoA;
  final String textoB;
  final CriterioGanador criterio;
  final String? subtituloA;
  final String? subtituloB;

  (double, double) _calcularProporciones() {
    if (valorA == null && valorB == null) return (0.0, 0.0);
    if (valorA != null && valorB == null) return (1.0, 0.0);
    if (valorA == null && valorB != null) return (0.0, 1.0);
    final a = valorA!;
    final b = valorB!;
    final maximo = math.max(a, b);
    if (maximo <= 0) return (0.0, 0.0);
    final propA = a > 0 ? (a / maximo).clamp(0.06, 1.0) : 0.0;
    final propB = b > 0 ? (b / maximo).clamp(0.06, 1.0) : 0.0;
    return (propA, propB);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final resultado = ResultadoComparacion.evaluar(valorA, valorB, criterio);
    final (propA, propB) = _calcularProporciones();

    Color colorBarra({required bool gana, required bool esNulo}) {
      if (esNulo) return Colors.transparent;
      if (gana) return colorScheme.primary;
      if (criterio == CriterioGanador.ninguno || resultado.empate) {
        return colorScheme.onSurface.withValues(alpha: 0.35);
      }
      return colorScheme.onSurface.withValues(alpha: 0.2);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: 12,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icono,
                size: 15,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Text(
                etiqueta,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: 13,
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              if (resultado.empate) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    "Empate",
                    style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ValorCelda(
                  texto: textoA,
                  subtitulo: subtituloA,
                  esGanador: resultado.ganaA,
                  esNulo: valorA == null,
                  alinearDerecha: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ValorCelda(
                  texto: textoB,
                  subtitulo: subtituloB,
                  esGanador: resultado.ganaB,
                  esNulo: valorB == null,
                  alinearDerecha: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _BarraProporcionalDoble(
            proporcionA: propA,
            proporcionB: propB,
            colorA: colorBarra(gana: resultado.ganaA, esNulo: valorA == null),
            colorB: colorBarra(gana: resultado.ganaB, esNulo: valorB == null),
          ),
        ],
      ),
    );
  }
}

class _ValorCelda extends StatelessWidget {
  const _ValorCelda({
    required this.texto,
    required this.esGanador,
    required this.esNulo,
    required this.alinearDerecha,
    this.subtitulo,
  });

  final String texto;
  final String? subtitulo;
  final bool esGanador;
  final bool esNulo;
  final bool alinearDerecha;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final textColor = esNulo
        ? colorScheme.onSurface.withValues(alpha: 0.4)
        : esGanador
            ? colorScheme.primary
            : colorScheme.onSurface;

    final textStyle = theme.textTheme.titleSmall?.copyWith(
      color: textColor,
      fontWeight: esGanador ? FontWeight.w800 : FontWeight.w600,
      fontStyle: esNulo ? FontStyle.italic : FontStyle.normal,
    );

    final children = <Widget>[
      if (esGanador && alinearDerecha) ...[
        Icon(Icons.emoji_events_rounded, size: 15, color: colorScheme.primary),
        const SizedBox(width: 4),
      ],
      Flexible(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment:
              alinearDerecha ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(texto, style: textStyle),
        ),
      ),
      if (esGanador && !alinearDerecha) ...[
        const SizedBox(width: 4),
        Icon(Icons.emoji_events_rounded, size: 15, color: colorScheme.primary),
      ],
    ];

    return Column(
      crossAxisAlignment:
          alinearDerecha ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              alinearDerecha ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: children,
        ),
        if (subtitulo != null && subtitulo!.isNotEmpty) ...[
          const SizedBox(height: 1),
          Text(
            subtitulo!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 10.5),
          ),
        ],
      ],
    );
  }
}

class _BarraProporcionalDoble extends StatelessWidget {
  const _BarraProporcionalDoble({
    required this.proporcionA,
    required this.proporcionB,
    required this.colorA,
    required this.colorB,
  });

  final double proporcionA;
  final double proporcionB;
  final Color colorA;
  final Color colorB;

  @override
  Widget build(BuildContext context) {
    final trackColor =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08);

    return SizedBox(
      height: 8,
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(999),
                right: Radius.circular(2),
              ),
              child: Container(
                color: trackColor,
                alignment: Alignment.centerRight,
                child: AnimatedFractionallySizedBox(
                  duration: defaultDuration,
                  curve: Curves.easeOutCubic,
                  widthFactor: proporcionA,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorA,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(999),
                        right: Radius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(2),
                right: Radius.circular(999),
              ),
              child: Container(
                color: trackColor,
                alignment: Alignment.centerLeft,
                child: AnimatedFractionallySizedBox(
                  duration: defaultDuration,
                  curve: Curves.easeOutCubic,
                  widthFactor: proporcionB,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorB,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(2),
                        right: Radius.circular(999),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fila comparativa de texto/etiqueta (por ejemplo Licencia o Categoría).
class CompareBadgeRow extends StatelessWidget {
  const CompareBadgeRow({
    super.key,
    required this.etiqueta,
    required this.icono,
    required this.valorA,
    required this.valorB,
    this.svgA,
    this.svgB,
  });

  final String etiqueta;
  final IconData icono;
  final String valorA;
  final String valorB;
  final String? svgA;
  final String? svgB;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: 12,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icono,
                size: 15,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Text(
                etiqueta,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: 13,
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _BadgeValor(texto: valorA, svgPath: svgA),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _BadgeValor(texto: valorB, svgPath: svgB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BadgeValor extends StatelessWidget {
  const _BadgeValor({required this.texto, this.svgPath});

  final String texto;
  final String? svgPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (svgPath != null) ...[
            SvgPicture.asset(
              svgPath!,
              height: 16,
              colorFilter: ColorFilter.mode(
                colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              texto,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
