import 'package:flutter/material.dart';
import 'package:shop/components/moto_card.dart';
import 'package:shop/models/moto_model.dart';
import 'package:shop/state/favoritos.dart';

import '../../../constants.dart';

/// Motos guardadas en favoritos.
class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<int>>(
      valueListenable: Favoritos.instancia,
      builder: (context, ids, _) {
        final guardadas = motos.where((m) => ids.contains(m.id)).toList();
        if (guardadas.isEmpty) return const _SinFavoritos();
        return GridView.builder(
          padding: const EdgeInsets.all(defaultPadding),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: defaultPadding,
            crossAxisSpacing: defaultPadding,
            childAspectRatio: 0.66,
          ),
          itemCount: guardadas.length,
          itemBuilder: (context, i) => MotoCard(moto: guardadas[i]),
        );
      },
    );
  }
}

class _SinFavoritos extends StatelessWidget {
  const _SinFavoritos();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bookmark_border_rounded,
                size: 64, color: primaryColor.withValues(alpha: 0.5)),
            const SizedBox(height: defaultPadding),
            Text("Aún no tienes favoritas",
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: defaultPadding / 2),
            const Text(
              "Toca el marcador en la ficha de una moto para guardarla aquí.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
