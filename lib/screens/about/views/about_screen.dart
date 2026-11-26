import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';

/// Créditos del proyecto: autor de la plantilla original y fuentes.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _abrir(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    final titulo = Theme.of(context).textTheme.titleSmall;
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.two_wheeler_rounded,
                size: 56, color: primaryColor),
          ),
        ),
        const SizedBox(height: defaultPadding),
        Center(
          child: Text("Catálogo de Motos",
              style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: defaultPadding / 2),
        const Center(
          child: Text(
            "Proyecto académico de Desarrollo Móvil.\nSolo demostración.",
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: defaultPadding * 2),
        Text("Créditos", style: titulo),
        const SizedBox(height: defaultPadding / 2),
        Card(
          child: ListTile(
            leading: const Icon(Icons.design_services_outlined),
            title: const Text("Plantilla FlutterShop"),
            subtitle: const Text(
                "Diseño original de Abu Anwar (The Flutter Way). Esta app es un fork adaptado a motos."),
            isThreeLine: true,
            onTap: () => _abrir(
                "https://github.com/abuanwar072/E-commerce-Complete-Flutter-UI"),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text("Fotografías"),
            subtitle: const Text(
                "Wikimedia Commons (con la licencia y autoría de cada página) y sitios oficiales de las marcas en México."),
            isThreeLine: true,
            onTap: () => _abrir("https://commons.wikimedia.org"),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("Datos técnicos y precios"),
            subtitle: Text(
                "Tomados de los sitios oficiales y distribuidores en México (noviembre de 2026). Cada ficha enlaza sus fuentes. Las marcas y logotipos pertenecen a sus dueños."),
            isThreeLine: true,
          ),
        ),
      ],
    );
  }
}
