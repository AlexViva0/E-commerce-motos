import 'package:flutter/material.dart';
import 'package:catalogo_motos/components/moto_card.dart';
import 'package:catalogo_motos/constants.dart';
import 'package:catalogo_motos/models/moto_model.dart';
import 'package:catalogo_motos/route/route_constants.dart';

import 'components/categories.dart';
import 'components/offers_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _categoria = todasLasCategorias;

  @override
  Widget build(BuildContext context) {
    final filtradas = motosPorCategoria(_categoria);
    final economicas = [...motos]..sort((a, b) => a.precio.compareTo(b.precio));
    final potentes = [...motos]
      ..sort((a, b) => b.potencia.compareTo(a.potencia));

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    defaultPadding, defaultPadding * 1.25, defaultPadding, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        "Explorar",
                        style: TextStyle(
                          fontFamily: grandisExtendedFont,
                          fontWeight: FontWeight.w800,
                          fontSize: 34,
                          height: 1,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      "${motos.length} MODELOS",
                      style: TextStyle(
                        fontFamily: monoFont,
                        fontSize: 12,
                        letterSpacing: 1,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: OffersCarousel()),
            SliverToBoxAdapter(
              child: _Titulo(
                "Categorías",
                accion: "Buscar",
                alTocar: () => Navigator.pushNamed(context, searchScreenRoute,
                    arguments: _categoria),
              ),
            ),
            SliverToBoxAdapter(
              child: Categories(
                seleccionada: _categoria,
                alSeleccionar: (c) => setState(() => _categoria = c),
              ),
            ),
            SliverToBoxAdapter(
              child: _Titulo(_categoria == todasLasCategorias
                  ? "Todas las motos"
                  : "Motos $_categoria"),
            ),
            SliverToBoxAdapter(child: _FilaMotos(motos: filtradas)),
            const SliverToBoxAdapter(child: _Titulo("Más potentes")),
            SliverToBoxAdapter(child: _FilaMotos(motos: potentes.take(5))),
            const SliverToBoxAdapter(child: _Titulo("Para empezar")),
            SliverList.builder(
              itemCount: 4,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.fromLTRB(
                    defaultPadding, 0, defaultPadding, defaultPadding),
                child: MotoCardHorizontal(moto: economicas[i]),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: defaultPadding)),
          ],
        ),
      ),
    );
  }
}

class _Titulo extends StatelessWidget {
  const _Titulo(this.texto, {this.accion, this.alTocar});

  final String texto;
  final String? accion;
  final VoidCallback? alTocar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(defaultPadding, defaultPadding * 1.5,
          defaultPadding / 2, defaultPadding),
      child: Row(
        children: [
          Expanded(
            child: Text(texto, style: Theme.of(context).textTheme.titleSmall),
          ),
          if (accion != null)
            TextButton(onPressed: alTocar, child: Text(accion!)),
        ],
      ),
    );
  }
}

class _FilaMotos extends StatelessWidget {
  const _FilaMotos({required this.motos});

  final Iterable<Moto> motos;

  @override
  Widget build(BuildContext context) {
    final lista = motos.toList();
    return SizedBox(
      height: 220,
      child: AnimatedSwitcher(
        duration: defaultDuration,
        child: ListView.builder(
          key: ValueKey(lista.map((m) => m.id).join(",")),
          scrollDirection: Axis.horizontal,
          itemCount: lista.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(
              left: defaultPadding,
              right: index == lista.length - 1 ? defaultPadding : 0,
            ),
            child: MotoCard(moto: lista[index]),
          ),
        ),
      ),
    );
  }
}
