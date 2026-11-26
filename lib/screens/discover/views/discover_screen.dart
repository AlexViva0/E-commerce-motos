import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:catalogo_motos/constants.dart';
import 'package:catalogo_motos/models/moto_model.dart';
import 'package:catalogo_motos/route/route_constants.dart';
import 'package:catalogo_motos/screens/search/views/components/search_form.dart';
import 'package:catalogo_motos/screens/search/views/search_screen.dart';

/// Explorar: acceso al catálogo por categoría y por marca.
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, searchScreenRoute),
                child: const AbsorbPointer(child: SearchForm()),
              ),
            ),
            const _Seccion("Categorías"),
            for (final c in categorias)
              ListTile(
                minLeadingWidth: 24,
                leading: SvgPicture.asset(
                  iconoCategoria[c]!,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).iconTheme.color!, BlendMode.srcIn),
                ),
                title: Text(c),
                trailing: Text("${motosPorCategoria(c).length}"),
                onTap: () => Navigator.pushNamed(context, searchScreenRoute,
                    arguments: c),
              ),
            const _Seccion("Marcas"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: defaultPadding / 2,
                crossAxisSpacing: defaultPadding / 2,
                childAspectRatio: 0.85,
                children: [for (final m in marcas) _TarjetaMarca(marca: m)],
              ),
            ),
            const SizedBox(height: defaultPadding),
          ],
        ),
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  const _Seccion(this.titulo);

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          defaultPadding, defaultPadding, defaultPadding, defaultPadding / 2),
      child: Text(titulo, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class _TarjetaMarca extends StatelessWidget {
  const _TarjetaMarca({required this.marca});

  final Marca marca;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(8)),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SearchScreen(marcaId: marca.id)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.all(Radius.circular(defaultBorderRadious)),
              ),
              child: Image.asset(marca.logo, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          Text(marca.nombre,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 12,
                  )),
          Text("${motosPorMarca(marca.id).length} motos",
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
