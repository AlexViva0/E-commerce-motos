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
    // Póster (1376x768) + franja de información.
    final alto = width / 1.79 + _FranjaInfo.alto;

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
        SizedBox(
          height: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _destacadas.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: index == _selectedIndex ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == _selectedIndex
                      ? primaryColor
                      : Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Tarjeta del carrusel: póster (o foto) arriba y franja con la información
/// abajo, para no tapar el diseño del póster.
class _TarjetaBanner extends StatelessWidget {
  const _TarjetaBanner({
    required this.moto,
    required this.heroTag,
    required this.press,
  });

  final Moto moto;
  final String heroTag;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final poster = bannerPorModelo[moto.modelo];
    return GestureDetector(
      onTap: press,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFF15171C),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Hero(
                tag: heroTag,
                flightShuttleBuilder: (_, __, ___, ____, _____) =>
                    NetworkImageWithLoader(moto.imagen,
                        fit: BoxFit.cover, radius: 0),
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFF5F5F5),
                  child: poster != null
                      ? Image.asset(poster, fit: BoxFit.cover)
                      : NetworkImageWithLoader(moto.imagen,
                          fit: BoxFit.cover, radius: 0),
                ),
              ),
            ),
            _FranjaInfo(moto: moto),
          ],
        ),
      ),
    );
  }
}

class _FranjaInfo extends StatelessWidget {
  const _FranjaInfo({required this.moto});

  static const double alto = 64;
  final Moto moto;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: alto,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF15171C), Color(0xFF23262E)],
        ),
        border: Border(top: BorderSide(color: primaryColor, width: 3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "NUEVO • ${moto.anio}",
                        style: const TextStyle(
                          color: Color(0xFF15171C),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        "${moto.categoria} · ${formatoPrecio(moto.precio)}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "${moto.marca.nombre} ${moto.modelo}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: grandisExtendedFont,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Ver ficha",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded,
                    color: Colors.white, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
