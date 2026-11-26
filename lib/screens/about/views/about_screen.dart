import 'package:flutter/material.dart';
import 'package:catalogo_motos/state/tema.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';

/// Créditos del proyecto, fuentes y ajuste de apariencia.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _abrir(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final titulo = theme.textTheme.titleSmall;

    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Center(
          child: Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor, primaryDarkColor],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.28),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.two_wheeler_rounded,
              size: 46,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
        const SizedBox(height: defaultPadding),
        Center(
          child: Text(
            "Catálogo de Motos",
            style: theme.textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: defaultPadding / 2),
        Center(
          child: Text(
            "Proyecto académico de Desarrollo Móvil.\nSolo demostración.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: defaultPadding * 1.5),
        Text("Apariencia", style: titulo),
        const SizedBox(height: defaultPadding / 2),
        const _TarjetaApariencia(),
        const SizedBox(height: defaultPadding * 1.5),
        Text("Créditos", style: titulo),
        const SizedBox(height: defaultPadding / 2),
        Card(
          child: ListTile(
            leading: _IconoCredito(
              icon: Icons.design_services_outlined,
              colorScheme: colorScheme,
            ),
            title: const Text("Plantilla FlutterShop"),
            subtitle: const Text(
              "Diseño original de Abu Anwar (The Flutter Way). Esta app es un fork adaptado a motos.",
            ),
            trailing: const Icon(Icons.open_in_new_rounded, size: 18),
            isThreeLine: true,
            onTap: () => _abrir(
              "https://github.com/abuanwar072/E-commerce-Complete-Flutter-UI",
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: _IconoCredito(
              icon: Icons.photo_library_outlined,
              colorScheme: colorScheme,
            ),
            title: const Text("Fotografías"),
            subtitle: const Text(
              "Wikimedia Commons (con la licencia y autoría de cada página) y sitios oficiales de las marcas en México.",
            ),
            trailing: const Icon(Icons.open_in_new_rounded, size: 18),
            isThreeLine: true,
            onTap: () => _abrir("https://commons.wikimedia.org"),
          ),
        ),
        Card(
          child: ListTile(
            leading: _IconoCredito(
              icon: Icons.info_outline,
              colorScheme: colorScheme,
            ),
            title: const Text("Datos técnicos y precios"),
            subtitle: const Text(
              "Tomados de los sitios oficiales y distribuidores en México (noviembre de 2026). Cada ficha enlaza sus fuentes. Las marcas y logotipos pertenecen a sus dueños.",
            ),
            isThreeLine: true,
          ),
        ),
      ],
    );
  }
}

class _TarjetaApariencia extends StatelessWidget {
  const _TarjetaApariencia();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final brilloPlataforma = MediaQuery.platformBrightnessOf(context);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: Tema.instancia,
      builder: (context, mode, _) {
        final esOscuro = Tema.instancia.estaOscuro(brilloPlataforma);
        final subtitulo = switch (mode) {
          ThemeMode.system => esOscuro
              ? "Activado (según el sistema)"
              : "Desactivado (según el sistema)",
          ThemeMode.dark => "Activado",
          ThemeMode.light => "Desactivado",
        };

        return Card(
          child: Column(
            children: [
              SwitchListTile(
                secondary: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: esOscuro
                        ? colorScheme.secondaryContainer
                        : colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AnimatedSwitcher(
                    duration: defaultDuration,
                    transitionBuilder: (child, animation) => RotationTransition(
                      turns: Tween<double>(begin: 0.7, end: 1.0)
                          .animate(animation),
                      child: ScaleTransition(scale: animation, child: child),
                    ),
                    child: esOscuro
                        ? Icon(
                            Icons.dark_mode_rounded,
                            key: const ValueKey('about_luna'),
                            color: colorScheme.onSecondaryContainer,
                          )
                        : Icon(
                            Icons.light_mode_rounded,
                            key: const ValueKey('about_sol'),
                            color: colorScheme.onPrimaryContainer,
                          ),
                  ),
                ),
                title: const Text("Modo oscuro"),
                subtitle: Text(subtitulo),
                value: esOscuro,
                onChanged: (_) => Tema.instancia.alternar(brilloPlataforma),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(defaultPadding * 0.75),
                child: SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<ThemeMode>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.light,
                        icon: Icon(Icons.light_mode_outlined, size: 17),
                        label: Text("Claro"),
                      ),
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.system,
                        icon: Icon(Icons.brightness_auto_outlined, size: 17),
                        label: Text("Sistema"),
                      ),
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.dark,
                        icon: Icon(Icons.dark_mode_outlined, size: 17),
                        label: Text("Oscuro"),
                      ),
                    ],
                    selected: {mode},
                    onSelectionChanged: (seleccion) {
                      if (seleccion.isNotEmpty) {
                        Tema.instancia.establecer(seleccion.first);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _IconoCredito extends StatelessWidget {
  const _IconoCredito({
    required this.icon,
    required this.colorScheme,
  });

  final IconData icon;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: colorScheme.onPrimaryContainer,
      ),
    );
  }
}
