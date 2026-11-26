import 'package:catalogo_motos/components/compare_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:catalogo_motos/components/cart_button.dart';
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
      bottomNavigationBar: CartButton(
        price: moto.precio,
        press: () => _mostrarInteres(context, moto),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
              actions: [
                CompareButton.icon(motoId: moto.id),
                _BotonFavorito(moto: moto),
              ],
            ),
            ProductImages(
              images: moto.fotos,
              marca: moto.marca,
              heroTag: effectiveHeroTag,
              title: moto.nombreCompleto,
            ),
            ProductInfo(moto: moto),
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

  void _mostrarInteres(BuildContext context, Moto moto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
              "¡Listo! Te contactaríamos sobre la ${moto.nombreCompleto}. (Demo)"),
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
        return IconButton(
          tooltip: esFavorita ? "Quitar de favoritos" : "Guardar en favoritos",
          onPressed: () => Favoritos.instancia.alternar(moto.id),
          icon: SvgPicture.asset(
            "assets/icons/Bookmark.svg",
            colorFilter: ColorFilter.mode(
              esFavorita
                  ? primaryColor
                  : Theme.of(context).textTheme.bodyLarge!.color!,
              BlendMode.srcIn,
            ),
          ),
        );
      },
    );
  }
}
