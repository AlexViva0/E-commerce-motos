import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/route/router.dart' as router;
import 'package:shop/state/tema.dart';
import 'package:shop/theme/app_theme.dart';

// Catálogo de motos basado en la plantilla gratuita FlutterShop de
// Abu Anwar (The Flutter Way):
// https://github.com/abuanwar072/E-commerce-Complete-Flutter-UI

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: Tema.instancia,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Catálogo de Motos',
          theme: AppTheme.lightTheme(context),
          darkTheme: AppTheme.darkTheme(context),
          themeMode: themeMode,
          themeAnimationDuration: defaultDuration,
          themeAnimationCurve: Curves.easeInOut,
          onGenerateRoute: router.generateRoute,
          initialRoute: onbordingScreenRoute,
        );
      },
    );
  }
}
