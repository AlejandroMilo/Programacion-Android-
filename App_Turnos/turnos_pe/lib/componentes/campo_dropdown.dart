import 'package:flutter/material.dart';

import '../tema/tema_app.dart';
import 'componentes.dart';

/// Selector desplegable con etiqueta, icono y error, usado en el formulario
/// de turno.
class CampoDropdown<T> extends StatelessWidget {
  const CampoDropdown({
    super.key,
    this.etiqueta,
    required this.hint,
    required this.valor,
    required this.opciones,
    required this.onChanged,
    this.focusNode,
    this.error,
    this.icono,
    this.opcionesSeleccionadas,
  });

  final String? etiqueta;
  final String hint;
  final T? valor;
  final List<DropdownMenuItem<T>> opciones;
  final ValueChanged<T?>? onChanged;
  final FocusNode? focusNode;
  final String? error;
  final IconData? icono;

  /// Contenido a mostrar cuando la opcion esta seleccionada.
  final List<Widget>? opcionesSeleccionadas;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (etiqueta != null) ...[
          EtiquetaCampo(etiqueta!, error: error != null),
          const SizedBox(height: 4),
        ],
        Container(
          height: AppTheme.altoCampo,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radioCampos),
            border: Border.all(
              color: error != null ? esquema.error : esquema.outline,
              width: error != null ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              if (icono != null) ...[
                Icon(icono, size: 18, color: esquema.onSurfaceVariant),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: valor,
                    isExpanded: true,
                    isDense: true,
                    hint: Text(
                      hint,
                      style: textos.bodyMedium?.copyWith(
                        color: esquema.onSurfaceVariant,
                      ),
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: esquema.onSurfaceVariant,
                    ),
                    iconSize: 18,
                    dropdownColor: esquema.surface,
                    borderRadius: BorderRadius.circular(AppTheme.radioCampos),
                    focusNode: focusNode,
                    selectedItemBuilder: opcionesSeleccionadas == null
                        ? null
                        : (context) => opcionesSeleccionadas!,
                    items: opciones,
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 4),
          MensajeError(error!),
        ],
      ],
    );
  }
}
