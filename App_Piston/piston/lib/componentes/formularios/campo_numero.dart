import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Campo numérico (enteros o decimales) reutilizable.
class CampoNumero extends StatelessWidget {
  const CampoNumero({
    super.key,
    required this.etiqueta,
    this.controlador,
    this.validator,
    this.icono,
    this.decimal = false,
    this.hint,
    this.onChanged,
    this.habilitado = true,
  });

  final String etiqueta;
  final TextEditingController? controlador;
  final String? Function(String?)? validator;
  final IconData? icono;
  final bool decimal;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final bool habilitado;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      validator: validator,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          decimal ? RegExp(r'[0-9.,]') : RegExp(r'[0-9]'),
        ),
      ],
      onChanged: onChanged,
      enabled: habilitado,
      decoration: InputDecoration(
        labelText: etiqueta,
        hintText: hint,
        prefixIcon: icono == null ? null : Icon(icono, size: 20),
      ),
    );
  }
}
