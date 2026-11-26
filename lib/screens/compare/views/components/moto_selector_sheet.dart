import 'package:flutter/material.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/moto_model.dart';
import 'package:shop/screens/home/views/components/categories.dart';

/// Abre un bottom sheet con buscador, filtro de categorías y miniaturas para
/// seleccionar una moto de la lista [motos].
Future<Moto?> mostrarSelectorMoto(
  BuildContext context, {
  required String titulo,
  Moto? seleccionadaActual,
  Moto? otraMoto,
}) {
  return showModalBottomSheet<Moto>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => MotoSelectorSheet(
      titulo: titulo,
      seleccionadaActual: seleccionadaActual,
      otraMoto: otraMoto,
    ),
  );
}

/// Contenido del selector de motos con buscador, categorías y lista de fichas.
class MotoSelectorSheet extends StatefulWidget {
  const MotoSelectorSheet({
    super.key,
    required this.titulo,
    this.seleccionadaActual,
    this.otraMoto,
  });

  final String titulo;
  final Moto? seleccionadaActual;
  final Moto? otraMoto;

  @override
  State<MotoSelectorSheet> createState() => _MotoSelectorSheetState();
}

class _MotoSelectorSheetState extends State<MotoSelectorSheet> {
  final TextEditingController _controller = TextEditingController();
  String _busqueda = "";
  String _categoria = todasLasCategorias;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Moto> get _filtradas {
    return motosPorCategoria(_categoria)
        .where((m) => m.coincideCon(_busqueda))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filtradas = _filtradas;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.titulo,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontFamily: grandisExtendedFont,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${filtradas.length} ${filtradas.length == 1 ? 'modelo disponible' : 'modelos disponibles'}",
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: "Cerrar",
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding * 0.75),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: TextField(
                controller: _controller,
                onChanged: (valor) => setState(() => _busqueda = valor),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "Buscar por modelo, marca o cc...",
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _busqueda.isNotEmpty
                      ? IconButton(
                          tooltip: "Limpiar búsqueda",
                          onPressed: () {
                            _controller.clear();
                            setState(() => _busqueda = "");
                          },
                          icon: const Icon(Icons.close_rounded, size: 20),
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: defaultPadding * 0.75),
            Categories(
              seleccionada: _categoria,
              alSeleccionar: (c) => setState(() => _categoria = c),
            ),
            const SizedBox(height: defaultPadding * 0.75),
            Divider(height: 1, color: colorScheme.outline),
            Expanded(
              child: filtradas.isEmpty
                  ? _SinMotosCoincidentes(
                      alLimpiar: () {
                        _controller.clear();
                        setState(() {
                          _busqueda = "";
                          _categoria = todasLasCategorias;
                        });
                      },
                    )
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.all(defaultPadding),
                      itemCount: filtradas.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: defaultPadding * 0.65),
                      itemBuilder: (context, index) {
                        final moto = filtradas[index];
                        final esActual =
                            widget.seleccionadaActual?.id == moto.id;
                        final esOtra = widget.otraMoto?.id == moto.id;
                        return _MotoSelectorTile(
                          moto: moto,
                          esActual: esActual,
                          esOtra: esOtra,
                          onTap: esOtra
                              ? null
                              : () => Navigator.pop(context, moto),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _MotoSelectorTile extends StatelessWidget {
  const _MotoSelectorTile({
    required this.moto,
    required this.esActual,
    required this.esOtra,
    required this.onTap,
  });

  final Moto moto;
  final bool esActual;
  final bool esOtra;
  final VoidCallback? onTap;

  String _fmtPotencia(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final imagen = moto.fotos.isNotEmpty ? moto.fotos.first : moto.imagen;

    return Opacity(
      opacity: esOtra ? 0.5 : 1.0,
      child: Material(
        color: esActual
            ? colorScheme.primary.withValues(alpha: 0.08)
            : theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(defaultBorderRadious),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(defaultBorderRadious),
              border: Border.all(
                color: esActual ? colorScheme.primary : colorScheme.outline,
                width: esActual ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 76,
                  height: 58,
                  child: NetworkImageWithLoader(imagen, radius: 10),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${moto.marca.nombre.toUpperCase()} · ${moto.categoria}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        moto.modelo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${moto.cilindrada} cc · ${_fmtPotencia(moto.potencia)} hp · ${moto.anio}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatoPrecio(moto.precio),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (esActual)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          "Actual",
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    else if (esOtra)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          "En la otra",
                          style: theme.textTheme.labelSmall,
                        ),
                      )
                    else
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SinMotosCoincidentes extends StatelessWidget {
  const _SinMotosCoincidentes({required this.alLimpiar});

  final VoidCallback alLimpiar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.two_wheeler_rounded,
              size: 52,
              color: theme.colorScheme.primary.withValues(alpha: 0.55),
            ),
            const SizedBox(height: defaultPadding),
            Text(
              "Sin coincidencias",
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 6),
            Text(
              "Prueba con otro modelo, marca o categoría.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: defaultPadding),
            TextButton(
              onPressed: alLimpiar,
              child: const Text("Ver todas las motos"),
            ),
          ],
        ),
      ),
    );
  }
}
