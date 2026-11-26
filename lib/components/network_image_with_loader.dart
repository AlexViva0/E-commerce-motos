import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'skleton/skelton.dart';

/// Muestra una imagen de red, de assets (si empieza con "assets/") o un
/// marcador con icono de moto cuando no hay foto.
class NetworkImageWithLoader extends StatelessWidget {
  final BoxFit fit;

  const NetworkImageWithLoader(
    this.src, {
    super.key,
    this.fit = BoxFit.cover,
    this.radius = defaultPadding,
  });

  final String src;
  final double radius;

  // Wikimedia rechaza peticiones sin un User-Agent descriptivo.
  static const _headers = {
    "User-Agent": "CatalogoMotosDemo/1.0 (proyecto academico)",
  };

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (src.isEmpty) {
      child = const MotoImagePlaceholder();
    } else if (src.startsWith("assets/")) {
      child = Image.asset(src, fit: fit);
    } else {
      child = CachedNetworkImage(
        fit: fit,
        imageUrl: src,
        httpHeaders: _headers,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: fit),
          ),
        ),
        placeholder: (context, url) => const Skeleton(),
        errorWidget: (context, url, error) => const MotoImagePlaceholder(),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: child,
    );
  }
}

class MotoImagePlaceholder extends StatelessWidget {
  const MotoImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withValues(alpha: 0.18),
            primaryColor.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Center(
        child: LayoutBuilder(
          builder: (context, c) => Icon(
            Icons.two_wheeler_rounded,
            size: (c.biggest.shortestSide * 0.45).clamp(16, 120),
            color: primaryColor.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
