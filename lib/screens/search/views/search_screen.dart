import 'package:flutter/material.dart';
import 'package:shop/components/moto_card.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/moto_model.dart';
import 'package:shop/screens/home/views/components/categories.dart';

import 'components/search_form.dart';

enum Orden {
  relevancia("Relevancia"),
  precioMenor("Precio: menor a mayor"),
  precioMayor("Precio: mayor a menor"),
  potencia("Más potencia"),
  ligera("Más ligera");

  const Orden(this.nombre);
  final String nombre;
}

/// Búsqueda con filtro por categoría y orden. Puede recibir una categoría
/// inicial como argumento de la ruta.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.categoriaInicial, this.marcaId});

  final String? categoriaInicial;
  final String? marcaId;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String _categoria = widget.categoriaInicial ?? todasLasCategorias;
  String _texto = "";
  Orden _orden = Orden.relevancia;

  List<Moto> get _resultados {
    final lista = motosPorCategoria(_categoria)
        .where((m) => widget.marcaId == null || m.marcaId == widget.marcaId)
        .where((m) => m.coincideCon(_texto))
        .toList();
    switch (_orden) {
      case Orden.relevancia:
        break;
      case Orden.precioMenor:
        lista.sort((a, b) => a.precio.compareTo(b.precio));
      case Orden.precioMayor:
        lista.sort((a, b) => b.precio.compareTo(a.precio));
      case Orden.potencia:
        lista.sort((a, b) => b.potencia.compareTo(a.potencia));
      case Orden.ligera:
        lista.sort((a, b) => a.peso.compareTo(b.peso));
    }
    return lista;
  }

  void _elegirOrden() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: RadioGroup<Orden>(
          groupValue: _orden,
          onChanged: (o) {
            setState(() => _orden = o!);
            Navigator.pop(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Ordenar por",
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: defaultPadding / 2),
              for (final o in Orden.values)
                RadioListTile<Orden>(value: o, title: Text(o.nombre)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultados = _resultados;
    final marca = widget.marcaId == null
        ? null
        : marcas.firstWhere((m) => m.id == widget.marcaId);

    return Scaffold(
      appBar: AppBar(title: Text(marca?.nombre ?? "Buscar motos")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                defaultPadding, defaultPadding / 2, defaultPadding, defaultPadding),
            child: SearchForm(
              autofocus: widget.categoriaInicial == null && marca == null,
              onChanged: (t) => setState(() => _texto = t ?? ""),
              onTabFilter: _elegirOrden,
            ),
          ),
          Categories(
            seleccionada: _categoria,
            alSeleccionar: (c) => setState(() => _categoria = c),
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(
              "${resultados.length} ${resultados.length == 1 ? "moto" : "motos"}"
              "${_orden == Orden.relevancia ? "" : " · ${_orden.nombre}"}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: resultados.isEmpty
                ? const _SinResultados()
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(
                        defaultPadding, 0, defaultPadding, defaultPadding),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.0,
                      mainAxisSpacing: defaultPadding,
                      crossAxisSpacing: defaultPadding,
                      childAspectRatio: 0.66,
                    ),
                    itemCount: resultados.length,
                    itemBuilder: (context, i) => MotoCard(moto: resultados[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SinResultados extends StatelessWidget {
  const _SinResultados();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.two_wheeler_rounded,
                size: 64, color: primaryColor.withValues(alpha: 0.5)),
            const SizedBox(height: defaultPadding),
            Text("No encontramos motos",
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: defaultPadding / 2),
            const Text("Prueba con otra palabra o cambia la categoría.",
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
