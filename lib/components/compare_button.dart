import 'package:flutter/material.dart';
import 'package:catalogo_motos/constants.dart';
import 'package:catalogo_motos/route/route_constants.dart';

/// Botón o acción reutilizable para abrir el comparador de motos.
///
/// Si se pasa [motoId], el comparador inicia con esa moto preseleccionada en
/// la primera columna. Usa [compact] = true (o [CompareButton.icon]) para
/// barras de acciones como `AppBar.actions`.
class CompareButton extends StatelessWidget {
  const CompareButton({
    super.key,
    this.motoId,
    this.compact = false,
    this.expanded = false,
    this.label = "Comparar",
  });

  const CompareButton.icon({
    super.key,
    this.motoId,
    this.label = "Comparar",
  })  : compact = true,
        expanded = false;

  final int? motoId;
  final bool compact;
  final bool expanded;
  final String label;

  void _abrirComparador(BuildContext context) {
    Navigator.pushNamed(context, compareScreenRoute, arguments: motoId);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (compact) {
      return IconButton(
        tooltip: label,
        onPressed: () => _abrirComparador(context),
        icon: Icon(
          Icons.compare_arrows_rounded,
          color: colorScheme.onSurface,
        ),
      );
    }

    final button = OutlinedButton.icon(
      onPressed: () => _abrirComparador(context),
      icon: const Icon(Icons.compare_arrows_rounded, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        backgroundColor: colorScheme.primary.withValues(alpha: 0.08),
        side: BorderSide(
          color: colorScheme.primary.withValues(alpha: 0.45),
          width: 1.5,
        ),
        minimumSize: Size(expanded ? double.infinity : 0, 44),
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: 10,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
        ),
        textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
    );

    if (expanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
