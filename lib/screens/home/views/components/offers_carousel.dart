import 'dart:async';

import 'package:flutter/material.dart';
import 'package:catalogo_motos/components/Banner/M/banner_m_style_1.dart';
import 'package:catalogo_motos/components/dot_indicators.dart';
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

    return AspectRatio(
      aspectRatio: 1.87,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _destacadas.length,
            onPageChanged: (int index) {
              setState(() => _selectedIndex = index);
            },
            itemBuilder: (context, index) {
              final moto = _destacadas[index];
              final heroTag = "moto-banner-${moto.id}";
              return Hero(
                tag: heroTag,
                flightShuttleBuilder: (
                  flightContext,
                  animation,
                  flightDirection,
                  fromHeroContext,
                  toHeroContext,
                ) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: NetworkImageWithLoader(
                      moto.imagen,
                      fit: BoxFit.cover,
                      radius: 0,
                    ),
                  );
                },
                child: Material(
                  type: MaterialType.transparency,
                  child: BannerMStyle1(
                    image: moto.imagen,
                    text: "${moto.marca.nombre}\n${moto.modelo}",
                    press: () => abrirMoto(context, moto, heroTag: heroTag),
                  ),
                ),
              );
            },
          ),
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: SizedBox(
                height: 16,
                child: Row(
                  children: List.generate(
                    _destacadas.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(left: defaultPadding / 4),
                      child: DotIndicator(
                        isActive: index == _selectedIndex,
                        activeColor: Colors.white70,
                        inActiveColor: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
