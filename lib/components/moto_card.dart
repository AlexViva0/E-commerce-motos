import 'package:flutter/material.dart';

import '../models/moto_model.dart';
import '../route/route_constants.dart';
import '../screens/product/views/product_details_screen.dart';
import 'product/product_card.dart';
import 'product/secondary_product_card.dart';

int _nextHeroInstanceId = 0;

/// Abre la ficha de una moto conservando el [heroTag] de origen para animar
/// la transición Hero hacia la imagen principal del detalle.
void abrirMoto(BuildContext context, Moto moto, {String? heroTag}) {
  Navigator.push(
    context,
    MaterialPageRoute<void>(
      settings: RouteSettings(
        name: productDetailsScreenRoute,
        arguments: moto.id,
      ),
      builder: (_) => ProductDetailsScreen(
        motoId: moto.id,
        heroTag: heroTag,
      ),
    ),
  );
}

/// Tarjeta vertical de moto, basada en la [ProductCard] del kit original.
class MotoCard extends StatefulWidget {
  const MotoCard({super.key, required this.moto, this.heroTag});

  final Moto moto;

  /// Tag explícito para el Hero. Si se omite, se genera un tag único por
  /// instancia para evitar colisiones cuando una moto aparece en varias listas.
  final String? heroTag;

  @override
  State<MotoCard> createState() => _MotoCardState();
}

class _MotoCardState extends State<MotoCard> {
  late final int _instanceId = _nextHeroInstanceId++;

  String get _effectiveHeroTag =>
      widget.heroTag ?? "moto-foto-${widget.moto.id}-$_instanceId";

  @override
  Widget build(BuildContext context) {
    final tag = _effectiveHeroTag;
    return ProductCard(
      image: widget.moto.imagen,
      brandName: "${widget.moto.marca.nombre} · ${widget.moto.cilindrada} cc",
      title: widget.moto.modelo,
      price: widget.moto.precio,
      heroTag: tag,
      press: () => abrirMoto(context, widget.moto, heroTag: tag),
    );
  }
}

/// Tarjeta horizontal de moto, basada en la [SecondaryProductCard].
class MotoCardHorizontal extends StatefulWidget {
  const MotoCardHorizontal({super.key, required this.moto, this.heroTag});

  final Moto moto;

  /// Tag explícito para el Hero. Si se omite, se genera un tag único por
  /// instancia para evitar colisiones cuando una moto aparece en varias listas.
  final String? heroTag;

  @override
  State<MotoCardHorizontal> createState() => _MotoCardHorizontalState();
}

class _MotoCardHorizontalState extends State<MotoCardHorizontal> {
  late final int _instanceId = _nextHeroInstanceId++;

  String get _effectiveHeroTag =>
      widget.heroTag ?? "moto-foto-${widget.moto.id}-$_instanceId";

  @override
  Widget build(BuildContext context) {
    final tag = _effectiveHeroTag;
    return SecondaryProductCard(
      image: widget.moto.imagen,
      brandName: "${widget.moto.marca.nombre} · ${widget.moto.categoria}",
      title: widget.moto.modelo,
      price: widget.moto.precio,
      heroTag: tag,
      press: () => abrirMoto(context, widget.moto, heroTag: tag),
    );
  }
}
