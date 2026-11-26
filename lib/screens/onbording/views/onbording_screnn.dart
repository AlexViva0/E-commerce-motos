import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:catalogo_motos/constants.dart';
import 'package:catalogo_motos/route/route_constants.dart';

import 'components/onboarding_background.dart';
import 'components/onbording_content.dart';

class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;

  final List<Onbord> _onbordData = [
    Onbord(
      image: "assets/Illustration/motos/onb_deportiva.webp",
      tag: "EXPOSICIÓN MÓVIL",
      title: "Descubre las mejores motos",
      description:
          "Explora un catálogo deportivo con los modelos más destacados, fotografías nítidas y detalles de ingeniería.",
      highlights: const ["+25 Modelos", "Catálogo 2026", "Alta gama"],
    ),
    Onbord(
      image: "assets/Illustration/motos/onb_casco.webp",
      tag: "DATOS PRECISOS",
      title: "Compara fichas técnicas",
      description:
          "Consulta cilindrada, potencia máxima, par motor y peso en seco de un vistazo para elegir la mejor máquina.",
      highlights: const ["998 cc", "210 CV", "198 kg"],
    ),
    Onbord(
      image: "assets/Illustration/motos/onb_aventura.webp",
      tag: "CUATRO CATEGORÍAS",
      title: "Encuentra tu estilo: deportiva, naked, touring, scooter",
      description:
          "Filtra por categoría según tu forma de rodar: circuito, ciudad, montaña o rutas de larga distancia.",
      highlights: const ["Deportiva", "Naked", "Touring", "Scooter"],
    ),
    Onbord(
      image: "assets/Illustration/motos/ficha_tecnica.svg",
      tag: "TU GARAJE",
      title: "Guarda tus favoritas",
      description:
          "Marca tus motocicletas preferidas y ten siempre a mano tus comparativas y especificaciones clave.",
      highlights: const ["Lista personal", "Acceso rápido", "Sin límites"],
    ),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding() {
    Navigator.pushNamedAndRemoveUntil(
        context, entryPointScreenRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _pageIndex == _onbordData.length - 1;
    final Color primaryDark =
        Color.lerp(primaryColor, blackColor, 0.22) ?? primaryColor;

    return Scaffold(
      body: OnboardingBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Column(
              children: [
                const SizedBox(height: defaultPadding * 0.5),
                // Cabecera deportiva con marca del catálogo y botón Omitir
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: blackColor,
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadious),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withOpacity(0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.two_wheeler_rounded,
                            color: primaryColor,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "CILINDRA",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.9,
                              color: whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "0${_pageIndex + 1}/0${_onbordData.length}",
                      style: const TextStyle(
                        fontFamily: grandisExtendedFont,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _finishOnboarding,
                      style: TextButton.styleFrom(
                        foregroundColor: blackColor80,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(defaultBorderRadious),
                        ),
                      ),
                      child: const Text(
                        "Omitir",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: defaultPadding * 0.75),

                // Carrusel principal
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _onbordData.length,
                    onPageChanged: (value) {
                      setState(() {
                        _pageIndex = value;
                      });
                    },
                    itemBuilder: (context, index) {
                      final item = _onbordData[index];
                      return OnbordingContent(
                        title: item.title,
                        description: item.description,
                        image:
                            (Theme.of(context).brightness == Brightness.dark &&
                                    item.imageDarkTheme != null)
                                ? item.imageDarkTheme!
                                : item.image,
                        tag: item.tag,
                        highlights: item.highlights,
                      );
                    },
                  ),
                ),

                // Indicadores de página en rojo primario
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding * 0.75,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onbordData.length,
                      (index) {
                        final bool isActive = index == _pageIndex;
                        return GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(
                              index,
                              duration: defaultDuration,
                              curve: Curves.easeOutCubic,
                            );
                          },
                          child: AnimatedContainer(
                            duration: defaultDuration,
                            curve: Curves.easeOutCubic,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 7,
                            width: isActive ? 30 : 8,
                            decoration: BoxDecoration(
                              color: isActive ? primaryColor : blackColor20,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Controles inferiores con botón grande
                Row(
                  children: [
                    if (_pageIndex > 0) ...[
                      SizedBox(
                        height: 56,
                        width: 56,
                        child: OutlinedButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: defaultDuration,
                              curve: Curves.easeOutCubic,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: whiteColor,
                            side: const BorderSide(
                              color: blackColor20,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(defaultBorderRadious),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: blackColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [primaryColor, primaryDark],
                          ),
                          borderRadius:
                              BorderRadius.circular(defaultBorderRadious),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.32),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (!isLastPage) {
                              _pageController.nextPage(
                                curve: Curves.easeOutCubic,
                                duration: defaultDuration,
                              );
                            } else {
                              _finishOnboarding();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(defaultBorderRadious),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isLastPage ? "Explorar catálogo" : "Siguiente",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                  color: whiteColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              SvgPicture.asset(
                                "assets/icons/Arrow - Right.svg",
                                width: 20,
                                height: 20,
                                colorFilter: const ColorFilter.mode(
                                  whiteColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: defaultPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Onbord {
  final String image, title, description;
  final String? imageDarkTheme, tag;
  final List<String> highlights;

  Onbord({
    required this.image,
    required this.title,
    this.description = "",
    this.imageDarkTheme,
    this.tag,
    this.highlights = const [],
  });
}
