import 'package:flutter/material.dart';
import 'package:catalogo_motos/components/moto_card.dart';
import 'package:catalogo_motos/components/network_image_with_loader.dart';
import 'package:catalogo_motos/constants.dart';
import 'package:catalogo_motos/models/moto_model.dart';

/// Tarjetas superiores lado a lado con foto, nombre, precio y botón central
/// para intercambiar las dos motos seleccionadas.
class MotoCompareHeader extends StatelessWidget {
  const MotoCompareHeader({
    super.key,
    required this.motoA,
    required this.motoB,
    required this.swapTurns,
    required this.onSelectA,
    required this.onSelectB,
    required this.onSwap,
  });

  final Moto? motoA;
  final Moto? motoB;
  final double swapTurns;
  final VoidCallback onSelectA;
  final VoidCallback onSelectB;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final puedeIntercambiar = motoA != null || motoB != null;

    return Stack(
      alignment: Alignment.center,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _MotoSlotCard(
                  moto: motoA,
                  slotLabel: "Moto 1",
                  onTap: onSelectA,
                  onVerFicha:
                      motoA == null ? null : () => abrirMoto(context, motoA!),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _MotoSlotCard(
                  moto: motoB,
                  slotLabel: "Moto 2",
                  onTap: onSelectB,
                  onVerFicha:
                      motoB == null ? null : () => abrirMoto(context, motoB!),
                ),
              ),
            ],
          ),
        ),
        Material(
          color: colorScheme.surface,
          shape: CircleBorder(
            side: BorderSide(
              color: puedeIntercambiar
                  ? colorScheme.primary.withValues(alpha: 0.5)
                  : colorScheme.outline,
              width: 1.5,
            ),
          ),
          elevation: 3,
          shadowColor: colorScheme.onSurface.withValues(alpha: 0.16),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: puedeIntercambiar ? onSwap : null,
            child: Tooltip(
              message: "Intercambiar motos",
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: AnimatedRotation(
                  turns: swapTurns,
                  duration: defaultDuration,
                  curve: Curves.easeOutCubic,
                  child: Icon(
                    Icons.swap_horiz_rounded,
                    size: 22,
                    color: puedeIntercambiar
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MotoSlotCard extends StatelessWidget {
  const _MotoSlotCard({
    required this.moto,
    required this.slotLabel,
    required this.onTap,
    required this.onVerFicha,
  });

  final Moto? moto;
  final String slotLabel;
  final VoidCallback onTap;
  final VoidCallback? onVerFicha;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final seleccionada = moto != null;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: seleccionada
                  ? colorScheme.primary.withValues(alpha: 0.35)
                  : colorScheme.outline,
              width: seleccionada ? 1.5 : 1.2,
            ),
          ),
          child: seleccionada
              ? _MotoSeleccionadaBody(
                  moto: moto!,
                  onVerFicha: onVerFicha!,
                )
              : _MotoVaciaBody(slotLabel: slotLabel),
        ),
      ),
    );
  }
}

class _MotoVaciaBody extends StatelessWidget {
  const _MotoVaciaBody({required this.slotLabel});

  final String slotLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 190,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_rounded,
              color: colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Elegir $slotLabel",
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            "Toca para buscar",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _MotoSeleccionadaBody extends StatelessWidget {
  const _MotoSeleccionadaBody({
    required this.moto,
    required this.onVerFicha,
  });

  final Moto moto;
  final VoidCallback onVerFicha;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final foto = moto.fotos.isNotEmpty ? moto.fotos.first : moto.imagen;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1.35,
          child: Stack(
            fit: StackFit.expand,
            children: [
              NetworkImageWithLoader(foto, radius: 12),
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: colorScheme.outline),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_rounded,
                        size: 11,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Cambiar",
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "${moto.marca.nombre.toUpperCase()} · ${moto.anio}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          moto.modelo,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(height: 1.2),
        ),
        const Spacer(),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  formatoPrecio(moto.precio),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: onVerFicha,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Ficha",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.open_in_new_rounded,
                      size: 12,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
