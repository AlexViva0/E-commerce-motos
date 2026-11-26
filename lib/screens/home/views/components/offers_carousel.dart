import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shop/components/Banner/M/banner_m_style_1.dart';
import 'package:shop/components/dot_indicators.dart';
import 'package:shop/models/moto_model.dart';
import 'package:shop/route/route_constants.dart';

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
      if (!_pageController.hasClients) return;
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
              return BannerMStyle1(
                image: moto.imagen,
                text: "${moto.marca.nombre}\n${moto.modelo}",
                press: () => Navigator.pushNamed(
                  context,
                  productDetailsScreenRoute,
                  arguments: moto.id,
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
