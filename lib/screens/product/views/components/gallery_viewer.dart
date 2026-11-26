import 'package:flutter/material.dart';
import 'package:shop/components/network_image_with_loader.dart';

import '../../../../constants.dart';

/// Visor de galería a pantalla completa sobre fondo negro con deslizamiento
/// entre fotos, zoom con pellizco (pinch zoom) y doble toque para acercar o alejar.
class GalleryViewer extends StatefulWidget {
  const GalleryViewer({
    super.key,
    required this.images,
    this.initialIndex = 0,
    this.title,
  });

  final List<String> images;
  final int initialIndex;
  final String? title;

  @override
  State<GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<GalleryViewer> {
  late final PageController _pageController;
  late int _currentIndex;
  bool _isZoomed = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.images.isEmpty
        ? 0
        : widget.images.length == 1
            ? 0
            : widget.initialIndex.clamp(0, widget.images.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _close() {
    Navigator.of(context).pop(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.images.length;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _close();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: total,
              physics: _isZoomed
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  _isZoomed = false;
                });
              },
              itemBuilder: (context, index) {
                return _ZoomablePhotoPage(
                  imageUrl: widget.images[index],
                  onTap: () => setState(() => _showControls = !_showControls),
                  onZoomChanged: (zoomed) {
                    if (index == _currentIndex && zoomed != _isZoomed) {
                      setState(() => _isZoomed = zoomed);
                    }
                  },
                );
              },
            ),
            // Barra superior: contador "2/4", título opcional y botón cerrar.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                ignoring: !_showControls,
                child: AnimatedOpacity(
                  opacity: _showControls ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 180),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.78),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          defaultPadding,
                          defaultPadding * 0.75,
                          defaultPadding,
                          defaultPadding * 1.25,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.18),
                                ),
                              ),
                              child: Text(
                                "${_currentIndex + 1}/$total",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (widget.title != null &&
                                widget.title!.isNotEmpty) ...[
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.title!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ] else
                              const Spacer(),
                            const SizedBox(width: 12),
                            Semantics(
                              button: true,
                              label: "Cerrar visor",
                              child: Material(
                                color: Colors.white.withValues(alpha: 0.14),
                                shape: CircleBorder(
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.18),
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: IconButton(
                                  tooltip: "Cerrar",
                                  onPressed: _close,
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Indicadores inferiores y guía breve de gestos.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                ignoring: !_showControls,
                child: AnimatedOpacity(
                  opacity: _showControls ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 180),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.72),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          defaultPadding,
                          defaultPadding,
                          defaultPadding,
                          defaultPadding,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (total > 1) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  total,
                                  (index) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    height: 6,
                                    width: index == _currentIndex ? 18 : 6,
                                    decoration: BoxDecoration(
                                      color: index == _currentIndex
                                          ? primaryColor
                                          : Colors.white
                                              .withValues(alpha: 0.35),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            Text(
                              _isZoomed
                                  ? "Arrastra para mover · Doble toque para alejar"
                                  : "Pellizca o toca dos veces para hacer zoom",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.72),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoomablePhotoPage extends StatefulWidget {
  const _ZoomablePhotoPage({
    required this.imageUrl,
    required this.onZoomChanged,
    required this.onTap,
  });

  final String imageUrl;
  final ValueChanged<bool> onZoomChanged;
  final VoidCallback onTap;

  @override
  State<_ZoomablePhotoPage> createState() => _ZoomablePhotoPageState();
}

class _ZoomablePhotoPageState extends State<_ZoomablePhotoPage>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  late final AnimationController _animationController;
  Animation<Matrix4>? _matrixAnimation;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_notifyZoomState);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..addListener(() {
        if (_matrixAnimation != null) {
          _transformationController.value = _matrixAnimation!.value;
        }
      });
  }

  @override
  void dispose() {
    _transformationController.removeListener(_notifyZoomState);
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _notifyZoomState() {
    final zoomed = _transformationController.value.getMaxScaleOnAxis() > 1.05;
    widget.onZoomChanged(zoomed);
  }

  void _handleDoubleTap(Size viewportSize) {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    final Matrix4 targetMatrix;

    if (currentScale > 1.05) {
      targetMatrix = Matrix4.identity();
    } else {
      const double targetScale = 2.5;
      final Offset tapPos = _doubleTapDetails?.localPosition ??
          Offset(viewportSize.width / 2, viewportSize.height / 2);
      final double dx = (-tapPos.dx * (targetScale - 1))
          .clamp(-(targetScale - 1) * viewportSize.width, 0.0);
      final double dy = (-tapPos.dy * (targetScale - 1))
          .clamp(-(targetScale - 1) * viewportSize.height, 0.0);
      targetMatrix = Matrix4.diagonal3Values(targetScale, targetScale, 1.0)
        ..setTranslationRaw(dx, dy, 0.0);
    }

    _matrixAnimation = Matrix4Tween(
      begin: _transformationController.value,
      end: targetMatrix,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportSize = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          onDoubleTapDown: (details) => _doubleTapDetails = details,
          onDoubleTap: () => _handleDoubleTap(viewportSize),
          child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: 1.0,
            maxScale: 4.0,
            clipBehavior: Clip.none,
            child: SizedBox(
              width: viewportSize.width,
              height: viewportSize.height,
              child: NetworkImageWithLoader(
                widget.imageUrl,
                fit: BoxFit.contain,
                radius: 0,
              ),
            ),
          ),
        );
      },
    );
  }
}
