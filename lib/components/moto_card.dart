import 'package:flutter/material.dart';

import '../models/moto_model.dart';
import '../route/route_constants.dart';
import 'product/product_card.dart';
import 'product/secondary_product_card.dart';

/// Abre la ficha de una moto.
void abrirMoto(BuildContext context, Moto moto) {
  Navigator.pushNamed(context, productDetailsScreenRoute, arguments: moto.id);
}

/// Tarjeta vertical de moto, basada en la [ProductCard] del kit original.
class MotoCard extends StatelessWidget {
  const MotoCard({super.key, required this.moto});

  final Moto moto;

  @override
  Widget build(BuildContext context) {
    return ProductCard(
      image: moto.imagen,
      brandName: "${moto.marca.nombre} · ${moto.cilindrada} cc",
      title: moto.modelo,
      price: moto.precio,
      press: () => abrirMoto(context, moto),
    );
  }
}

/// Tarjeta horizontal de moto, basada en la [SecondaryProductCard].
class MotoCardHorizontal extends StatelessWidget {
  const MotoCardHorizontal({super.key, required this.moto});

  final Moto moto;

  @override
  Widget build(BuildContext context) {
    return SecondaryProductCard(
      image: moto.imagen,
      brandName: "${moto.marca.nombre} · ${moto.categoria}",
      title: moto.modelo,
      price: moto.precio,
      press: () => abrirMoto(context, moto),
    );
  }
}
