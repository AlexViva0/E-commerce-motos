// Datos de demostración del catálogo de motos.
//
// Fichas técnicas y precios de lista consultados en noviembre de 2026 en los
// sitios oficiales de cada marca en México y en distribuidores; cada moto
// guarda sus fuentes en `fuentes`. Precios en pesos mexicanos (MXN).
// Las fotos vienen de Wikimedia Commons o del sitio oficial de la marca.

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

  /// Torque máximo en newton-metro. Null si la marca no lo publica.
  final double? torque;

  /// Peso en kilogramos. Null si la ficha oficial no lo publica.
  final int? peso;

  /// "seco" u "orden de marcha", según la fuente.
  final String tipoPeso;

  /// Capacidad del tanque en litros.
  final double? tanque;

  /// Altura del asiento en milímetros.
  final int? alturaAsiento;

  /// Precio de referencia en pesos mexicanos.
  final double precio;

  final String motor;
  final String transmision;

  /// URL de la foto. Vacío si no hay foto libre disponible.
  final String imagen;
  final String descripcion;
  final List<String> colores;

  /// Páginas de donde salen los datos técnicos y el precio.
  final List<String> fuentes;
  final bool destacada;

  const Moto({
    required this.id,
    required this.marcaId,
    required this.modelo,
    required this.categoria,
    required this.anio,
    required this.cilindrada,
    required this.potencia,
    this.torque,
    required this.peso,
    this.tipoPeso = "",
    this.tanque,
    this.alturaAsiento,
    required this.precio,
    required this.motor,
    required this.transmision,
    required this.imagen,
    required this.descripcion,
    required this.colores,
    this.fuentes = const [],
    this.destacada = false,
  });

  Marca get marca => marcas.firstWhere((m) => m.id == marcaId);

  String get nombreCompleto => "${marca.nombre} $modelo";

  /// Kilos que mueve cada caballo de fuerza. Menos es más deportiva.
  double? get pesoPorHp => peso == null ? null : peso! / potencia;

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
    id: "honda",
    nombre: "Honda",
    pais: "Japón",
    logo: "assets/marcas/honda.png",
    descripcion:
        "El mayor fabricante de motos del mundo, con una gama en México que va de motonetas y motos de trabajo a deportivas y de aventura.",
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

const List<Moto> motos = [
  Moto(
    id: 1,
    marcaId: "yamaha",
    modelo: "MT-07",
    categoria: "Naked",
    anio: 2025,
    cilindrada: 689,
    potencia: 73.4,
    torque: 68.0,
    peso: 183,
    tipoPeso: "orden de marcha",
    tanque: 14.0,
    alturaAsiento: 805,
    precio: 259999.0,
    motor: "Bicilíndrico en línea (CP2), 4 tiempos, DOHC, 4 válvulas por cilindro, refrigerado por líquido",
    transmision: "6 velocidades, embrague asistido y antirrebote, transmisión final por cadena",
    imagen: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9c/2021_Black_Yamaha_MT-07.jpg/960px-2021_Black_Yamaha_MT-07.jpg",
    descripcion: "Naked bicilíndrica de cilindrada media reconocida por la entrega lineal y contundente de su motor CP2 con cigüeñal calado a 270 grados. Su generación renovada suma acelerador electrónico, modos de conducción y suspensión delantera invertida para uso urbano y carretera.",
    colores: ["Icon Blue", "Tech Black", "Gris"],
    fuentes: ["https://www.yamaha-motor.com.mx/mt-07.php", "https://en.wikipedia.org/wiki/Yamaha_MT-07", "https://commons.wikimedia.org/wiki/File:2021_Black_Yamaha_MT-07.jpg"],
    destacada: true,
  ),
  Moto(
    id: 2,
    marcaId: "yamaha",
    modelo: "YZF-R3",
    categoria: "Deportiva",
    anio: 2026,
    cilindrada: 321,
    potencia: 41.4,
    torque: 29.6,
    peso: 169,
    tipoPeso: "orden de marcha",
    tanque: 14.0,
    alturaAsiento: 780,
    precio: 159999.0,
    motor: "Bicilíndrico en línea, 4 tiempos, DOHC, 4 válvulas por cilindro, refrigerado por líquido",
    transmision: "6 velocidades, embrague asistido y antirrebote, transmisión final por cadena",
    imagen: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/2025_Yamaha_YZF-R3.jpg/960px-2025_Yamaha_YZF-R3.jpg",
    descripcion: "Deportiva ligera bicilíndrica que combina una posición de manejo accesible con carenado aerodinámico inspirado en la serie R de competición. Incorpora frenos ABS de doble canal, conectividad Y-Connect y puerto USB-A.",
    colores: ["Edición 70 Aniversario", "Azul Racing", "Negro Mate"],
    fuentes: ["https://www.yamaha-motor.com.mx/yzf-r3.php", "https://en.wikipedia.org/wiki/Yamaha_YZF-R3", "https://commons.wikimedia.org/wiki/Category:Yamaha_YZF-R3"],
    destacada: true,
  ),
  Moto(
    id: 3,
    marcaId: "benelli",
    modelo: "302S",
    categoria: "Naked",
    anio: 2025,
    cilindrada: 300,
    potencia: 37.5,
    torque: 25.6,
    peso: 195,
    tipoPeso: "seco",
    tanque: 16.0,
    alturaAsiento: 795,
    precio: 98999.0,
    motor: "Bicilíndrico en paralelo, 4 tiempos, DOHC, 8 válvulas, refrigerado por líquido",
    transmision: "6 velocidades, transmisión final por cadena",
    imagen: "https://cdn.keeway.com/benelli-3-0/media/2143/conversions/2560x2180-hd.png?x-oss-process=image/resize,w_1920,limit_1/quality,q_80/format,webp",
    descripcion: "Naked bicilíndrica de entrada con chasis multitubular a la vista, horquilla delantera invertida y doble disco delantero con ABS. Su motor de giro alto y tanque de 16 litros la orientan tanto al tránsito diario como a recorridos en carretera.",
    colores: ["Rojo / Blanco", "Negro", "Verde / Negro"],
    fuentes: ["https://mexicobenelli.com/modelos/302s", "https://mexicobenelli.com/", "https://benelli.com"],
  ),
  Moto(
    id: 4,
    marcaId: "suzuki",
    modelo: "V-Strom 800DE",
    categoria: "Aventura",
    anio: 2025,
    cilindrada: 776,
    potencia: 83.0,
    torque: 78.0,
    peso: 230,
    tipoPeso: "orden de marcha",
    tanque: 20.0,
    alturaAsiento: 855,
    precio: 255000.0,
    motor: "Bicilíndrico en paralelo, 4 tiempos, DOHC, cigüeñal calado a 270°, refrigerado por líquido",
    transmision: "6 velocidades, embrague asistido y antirrebote (SCAS), acelerador electrónico Ride-by-Wire",
    imagen: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Suzuki_V-Strom_800DE_%283-resized%29.jpg/960px-Suzuki_V-Strom_800DE_%283-resized%29.jpg",
    descripcion: "Motocicleta doble propósito de media-alta cilindrada equipada con rines de rayos, rueda delantera de 21 pulgadas y suspensiones de largo recorrido para rutas mixtas. Integra pantalla TFT a color, modos de conducción y control de tracción adaptable a terracería.",
    colores: ["Amarillo", "Blanco Perlado", "Negro"],
    fuentes: ["https://motos.suzuki.com.mx/modelos/doble-proposito/v-strom-800", "https://en.wikipedia.org/wiki/Suzuki_V-Strom_800"],
    destacada: true,
  ),
  Moto(
    id: 5,
    marcaId: "suzuki",
    modelo: "Gixxer SF 250",
    categoria: "Deportiva",
    anio: 2025,
    cilindrada: 249,
    potencia: 26.1,
    torque: 22.6,
    peso: 161,
    tipoPeso: "orden de marcha",
    tanque: 12.0,
    alturaAsiento: 800,
    precio: 97000.0,
    motor: "Monocilíndrico, 4 tiempos, SOHC, 4 válvulas, refrigerado por aceite (SOCS)",
    transmision: "6 velocidades, transmisión final por cadena",
    imagen: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/2021_Suzuki_Gixxer_SF_250_%2820211117%29.jpg/960px-2021_Suzuki_Gixxer_SF_250_%2820211117%29.jpg",
    descripcion: "Deportiva carenada de cuarto de litro impulsada por un monocilíndrico refrigerado por aceite que prioriza la eficiencia y el bajo mantenimiento. Cuenta con frenos ABS de doble canal, iluminación LED y una ergonomía apta para desplazamientos cotidianos.",
    colores: ["Blanco", "Azul-Blanco", "Negro"],
    fuentes: ["https://motos.suzuki.com.mx/gixxer-sf-250"],
  ),
  Moto(
    id: 6,
    marcaId: "kawasaki",
    modelo: "Ninja 500",
    categoria: "Deportiva",
    anio: 2026,
    cilindrada: 451,
    potencia: 51.0,
    torque: 43.0,
    peso: 170,
    tipoPeso: "orden de marcha",
    tanque: 14.0,
    alturaAsiento: 785,
    precio: 134990.0,
    motor: "Bicilíndrico en paralelo, 4 tiempos, DOHC, 8 válvulas, refrigerado por líquido",
    transmision: "6 velocidades, embrague asistido y antirrebote (Assist & Slipper Clutch)",
    imagen: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3d/Kawasaki_Ninja_500_SE_2025.jpg/960px-Kawasaki_Ninja_500_SE_2025.jpg",
    descripcion: "Deportiva bicilíndrica de 451 cc que evoluciona la plataforma anterior con mayor par en bajas y medias revoluciones. Mantiene un chasis ligero tipo trellis, asiento bajo de 785 mm y conectividad para smartphone mediante Rideology.",
    colores: ["Verde Lime", "Negro", "Gris / Plata", "Rojo / Negro"],
    fuentes: ["https://www.kawasaki.com.mx/es-mx/motorcycle/ninja/sport/ninja-500/2026-ninja-500-abs", "https://www.kawasaki.com.mx/es-mx/motorcycle/ninja/sport/ninja-500"],
    destacada: true,
  ),
  Moto(
    id: 7,
    marcaId: "kawasaki",
    modelo: "Z500",
    categoria: "Naked",
    anio: 2026,
    cilindrada: 451,
    potencia: 51.0,
    torque: 42.9,
    peso: 166,
    tipoPeso: "orden de marcha",
    tanque: 14.0,
    alturaAsiento: 785,
    precio: 132690.0,
    motor: "Bicilíndrico en paralelo, 4 tiempos, DOHC, 8 válvulas, refrigerado por líquido",
    transmision: "6 velocidades, embrague asistido y antirrebote (Assist & Slipper Clutch)",
    imagen: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Kawasaki_Z500_%28ER500%29_2024.jpg/960px-Kawasaki_Z500_%28ER500%29_2024.jpg",
    descripcion: "Supernaked ligera con estética agresiva Sugomi y un motor bicilíndrico de 451 cc ágil para ciudad y curvas. Incorpora frenos ABS de serie, embrague antirrebote y ergonomía adaptable ERGO-FIT.",
    colores: ["Gris / Negro", "Blanco"],
    fuentes: ["https://www.kawasaki.com.mx/es-mx/motorcycle/z/supernaked/z500/2026-z500-abs", "https://en.wikipedia.org/wiki/Kawasaki_Z_series"],
  ),
  Moto(
    id: 8,
    marcaId: "honda",
    modelo: "NAVi",
    categoria: "Urbana",
    anio: 2026,
    cilindrada: 109,
    potencia: 7.8,
    torque: 9.0,
    peso: 101,
    tipoPeso: "orden de marcha",
    tanque: 3.8,
    alturaAsiento: 765,
    precio: 28990.0,
    motor: "Monocilíndrico HET, 4 tiempos, SOHC, 2 válvulas, enfriado por aire forzado",
    transmision: "Automática V-Matic por banda",
    imagen: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Honda_Navi_100.jpg/960px-Honda_Navi_100.jpg",
    descripcion: "Motocicleta urbana compacta con estética de moto y manejo automático de scooter, ideal para traslados ágiles en ciudad. Destaca por su ligereza, bajo consumo de combustible y ensamble en México.",
    colores: ["Rojo", "Negro", "Blanco", "Azul"],
    fuentes: ["https://www.honda.mx/motos/navi110", "https://www.comotohonda.mx/navi110/", "https://www.motofichas.com.mx/modelos/honda"],
  ),
  Moto(
    id: 9,
    marcaId: "honda",
    modelo: "GL150 Cargo",
    categoria: "Trabajo",
    anio: 2026,
    cilindrada: 149,
    potencia: 11.2,
    torque: 11.9,
    peso: 128,
    tipoPeso: "orden de marcha",
    tanque: 14.3,
    alturaAsiento: 768,
    precio: 39990.0,
    motor: "Monocilíndrico, 4 tiempos, SOHC, 2 válvulas, enfriado por aire natural",
    transmision: "Mecánica de 5 velocidades tipo retorno",
    imagen: "https://www.honda.mx/web/img/motorcycles/models/trabajo/gl-150-cargo/slider/1.jpg",
    descripcion: "Motocicleta utilitaria pensada para jornadas intensas de reparto y carga, con parrilla trasera reforzada y doble amortiguador posterior. Su motor carburado y frenos de tambor priorizan la durabilidad y el mantenimiento sencillo.",
    colores: ["Blanco", "Rojo"],
    fuentes: ["https://www.honda.mx/motos/gl150-cargo", "https://www.comotohonda.mx/gl150-cargo/", "https://www.motofichas.com.mx/modelos/honda"],
  ),
  Moto(
    id: 10,
    marcaId: "honda",
    modelo: "CB190R 2.0",
    categoria: "Naked",
    anio: 2026,
    cilindrada: 184,
    potencia: 17.3,
    torque: 16.1,
    peso: 142,
    tipoPeso: "orden de marcha",
    tanque: 12.0,
    alturaAsiento: 770,
    precio: 58990.0,
    motor: "Monocilíndrico, 4 tiempos, SOHC, 2 válvulas, inyección electrónica PGM-FI, enfriado por aire natural",
    transmision: "Mecánica de 5 velocidades tipo retorno con embrague antirrebote",
    imagen: "https://www.honda.mx/web/img/motorcycles/models/naked/cb190r/slider/1.jpg",
    descripcion: "Naked deportiva de baja cilindrada que actualiza la plataforma 190 con tablero TFT, iluminación Full LED, puerto USB-C y control de tracción. Equipa horquilla invertida y frenos de disco con ABS para uso urbano ágil.",
    colores: ["Rojo", "Negro"],
    fuentes: ["https://www.honda.mx/motos/cb190r-2-0", "https://www.comotohonda.mx/cb190r-2-0/", "https://www.motofichas.com.mx/modelos/honda"],
  ),
  Moto(
    id: 11,
    marcaId: "honda",
    modelo: "XR190L",
    categoria: "Aventura",
    anio: 2026,
    cilindrada: 184,
    potencia: 15.6,
    torque: 15.7,
    peso: 134,
    tipoPeso: "orden de marcha",
    tanque: 12.0,
    alturaAsiento: 835,
    precio: 60990.0,
    motor: "Monocilíndrico, 4 tiempos, OHC, 2 válvulas, inyección electrónica PGM-FI, enfriado por aire natural",
    transmision: "Mecánica de 5 velocidades tipo retorno",
    imagen: "https://www.honda.mx/web/img/motorcycles/models/doble-proposito/xr-190l/slider/1.jpg",
    descripcion: "Doble propósito versátil diseñada para alternar entre asfalto urbano y terracería ligera gracias a sus suspensiones de largo recorrido y rin delantero de 19 pulgadas. Su alimentación PGM-FI mejora la respuesta en altitud.",
    colores: ["Rojo", "Blanco"],
    fuentes: ["https://www.honda.mx/motos/xr190l", "https://www.comotohonda.mx/xr190l/", "https://www.motofichas.com.mx/modelos/honda"],
  ),
  Moto(
    id: 12,
    marcaId: "honda",
    modelo: "CBR500R",
    categoria: "Deportiva",
    anio: 2026,
    cilindrada: 471,
    potencia: 47.0,
    torque: 43.0,
    peso: 192,
    tipoPeso: "orden de marcha",
    tanque: 17.1,
    alturaAsiento: 785,
    precio: 159990.0,
    motor: "Bicilíndrico en paralelo, 4 tiempos, DOHC, 8 válvulas, inyección electrónica PGM-FI, enfriado por líquido",
    transmision: "Manual de 6 velocidades con embrague antirrebote (opción E-Clutch)",
    imagen: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/2023_Honda_CBR500R.jpg/960px-2023_Honda_CBR500R.jpg",
    descripcion: "Deportiva carenada de media cilindrada con horquilla invertida Showa SFF-BP, doble disco delantero con ABS y pantalla TFT de 5 pulgadas con Honda RoadSync. Combina prestaciones equilibradas para carretera con ergonomía accesible.",
    colores: ["Rojo Grand Prix", "Negro Mate Metálico"],
    fuentes: ["https://www.honda.mx/motos/cbr500r", "https://www.comotohonda.mx/cbr500r/", "https://www.motofichas.com.mx/modelos/honda"],
    destacada: true,
  ),
  Moto(
    id: 13,
    marcaId: "honda",
    modelo: "NX500",
    categoria: "Aventura",
    anio: 2026,
    cilindrada: 471,
    potencia: 47.0,
    torque: 43.0,
    peso: 196,
    tipoPeso: "orden de marcha",
    tanque: 17.5,
    alturaAsiento: 830,
    precio: 149990.0,
    motor: "Bicilíndrico en paralelo, 4 tiempos, DOHC, 8 válvulas, inyección electrónica PGM-FI, enfriado por líquido",
    transmision: "Manual de 6 velocidades con embrague antirrebote (opción E-Clutch)",
    imagen: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/2023_Honda_NX500.jpg/960px-2023_Honda_NX500.jpg",
    descripcion: "Crossover de aventura sucesora de la CB500X, equipada con rueda delantera de 19 pulgadas, control de tracción HSTC y pantalla TFT a color con conectividad. Ofrece postura erguida y autonomía amplia para viajes mixtos.",
    colores: ["Blanco Horizon Perlado", "Negro Gunpowder Mate Metalizado", "Negro Graphite"],
    fuentes: ["https://www.honda.mx/motos/nx500", "https://www.comotohonda.mx/nx500/", "https://www.motofichas.com.mx/modelos/honda"],
    destacada: true,
  ),
  Moto(
    id: 14,
    marcaId: "vento",
    modelo: "Rocketman Racing 300",
    categoria: "Naked",
    anio: 2026,
    cilindrada: 300,
    potencia: 24.0,
    torque: null,
    peso: 115,
    tipoPeso: "seco",
    tanque: 20.0,
    alturaAsiento: 795,
    precio: 41990.0,
    motor: "4 tiempos, monocilíndrico, enfriado por aceite",
    transmision: "Manual de 6 velocidades",
    imagen: "https://www.motobunker.mx/Images/Familia/REBELDES/ROCKETMAN_RACING_300/4fc577a1-8ec0-4bb5-ac36-2229efb46640.jpg",
    descripcion: "Motocicleta de estética café racer clásica equipada con un bloque de 300 cc, caja de seis marchas y tanque de 20 litros para recorridos largos. Incluye iluminación LED, frenos de disco en ambos ejes y sistema de conectividad VenTec.",
    colores: ["Gris"],
    fuentes: ["https://www.vento.com/rocketman-racing-300", "https://www.motobunker.mx/Images/Familia/REBELDES/ROCKETMAN_RACING_300/4fc577a1-8ec0-4bb5-ac36-2229efb46640.jpg"],
  ),
  Moto(
    id: 15,
    marcaId: "vento",
    modelo: "Nitrox 300 T3",
    categoria: "Naked",
    anio: 2026,
    cilindrada: 300,
    potencia: 25.0,
    torque: 22.0,
    peso: 120,
    tipoPeso: "seco",
    tanque: 13.4,
    alturaAsiento: 800,
    precio: 52999.0,
    motor: "4 tiempos, monocilíndrico, SOHC, enfriado por aire con radiador de aceite",
    transmision: "Manual de 6 velocidades",
    imagen: "https://www.frmmotos.com.mx/assets/img/pages/description/vento/nitrox-300-t3/image-00.webp",
    descripcion: "Naked urbana de corte deportivo con horquilla delantera invertida, monoshock trasero y refrigeración apoyada por radiador de aceite. Integra tablero digital, iluminación Full LED y conectividad VenTec para vincular el teléfono inteligente.",
    colores: ["Gris Mate con Rojo", "Negro"],
    fuentes: ["https://www.vento.com/nitrox-300-t3", "https://www.motofichas.com.mx/motos/vento/nitrox-300-t3", "https://www.galgo.com/mx/motos/vento-nitrox-t3-300"],
  ),
  Moto(
    id: 16,
    marcaId: "vento",
    modelo: "Hyper 2.0 310",
    categoria: "Deportiva",
    anio: 2026,
    cilindrada: 310,
    potencia: 30.0,
    torque: 25.0,
    peso: 144,
    tipoPeso: "seco",
    tanque: 13.0,
    alturaAsiento: 780,
    precio: 69999.0,
    motor: "4 tiempos, monocilíndrico, 4 válvulas, enfriado por aceite",
    transmision: "Manual de 6 velocidades",
    imagen: "https://www.vento.com/wp-content/uploads/banner_LANDING_mob_HYPER2_1500x1600v4.webp",
    descripcion: "Modelo insignia deportivo de Vento con motor de 310 cc y cuatro válvulas capaz de entregar 30 hp. Incorpora horquilla invertida, doble freno de disco hidráulico y sistema VenTec para gestionar música y llamadas en ruta.",
    colores: ["Negro", "Negro Mate"],
    fuentes: ["https://www.vento.com/hyper-2-0-310", "https://www.galgo.com/mx/motos/vento-hyper-310-2027", "https://www.motometa.com.mx/motocicleta-vento-hyper-20-310-4v-p200180192"],
    destacada: true,
  ),
  Moto(
    id: 17,
    marcaId: "vento",
    modelo: "Crossmax 330 Rally",
    categoria: "Aventura",
    anio: 2026,
    cilindrada: 330,
    potencia: 30.0,
    torque: 24.5,
    peso: 126,
    tipoPeso: "seco",
    tanque: 12.0,
    alturaAsiento: 850,
    precio: 47999.0,
    motor: "4 tiempos, monocilíndrico, enfriado por aceite (doble radiador)",
    transmision: "Manual de 6 velocidades",
    imagen: "https://www.vento.com/wp-content/uploads/banner_LANDING_mob_CROSSMAX-330-RALLY-TRX_2026_1500x1600.webp",
    descripcion: "Motocicleta doble propósito de estilo rally equipada con rines de 21 y 18 pulgadas, suspensión delantera invertida y doble radiador de aceite. Suma parabrisas alto, cubrepuños con iluminación LED, parrilla trasera y conectividad VenTec.",
    colores: ["Negro", "Gris"],
    fuentes: ["https://www.vento.com/crossmax-330-rally", "https://www.galgo.com/mx/m/vento-crossmax-330-rally-2027"],
  ),
  Moto(
    id: 18,
    marcaId: "vento",
    modelo: "Workman 250",
    categoria: "Trabajo",
    anio: 2026,
    cilindrada: 250,
    potencia: 18.0,
    torque: 18.0,
    peso: 115,
    tipoPeso: "seco",
    tanque: 14.5,
    alturaAsiento: 799,
    precio: 37999.0,
    motor: "4 tiempos, monocilíndrico, enfriado por aire",
    transmision: "Manual de 5 velocidades",
    imagen: "https://www.vento.com/img/workman250/2022/workman250-mobi.jpg",
    descripcion: "Motocicleta utilitaria pensada para reparto y carga diaria, equipada con parrilla trasera reforzada para hasta 50 kg y doble amortiguador posterior. Combina arranque eléctrico y de pedal con freno de disco delantero, puerto USB y alarma antirrobo.",
    colores: ["Blanco"],
    fuentes: ["https://www.vento.com/workman-250", "https://www.motofichas.com.mx/motos/vento/workman-250", "https://www.galgo.com/mx/motos/vento-workman-250-2027"],
  ),
  Moto(
    id: 19,
    marcaId: "vento",
    modelo: "Terra 200 S",
    categoria: "Urbana",
    anio: 2026,
    cilindrada: 200,
    potencia: 12.0,
    torque: 10.5,
    peso: 108,
    tipoPeso: "seco",
    tanque: 6.4,
    alturaAsiento: 760,
    precio: 29999.0,
    motor: "4 tiempos, monocilíndrico, enfriado por aire",
    transmision: "Automática CVT",
    imagen: "https://www.vento.com/wp-content/uploads/banner_mob_terra-200_2026_1500x1600.jpg",
    descripcion: "Motoneta automática de inspiración todoterreno diseñada para movilidad urbana ágil sobre asfalto y calles irregulares. Incluye llantas de dibujo mixto, defensa protectora frontal, cajuela trasera de 34 litros y conectividad VenTec.",
    colores: ["Gris con Verde Neón", "Plata"],
    fuentes: ["https://www.vento.com/terra-200-s"],
  ),
  Moto(
    id: 20,
    marcaId: "italika",
    modelo: "DM150",
    categoria: "Aventura",
    anio: 2026,
    cilindrada: 149,
    potencia: 13.0,
    torque: 13.2,
    peso: 114,
    tipoPeso: "seco",
    tanque: 11.0,
    alturaAsiento: 860,
    precio: 38999.0,
    motor: "Monocilíndrico 4 tiempos, SOHC, 2 válvulas, enfriado por aire forzado",
    transmision: "Manual de 5 velocidades por cadena",
    imagen: "",
    descripcion: "Motocicleta doble propósito ligera orientada a trayectos mixtos de ciudad y terracería en México. Equipa motor de 149 cc, freno delantero de disco, suspensión trasera monoshock y rastreador GPS integrado.",
    colores: ["Blanco"],
    fuentes: ["https://www.italika.mx/italika-dm150-con-gps-blanca/p/11150260426", "https://www.italika.mx/Modelos/Doble-proposito/DM150-GPS-BLANCA/", "https://www.motofichas.com.mx/motos/italika/dm150"],
  ),
  Moto(
    id: 21,
    marcaId: "italika",
    modelo: "FT150 GTS",
    categoria: "Trabajo",
    anio: 2026,
    cilindrada: 149,
    potencia: 11.2,
    torque: 11.0,
    peso: 113,
    tipoPeso: "seco",
    tanque: 17.0,
    alturaAsiento: 770,
    precio: 40999.0,
    motor: "Monocilíndrico 4 tiempos, enfriado por aire",
    transmision: "Manual de 5 velocidades por cadena",
    imagen: "https://elektra.vtexassets.com/arquivos/ids/37234695/34007051.jpg",
    descripcion: "Variante de trabajo y reparto de la familia FT150 con tanque de gran autonomía de 17 litros y sistema GPS de fábrica. Combina freno delantero de disco sencillo, rines de aleación y capacidad de carga de 150 kg.",
    colores: ["Gris con Amarillo"],
    fuentes: ["https://www.italika.mx/p/FT150-GTS/", "https://www.elektra.mx/motocicleta-italika-ft150-gts-gris-con-gps-34007051/p", "https://www.motofichas.com.mx/motos/italika/ft150-gts-2020"],
  ),
  Moto(
    id: 22,
    marcaId: "italika",
    modelo: "Vort-X 250",
    categoria: "Deportiva",
    anio: 2026,
    cilindrada: 250,
    potencia: 22.1,
    torque: 22.0,
    peso: 142,
    tipoPeso: "seco",
    tanque: 15.0,
    alturaAsiento: 785,
    precio: 73999.0,
    motor: "Monocilíndrico 4 tiempos, OHC, 2 válvulas",
    transmision: "Manual de 6 velocidades por cadena",
    imagen: "https://www.italika.mx/medias/IM-250-ROJO-GPS-2026-MX.webp?context=bWFzdGVyfDI1MC1ST0pPLTIwMjYtTVh8MTUwOTU4fGltYWdlL3dlYnB8YURCbEwyaGpOaTh4TURFME9EZ3hPRGt4TVRJMk1pOUpUUzB5TlRBdFVrOUtUeTFIVUZNdE1qQXlOaTFOV0M1M1pXSnd8NTQ1MjJmNmQ5OGI0ZDk4M2QwM2Y1ZjdmNGZiYWU5YjIxMTBhYjEwZjJiYTRjY2ZiNzI5NTg2N2VkNjVjOTYyNQ",
    descripcion: "Motocicleta deportiva de estilo streetfighter dentro de la línea Vort-X de Italika, con chasis tipo trellis y horquilla telescópica invertida dorada. Alcanza hasta 135 km/h e incorpora tablero digital a color, puertos USB y GPS integrado.",
    colores: ["Rojo con Negro"],
    fuentes: ["https://www.italika.mx/p/IM-250-ROJO-GPS-2026-MX", "https://www.motofichas.com.mx/motos/italika/vort-x-250"],
    destacada: true,
  ),
  Moto(
    id: 23,
    marcaId: "italika",
    modelo: "250Z 4V",
    categoria: "Naked",
    anio: 2026,
    cilindrada: 249,
    potencia: 22.1,
    torque: 17.7,
    peso: 122,
    tipoPeso: "seco",
    tanque: 15.0,
    alturaAsiento: 790,
    precio: 57499.0,
    motor: "Monocilíndrico 4 tiempos, 4 válvulas, OHC, radiador de aceite y aire forzado",
    transmision: "Manual de 6 velocidades por cadena con embrague antirrebote (Slipper Clutch)",
    imagen: "https://www.italika.mx/medias/IM-250Z-4V-GRAFITO-GPS-2026-MX.webp?context=bWFzdGVyfDI1MFogNFYtR1JBRklUTy1HUFMtMjAyNi1NWHwxMTM1MzR8aW1hZ2Uvd2VicHxhREV4TDJnd05DOHhNREUwTWprME1UWTBNamM0TWk5SlRTMHlOVEJhSURSV0xVZFNRVVpKVkU4dFIxQlRMVEl3TWpZdFRWZ3VkMlZpY0F8NTgwMDk3ZTI1Mzg1NjVmZTNiZGI5MTVlOThkOWIzNzY1NTM3NWUxNDYzZWQ2NzA4Yzk4YTAxNmQwMmM3N2RmOQ",
    descripcion: "Naked de nueva plataforma modular equipada con motor monocilíndrico de 4 válvulas, radiador de aceite y embrague antirrebote. Suma iluminación LED con función Autolamp, tablero digital a color, puertos USB y rastreador GPS.",
    colores: ["Grafito"],
    fuentes: ["https://www.italika.mx/italika-250z-4v-grafito-con-gps-101168/p", "https://www.motofichas.com.mx/motos/italika/250z"],
  ),
  Moto(
    id: 24,
    marcaId: "italika",
    modelo: "D150 LT",
    categoria: "Urbana",
    anio: 2026,
    cilindrada: 149,
    potencia: 8.6,
    torque: 10.0,
    peso: null,
    tipoPeso: "seco",
    tanque: 7.0,
    alturaAsiento: 775,
    precio: 19999.0,
    motor: "Monocilíndrico 4 tiempos, enfriado por aire",
    transmision: "Automática",
    imagen: "https://www.italika.mx/medias/IM-D150-GRIS-LT-2026-MX.webp?context=bWFzdGVyfEQxNTAtR1JJUy0yMDI2LU1YfDIyOTAyNHxpbWFnZS93ZWJwfGFHTXdMMmd4WVM4eE1ERTBPRGd4TmpVMU1UazJOaTlKVFMxRU1UVXdMVWRTU1ZNdFRGUXRNakF5TmkxTldDNTNaV0p3fGNmZGYxNWQzODgwM2YzNmQxN2I4MzI4Nzc2MzEwMzRjYTQzOGUxYTRjMDEzMTFhYjdmNGU0ZDk5OGRkNTYyZmY",
    descripcion: "Motoneta urbana de entrada pensada para traslados cotidianos económicos en ciudad, con transmisión automática y rendimiento de hasta 40 km/L. Incluye faro LED delantero, tablero digital y puertos de carga USB A y C.",
    colores: ["Gris con Naranja"],
    fuentes: ["https://www.italika.mx/italika-d150-lt-gris-con-naranja/p/12150270156", "https://www.italika.mx/medias/FITE-D150LT-GRISNARANJA-VUELTA-2026-MX.pdf?context=bWFzdGVyfHJvb3R8MTU4Nzg4M3xhcHBsaWNhdGlvbi9wZGZ8aDM4L2g5My85NjM5NTA1Mzk5ODM4LnBkZnw4MzhmNGNmMmVkNTQwNDNkZjg4MGY4OTkyMTI3ZWE4YzEyZTFhZjZjYTA2OGIxZDFhY2EzNWY5YWViMjgzN2Q3", "https://www.motofichas.com.mx/motos/italika/d150"],
  ),
  Moto(
    id: 25,
    marcaId: "italika",
    modelo: "DM250",
    categoria: "Aventura",
    anio: 2026,
    cilindrada: 250,
    potencia: 16.2,
    torque: 16.5,
    peso: 123,
    tipoPeso: "orden de marcha",
    tanque: 11.0,
    alturaAsiento: 870,
    precio: 51999.0,
    motor: "Monocilíndrico 4 tiempos, enfriado por aire",
    transmision: "Manual de 5 velocidades por cadena",
    imagen: "https://www.italika.mx/medias/IM-DM250-VERDE-GPS-2026-MX.webp?context=bWFzdGVyfERNMjUwLVZFUkRFLTIwMjYtTVh8MjQxNzk4fGltYWdlL3dlYnB8YURnNUwyZ3hOQzh4TURFeE5qRXlNemM0TnpJNU5DOUpUUzFFVFRJMU1DMVdSVkpFUlMxSFVGTXRNakF5TmkxTldDNTNaV0p3fDBjYjBhYTAwMmM5Y2UwNmRiNDY5Y2QzNWZjMDJiYTQ4YTk2YjM1YjgzODlmNjNmNzYzY2M2YmNhNDhjZDkzZDg",
    descripcion: "Motocicleta doble propósito de 250 cc con asiento elevado a 870 mm, frenos de disco en ambas ruedas y suspensión monoshock trasera. Está orientada al uso mixto urbano y de terracería moderada con GPS integrado de fábrica.",
    colores: ["Negra con Verde"],
    fuentes: ["https://www.italika.mx/italika-dm250-con-gps-negra-con-verde/p/11250180262", "https://www.motofichas.com.mx/motos/italika/dm250"],
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
