import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:catalogo_motos/components/network_image_with_loader.dart';
import 'package:catalogo_motos/models/moto_model.dart';

import '../../../../constants.dart';
import 'gallery_viewer.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    super.key,
    required this.images,
    this.marca,
    this.heroTag,
    this.title,
    this.acciones = const [],
  });

  /// Botones flotantes (estilo vidrio) en la esquina superior derecha.
  final List<Widget> acciones;
  final List<String> images;
  final Marca? marca;
  final String? heroTag;
  final String? title;

  @override
  State<ProductImages> createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: 1.0,
      initialPage: _currentPage,
    );
  }

  @override
  void didUpdateWidget(covariant ProductImages oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.images.isEmpty) {
      _currentPage = 0;
    } else if (_currentPage >= widget.images.length) {
      _currentPage = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controller.hasClients) {
          _controller.jumpToPage(0);
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openViewer(int index) async {
    final int? resultIndex = await Navigator.of(context).push<int>(
      PageRouteBuilder<int>(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 240),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) => GalleryViewer(
          images: widget.images,
          initialIndex: index,
          title: widget.title,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
            child: child,
          );
        },
      ),
    );

    if (!mounted) return;
    if (resultIndex != null &&
        resultIndex >= 0 &&
        resultIndex < widget.images.length &&
        resultIndex != _currentPage) {
      setState(() => _currentPage = resultIndex);
      if (_controller.hasClients) {
        _controller.jumpToPage(resultIndex);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.images.isEmpty) {
      Widget placeholder = _EmptyPhotoPlaceholder(marca: widget.marca);
      if (widget.heroTag != null && widget.heroTag!.isNotEmpty) {
        placeholder = Hero(
          tag: widget.heroTag!,
          child: Material(
            type: MaterialType.transparency,
            child: placeholder,
          ),
        );
      }
      return SliverToBoxAdapter(
        child: AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: placeholder,
          ),
        ),
      );
    }

    final imageSurface = Color.alphaBlend(
      colorScheme.onSurface.withValues(alpha: 0.04),
      colorScheme.surface,
    );

    const double radio = 22;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radio),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(color: imageSurface),
                PageView.builder(
                  controller: _controller,
                  onPageChanged: (pageNum) {
                    setState(() => _currentPage = pageNum);
                  },
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    Widget image = SizedBox.expand(
                      child: NetworkImageWithLoader(
                        widget.images[index],
                        fit: BoxFit.cover,
                        radius: 0,
                      ),
                    );
                    if (index == 0 &&
                        widget.heroTag != null &&
                        widget.heroTag!.isNotEmpty) {
                      image = Hero(
                        tag: widget.heroTag!,
                        child: Material(
                          type: MaterialType.transparency,
                          child: image,
                        ),
                      );
                    }
                    return GestureDetector(
                      onTap: () => _openViewer(index),
                      child: image,
                    );
                  },
                ),
                if (widget.acciones.isNotEmpty)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Row(
                      children: [
                        for (final (i, a) in widget.acciones.indexed) ...[
                          if (i > 0) const SizedBox(width: 10),
                          a,
                        ],
                      ],
                    ),
                  ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: _Vidrio(
                    forma: BoxShape.rectangle,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Text(
                        "${_currentPage + 1} / ${widget.images.length}",
                        style: const TextStyle(
                          fontFamily: monoFont,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: BotonVidrio(
                    icono: Icons.open_in_full_rounded,
                    tooltip: "Ampliar foto",
                    onTap: () => _openViewer(_currentPage),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Botón redondo translúcido (estilo vidrio) para poner sobre fotos.
class BotonVidrio extends StatelessWidget {
  const BotonVidrio({
    super.key,
    required this.icono,
    required this.onTap,
    this.tooltip,
    this.activo = false,
  });

  final IconData icono;
  final VoidCallback onTap;
  final String? tooltip;
  final bool activo;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? "",
      child: GestureDetector(
        onTap: onTap,
        child: _Vidrio(
          child: SizedBox(
            width: 46,
            height: 46,
            child: Icon(icono,
                size: 22, color: activo ? primaryColor : Colors.white),
          ),
        ),
      ),
    );
  }
}

class _Vidrio extends StatelessWidget {
  const _Vidrio({required this.child, this.forma = BoxShape.circle});

  final Widget child;
  final BoxShape forma;

  @override
  Widget build(BuildContext context) {
    final radio = forma == BoxShape.circle ? 999.0 : 20.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radio),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF15171C).withValues(alpha: 0.42),
            borderRadius: BorderRadius.circular(radio),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.22), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _EmptyPhotoPlaceholder extends StatelessWidget {
  const _EmptyPhotoPlaceholder({this.marca});

  final Marca? marca;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final topColor = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.08),
      colorScheme.surface,
    );
    final bottomColor = Color.alphaBlend(
      colorScheme.onSurface.withValues(alpha: 0.04),
      colorScheme.surface,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [topColor, bottomColor],
        ),
        borderRadius: BorderRadius.circular(defaultBorderRadious * 2),
        border: Border.all(color: colorScheme.outline, width: 1),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding * 1.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (marca != null) ...[
                Container(
                  width: 148,
                  height: 92,
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(defaultBorderRadious),
                    border: Border.all(color: colorScheme.outline),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    marca!.logo,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: defaultPadding),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.two_wheeler_rounded,
                    size: 48,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: defaultPadding),
              ],
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.image_not_supported_outlined,
                    size: 18,
                    color: theme.textTheme.bodyMedium?.color ??
                        colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Foto no disponible",
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              if (marca != null) ...[
                const SizedBox(height: 4),
                Text(
                  "${marca!.nombre} · Imagen próximamente",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
