import 'package:flutter/material.dart';
import 'package:shop/components/filtros/filtros_sheet.dart';
import 'package:shop/components/moto_card.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/moto_model.dart';
import 'package:shop/screens/home/views/components/categories.dart';

import 'components/active_filters_bar.dart';
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

/// Búsqueda con filtros avanzados, chips de filtros activos y orden.
/// Puede recibir una categoría inicial o una marca inicial.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.categoriaInicial, this.marcaId});

  final String? categoriaInicial;
  final String? marcaId;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;
  late FiltrosMotos _filtros;
  String _texto = "";
  Orden _orden = Orden.relevancia;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filtros = FiltrosMotos(
      categoriasSeleccionadas: widget.categoriaInicial != null &&
              widget.categoriaInicial != todasLasCategorias
          ? {widget.categoriaInicial!}
          : const {},
      marcasIds: widget.marcaId != null ? {widget.marcaId!} : const {},
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _categoriaBarra {
    if (_filtros.categoriasSeleccionadas.isEmpty) return todasLasCategorias;
    if (_filtros.categoriasSeleccionadas.length == 1) {
      return _filtros.categoriasSeleccionadas.first;
    }
    return "";
  }

  List<Moto> get _resultados {
    final lista = _filtros.aplicar(motos, texto: _texto);
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
        lista.sort((a, b) => (a.peso ?? 9999).compareTo(b.peso ?? 9999));
    }
    return lista;
  }

  Future<void> _abrirFiltros() async {
    FocusScope.of(context).unfocus();
    final resultado = await mostrarFiltrosSheet(
      context,
      filtrosActuales: _filtros,
      textoBusqueda: _texto,
    );
    if (resultado != null && mounted) {
      setState(() => _filtros = resultado);
    }
  }

  void _limpiarFiltros() {
    setState(() => _filtros = FiltrosMotos());
  }

  void _limpiarTodo() {
    _searchController.clear();
    setState(() {
      _texto = "";
      _filtros = FiltrosMotos();
    });
  }

  void _elegirOrden() {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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

  String _tituloAppBar() {
    if (widget.marcaId != null &&
        _filtros.marcasIds.length == 1 &&
        _filtros.marcasIds.contains(widget.marcaId)) {
      final encontrada = marcas.where((m) => m.id == widget.marcaId);
      if (encontrada.isNotEmpty) return encontrada.first.nombre;
    }
    return "Buscar motos";
  }

  @override
  Widget build(BuildContext context) {
    final resultados = _resultados;

    return Scaffold(
      appBar: AppBar(title: Text(_tituloAppBar())),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              defaultPadding,
              defaultPadding / 2,
              defaultPadding,
              defaultPadding * 0.75,
            ),
            child: Row(
              children: [
                Expanded(
                  child: SearchForm(
                    controller: _searchController,
                    autofocus: widget.categoriaInicial == null &&
                        widget.marcaId == null,
                    showFilterButton: false,
                    showClearButton: _texto.isNotEmpty,
                    onClear: () {
                      _searchController.clear();
                      setState(() => _texto = "");
                    },
                    onChanged: (t) => setState(() => _texto = t ?? ""),
                  ),
                ),
                const SizedBox(width: 10),
                FilterIconButton(
                  filtrosActivos: _filtros.cantidadActivos,
                  onTap: _abrirFiltros,
                ),
              ],
            ),
          ),
          ActiveFiltersBar(
            filtros: _filtros,
            onCambiar: (nuevo) => setState(() => _filtros = nuevo),
            onLimpiarTodo: _limpiarFiltros,
          ),
          Categories(
            seleccionada: _categoriaBarra,
            alSeleccionar: (c) => setState(() {
              _filtros = _filtros.copyWith(
                categoriasSeleccionadas:
                    c == todasLasCategorias ? const {} : {c},
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              defaultPadding,
              defaultPadding * 0.75,
              defaultPadding,
              defaultPadding * 0.75,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "${resultados.length} ${resultados.length == 1 ? "moto" : "motos"}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                _BotonOrden(
                  orden: _orden,
                  onTap: _elegirOrden,
                ),
              ],
            ),
          ),
          Expanded(
            child: resultados.isEmpty
                ? _SinResultados(
                    hayFiltros: _filtros.hayFiltrosActivos,
                    hayTexto: _texto.trim().isNotEmpty,
                    onAjustarFiltros: _abrirFiltros,
                    onLimpiarTodo: _limpiarTodo,
                  )
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

class _BotonOrden extends StatelessWidget {
  const _BotonOrden({required this.orden, required this.onTap});

  final Orden orden;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activo = orden != Orden.relevancia;

    return Material(
      color: activo ? colorScheme.primaryContainer : Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: activo ? colorScheme.primary : theme.dividerColor,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.swap_vert_rounded,
                size: 16,
                color: activo
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
              ),
              const SizedBox(width: 4),
              Text(
                orden.nombre,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontSize: 12,
                  color: activo
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SinResultados extends StatelessWidget {
  const _SinResultados({
    required this.hayFiltros,
    required this.hayTexto,
    required this.onAjustarFiltros,
    required this.onLimpiarTodo,
  });

  final bool hayFiltros;
  final bool hayTexto;
  final VoidCallback onAjustarFiltros;
  final VoidCallback onLimpiarTodo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final mensaje = hayFiltros && hayTexto
        ? "Ninguna moto coincide con tu búsqueda y los filtros seleccionados."
        : hayFiltros
            ? "Prueba ampliar el rango de precio o cilindrada, o quitar algún filtro activo."
            : "Prueba con otro modelo, marca, categoría o cilindrada.";

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding * 1.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.two_wheeler_rounded,
                size: 46,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: defaultPadding),
            Text(
              "No encontramos motos",
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: defaultPadding / 2),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: Text(
                mensaje,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            if (hayFiltros || hayTexto) ...[
              const SizedBox(height: defaultPadding * 1.25),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                    ),
                    onPressed: onLimpiarTodo,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(
                      hayFiltros && !hayTexto
                          ? "Limpiar filtros"
                          : "Restablecer todo",
                    ),
                  ),
                  if (hayFiltros)
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 44),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                      ),
                      onPressed: onAjustarFiltros,
                      icon: const Icon(Icons.tune_rounded, size: 18),
                      label: const Text("Ajustar filtros"),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
