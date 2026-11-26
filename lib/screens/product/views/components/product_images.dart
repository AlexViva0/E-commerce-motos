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
  });

  final List<String> images;
  final Marca? marca;
  final String? heroTag;
  final String? title;

  @override
  State<ProductImages> createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  late PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = _createController();
  }

  PageController _createController() {
    return PageController(
      viewportFraction: widget.images.length > 1 ? 0.88 : 1.0,
      initialPage: _currentPage,
    );
  }

  @override
  void didUpdateWidget(covariant ProductImages oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldMultiple = oldWidget.images.length > 1;
    final newMultiple = widget.images.length > 1;
    if (oldMultiple != newMultiple) {
      if (_currentPage >= widget.images.length) {
        _currentPage = 0;
      }
      _controller.dispose();
      _controller = _createController();
    } else if (_currentPage >= widget.images.length &&
        widget.images.isNotEmpty) {
      _currentPage = 0;
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

    final bool hasMultiple = widget.images.length > 1;
    final imageSurface = Color.alphaBlend(
      colorScheme.onSurface.withValues(alpha: 0.04),
      colorScheme.surface,
    );

    return SliverToBoxAdapter(
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _controller,
              onPageChanged: (pageNum) {
                setState(() => _currentPage = pageNum);
              },
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                Widget image = NetworkImageWithLoader(
                  widget.images[index],
                  fit: BoxFit.cover,
                  radius: 0,
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

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        hasMultiple ? defaultPadding * 0.35 : defaultPadding,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: imageSurface,
                      borderRadius: BorderRadius.circular(
                        defaultBorderRadious * 2,
                      ),
                      border: Border.all(
                        color: colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: GestureDetector(
                      onTap: () => _openViewer(index),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          image,
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.55),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.zoom_in_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "Ampliar",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            if (hasMultiple)
              Positioned(
                bottom: defaultPadding,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding * 0.75,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: colorScheme.outline),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(
                        widget.images.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: EdgeInsets.only(
                            right: index == widget.images.length - 1 ? 0 : 5,
                          ),
                          height: 6,
                          width: index == _currentPage ? 16 : 6,
                          decoration: BoxDecoration(
                            color: index == _currentPage
                                ? colorScheme.primary
                                : colorScheme.onSurface.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${_currentPage + 1}/${widget.images.length}",
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
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
