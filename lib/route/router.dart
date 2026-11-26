import 'package:flutter/material.dart';
import 'package:shop/entry_point.dart';

import 'screen_export.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case onbordingScreenRoute:
      return MaterialPageRoute(builder: (context) => const OnBordingScreen());
    case productDetailsScreenRoute:
      final motoId = settings.arguments as int? ?? 1;
      return MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(motoId: motoId),
      );
    case homeScreenRoute:
      return MaterialPageRoute(builder: (context) => const HomeScreen());
    case discoverScreenRoute:
      return MaterialPageRoute(builder: (context) => const DiscoverScreen());
    case searchScreenRoute:
      final categoria = settings.arguments as String?;
      return MaterialPageRoute(
        builder: (context) => SearchScreen(categoriaInicial: categoria),
      );
    case bookmarkScreenRoute:
      return MaterialPageRoute(builder: (context) => const BookmarkScreen());
    case compareScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>
            CompareScreen(motoInicialId: settings.arguments as int?),
      );
    case aboutScreenRoute:
      return MaterialPageRoute(builder: (context) => const AboutScreen());
    case entryPointScreenRoute:
    default:
      return MaterialPageRoute(builder: (context) => const EntryPoint());
  }
}
