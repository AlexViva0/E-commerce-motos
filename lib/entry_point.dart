import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:catalogo_motos/constants.dart';
import 'package:catalogo_motos/route/screen_export.dart';
import 'package:catalogo_motos/state/favoritos.dart';
import 'package:catalogo_motos/state/tema.dart';

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
        titleSpacing: defaultPadding,
        toolbarHeight: 64,
        title: const _LogoCilindra(),
        actions: [
          _BotonCircular(
            tooltip: "Cambiar tema",
            relleno: false,
            child: const _IconoTema(),
            onTap: () => Tema.instancia
                .alternar(MediaQuery.platformBrightnessOf(context)),
          ),
          const SizedBox(width: 10),
          _BotonCircular(
            tooltip: "Buscar",
            relleno: true,
            onTap: () => Navigator.pushNamed(context, searchScreenRoute),
            child: Icon(Icons.search_rounded,
                size: 22, color: colorScheme.surface),
          ),
          const SizedBox(width: defaultPadding),
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
              icon: _ConBurbuja(child: svgIcon("assets/icons/Bookmark.svg")),
              activeIcon: _ConBurbuja(
                child: svgIcon("assets/icons/Bookmark.svg",
                    color: colorScheme.primary),
              ),
              label: "Favoritos",
            ),
          ],
        ),
      ),
    );
  }
}

/// Pone sobre el ícono una burbuja con el número de motos en favoritos.
/// No se muestra cuando no hay ninguna guardada.
class _ConBurbuja extends StatelessWidget {
  const _ConBurbuja({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<Set<int>>(
      valueListenable: Favoritos.instancia,
      builder: (context, favoritos, _) {
        final total = favoritos.length;
        return Badge(
          isLabelVisible: total > 0,
          backgroundColor: colorScheme.primary,
          textColor: colorScheme.onPrimary,
          offset: const Offset(8, -6),
          label: AnimatedSwitcher(
            duration: defaultDuration,
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Text(
              total > 99 ? "99+" : "$total",
              key: ValueKey(total),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          child: child,
        );
      },
    );
  }
}

/// Logotipo de texto: tres diagonales rojas y "Cilindra".
class _LogoCilindra extends StatelessWidget {
  const _LogoCilindra();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Theme.of(context).brightness == Brightness.dark
          ? 'assets/branding/logo_texto_blanco.png'
          : 'assets/branding/logo_texto.png',
      height: 30,
      fit: BoxFit.contain,
      semanticLabel: 'Cilindra',
    );
  }
}

/// Botón redondo de la barra superior: contorno (relleno = false) o sólido.
class _BotonCircular extends StatelessWidget {
  const _BotonCircular({
    required this.tooltip,
    required this.relleno,
    required this.child,
    required this.onTap,
  });

  final String tooltip;
  final bool relleno;
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: relleno ? cs.onSurface : Colors.transparent,
        shape: CircleBorder(
          side: relleno
              ? BorderSide.none
              : BorderSide(color: cs.outlineVariant, width: 1.2),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(width: 44, height: 44, child: Center(child: child)),
        ),
      ),
    );
  }
}

/// Ícono sol/luna animado según el tema actual.
class _IconoTema extends StatelessWidget {
  const _IconoTema();

  @override
  Widget build(BuildContext context) {
    final brillo = MediaQuery.platformBrightnessOf(context);
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: Tema.instancia,
      builder: (context, _, __) {
        final oscuro = Tema.instancia.estaOscuro(brillo);
        return AnimatedSwitcher(
          duration: defaultDuration,
          transitionBuilder: (child, a) => RotationTransition(
            turns: Tween<double>(begin: 0.6, end: 1).animate(a),
            child: ScaleTransition(scale: a, child: child),
          ),
          child: Icon(
            oscuro ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            key: ValueKey(oscuro),
            size: 22,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        );
      },
    );
  }
}
