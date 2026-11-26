import 'package:flutter_test/flutter_test.dart';

import 'package:catalogo_motos/models/moto_model.dart';

void main() {
  test('el catálogo tiene motos con datos completos', () {
    expect(motos, isNotEmpty);
    for (final moto in motos) {
      expect(moto.cilindrada, greaterThan(0), reason: moto.modelo);
      expect(moto.potencia, greaterThan(0), reason: moto.modelo);
      // Algunas fichas oficiales no publican el peso.
      if (moto.peso != null) {
        expect(moto.peso, greaterThan(0), reason: moto.modelo);
      }
      expect(moto.precio, greaterThan(0), reason: moto.modelo);
      expect(categorias, contains(moto.categoria), reason: moto.modelo);
      expect(marcas.map((m) => m.id), contains(moto.marcaId),
          reason: moto.modelo);
    }
  });

  test('los ids de las motos no se repiten', () {
    final ids = motos.map((m) => m.id).toSet();
    expect(ids.length, motos.length);
  });

  test('el filtro por categoría solo devuelve esa categoría', () {
    for (final categoria in categorias) {
      expect(
        motosPorCategoria(categoria).every((m) => m.categoria == categoria),
        isTrue,
      );
    }
    expect(motosPorCategoria(todasLasCategorias).length, motos.length);
  });

  test('formato de precio en pesos', () {
    expect(formatoPrecio(179900), r'$179,900');
    expect(formatoPrecio(1234567), r'$1,234,567');
    expect(formatoPrecio(999), r'$999');
  });
}
