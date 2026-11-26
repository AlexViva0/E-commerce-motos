import 'dart:async';

import 'package:flutter/material.dart';
import 'package:catalogo_motos/components/moto_card.dart';
import 'package:catalogo_motos/components/network_image_with_loader.dart';
import 'package:catalogo_motos/models/moto_model.dart';

import '../../../../constants.dart';

/// Carrusel con las motos destacadas del catálogo.
class OffersCarousel extends StatefulWidget {
  const OffersCarousel({super.key});

  @override
  State<OffersCarousel> createState() => _OffersCarouselState();
}

class _OffersCarouselState extends State<OffersCarousel> {
  int _selectedIndex = 0;
  late PageController _pageController;
  late Timer _timer;
  final List<Moto> _destacadas = motosDestacadas;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (!_pageController.hasClients || _destacadas.length <= 1) return;
      _selectedIndex =
          _selectedIndex < _destacadas.length - 1 ? _selectedIndex + 1 : 0;
      _pageController.animateToPage(
        _selectedIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_destacadas.isEmpty) return const SizedBox.shrink();
    final width = MediaQuery.sizeOf(context).width - defaultPadding * 2;
    // Barra superior + póster (1376x768) + pie con precio.
    final alto =
        _TarjetaBanner.altoCabecera + width / 1.79 + _TarjetaBanner.altoPie;

    return SizedBox(
      height: alto,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _destacadas.length,
        onPageChanged: (int index) {
          setState(() => _selectedIndex = index);
        },
        itemBuilder: (context, index) {
          final moto = _destacadas[index];
          final heroTag = "moto-banner-${moto.id}";
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: _TarjetaBanner(
              moto: moto,
              heroTag: heroTag,
              posicion: index + 1,
              total: _destacadas.length,
              press: () => abrirMoto(context, moto, heroTag: heroTag),
            ),
          );
        },
      ),
    );
  }
}

/// Tarjeta del carrusel (estilo Astra): etiqueta y contador arriba, póster al
/// centro y pie oscuro con el precio y "Ver ficha".
class _TarjetaBanner extends StatelessWidget {
  const _TarjetaBanner({
    required this.moto,
    required this.heroTag,
    required this.posicion,
    required this.total,
    required this.press,
  });

  static const double altoCabecera = 44;
  static const double altoPie = 64;

  final Moto moto;
  final String heroTag;
  final int posicion, total;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final poster = bannerPorModelo[moto.modelo];
    const grafito = Color(0xFF15171C);
    return GestureDetector(
      onTap: press,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            SizedBox(
              height: altoCabecera,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${moto.marca.nombre.toUpperCase()}   /   ${moto.categoria.toUpperCase()}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: monoFont,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          letterSpacing: 1,
                          color: Color(0xFF4A4E58),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: grafito,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "$posicion / $total",
                        style: const TextStyle(
                          fontFamily: monoFont,
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Hero(
                tag: heroTag,
                flightShuttleBuilder: (_, __, ___, ____, _____) =>
                    NetworkImageWithLoader(moto.imagen,
                        fit: BoxFit.cover, radius: 0),
                child: SizedBox(
                  width: double.infinity,
                  child: poster != null
                      ? Image.asset(poster, fit: BoxFit.cover)
                      : NetworkImageWithLoader(moto.imagen,
                          fit: BoxFit.cover, radius: 0),
                ),
              ),
            ),
            Container(
              height: altoPie,
              color: grafito,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    formatoPrecio(moto.precio),
                    style: const TextStyle(
                      fontFamily: grandisExtendedFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      "MXN",
                      style: TextStyle(
                        fontFamily: monoFont,
                        fontSize: 10,
                        color: Colors.white60,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Ver ficha",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded,
                      color: accentColor, size: 22),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
