import 'package:flutter/material.dart';

import '../constants.dart';

const Color _amberAccent = Color(0xFFFFB020);

/// Tarjeta individual de especificación técnica para una motocicleta.
class MotoSpecItem extends StatelessWidget {
  const MotoSpecItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final Color accent = highlight ? _amberAccent : primaryColor;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: lightGreyColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight ? _amberAccent.withOpacity(0.45) : blackColor10,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  icon,
                  size: 17,
                  color: accent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                    color: blackColor60,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: grandisExtendedFont,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: blackColor,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Grilla 2x3 de especificaciones técnicas de motocicleta (Motor, Potencia,
/// Torque, Peso, Asiento y Tanque) con tipografía Grandis Extended para valores.
class MotoSpecGrid extends StatelessWidget {
  const MotoSpecGrid({
    super.key,
    this.title = "Ficha Técnica",
    this.subtitle = "Rendimiento y dimensiones",
    this.motor = "998",
    this.potencia = "215",
    this.torque = "123",
    this.peso = "195",
    this.asiento = "850",
    this.tanque = "17",
    this.items,
  });

  final String title;
  final String subtitle;
  final String motor;
  final String potencia;
  final String torque;
  final String peso;
  final String asiento;
  final String tanque;
  final List<MotoSpecItem>? items;

  List<MotoSpecItem> get _resolvedItems =>
      items ??
      [
        MotoSpecItem(
          icon: Icons.settings_input_component_rounded,
          label: "Motor",
          value: motor,
          unit: "cc",
        ),
        MotoSpecItem(
          icon: Icons.bolt_rounded,
          label: "Potencia",
          value: potencia,
          unit: "hp",
          highlight: true,
        ),
        MotoSpecItem(
          icon: Icons.speed_rounded,
          label: "Torque",
          value: torque,
          unit: "Nm",
        ),
        MotoSpecItem(
          icon: Icons.fitness_center_rounded,
          label: "Peso",
          value: peso,
          unit: "kg",
        ),
        MotoSpecItem(
          icon: Icons.height_rounded,
          label: "Asiento",
          value: asiento,
          unit: "mm",
        ),
        MotoSpecItem(
          icon: Icons.local_gas_station_rounded,
          label: "Tanque",
          value: tanque,
          unit: "L",
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final specs = _resolvedItems;
    final List<Widget> rows = [];

    for (int i = 0; i < specs.length; i += 2) {
      final hasSecond = i + 1 < specs.length;
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: i + 2 < specs.length ? 12 : 0),
          child: Row(
            children: [
              Expanded(child: specs[i]),
              const SizedBox(width: 12),
              Expanded(
                child: hasSecond ? specs[i + 1] : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: grandisExtendedFont,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: blackColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: blackColor60,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: blackColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "SPECS",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: whiteColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: defaultPadding),
        ...rows,
      ],
    );
  }
}
