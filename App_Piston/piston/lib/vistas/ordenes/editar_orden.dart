import 'package:flutter/material.dart';

import '../../componentes/formularios/campo_numero.dart';
import '../../componentes/formularios/campo_texto.dart';
import '../../componentes/formularios/selector_fecha.dart';
import '../../datos/base_datos.dart';
import '../../modelos/orden_servicio.dart';
import '../../utilidades/validaciones.dart';

typedef DatosEdicionOrden = ({
  DateTime fecha,
  String problema,
  int kilometraje,
  String notas,
  int? mecanicoId,
});

class EditarOrdenDialog extends StatefulWidget {
  const EditarOrdenDialog({
    super.key,
    required this.orden,
    required this.mecanicos,
  });

  final OrdenResumen orden;
  final List<Mecanico> mecanicos;

  static Future<DatosEdicionOrden?> mostrar(
    BuildContext context, {
    required OrdenResumen orden,
    required List<Mecanico> mecanicos,
  }) {
    return showDialog<DatosEdicionOrden>(
      context: context,
      builder: (_) => EditarOrdenDialog(orden: orden, mecanicos: mecanicos),
    );
  }

  @override
  State<EditarOrdenDialog> createState() => _EditarOrdenDialogState();
}

class _EditarOrdenDialogState extends State<EditarOrdenDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _problema;
  late final TextEditingController _notas;
  late final TextEditingController _kilometraje;
  late DateTime _fecha;
  int? _mecanicoId;

  @override
  void initState() {
    super.initState();
    _problema = TextEditingController(text: widget.orden.orden.problema);
    _notas = TextEditingController(text: widget.orden.orden.notas ?? '');
    _kilometraje = TextEditingController(
      text: '${widget.orden.orden.kilometrajeEntrada}',
    );
    _fecha = widget.orden.orden.fechaEntrada;
    _mecanicoId = widget.orden.mecanico?.id;
  }

  @override
  void dispose() {
    _problema.dispose();
    _notas.dispose();
    _kilometraje.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar ${widget.orden.numero}'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectorFecha(
                etiqueta: 'Fecha de entrada',
                fecha: _fecha,
                primera: DateTime(2000),
                ultima: DateTime.now().add(const Duration(days: 1)),
                onCambio: (valor) => setState(() => _fecha = valor),
              ),
              const SizedBox(height: 10),
              CampoNumero(
                etiqueta: 'Kilometraje de entrada',
                controlador: _kilometraje,
                icono: Icons.speed_rounded,
                validator: (v) =>
                    Validaciones.entero(v, campo: 'El kilometraje'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int?>(
                value: _mecanicoId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Mecánico asignado',
                  prefixIcon: Icon(Icons.engineering_rounded, size: 20),
                ),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('Sin asignar'),
                  ),
                  for (final mecanico in widget.mecanicos)
                    DropdownMenuItem<int?>(
                      value: mecanico.id,
                      child: Text(mecanico.nombre),
                    ),
                ],
                onChanged: (valor) => setState(() => _mecanicoId = valor),
              ),
              const SizedBox(height: 10),
              CampoTexto(
                etiqueta: 'Problema reportado',
                controlador: _problema,
                maxLines: 3,
                validator: (v) =>
                    Validaciones.requerido(v, campo: 'El problema'),
              ),
              const SizedBox(height: 10),
              CampoTexto(
                etiqueta: 'Notas internas',
                controlador: _notas,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.of(context).pop<DatosEdicionOrden>((
              fecha: _fecha,
              problema: _problema.text.trim(),
              kilometraje: int.tryParse(_kilometraje.text) ?? 0,
              notas: _notas.text.trim(),
              mecanicoId: _mecanicoId,
            ));
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
