import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/moto_model.dart';

/// Estado inmutable de los filtros avanzados del catálogo de motos.
class FiltrosMotos {
  FiltrosMotos({
    RangeValues? rangoPrecio,
    RangeValues? rangoCilindrada,
    Set<String> licencias = const {},
    Set<String> marcasIds = const {},
    Set<String> categoriasSeleccionadas = const {},
  })  : rangoPrecio = rangoPrecio ??
            RangeValues(precioMinimoCatalogo, precioMaximoCatalogo),
        rangoCilindrada = rangoCilindrada ??
            RangeValues(cilindradaMinimaCatalogo, cilindradaMaximaCatalogo),
        licencias = Set.unmodifiable(licencias),
        marcasIds = Set.unmodifiable(marcasIds),
        categoriasSeleccionadas = Set.unmodifiable(categoriasSeleccionadas);

  final RangeValues rangoPrecio;
  final RangeValues rangoCilindrada;
  final Set<String> licencias;
  final Set<String> marcasIds;
  final Set<String> categoriasSeleccionadas;

  static double get precioMinimoCatalogo =>
      motos.isEmpty ? 0 : motos.map((m) => m.precio).reduce(math.min);

  static double get precioMaximoCatalogo =>
      motos.isEmpty ? 0 : motos.map((m) => m.precio).reduce(math.max);

  static double get cilindradaMinimaCatalogo => motos.isEmpty
      ? 0
      : motos.map((m) => m.cilindrada).reduce(math.min).toDouble();

  static double get cilindradaMaximaCatalogo => motos.isEmpty
      ? 0
      : motos.map((m) => m.cilindrada).reduce(math.max).toDouble();

  bool get tienePrecioActivo =>
      rangoPrecio.start.round() > precioMinimoCatalogo.round() ||
      rangoPrecio.end.round() < precioMaximoCatalogo.round();

  bool get tieneCilindradaActivo =>
      rangoCilindrada.start.round() > cilindradaMinimaCatalogo.round() ||
      rangoCilindrada.end.round() < cilindradaMaximaCatalogo.round();

  bool get tieneLicenciasActivas => licencias.isNotEmpty;

  bool get tieneMarcasActivas => marcasIds.isNotEmpty;

  bool get tieneCategoriasActivas => categoriasSeleccionadas.isNotEmpty;

  bool get hayFiltrosActivos => cantidadActivos > 0;

  int get cantidadActivos =>
      (tienePrecioActivo ? 1 : 0) +
      (tieneCilindradaActivo ? 1 : 0) +
      licencias.length +
      marcasIds.length +
      categoriasSeleccionadas.length;

  FiltrosMotos copyWith({
    RangeValues? rangoPrecio,
    RangeValues? rangoCilindrada,
    Set<String>? licencias,
    Set<String>? marcasIds,
    Set<String>? categoriasSeleccionadas,
  }) {
    return FiltrosMotos(
      rangoPrecio: rangoPrecio ?? this.rangoPrecio,
      rangoCilindrada: rangoCilindrada ?? this.rangoCilindrada,
      licencias: licencias ?? this.licencias,
      marcasIds: marcasIds ?? this.marcasIds,
      categoriasSeleccionadas:
          categoriasSeleccionadas ?? this.categoriasSeleccionadas,
    );
  }

  /// Verifica si [moto] cumple todos los criterios activos.
  bool coincide(Moto moto) {
    if (tienePrecioActivo) {
      final precio = moto.precio.round();
      if (precio < rangoPrecio.start.round() ||
          precio > rangoPrecio.end.round()) {
        return false;
      }
    }
    if (tieneCilindradaActivo) {
      if (moto.cilindrada < rangoCilindrada.start.round() ||
          moto.cilindrada > rangoCilindrada.end.round()) {
        return false;
      }
    }
    if (licencias.isNotEmpty && !licencias.contains(moto.licencia)) {
      return false;
    }
    if (marcasIds.isNotEmpty && !marcasIds.contains(moto.marcaId)) {
      return false;
    }
    if (categoriasSeleccionadas.isNotEmpty &&
        !categoriasSeleccionadas.contains(moto.categoria)) {
      return false;
    }
    return true;
  }

  /// Filtra [origen] combinando los filtros avanzados con [texto].
  List<Moto> aplicar(Iterable<Moto> origen, {String texto = ""}) {
    return origen.where((m) => m.coincideCon(texto) && coincide(m)).toList();
  }
}

/// Abre el bottom sheet de filtros avanzados y devuelve la nueva selección,
/// o `null` si el usuario cerró el modal sin confirmar.
Future<FiltrosMotos?> mostrarFiltrosSheet(
  BuildContext context, {
  required FiltrosMotos filtrosActuales,
  String textoBusqueda = "",
  List<Moto> catalogo = motos,
}) {
  return showModalBottomSheet<FiltrosMotos>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => FiltrosSheet(
      filtrosIniciales: filtrosActuales,
      textoBusqueda: textoBusqueda,
      catalogo: catalogo,
    ),
  );
}

/// Bottom sheet moderno para configurar filtros avanzados del catálogo.
class FiltrosSheet extends StatefulWidget {
  const FiltrosSheet({
    super.key,
    required this.filtrosIniciales,
    this.textoBusqueda = "",
    this.catalogo = motos,
  });

  final FiltrosMotos filtrosIniciales;
  final String textoBusqueda;
  final List<Moto> catalogo;

  @override
  State<FiltrosSheet> createState() => _FiltrosSheetState();
}

class _FiltrosSheetState extends State<FiltrosSheet> {
  static const List<({String codigo, String descripcion})> _infoLicencias = [
    (
      codigo: "A1",
      descripcion: "Hasta 125 cc y 15 hp · Ideal para empezar",
    ),
    (
      codigo: "A2",
      descripcion: "Hasta 47 hp · Uso urbano y carretera",
    ),
    (
      codigo: "A",
      descripcion: "Más de 47 hp · Sin límite de potencia",
    ),
  ];

  late FiltrosMotos _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.filtrosIniciales;
  }

  void _alternarEnSet(
    Set<String> actual,
    String valor,
    FiltrosMotos Function(Set<String> nuevo) actualizar,
  ) {
    final copia = Set<String>.from(actual);
    if (!copia.add(valor)) {
      copia.remove(valor);
    }
    setState(() => _draft = actualizar(copia));
  }

  void _limpiar() {
    setState(() => _draft = FiltrosMotos());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final totalCoincidencias =
        _draft.aplicar(widget.catalogo, texto: widget.textoBusqueda).length;

    final minPrecio = FiltrosMotos.precioMinimoCatalogo;
    final maxPrecio = FiltrosMotos.precioMaximoCatalogo;
    final minCc = FiltrosMotos.cilindradaMinimaCatalogo;
    final maxCc = FiltrosMotos.cilindradaMaximaCatalogo;

    final precioDivisions = maxPrecio > minPrecio
        ? ((maxPrecio - minPrecio) / 5000).round().clamp(1, 100)
        : null;
    final ccDivisions =
        maxCc > minCc ? ((maxCc - minCc) / 25).round().clamp(1, 100) : null;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                defaultPadding, 12, defaultPadding / 2, 8),
            child: Row(
              children: [
                Text(
                  "Filtros",
                  style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20),
                ),
                if (_draft.hayFiltrosActivos) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${_draft.cantidadActivos} activos",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                IconButton(
                  tooltip: "Cerrar",
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EncabezadoRango(
                    icono: Icons.payments_outlined,
                    titulo: "Rango de precio",
                    valor:
                        "${formatoPrecio(_draft.rangoPrecio.start)} – ${formatoPrecio(_draft.rangoPrecio.end)}",
                    activo: _draft.tienePrecioActivo,
                  ),
                  const SizedBox(height: 4),
                  _RangoSliderTematizado(
                    values: RangeValues(
                      _draft.rangoPrecio.start.clamp(minPrecio, maxPrecio),
                      _draft.rangoPrecio.end.clamp(minPrecio, maxPrecio),
                    ),
                    min: minPrecio,
                    max: maxPrecio,
                    divisions: precioDivisions,
                    labels: RangeLabels(
                      formatoPrecio(_draft.rangoPrecio.start),
                      formatoPrecio(_draft.rangoPrecio.end),
                    ),
                    onChanged: maxPrecio > minPrecio
                        ? (v) => setState(
                            () => _draft = _draft.copyWith(rangoPrecio: v))
                        : null,
                  ),
                  _EtiquetasExtremos(
                    inicio: formatoPrecio(minPrecio),
                    fin: formatoPrecio(maxPrecio),
                  ),
                  const SizedBox(height: defaultPadding * 1.25),
                  _EncabezadoRango(
                    icono: Icons.speed_rounded,
                    titulo: "Cilindrada",
                    valor:
                        "${_draft.rangoCilindrada.start.round()} cc – ${_draft.rangoCilindrada.end.round()} cc",
                    activo: _draft.tieneCilindradaActivo,
                  ),
                  const SizedBox(height: 4),
                  _RangoSliderTematizado(
                    values: RangeValues(
                      _draft.rangoCilindrada.start.clamp(minCc, maxCc),
                      _draft.rangoCilindrada.end.clamp(minCc, maxCc),
                    ),
                    min: minCc,
                    max: maxCc,
                    divisions: ccDivisions,
                    labels: RangeLabels(
                      "${_draft.rangoCilindrada.start.round()} cc",
                      "${_draft.rangoCilindrada.end.round()} cc",
                    ),
                    onChanged: maxCc > minCc
                        ? (v) => setState(
                            () => _draft = _draft.copyWith(rangoCilindrada: v))
                        : null,
                  ),
                  _EtiquetasExtremos(
                    inicio: "${minCc.round()} cc",
                    fin: "${maxCc.round()} cc",
                  ),
                  const SizedBox(height: defaultPadding * 1.25),
                  const _TituloSeccion(
                    icono: Icons.badge_outlined,
                    titulo: "Tipo de licencia",
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final info in _infoLicencias)
                        _ChipFiltro(
                          etiqueta: "Licencia ${info.codigo}",
                          seleccionado: _draft.licencias.contains(info.codigo),
                          onSelected: (_) => _alternarEnSet(
                            _draft.licencias,
                            info.codigo,
                            (nuevo) => _draft.copyWith(licencias: nuevo),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: theme.inputDecorationTheme.fillColor ??
                          colorScheme.onSurface.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(defaultBorderRadious),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0; i < _infoLicencias.length; i++) ...[
                          if (i > 0) const SizedBox(height: 6),
                          _LineaAyudaLicencia(
                            codigo: _infoLicencias[i].codigo,
                            descripcion: _infoLicencias[i].descripcion,
                            resaltada: _draft.licencias
                                .contains(_infoLicencias[i].codigo),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: defaultPadding * 1.25),
                  const _TituloSeccion(
                    icono: Icons.verified_outlined,
                    titulo: "Marca",
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final marca in marcas)
                        _ChipFiltro(
                          etiqueta: marca.nombre,
                          seleccionado: _draft.marcasIds.contains(marca.id),
                          avatar: Container(
                            width: 20,
                            height: 20,
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                marca.logo,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          onSelected: (_) => _alternarEnSet(
                            _draft.marcasIds,
                            marca.id,
                            (nuevo) => _draft.copyWith(marcasIds: nuevo),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: defaultPadding * 1.25),
                  const _TituloSeccion(
                    icono: Icons.category_outlined,
                    titulo: "Categoría",
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final categoria in categorias)
                        _ChipFiltro(
                          etiqueta: categoria,
                          seleccionado: _draft.categoriasSeleccionadas
                              .contains(categoria),
                          avatar: iconoCategoria[categoria] == null
                              ? null
                              : Builder(
                                  builder: (context) {
                                    final seleccionado = _draft
                                        .categoriasSeleccionadas
                                        .contains(categoria);
                                    return SvgPicture.asset(
                                      iconoCategoria[categoria]!,
                                      width: 16,
                                      height: 16,
                                      colorFilter: ColorFilter.mode(
                                        seleccionado
                                            ? colorScheme.onPrimary
                                            : colorScheme.onSurface,
                                        BlendMode.srcIn,
                                      ),
                                    );
                                  },
                                ),
                          onSelected: (_) => _alternarEnSet(
                            _draft.categoriasSeleccionadas,
                            categoria,
                            (nuevo) =>
                                _draft.copyWith(categoriasSeleccionadas: nuevo),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: defaultPadding / 2),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
                defaultPadding, 12, defaultPadding, defaultPadding),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(top: BorderSide(color: theme.dividerColor)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: _draft.hayFiltrosActivos ? _limpiar : null,
                      child: const Text("Limpiar"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context, _draft),
                      child: Text(
                        "Ver $totalCoincidencias "
                        "${totalCoincidencias == 1 ? "moto" : "motos"}",
                      ),
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

class _TituloSeccion extends StatelessWidget {
  const _TituloSeccion({required this.icono, required this.titulo});

  final IconData icono;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icono, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            titulo,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}

class _EncabezadoRango extends StatelessWidget {
  const _EncabezadoRango({
    required this.icono,
    required this.titulo,
    required this.valor,
    required this.activo,
  });

  final IconData icono;
  final String titulo;
  final String valor;
  final bool activo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(child: _TituloSeccion(icono: icono, titulo: titulo)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: activo
                ? colorScheme.primaryContainer
                : colorScheme.onSurface.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            valor,
            style: theme.textTheme.labelMedium?.copyWith(
              color: activo
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _RangoSliderTematizado extends StatelessWidget {
  const _RangoSliderTematizado({
    required this.values,
    required this.min,
    required this.max,
    required this.divisions,
    required this.labels,
    required this.onChanged,
  });

  final RangeValues values;
  final double min;
  final double max;
  final int? divisions;
  final RangeLabels labels;
  final ValueChanged<RangeValues>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.primary.withValues(alpha: 0.18),
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.14),
        valueIndicatorColor: colorScheme.primary,
        valueIndicatorTextStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        trackHeight: 4,
      ),
      child: RangeSlider(
        values: values,
        min: min,
        max: max,
        divisions: divisions,
        labels: labels,
        onChanged: onChanged,
      ),
    );
  }
}

class _EtiquetasExtremos extends StatelessWidget {
  const _EtiquetasExtremos({required this.inicio, required this.fin});

  final String inicio;
  final String fin;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(inicio, style: style),
          Text(fin, style: style),
        ],
      ),
    );
  }
}

class _LineaAyudaLicencia extends StatelessWidget {
  const _LineaAyudaLicencia({
    required this.codigo,
    required this.descripcion,
    required this.resaltada,
  });

  final String codigo;
  final String descripcion;
  final bool resaltada;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 28,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: resaltada
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            codigo,
            style: theme.textTheme.labelSmall?.copyWith(
              color: resaltada ? colorScheme.onPrimary : colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            descripcion,
            style: theme.textTheme.bodySmall?.copyWith(
              color: resaltada
                  ? colorScheme.onSurface
                  : theme.textTheme.bodyMedium?.color,
              fontWeight: resaltada ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChipFiltro extends StatelessWidget {
  const _ChipFiltro({
    required this.etiqueta,
    required this.seleccionado,
    required this.onSelected,
    this.avatar,
  });

  final String etiqueta;
  final bool seleccionado;
  final ValueChanged<bool> onSelected;
  final Widget? avatar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FilterChip(
      selected: seleccionado,
      onSelected: onSelected,
      avatar: avatar,
      showCheckmark: avatar == null,
      checkmarkColor: colorScheme.onPrimary,
      selectedColor: colorScheme.primary,
      backgroundColor: colorScheme.surface,
      side: BorderSide(
        color: seleccionado ? colorScheme.primary : theme.dividerColor,
      ),
      label: Text(
        etiqueta,
        style: theme.textTheme.labelMedium?.copyWith(
          color: seleccionado ? colorScheme.onPrimary : colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
