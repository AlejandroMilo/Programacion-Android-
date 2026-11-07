import 'package:flutter/material.dart';

import '../../componentes/botones/boton_principal.dart';
import '../../componentes/formularios/campo_numero.dart';
import '../../componentes/formularios/campo_texto.dart';
import '../../utilidades/validaciones.dart';

class FormularioTrabajo extends StatefulWidget {
  const FormularioTrabajo({super.key});

  static Future<({String descripcion, double precio})?> mostrar(
    BuildContext context,
  ) {
    return showModalBottomSheet<({String descripcion, double precio})>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const FormularioTrabajo(),
      ),
    );
  }

  @override
  State<FormularioTrabajo> createState() => _FormularioTrabajoState();
}

class _FormularioTrabajoState extends State<FormularioTrabajo> {
  final _formKey = GlobalKey<FormState>();
  final _descripcion = TextEditingController();
  final _precio = TextEditingController();

  @override
  void dispose() {
    _descripcion.dispose();
    _precio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 18),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Agregar trabajo',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'Mano de obra realizada en esta orden.',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).hintColor,
                ),
              ),
              const SizedBox(height: 14),
              CampoTexto(
                etiqueta: 'Descripción',
                controlador: _descripcion,
                icono: Icons.build_outlined,
                hint: 'Ej. Cambio de aceite y filtro',
                validator: (v) =>
                    Validaciones.requerido(v, campo: 'La descripción'),
              ),
              const SizedBox(height: 12),
              CampoNumero(
                etiqueta: 'Precio de mano de obra',
                controlador: _precio,
                decimal: true,
                icono: Icons.attach_money_rounded,
                validator: (v) => Validaciones.monto(v),
              ),
              const SizedBox(height: 18),
              BotonPrincipal(
                texto: 'Agregar trabajo',
                icono: Icons.add_rounded,
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  Navigator.of(context).pop((
                    descripcion: _descripcion.text.trim(),
                    precio: double.parse(
                      _precio.text.replaceAll(',', '.'),
                    ),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
