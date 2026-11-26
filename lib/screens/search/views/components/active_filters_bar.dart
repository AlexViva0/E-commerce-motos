import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/components/filtros/filtros_sheet.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/moto_model.dart';

/// Botón cuadrado redondeado de filtros con contador de filtros activos.
class FilterIconButton extends StatelessWidget {
  const FilterIconButton({
    super.key,
    required this.filtrosActivos,
    required this.onTap,
  });

  final int filtrosActivos;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activo = filtrosActivos > 0;

    return Tooltip(
      message: "Filtros avanzados",
      child: Material(
        color: activo ? colorScheme.primaryContainer : colorScheme.surface,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(defaultBorderRadious),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(defaultBorderRadious),
              border: Border.all(
                color: activo
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.15),
                width: activo ? 1.5 : 1,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/Filter.svg",
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    activo
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
                if (activo)
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      constraints:
                          const BoxConstraints(minWidth: 20, minHeight: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        "$filtrosActivos",
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Barra horizontal de chips removibles para los filtros activos.
class ActiveFiltersBar extends StatelessWidget {
  const ActiveFiltersBar({
    super.key,
    required this.filtros,
    required this.onCambiar,
    required this.onLimpiarTodo,
  });

  final FiltrosMotos filtros;
  final ValueChanged<FiltrosMotos> onCambiar;
  final VoidCallback onLimpiarTodo;

  @override
  Widget build(BuildContext context) {
    if (!filtros.hayFiltrosActivos) {
      return const SizedBox.shrink();
    }

    final chips = <Widget>[
      if (filtros.tienePrecioActivo)
        _ActiveFilterChip(
          icono: Icons.payments_outlined,
          etiqueta:
              "${formatoPrecio(filtros.rangoPrecio.start)} – ${formatoPrecio(filtros.rangoPrecio.end)}",
          onRemove: () => onCambiar(
            filtros.copyWith(
              rangoPrecio: RangeValues(
                FiltrosMotos.precioMinimoCatalogo,
                FiltrosMotos.precioMaximoCatalogo,
              ),
            ),
          ),
        ),
      if (filtros.tieneCilindradaActivo)
        _ActiveFilterChip(
          icono: Icons.speed_rounded,
          etiqueta:
              "${filtros.rangoCilindrada.start.round()} – ${filtros.rangoCilindrada.end.round()} cc",
          onRemove: () => onCambiar(
            filtros.copyWith(
              rangoCilindrada: RangeValues(
                FiltrosMotos.cilindradaMinimaCatalogo,
                FiltrosMotos.cilindradaMaximaCatalogo,
              ),
            ),
          ),
        ),
      for (final licencia in filtros.licencias)
        _ActiveFilterChip(
          icono: Icons.badge_outlined,
          etiqueta: "Licencia $licencia",
          onRemove: () => onCambiar(
            filtros.copyWith(
              licencias: Set.of(filtros.licencias)..remove(licencia),
            ),
          ),
        ),
      for (final marcaId in filtros.marcasIds)
        _ActiveFilterChip(
          icono: Icons.verified_outlined,
          etiqueta: _nombreMarca(marcaId),
          onRemove: () => onCambiar(
            filtros.copyWith(
              marcasIds: Set.of(filtros.marcasIds)..remove(marcaId),
            ),
          ),
        ),
      for (final categoria in filtros.categoriasSeleccionadas)
        _ActiveFilterChip(
          icono: Icons.category_outlined,
          etiqueta: categoria,
          onRemove: () => onCambiar(
            filtros.copyWith(
              categoriasSeleccionadas: Set.of(filtros.categoriasSeleccionadas)
                ..remove(categoria),
            ),
          ),
        ),
    ];

    final items = <Widget>[
      ...chips,
      if (chips.length > 1) _LimpiarTodoChip(onTap: onLimpiarTodo),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              items[i],
            ],
          ],
        ),
      ),
    );
  }

  static String _nombreMarca(String id) {
    return marcas
        .firstWhere(
          (m) => m.id == id,
          orElse: () => Marca(
            id: id,
            nombre: id,
            pais: "",
            logo: "",
            descripcion: "",
          ),
        )
        .nombre;
  }
}

class _ActiveFilterChip extends StatelessWidget {
  const _ActiveFilterChip({
    required this.icono,
    required this.etiqueta,
    required this.onRemove,
  });

  final IconData icono;
  final String etiqueta;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onRemove,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icono, size: 14, color: colorScheme.onPrimaryContainer),
              const SizedBox(width: 5),
              Text(
                etiqueta,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.close_rounded,
                size: 15,
                color: colorScheme.onPrimaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LimpiarTodoChip extends StatelessWidget {
  const _LimpiarTodoChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Text(
            "Limpiar todo",
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
