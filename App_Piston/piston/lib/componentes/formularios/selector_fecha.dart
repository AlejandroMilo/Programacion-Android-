import 'package:flutter/material.dart';

import '../../utilidades/formatos.dart';

/// Selector de fecha con el estilo de los formularios.
class SelectorFecha extends StatelessWidget {
  const SelectorFecha({
    super.key,
    required this.etiqueta,
    required this.fecha,
    required this.onCambio,
    this.primera,
    this.ultima,
    this.icono = Icons.calendar_month_rounded,
  });

  final String etiqueta;
  final DateTime fecha;
  final ValueChanged<DateTime> onCambio;
  final DateTime? primera;
  final DateTime? ultima;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        final elegida = await showDatePicker(
          context: context,
          initialDate: fecha,
          firstDate: primera ?? DateTime(2000),
          lastDate: ultima ?? DateTime.now().add(const Duration(days: 365)),
          helpText: etiqueta,
          cancelText: 'Cancelar',
          confirmText: 'Aceptar',
        );
        if (elegida != null) onCambio(elegida);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: etiqueta,
          prefixIcon: Icon(icono, size: 20),
        ),
        child: Text(
          Formatos.fecha(fecha),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
