import 'package:flutter/material.dart';
import 'package:catalogo_motos/route/route_constants.dart';
import 'package:catalogo_motos/components/moto_card.dart';
import 'package:catalogo_motos/constants.dart';
import 'package:catalogo_motos/models/moto_model.dart';
import 'package:catalogo_motos/state/favoritos.dart';

import 'components/product_images.dart';
import 'components/product_info.dart';

/// Ficha de una moto. Recibe el id de la moto como argumento de la ruta.
class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    super.key,
    required this.motoId,
    this.heroTag,
  });

  final int motoId;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final moto = motoPorId(motoId);
    final effectiveHeroTag = heroTag ?? "moto-foto-${moto.id}";
    final similares = motos
        .where((m) => m.categoria == moto.categoria && m.id != moto.id)
        .toList();

    return Scaffold(
      bottomNavigationBar: _BarraPrecio(moto: moto),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, defaultPadding, 0),
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.maybePop(context),
                      icon: Icon(Icons.arrow_back_rounded,
                          color: Theme.of(context).colorScheme.onSurface),
                      label: Text(
                        "Catálogo",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ProductInfo(moto: moto),
            ProductImages(
              images: moto.fotos,
              marca: moto.marca,
              heroTag: effectiveHeroTag,
              title: moto.nombreCompleto,
              acciones: [
                BotonVidrio(
                  icono: Icons.compare_arrows_rounded,
                  tooltip: "Comparar",
                  onTap: () => Navigator.pushNamed(context, compareScreenRoute,
                      arguments: moto.id),
                ),
                _BotonFavorito(moto: moto),
              ],
            ),
            FichaTecnica(moto: moto),
            if (similares.isNotEmpty) ...[
              SliverPadding(
                padding: const EdgeInsets.all(defaultPadding),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "Más motos ${moto.categoria}",
                    style: Theme.of(context).textTheme.titleSmall!,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: similares.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(
                          left: defaultPadding,
                          right: index == similares.length - 1
                              ? defaultPadding
                              : 0),
                      child: MotoCard(
                        moto: similares[index],
                        heroTag: "similares-${moto.id}-${similares[index].id}",
                      ),
                    ),
                  ),
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: defaultPadding)),
          ],
        ),
      ),
    );
  }
}

class _BotonFavorito extends StatelessWidget {
  const _BotonFavorito({required this.moto});

  final Moto moto;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<int>>(
      valueListenable: Favoritos.instancia,
      builder: (context, favoritos, _) {
        final esFavorita = favoritos.contains(moto.id);
        return BotonVidrio(
          icono: esFavorita
              ? Icons.bookmark_rounded
              : Icons.bookmark_border_rounded,
          activo: esFavorita,
          tooltip: esFavorita ? "Quitar de favoritos" : "Guardar en favoritos",
          onTap: () => Favoritos.instancia.alternar(moto.id),
        );
      },
    );
  }
}

/// Barra inferior fija (estilo Astra): precio protagonista y "Comparar".
class _BarraPrecio extends StatelessWidget {
  const _BarraPrecio({required this.moto});

  final Moto moto;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF15171C),
      child: SafeArea(
        top: false,
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(defaultPadding, 14, defaultPadding, 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Precio de referencia",
                      style: TextStyle(fontSize: 12, color: Colors.white60),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            formatoPrecio(moto.precio),
                            style: const TextStyle(
                              fontFamily: grandisExtendedFont,
                              fontWeight: FontWeight.w800,
                              fontSize: 28,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            "MXN",
                            style: TextStyle(
                              fontFamily: monoFont,
                              fontSize: 11,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 56),
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => Navigator.pushNamed(
                      context, compareScreenRoute,
                      arguments: moto.id),
                  icon: const Icon(Icons.compare_arrows_rounded, size: 22),
                  label: const Text(
                    "Comparar",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
