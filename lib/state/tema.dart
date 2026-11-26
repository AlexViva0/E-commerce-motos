import 'package:flutter/material.dart';

/// Controlador global de tema (claro, oscuro o del sistema).
///
/// Sigue el mismo patrón reactivo que [Favoritos] usando [ValueNotifier]
/// para no introducir dependencias externas.
class Tema extends ValueNotifier<ThemeMode> {
  Tema._() : super(ThemeMode.system);

  /// Instancia única compartida en toda la aplicación.
  static final Tema instancia = Tema._();

  /// Indica si el modo efectivo es oscuro tomando en cuenta el brillo actual
  /// de la plataforma cuando [value] es [ThemeMode.system].
  bool estaOscuro(Brightness brilloActual) {
    return switch (value) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => brilloActual == Brightness.dark,
    };
  }

  /// Alterna entre tema claro y oscuro a partir del brillo visible actual.
  void alternar(Brightness brilloActual) {
    value = estaOscuro(brilloActual) ? ThemeMode.light : ThemeMode.dark;
  }

  /// Cambia explícitamente al [modo] indicado.
  void establecer(ThemeMode modo) {
    if (value != modo) {
      value = modo;
    }
  }

  /// Etiqueta legible en español del modo seleccionado.
  String get etiqueta => switch (value) {
        ThemeMode.light => "Claro",
        ThemeMode.dark => "Oscuro",
        ThemeMode.system => "Sistema",
      };
}
