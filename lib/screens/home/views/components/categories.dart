import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:catalogo_motos/models/moto_model.dart';

import '../../../../constants.dart';

/// Fila horizontal de categorías de motos. Marca la [seleccionada] y avisa
/// con [alSeleccionar] cuando el usuario toca otra.
class Categories extends StatelessWidget {
  const Categories({
    super.key,
    required this.seleccionada,
    required this.alSeleccionar,
  });

  final String seleccionada;
  final ValueChanged<String> alSeleccionar;

  @override
  Widget build(BuildContext context) {
    final opciones = [todasLasCategorias, ...categorias];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          opciones.length,
          (index) => Padding(
            padding: EdgeInsets.only(
                left: index == 0 ? defaultPadding : defaultPadding / 2,
                right: index == opciones.length - 1 ? defaultPadding : 0),
            child: CategoryBtn(
              category: opciones[index],
              svgSrc: iconoCategoria[opciones[index]],
              isActive: opciones[index] == seleccionada,
              press: () => alSeleccionar(opciones[index]),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryBtn extends StatelessWidget {
  const CategoryBtn({
    super.key,
    required this.category,
    this.svgSrc,
    required this.isActive,
    required this.press,
  });

  final String category;
  final String? svgSrc;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      child: AnimatedContainer(
        duration: defaultDuration,
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.transparent,
          border: Border.all(
              color: isActive
                  ? Colors.transparent
                  : Theme.of(context).dividerColor),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          children: [
            if (svgSrc != null)
              SvgPicture.asset(
                svgSrc!,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isActive ? Colors.white : Theme.of(context).iconTheme.color!,
                  BlendMode.srcIn,
                ),
              ),
            if (svgSrc != null) const SizedBox(width: defaultPadding / 2),
            Text(
              category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
