import 'package:flutter/material.dart';

/// Campo de texto con la estética de los formularios del taller.
class CampoTexto extends StatelessWidget {
  const CampoTexto({
    super.key,
    required this.etiqueta,
    this.controlador,
    this.validator,
    this.hint,
    this.icono,
    this.maxLines = 1,
    this.obscure = false,
    this.sufijo,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.habilitado = true,
  });

  final String etiqueta;
  final TextEditingController? controlador;
  final String? Function(String?)? validator;
  final String? hint;
  final IconData? icono;
  final int maxLines;
  final bool obscure;
  final Widget? sufijo;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final bool habilitado;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      validator: validator,
      obscureText: obscure,
      maxLines: obscure ? 1 : maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      enabled: habilitado,
      decoration: InputDecoration(
        labelText: etiqueta,
        hintText: hint,
        prefixIcon: icono == null ? null : Icon(icono, size: 20),
        suffixIcon: sufijo,
      ),
    );
  }
}
