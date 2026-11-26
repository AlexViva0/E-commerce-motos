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
  final List<Moto> _destacadas = [
    for (final moto in motosDestacadas)
      if (moto.modelo == "MT-07")
        motos.firstWhere((m) => m.modelo == "NAVi")
      else
        moto,
  ];

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
    final alto = width / 1.79 + _TarjetaBanner.altoPie;

    return Column(
      children: [
        SizedBox(
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
                  press: () => abrirMoto(context, moto, heroTag: heroTag),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: defaultPadding * 0.75),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < _destacadas.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: i == _selectedIndex ? 22 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: i == _selectedIndex
                      ? primaryColor
                      : Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Póster con el precio y la categoría en el pie de la tarjeta.
class _TarjetaBanner extends StatelessWidget {
  const _TarjetaBanner({
    required this.moto,
    required this.heroTag,
    required this.press,
  });

  static const double altoPie = 64;

  final Moto moto;
  final String heroTag;
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
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0x1FFFFFFF),
                              border: Border.all(color: const Color(0x33FFFFFF)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              moto.modelo == "NAVi"
                                  ? "SUPER DEPORTIVA"
                                  : moto.categoria.toUpperCase(),
                              style: const TextStyle(
                                fontFamily: monoFont,
                                fontSize: 11,
                                color: Color(0xD9FFFFFF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
