import 'package:flutter/foundation.dart';

/// Favoritos en memoria. Para la demo no hace falta guardarlos en disco.
class Favoritos extends ValueNotifier<Set<int>> {
  Favoritos._() : super(<int>{});

  static final Favoritos instancia = Favoritos._();

  bool contiene(int id) => value.contains(id);

  void alternar(int id) {
    final nuevos = Set<int>.from(value);
    if (!nuevos.remove(id)) nuevos.add(id);
    value = nuevos;
  }
}
