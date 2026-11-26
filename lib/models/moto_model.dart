// Datos de demostración del catálogo de motos.
//
// Las fichas técnicas son aproximadas y están tomadas de hojas de
// especificaciones públicas. Los precios son de referencia en pesos
// mexicanos (MXN). Las fotos vienen de Wikimedia Commons (ver la pantalla
// "Créditos" y el README para las licencias).

class Marca {
  final String id, nombre, pais, logo, descripcion;

  const Marca({
    required this.id,
    required this.nombre,
    required this.pais,
    required this.logo,
    required this.descripcion,
  });
}

class Moto {
  final int id;
  final String marcaId;
  final String modelo;
  final String categoria;
  final int anio;

  /// Cilindrada en centímetros cúbicos.
  final int cilindrada;

  /// Potencia máxima en caballos de fuerza (hp).
  final double potencia;

  /// Peso en orden de marcha, en kilogramos.
  final int peso;

  /// Precio de referencia en pesos mexicanos.
  final double precio;

  final String motor;
  final String transmision;

  /// URL de la foto. Vacío si no hay foto libre disponible.
  final String imagen;
  final String descripcion;
  final List<String> colores;
  final bool destacada;

  const Moto({
    required this.id,
    required this.marcaId,
    required this.modelo,
    required this.categoria,
    required this.anio,
    required this.cilindrada,
    required this.potencia,
    required this.peso,
    required this.precio,
    required this.motor,
    required this.transmision,
    required this.imagen,
    required this.descripcion,
    required this.colores,
    this.destacada = false,
  });

  Marca get marca => marcas.firstWhere((m) => m.id == marcaId);

  String get nombreCompleto => "${marca.nombre} $modelo";

  /// Kilos que mueve cada caballo de fuerza. Menos es más deportiva.
  double get pesoPorHp => peso / potencia;

  bool coincideCon(String texto) {
    final q = texto.trim().toLowerCase();
    if (q.isEmpty) return true;
    return modelo.toLowerCase().contains(q) ||
        marca.nombre.toLowerCase().contains(q) ||
        categoria.toLowerCase().contains(q) ||
        "$cilindrada".contains(q);
  }
}

const String todasLasCategorias = "Todas";

const List<String> categorias = [
  "Deportiva",
  "Naked",
  "Aventura",
  "Urbana",
  "Trabajo",
];

/// Icono SVG del kit original que mejor representa cada categoría.
const Map<String, String> iconoCategoria = {
  "Deportiva": "assets/icons/Flashlight.svg",
  "Naked": "assets/icons/Standard.svg",
  "Aventura": "assets/icons/Location.svg",
  "Urbana": "assets/icons/Stores.svg",
  "Trabajo": "assets/icons/Delivery.svg",
};

const List<Marca> marcas = [
  Marca(
    id: "yamaha",
    nombre: "Yamaha",
    pais: "Japón",
    logo: "assets/marcas/yamaha.png",
    descripcion:
        "Fabricante japonés reconocido por sus motos deportivas y de calle, como la línea MT y la YZF-R.",
  ),
  Marca(
    id: "kawasaki",
    nombre: "Kawasaki",
    pais: "Japón",
    logo: "assets/marcas/kawasaki.png",
    descripcion:
        "Fabricante japonés famoso por la línea Ninja y por sus motos deportivas de carácter agresivo.",
  ),
  Marca(
    id: "suzuki",
    nombre: "Suzuki",
    pais: "Japón",
    logo: "assets/marcas/suzuki.png",
    descripcion:
        "Fabricante japonés con una gama que va de motos urbanas ligeras a motos de aventura de media cilindrada.",
  ),
  Marca(
    id: "benelli",
    nombre: "Benelli",
    pais: "Italia",
    logo: "assets/marcas/benelli.jpg",
    descripcion:
        "Marca de origen italiano con diseños de estilo europeo, desde motos naked hasta modelos de aventura.",
  ),
  Marca(
    id: "vento",
    nombre: "Vento",
    pais: "México",
    logo: "assets/marcas/vento.png",
    descripcion:
        "Marca con fuerte presencia en México, enfocada en motos accesibles de uso diario y deportivas de baja cilindrada.",
  ),
  Marca(
    id: "italika",
    nombre: "Italika",
    pais: "México",
    logo: "assets/marcas/italika.jpg",
    descripcion:
        "La marca de motos más vendida de México, con modelos económicos para trabajo y transporte diario.",
  ),
];

const String _wiki = "https://upload.wikimedia.org/wikipedia/commons/thumb";

const List<Moto> motos = [
  Moto(
    id: 1,
    marcaId: "yamaha",
    modelo: "MT-07",
    categoria: "Naked",
    anio: 2024,
    cilindrada: 689,
    potencia: 73.4,
    peso: 184,
    precio: 179900,
    motor: "Bicilíndrico en línea CP2, 4T, refrigerado por líquido",
    transmision: "6 velocidades",
    imagen:
        "$_wiki/9/9c/2021_Black_Yamaha_MT-07.jpg/960px-2021_Black_Yamaha_MT-07.jpg",
    descripcion:
        "Naked de media cilindrada con motor bicilíndrico, ágil en ciudad y con mucha respuesta en carretera.",
    colores: ["Negro", "Azul", "Gris"],
    destacada: true,
  ),
  Moto(
    id: 2,
    marcaId: "yamaha",
    modelo: "YZF-R3",
    categoria: "Deportiva",
    anio: 2024,
    cilindrada: 321,
    potencia: 41.4,
    peso: 169,
    precio: 114900,
    motor: "Bicilíndrico en línea, 4T, refrigerado por líquido",
    transmision: "6 velocidades",
    imagen:
        "$_wiki/d/d1/Yamaha_YZF-R3_2022_v1.jpg/960px-Yamaha_YZF-R3_2022_v1.jpg",
    descripcion:
        "Deportiva carenada de entrada con estilo inspirado en las R de competencia, ideal para empezar en la velocidad.",
    colores: ["Azul", "Negro", "Rojo"],
    destacada: true,
  ),
  Moto(
    id: 3,
    marcaId: "vento",
    modelo: "Rocketman 300 Racing",
    categoria: "Naked",
    anio: 2024,
    cilindrada: 300,
    potencia: 24,
    peso: 150,
    precio: 32999,
    motor: "Monocilíndrico, 4T, refrigerado por aire",
    transmision: "5 velocidades",
    imagen: "",
    descripcion:
        "Moto accesible de línea deportiva, pensada para quien quiere más potencia sin un precio elevado.",
    colores: ["Negro", "Rojo", "Blanco"],
  ),
  Moto(
    id: 4,
    marcaId: "vento",
    modelo: "Nitrox 300 T3",
    categoria: "Deportiva",
    anio: 2024,
    cilindrada: 300,
    potencia: 26,
    peso: 158,
    precio: 36999,
    motor: "Monocilíndrico, 4T, refrigerado por líquido",
    transmision: "6 velocidades",
    imagen: "",
    descripcion:
        "Deportiva económica de 300 cc con diseño agresivo y buena relación entre precio y desempeño.",
    colores: ["Negro", "Azul", "Naranja"],
  ),
  Moto(
    id: 5,
    marcaId: "benelli",
    modelo: "TNT 300",
    categoria: "Naked",
    anio: 2024,
    cilindrada: 300,
    potencia: 38,
    peso: 196,
    precio: 69900,
    motor: "Bicilíndrico en línea, 4T, refrigerado por líquido",
    transmision: "6 velocidades",
    imagen:
        "$_wiki/0/0f/Motocicleta_Benelli_TNT_300_2016.JPG/960px-Motocicleta_Benelli_TNT_300_2016.JPG",
    descripcion:
        "Naked con carácter italiano y chasis robusto, una opción atractiva para pasar de las motos pequeñas a algo más serio.",
    colores: ["Negro", "Rojo", "Verde"],
  ),
  Moto(
    id: 6,
    marcaId: "benelli",
    modelo: "Leoncino 500",
    categoria: "Aventura",
    anio: 2024,
    cilindrada: 500,
    potencia: 47.6,
    peso: 207,
    precio: 119900,
    motor: "Bicilíndrico en línea, 4T, refrigerado por líquido",
    transmision: "6 velocidades",
    imagen:
        "$_wiki/b/b7/Benelli_Leoncino_500_in_Avellino.jpg/960px-Benelli_Leoncino_500_in_Avellino.jpg",
    descripcion:
        "Moto de estilo clásico con toques de scrambler, cómoda para uso diario y para paseos por carretera.",
    colores: ["Gris", "Negro", "Blanco"],
    destacada: true,
  ),
  Moto(
    id: 7,
    marcaId: "suzuki",
    modelo: "V-Strom 650",
    categoria: "Aventura",
    anio: 2024,
    cilindrada: 645,
    potencia: 70,
    peso: 213,
    precio: 189900,
    motor: "V2 a 90°, 4T, refrigerado por líquido",
    transmision: "6 velocidades",
    imagen:
        "$_wiki/1/12/Suzuki_V-Strom_650_XT_MY2018.jpg/960px-Suzuki_V-Strom_650_XT_MY2018.jpg",
    descripcion:
        "Moto de aventura reconocida por su comodidad y autonomía en viajes largos, con motor V2 muy confiable.",
    colores: ["Amarillo", "Negro", "Gris"],
    destacada: true,
  ),
  Moto(
    id: 8,
    marcaId: "suzuki",
    modelo: "Gixxer SF 250",
    categoria: "Deportiva",
    anio: 2024,
    cilindrada: 249,
    potencia: 26.5,
    peso: 161,
    precio: 69900,
    motor: "Monocilíndrico, 4T, refrigerado por aceite",
    transmision: "6 velocidades",
    imagen:
        "$_wiki/b/b4/2021_Suzuki_Gixxer_SF_250_%2820211117%29.jpg/960px-2021_Suzuki_Gixxer_SF_250_%2820211117%29.jpg",
    descripcion:
        "Deportiva ligera con carenado completo y motor refrigerado por aceite, buena para ciudad y carretera.",
    colores: ["Azul", "Negro", "Rojo"],
  ),
  Moto(
    id: 9,
    marcaId: "italika",
    modelo: "DM150",
    categoria: "Urbana",
    anio: 2024,
    cilindrada: 149,
    potencia: 11,
    peso: 120,
    precio: 23999,
    motor: "Monocilíndrico, 4T, refrigerado por aire",
    transmision: "5 velocidades",
    imagen: "",
    descripcion:
        "Moto económica de uso diario, fácil de manejar y de mantener, muy común en las calles de México.",
    colores: ["Negro", "Rojo", "Azul"],
  ),
  Moto(
    id: 10,
    marcaId: "italika",
    modelo: "FT150",
    categoria: "Trabajo",
    anio: 2024,
    cilindrada: 149,
    potencia: 11,
    peso: 122,
    precio: 22999,
    motor: "Monocilíndrico, 4T, refrigerado por aire",
    transmision: "5 velocidades",
    imagen: "",
    descripcion:
        "Moto de trabajo resistente y de bajo consumo, pensada para reparto y transporte diario.",
    colores: ["Negro", "Rojo", "Blanco"],
  ),
  Moto(
    id: 11,
    marcaId: "kawasaki",
    modelo: "Ninja 400",
    categoria: "Deportiva",
    anio: 2024,
    cilindrada: 399,
    potencia: 45,
    peso: 168,
    precio: 129900,
    motor: "Bicilíndrico en línea, 4T, refrigerado por líquido",
    transmision: "6 velocidades",
    imagen:
        "$_wiki/8/8f/Kawasaki_Ninja_400_June_2022.jpg/960px-Kawasaki_Ninja_400_June_2022.jpg",
    descripcion:
        "La deportiva de entrada más popular de Kawasaki, con un diseño que recuerda a las Ninja de mayor cilindrada.",
    colores: ["Verde", "Negro", "Gris"],
    destacada: true,
  ),
  Moto(
    id: 12,
    marcaId: "kawasaki",
    modelo: "Z400",
    categoria: "Naked",
    anio: 2024,
    cilindrada: 399,
    potencia: 45,
    peso: 167,
    precio: 109900,
    motor: "Bicilíndrico en línea, 4T, refrigerado por líquido",
    transmision: "6 velocidades",
    imagen:
        "$_wiki/f/fd/The_frontview_of_Kawasaki_Z400_mid-year_2019.jpg/960px-The_frontview_of_Kawasaki_Z400_mid-year_2019.jpg",
    descripcion:
        "Naked de aspecto agresivo basada en la Ninja 400, con posición erguida y buena respuesta en ciudad.",
    colores: ["Verde", "Negro", "Gris"],
  ),
];

Moto motoPorId(int id) => motos.firstWhere((m) => m.id == id);

List<Moto> motosPorCategoria(String categoria) => categoria == todasLasCategorias
    ? motos
    : motos.where((m) => m.categoria == categoria).toList();

List<Moto> motosPorMarca(String marcaId) =>
    motos.where((m) => m.marcaId == marcaId).toList();

List<Moto> get motosDestacadas => motos.where((m) => m.destacada).toList();

/// Formato "$179,900" para precios en MXN.
String formatoPrecio(double precio) {
  final entero = precio.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < entero.length; i++) {
    if (i > 0 && (entero.length - i) % 3 == 0) buffer.write(",");
    buffer.write(entero[i]);
  }
  return "\$$buffer";
}
