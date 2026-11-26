import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:catalogo_motos/theme/input_decoration_theme.dart';

class SearchForm extends StatelessWidget {
  const SearchForm({
    super.key,
    this.formKey,
    this.controller,
    this.isEnabled = true,
    this.onSaved,
    this.validator,
    this.onChanged,
    this.onTabFilter,
    this.onClear,
    this.onFieldSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.showClearButton = false,
    this.showFilterButton = true,
    this.filterCount = 0,
  });

  final GlobalKey<FormState>? formKey;
  final TextEditingController? controller;
  final bool isEnabled;
  final ValueChanged<String?>? onSaved, onChanged, onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onTabFilter, onClear;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool showClearButton;
  final bool showFilterButton;
  final int filterCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor =
        Theme.of(context).iconTheme.color ?? colorScheme.onSurface;

    return Form(
      key: formKey,
      child: TextFormField(
        controller: controller,
        autofocus: autofocus,
        focusNode: focusNode,
        enabled: isEnabled,
        onChanged: onChanged,
        onSaved: onSaved,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Busca por modelo, marca o cc...",
          filled: false,
          border: secodaryOutlineInputBorder(context),
          enabledBorder: secodaryOutlineInputBorder(context),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.asset(
              "assets/icons/Search.svg",
              height: 22,
              colorFilter: ColorFilter.mode(
                iconColor.withValues(alpha: 0.45),
                BlendMode.srcIn,
              ),
            ),
          ),
          suffixIcon: _buildSuffix(context, iconColor, colorScheme),
        ),
      ),
    );
  }

  Widget? _buildSuffix(
    BuildContext context,
    Color iconColor,
    ColorScheme colorScheme,
  ) {
    if (!showClearButton && !showFilterButton) return null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showClearButton)
          IconButton(
            tooltip: "Limpiar búsqueda",
            onPressed: onClear,
            icon: Icon(
              Icons.close_rounded,
              size: 20,
              color: iconColor.withValues(alpha: 0.65),
            ),
          ),
        if (showFilterButton) ...[
          const SizedBox(
            height: 24,
            child: VerticalDivider(width: 1),
          ),
          IconButton(
            tooltip: "Filtros",
            onPressed: onTabFilter,
            icon: Badge(
              isLabelVisible: filterCount > 0,
              label: Text("$filterCount"),
              backgroundColor: colorScheme.primary,
              textColor: colorScheme.onPrimary,
              child: SvgPicture.asset(
                "assets/icons/Filter.svg",
                height: 22,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
