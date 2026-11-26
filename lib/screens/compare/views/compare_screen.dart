import 'package:flutter/material.dart';
import 'package:catalogo_motos/components/network_image_with_loader.dart';
import 'package:catalogo_motos/constants.dart';
import 'package:catalogo_motos/models/moto_model.dart';

import 'components/compare_spec_row.dart';
import 'components/moto_compare_header.dart';
import 'components/moto_selector_sheet.dart';

/// Pantalla de comparación lado a lado entre dos motocicletas.
///
/// Puede recibir [motoInicialId] para preseleccionar la primera moto al abrir
/// el comparador desde la ficha técnica de un modelo.
class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key, this.motoInicialId});

  final int? motoInicialId;

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  Moto? _motoA;
  Moto? _motoB;
  double _swapTurns = 0;

  @override
  void initState() {
    super.initState();
    _motoA = _buscarMotoPorId(widget.motoInicialId);
  }

  Moto? _buscarMotoPorId(int? id) {
    if (id == null) return null;
    for (final moto in motos) {
      if (moto.id == id) return moto;
    }
    return null;
  }

  Future<void> _elegirMoto({required bool esMotoA}) async {
    final elegida = await mostrarSelectorMoto(
      context,
      titulo: esMotoA ? "Elige la primera moto" : "Elige la segunda moto",
      seleccionadaActual: esMotoA ? _motoA : _motoB,
      otraMoto: esMotoA ? _motoB : _motoA,
    );
    if (elegida == null || !mounted) return;
    setState(() {
      if (esMotoA) {
        _motoA = elegida;
      } else {
        _motoB = elegida;
      }
    });
  }

  void _intercambiar() {
    setState(() {
      final temporal = _motoA;
      _motoA = _motoB;
      _motoB = temporal;
      _swapTurns += 0.5;
    });
  }

  void _limpiar() {
    setState(() {
      _motoA = null;
      _motoB = null;
    });
  }

  String _fmtNum(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ambasSeleccionadas = _motoA != null && _motoB != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Comparar motos"),
        actions: [
          if (_motoA != null || _motoB != null)
            IconButton(
              tooltip: "Reiniciar selección",
              onPressed: _limpiar,
              icon: const Icon(Icons.restart_alt_rounded),
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(defaultPadding),
          children: [
            MotoCompareHeader(
              motoA: _motoA,
              motoB: _motoB,
              swapTurns: _swapTurns,
              onSelectA: () => _elegirMoto(esMotoA: true),
              onSelectB: () => _elegirMoto(esMotoA: false),
              onSwap: _intercambiar,
            ),
            const SizedBox(height: defaultPadding * 1.25),
            if (ambasSeleccionadas) ...[
              _ResumenVentajas(motoA: _motoA!, motoB: _motoB!),
              const SizedBox(height: defaultPadding),
              Text(
                "Especificaciones frente a frente",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontFamily: grandisExtendedFont,
                ),
              ),
              const SizedBox(height: 10),
              _TablaComparativa(
                motoA: _motoA!,
                motoB: _motoB!,
                fmtNum: _fmtNum,
              ),
              if (_motoA!.peso != null &&
                  _motoB!.peso != null &&
                  _motoA!.tipoPeso.isNotEmpty &&
                  _motoB!.tipoPeso.isNotEmpty &&
                  _motoA!.tipoPeso != _motoB!.tipoPeso) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(defaultBorderRadious),
                    border: Border.all(color: colorScheme.outline),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: colorScheme.onSurface.withValues(alpha: 0.65),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Nota: un fabricante reporta peso en seco y otro en orden de marcha (con fluidos).",
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ] else if (_motoA != null || _motoB != null) ...[
              _PromptSegundaMoto(
                motoElegida: (_motoA ?? _motoB)!,
                alElegirOtra: () => _elegirMoto(esMotoA: _motoA == null),
                alSeleccionarSugerencia: (sugerida) {
                  setState(() {
                    if (_motoA == null) {
                      _motoA = sugerida;
                    } else {
                      _motoB = sugerida;
                    }
                  });
                },
              ),
            ] else ...[
              _EstadoInicialComparador(
                alElegirPrimera: () => _elegirMoto(esMotoA: true),
                alCargarPar: (a, b) => setState(() {
                  _motoA = a;
                  _motoB = b;
                }),
              ),
            ],
            const SizedBox(height: defaultPadding),
          ],
        ),
      ),
    );
  }
}

class _ResumenVentajas extends StatelessWidget {
  const _ResumenVentajas({required this.motoA, required this.motoB});

  final Moto motoA;
  final Moto motoB;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final marcador = calcularMarcadorComparacion(motoA, motoB);
    final lideraA = marcador.ventajasA > marcador.ventajasB;
    final lideraB = marcador.ventajasB > marcador.ventajasA;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  motoA.modelo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  "${marcador.ventajasA} ${marcador.ventajasA == 1 ? 'ventaja' : 'ventajas'}",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color:
                        lideraA ? colorScheme.primary : colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: colorScheme.outline),
            ),
            child: Text(
              lideraA || lideraB ? "VS" : "EMPATE",
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  motoB.modelo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  "${marcador.ventajasB} ${marcador.ventajasB == 1 ? 'ventaja' : 'ventajas'}",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color:
                        lideraB ? colorScheme.primary : colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TablaComparativa extends StatelessWidget {
  const _TablaComparativa({
    required this.motoA,
    required this.motoB,
    required this.fmtNum,
  });

  final Moto motoA;
  final Moto motoB;
  final String Function(double) fmtNum;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final divider = Divider(height: 1, color: colorScheme.outline);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        children: [
          CompareNumericRow(
            etiqueta: "Cilindrada",
            icono: Icons.speed_rounded,
            valorA: motoA.cilindrada.toDouble(),
            valorB: motoB.cilindrada.toDouble(),
            textoA: "${motoA.cilindrada} cc",
            textoB: "${motoB.cilindrada} cc",
            criterio: CriterioGanador.ninguno,
          ),
          divider,
          CompareNumericRow(
            etiqueta: "Potencia",
            icono: Icons.bolt_rounded,
            valorA: motoA.potencia,
            valorB: motoB.potencia,
            textoA: "${fmtNum(motoA.potencia)} hp",
            textoB: "${fmtNum(motoB.potencia)} hp",
            criterio: CriterioGanador.mayor,
          ),
          divider,
          CompareNumericRow(
            etiqueta: "Torque",
            icono: Icons.rotate_right_rounded,
            valorA: motoA.torque,
            valorB: motoB.torque,
            textoA:
                motoA.torque == null ? "N/D" : "${fmtNum(motoA.torque!)} Nm",
            textoB:
                motoB.torque == null ? "N/D" : "${fmtNum(motoB.torque!)} Nm",
            criterio: CriterioGanador.mayor,
          ),
          divider,
          CompareNumericRow(
            etiqueta: "Peso",
            icono: Icons.fitness_center_rounded,
            valorA: motoA.peso?.toDouble(),
            valorB: motoB.peso?.toDouble(),
            textoA: motoA.peso == null ? "N/D" : "${motoA.peso} kg",
            textoB: motoB.peso == null ? "N/D" : "${motoB.peso} kg",
            subtituloA: motoA.peso == null ? null : motoA.tipoPeso,
            subtituloB: motoB.peso == null ? null : motoB.tipoPeso,
            criterio: CriterioGanador.menor,
          ),
          divider,
          CompareNumericRow(
            etiqueta: "Peso / potencia",
            icono: Icons.balance_rounded,
            valorA: motoA.pesoPorHp,
            valorB: motoB.pesoPorHp,
            textoA: motoA.pesoPorHp == null
                ? "N/D"
                : "${motoA.pesoPorHp!.toStringAsFixed(1)} kg/hp",
            textoB: motoB.pesoPorHp == null
                ? "N/D"
                : "${motoB.pesoPorHp!.toStringAsFixed(1)} kg/hp",
            criterio: CriterioGanador.menor,
          ),
          divider,
          CompareNumericRow(
            etiqueta: "Tanque",
            icono: Icons.local_gas_station_rounded,
            valorA: motoA.tanque,
            valorB: motoB.tanque,
            textoA: motoA.tanque == null ? "N/D" : "${fmtNum(motoA.tanque!)} L",
            textoB: motoB.tanque == null ? "N/D" : "${fmtNum(motoB.tanque!)} L",
            criterio: CriterioGanador.mayor,
          ),
          divider,
          CompareNumericRow(
            etiqueta: "Asiento",
            icono: Icons.event_seat_rounded,
            valorA: motoA.alturaAsiento?.toDouble(),
            valorB: motoB.alturaAsiento?.toDouble(),
            textoA: motoA.alturaAsiento == null
                ? "N/D"
                : "${motoA.alturaAsiento} mm",
            textoB: motoB.alturaAsiento == null
                ? "N/D"
                : "${motoB.alturaAsiento} mm",
            criterio: CriterioGanador.ninguno,
          ),
          divider,
          CompareBadgeRow(
            etiqueta: "Licencia",
            icono: Icons.badge_rounded,
            valorA: "Licencia ${motoA.licencia}",
            valorB: "Licencia ${motoB.licencia}",
          ),
          divider,
          CompareBadgeRow(
            etiqueta: "Categoría",
            icono: Icons.category_rounded,
            valorA: motoA.categoria,
            valorB: motoB.categoria,
            svgA: iconoCategoria[motoA.categoria],
            svgB: iconoCategoria[motoB.categoria],
          ),
          divider,
          CompareNumericRow(
            etiqueta: "Precio",
            icono: Icons.attach_money_rounded,
            valorA: motoA.precio,
            valorB: motoB.precio,
            textoA: formatoPrecio(motoA.precio),
            textoB: formatoPrecio(motoB.precio),
            criterio: CriterioGanador.menor,
          ),
        ],
      ),
    );
  }
}

class _PromptSegundaMoto extends StatelessWidget {
  const _PromptSegundaMoto({
    required this.motoElegida,
    required this.alElegirOtra,
    required this.alSeleccionarSugerencia,
  });

  final Moto motoElegida;
  final VoidCallback alElegirOtra;
  final ValueChanged<Moto> alSeleccionarSugerencia;

  List<Moto> _sugerencias() {
    final candidatas = motos.where((m) => m.id != motoElegida.id).toList()
      ..sort((a, b) {
        final mismaCatA = a.categoria == motoElegida.categoria ? 0 : 1;
        final mismaCatB = b.categoria == motoElegida.categoria ? 0 : 1;
        if (mismaCatA != mismaCatB) return mismaCatA.compareTo(mismaCatB);
        final diffA = (a.cilindrada - motoElegida.cilindrada).abs();
        final diffB = (b.cilindrada - motoElegida.cilindrada).abs();
        return diffA.compareTo(diffB);
      });
    return candidatas.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sugeridas = _sugerencias();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Column(
            children: [
              Text(
                "Elige la segunda moto",
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Text(
                "Compara ${motoElegida.nombreCompleto} frente a cualquier modelo del catálogo.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: alElegirOtra,
                icon: const Icon(Icons.search_rounded),
                label: const Text("Buscar moto para comparar"),
              ),
            ],
          ),
        ),
        if (sugeridas.isNotEmpty) ...[
          const SizedBox(height: defaultPadding * 1.25),
          Text(
            "Rivales sugeridos",
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          for (final moto in sugeridas)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _TarjetaSugerenciaMoto(
                moto: moto,
                onTap: () => alSeleccionarSugerencia(moto),
              ),
            ),
        ],
      ],
    );
  }
}

class _TarjetaSugerenciaMoto extends StatelessWidget {
  const _TarjetaSugerenciaMoto({required this.moto, required this.onTap});

  final Moto moto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final foto = moto.fotos.isNotEmpty ? moto.fotos.first : moto.imagen;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(defaultBorderRadious),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(defaultBorderRadious),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 68,
                height: 50,
                child: NetworkImageWithLoader(foto, radius: 10),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      moto.nombreCompleto,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${moto.categoria} · ${moto.cilindrada} cc · ${formatoPrecio(moto.precio)}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.add_circle_outline_rounded,
                  color: colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _EstadoInicialComparador extends StatelessWidget {
  const _EstadoInicialComparador({
    required this.alElegirPrimera,
    required this.alCargarPar,
  });

  final VoidCallback alElegirPrimera;
  final void Function(Moto, Moto) alCargarPar;

  Moto? _porId(int id) {
    for (final m in motos) {
      if (m.id == id) return m;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final paresPopulares = <(String, int, int)>[
      ("Naked vs Aventura", 1, 4),
      ("Deportiva vs Naked 451 cc", 6, 7),
      ("Duelo de entrada", 10, 22),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(defaultPadding * 1.25),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.compare_arrows_rounded,
                  size: 32,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Compara ficha a ficha",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontFamily: grandisExtendedFont,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Selecciona dos motos arriba para analizar potencia, torque, peso, relación peso/potencia, tanque y precio.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: alElegirPrimera,
                icon: const Icon(Icons.two_wheeler_rounded),
                label: const Text("Elegir primera moto"),
              ),
            ],
          ),
        ),
        const SizedBox(height: defaultPadding * 1.25),
        Text(
          "Comparativas populares",
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 10),
        for (final (etiqueta, idA, idB) in paresPopulares)
          Builder(
            builder: (context) {
              final a = _porId(idA);
              final b = _porId(idB);
              if (a == null || b == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(defaultBorderRadious),
                  child: InkWell(
                    onTap: () => alCargarPar(a, b),
                    borderRadius: BorderRadius.circular(defaultBorderRadious),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadious),
                        border: Border.all(color: colorScheme.outline),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  etiqueta.toUpperCase(),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "${a.nombreCompleto}  vs  ${b.nombreCompleto}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
