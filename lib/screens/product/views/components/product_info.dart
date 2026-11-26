import 'package:flutter/material.dart';
import 'package:catalogo_motos/models/moto_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants.dart';

/// Encabezado de la ficha (estilo Astra): marca y país en monoespaciada,
/// modelo en grande y etiquetas de categoría y año.
class ProductInfo extends StatelessWidget {
  const ProductInfo({super.key, required this.moto});

  final Moto moto;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
          defaultPadding, defaultPadding / 2, defaultPadding, defaultPadding),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 4, height: 16, color: primaryColor),
                const SizedBox(width: 10),
                Text(
                  "${moto.marca.nombre.toUpperCase()}   /   ${moto.marca.pais.toUpperCase()}",
                  style: TextStyle(
                    fontFamily: monoFont,
                    fontSize: 12,
                    letterSpacing: 1,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    moto.modelo,
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: grandisExtendedFont,
                      fontWeight: FontWeight.w800,
                      fontSize: moto.modelo.length > 12 ? 32 : 44,
                      height: 1.05,
                      letterSpacing: -0.5,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _Chip(moto.categoria, relleno: true),
                const SizedBox(width: 6),
                _Chip("${moto.anio}", relleno: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.texto, {required this.relleno});

  final String texto;
  final bool relleno;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: relleno ? cs.onSurface.withValues(alpha: 0.88) : null,
        borderRadius: BorderRadius.circular(20),
        border: relleno ? null : Border.all(color: cs.outlineVariant),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontFamily: relleno ? null : monoFont,
          fontWeight: relleno ? FontWeight.w700 : FontWeight.w500,
          fontSize: 12,
          color: relleno ? cs.surface : cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Ficha técnica (estilo Astra): tres cifras grandes con la unidad en ámbar
/// y, debajo, filas con el resto de los datos.
class FichaTecnica extends StatelessWidget {
  const FichaTecnica({super.key, required this.moto});

  final Moto moto;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cifras = <(String, String, String)>[
      ("Cilindrada", "${moto.cilindrada}", "cc"),
      ("Potencia", _num(moto.potencia), "hp"),
      if (moto.torque != null)
        ("Torque", _num(moto.torque!), "Nm")
      else if (moto.peso != null)
        ("Peso", "${moto.peso}", "kg"),
    ];
    final filas = <(String, String)>[
      ("Motor", moto.motor),
      ("Transmisión", moto.transmision),
      if (moto.peso != null)
        (
          moto.tipoPeso == "seco" ? "Peso en seco" : "Peso en orden de marcha",
          "${moto.peso} kg"
        ),
      if (moto.pesoPorHp != null)
        ("Peso / potencia", "${moto.pesoPorHp!.toStringAsFixed(1)} kg/hp"),
      if (moto.tanque != null) ("Tanque", "${_num(moto.tanque!)} L"),
      if (moto.alturaAsiento != null)
        ("Altura del asiento", "${moto.alturaAsiento} mm"),
      ("Licencia", moto.licencia),
      ("Colores", moto.colores.join(", ")),
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: defaultPadding * 1.25),
            Text(
              "Ficha técnica",
              style: TextStyle(
                fontFamily: grandisExtendedFont,
                fontWeight: FontWeight.w800,
                fontSize: 26,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: defaultPadding),
            IntrinsicHeight(
              child: Row(
                children: [
                  for (final (i, (nombre, valor, unidad))
                      in cifras.indexed) ...[
                    if (i > 0)
                      VerticalDivider(
                          width: 24, thickness: 1, color: cs.outlineVariant),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nombre,
                              style: TextStyle(
                                  fontSize: 13, color: cs.onSurfaceVariant)),
                          const SizedBox(height: 6),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  valor,
                                  style: TextStyle(
                                    fontFamily: grandisExtendedFont,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 32,
                                    color: cs.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  unidad,
                                  style: const TextStyle(
                                    fontFamily: monoFont,
                                    fontSize: 13,
                                    color: accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: defaultPadding),
            Divider(height: 1, color: cs.outlineVariant),
            for (final (nombre, valor) in filas) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nombre,
                        style: TextStyle(
                            fontSize: 14, color: cs.onSurfaceVariant)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        valor,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: cs.outlineVariant),
            ],
            const SizedBox(height: defaultPadding * 1.5),
            Text(
              "Descripción",
              style: TextStyle(
                fontFamily: grandisExtendedFont,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(moto.descripcion,
                style: TextStyle(height: 1.45, color: cs.onSurfaceVariant)),
            const SizedBox(height: defaultPadding),
            if (moto.fuentes.isNotEmpty) ...[
              Text(
                "FUENTES · NOVIEMBRE 2026",
                style: TextStyle(
                  fontFamily: monoFont,
                  fontSize: 11,
                  letterSpacing: 1,
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              for (final url in moto.fuentes)
                InkWell(
                  onTap: () => launchUrl(Uri.parse(url),
                      mode: LaunchMode.externalApplication),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      Uri.parse(url).host.replaceFirst("www.", ""),
                      style: const TextStyle(
                        fontSize: 12,
                        color: primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: primaryColor,
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  static String _num(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
}
