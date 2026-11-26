import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/screen_export.dart';
import 'package:shop/state/tema.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  final List<Widget> _pages = const [
    HomeScreen(),
    DiscoverScreen(),
    BookmarkScreen(),
    AboutScreen(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fondoBarra =
        theme.bottomNavigationBarTheme.backgroundColor ?? colorScheme.surface;
    final colorInactivo = theme.bottomNavigationBarTheme.unselectedItemColor ??
        colorScheme.onSurfaceVariant;

    SvgPicture svgIcon(String src, {Color? color}) {
      return SvgPicture.asset(
        src,
        height: 24,
        colorFilter: ColorFilter.mode(
          color ?? colorInactivo,
          BlendMode.srcIn,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
        leading: const SizedBox(),
        leadingWidth: 0,
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: theme.dividerColor.withValues(alpha: 0.6),
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.two_wheeler_rounded,
                size: 18,
                color: colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: defaultPadding / 2),
            Flexible(
              child: Text(
                "MOTO CATÁLOGO",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: grandisExtendedFont,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        actions: [
          const _InterruptorTema(),
          const SizedBox(width: 4),
          IconButton(
            tooltip: "Buscar",
            onPressed: () => Navigator.pushNamed(context, searchScreenRoute),
            icon: SvgPicture.asset(
              "assets/icons/Search.svg",
              height: 22,
              colorFilter: ColorFilter.mode(
                colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: PageTransitionSwitcher(
        duration: defaultDuration,
        transitionBuilder: (child, animation, secondAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondAnimation,
            child: child,
          );
        },
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: fondoBarra,
          border: Border(
            top: BorderSide(color: theme.dividerColor, width: 1),
          ),
        ),
        padding: const EdgeInsets.only(top: defaultPadding / 4),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index != _currentIndex) {
              setState(() => _currentIndex = index);
            }
          },
          backgroundColor: fondoBarra,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorInactivo,
          items: [
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Shop.svg"),
              activeIcon:
                  svgIcon("assets/icons/Shop.svg", color: colorScheme.primary),
              label: "Inicio",
            ),
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Category.svg"),
              activeIcon: svgIcon("assets/icons/Category.svg",
                  color: colorScheme.primary),
              label: "Explorar",
            ),
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Bookmark.svg"),
              activeIcon: svgIcon("assets/icons/Bookmark.svg",
                  color: colorScheme.primary),
              label: "Favoritos",
            ),
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/info.svg"),
              activeIcon:
                  svgIcon("assets/icons/info.svg", color: colorScheme.primary),
              label: "Créditos",
            ),
          ],
        ),
      ),
    );
  }
}

/// Interruptor animado sol/luna para alternar entre tema claro y oscuro.
class _InterruptorTema extends StatelessWidget {
  const _InterruptorTema();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final brilloPlataforma = MediaQuery.platformBrightnessOf(context);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: Tema.instancia,
      builder: (context, _, __) {
        final esOscuro = Tema.instancia.estaOscuro(brilloPlataforma);

        return Semantics(
          button: true,
          toggled: esOscuro,
          label: esOscuro ? "Cambiar a modo claro" : "Cambiar a modo oscuro",
          child: Tooltip(
            message:
                esOscuro ? "Cambiar a modo claro" : "Cambiar a modo oscuro",
            child: InkWell(
              onTap: () => Tema.instancia.alternar(brilloPlataforma),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: defaultDuration,
                curve: Curves.easeOutCubic,
                width: 58,
                height: 32,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: esOscuro
                      ? colorScheme.surfaceContainerHigh
                      : colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: esOscuro
                        ? colorScheme.secondary.withValues(alpha: 0.45)
                        : colorScheme.outline,
                    width: 1.2,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.light_mode_rounded,
                            size: 13,
                            color: colorScheme.onSurfaceVariant
                                .withValues(alpha: esOscuro ? 0.45 : 0.2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.dark_mode_rounded,
                            size: 13,
                            color: colorScheme.onSurfaceVariant
                                .withValues(alpha: esOscuro ? 0.2 : 0.45),
                          ),
                        ),
                      ],
                    ),
                    AnimatedAlign(
                      duration: defaultDuration,
                      curve: Curves.easeOutCubic,
                      alignment: esOscuro
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: defaultDuration,
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: esOscuro
                              ? colorScheme.surface
                              : colorScheme.primary,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withValues(alpha: esOscuro ? 0.35 : 0.16),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: AnimatedSwitcher(
                          duration: defaultDuration,
                          switchInCurve: Curves.easeOutBack,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder: (child, animation) {
                            return RotationTransition(
                              turns: Tween<double>(begin: 0.65, end: 1.0)
                                  .animate(animation),
                              child: ScaleTransition(
                                scale: animation,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              ),
                            );
                          },
                          child: esOscuro
                              ? Icon(
                                  Icons.dark_mode_rounded,
                                  key: const ValueKey('luna'),
                                  size: 14,
                                  color: colorScheme.secondary,
                                )
                              : Icon(
                                  Icons.light_mode_rounded,
                                  key: const ValueKey('sol'),
                                  size: 14,
                                  color: colorScheme.onPrimary,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
