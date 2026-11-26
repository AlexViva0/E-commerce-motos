import 'package:flutter/material.dart';
import 'package:shop/models/moto_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants.dart';

/// Encabezado de la ficha: marca, modelo, etiquetas y descripción.
class ProductInfo extends StatelessWidget {
  const ProductInfo({super.key, required this.moto});

  final Moto moto;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(defaultPadding),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              moto.marca.nombre.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              moto.modelo,
              maxLines: 2,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: defaultPadding),
            Wrap(
              spacing: defaultPadding / 2,
              runSpacing: defaultPadding / 2,
              children: [
                _Etiqueta(moto.categoria, color: primaryColor),
                _Etiqueta("Modelo ${moto.anio}", color: successColor),
                _Etiqueta(moto.marca.pais, color: blackColor60),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Text(
              "Descripción",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(moto.descripcion, style: const TextStyle(height: 1.4)),
          ],
        ),
      ),
    );
  }
}

class _Etiqueta extends StatelessWidget {
  const _Etiqueta(this.texto, {required this.color});

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding * 0.75, vertical: defaultPadding / 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            const BorderRadius.all(Radius.circular(defaultBorderRadious / 2)),
      ),
      child: Text(
        texto,
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}

/// Cuadrícula con la ficha técnica: cilindrada, potencia, peso, etc.
class FichaTecnica extends StatelessWidget {
  const FichaTecnica({super.key, required this.moto});

  final Moto moto;

  @override
  Widget build(BuildContext context) {
    final datos = <(IconData, String, String)>[
      (Icons.speed_rounded, "Cilindrada", "${moto.cilindrada} cc"),
      (Icons.bolt_rounded, "Potencia", "${_num(moto.potencia)} hp"),
      if (moto.torque != null)
        (Icons.rotate_right_rounded, "Torque", "${_num(moto.torque!)} Nm"),
      (
        Icons.fitness_center_rounded,
        moto.tipoPeso == "seco" ? "Peso en seco" : "Peso",
        moto.peso == null ? "N/D" : "${moto.peso} kg"
      ),
      if (moto.pesoPorHp != null)
        (
          Icons.balance_rounded,
          "Peso / potencia",
          "${moto.pesoPorHp!.toStringAsFixed(1)} kg/hp"
        ),
      if (moto.tanque != null)
        (Icons.local_gas_station_rounded, "Tanque", "${_num(moto.tanque!)} L"),
      if (moto.alturaAsiento != null)
        (Icons.event_seat_rounded, "Asiento", "${moto.alturaAsiento} mm"),
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ficha técnica",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: defaultPadding),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: defaultPadding / 2,
              crossAxisSpacing: defaultPadding / 2,
              childAspectRatio: 2.2,
              children: [
                for (final (icono, nombre, valor) in datos)
                  _Dato(icono: icono, nombre: nombre, valor: valor),
              ],
            ),
            const SizedBox(height: defaultPadding),
            _Fila("Motor", moto.motor),
            _Fila("Transmisión", moto.transmision),
            _Fila("Colores", moto.colores.join(", ")),
            const SizedBox(height: defaultPadding / 2),
            if (moto.fuentes.isNotEmpty) ...[
              Text(
                "Fuentes (consultadas en noviembre de 2026)",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              for (final url in moto.fuentes)
                InkWell(
                  onTap: () => launchUrl(Uri.parse(url),
                      mode: LaunchMode.externalApplication),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      Uri.parse(url).host.replaceFirst("www.", ""),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: primaryColor,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
            ] else
              Text(
                "Datos de referencia.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }

  static String _num(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
}

class _Dato extends StatelessWidget {
  const _Dato({required this.icono, required this.nombre, required this.valor});

  final IconData icono;
  final String nombre, valor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding * 0.75),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius:
            const BorderRadius.all(Radius.circular(defaultBorderRadious)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icono, color: primaryColor, size: 20),
          ),
          const SizedBox(width: defaultPadding / 2),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(valor,
                      style: Theme.of(context).textTheme.titleSmall),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Fila extends StatelessWidget {
  const _Fila(this.nombre, this.valor);

  final String nombre, valor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(nombre, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(valor,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
