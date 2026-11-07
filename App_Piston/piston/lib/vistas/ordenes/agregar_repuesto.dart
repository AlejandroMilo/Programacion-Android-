import 'package:flutter/material.dart';

import '../../componentes/botones/boton_principal.dart';
import '../../componentes/formularios/campo_numero.dart';
import '../../datos/base_datos.dart';
import '../../modelos/repuesto.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';

class SeleccionarRepuesto extends StatefulWidget {
  const SeleccionarRepuesto({super.key, required this.repuestos});

  final List<Repuesto> repuestos;

  static Future<({int repuestoId, int cantidad})?> mostrar(
    BuildContext context, {
    required List<Repuesto> repuestos,
  }) {
    return showModalBottomSheet<({int repuestoId, int cantidad})>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SeleccionarRepuesto(repuestos: repuestos),
      ),
    );
  }

  @override
  State<SeleccionarRepuesto> createState() => _SeleccionarRepuestoState();
}

class _SeleccionarRepuestoState extends State<SeleccionarRepuesto> {
  final _formKey = GlobalKey<FormState>();
  final _cantidad = TextEditingController(text: '1');
  int? _repuestoId;

  Repuesto? get _seleccionado {
    for (final repuesto in widget.repuestos) {
      if (repuesto.id == _repuestoId) return repuesto;
    }
    return null;
  }

  @override
  void dispose() {
    _cantidad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final repuesto = _seleccionado;
    final disponibles = widget.repuestos
        .where((r) => r.activo && !r.sinStock)
        .toList();

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
                'Agregar repuesto',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'El inventario se descuenta automáticamente.',
                style: TextStyle(fontSize: 12, color: tema.hintColor),
              ),
              const SizedBox(height: 14),
              if (disponibles.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colores.rojo.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'No hay repuestos con existencias disponibles.',
                    style: TextStyle(fontSize: 12.5, color: Colores.rojo),
                  ),
                )
              else ...[
                DropdownButtonFormField<int>(
                  value: _repuestoId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Repuesto',
                    prefixIcon: Icon(Icons.inventory_2_outlined, size: 20),
                  ),
                  hint: const Text('Selecciona un repuesto'),
                  items: [
                    for (final r in widget.repuestos)
                      DropdownMenuItem<int>(
                        value: r.id,
                        enabled: r.activo && !r.sinStock,
                        child: Text(
                          '${r.nombre} · ${r.existencias} uds.',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: (valor) => setState(() {
                    _repuestoId = valor;
                    _cantidad.text = '1';
                  }),
                ),
                if (repuesto != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: Colores.naranja.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Text(
                      '${repuesto.nombre}\n'
                      'Precio: ${Formatos.dineroExacto(repuesto.precioVenta)} · '
                      'Existencias: ${repuesto.existencias}',
                      style: const TextStyle(fontSize: 11.5),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CampoNumero(
                    etiqueta: 'Cantidad',
                    controlador: _cantidad,
                    icono: Icons.numbers_rounded,
                    validator: (valor) {
                      final cantidad = int.tryParse(valor ?? '');
                      if (cantidad == null || cantidad <= 0) {
                        return 'Cantidad inválida';
                      }
                      if (cantidad > repuesto.existencias) {
                        return 'Solo hay ${repuesto.existencias} unidades';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Subtotal: ${Formatos.dineroExacto((int.tryParse(_cantidad.text) ?? 0) * repuesto.precioVenta)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colores.naranja,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                BotonPrincipal(
                  texto: 'Agregar a la orden',
                  icono: Icons.add_rounded,
                  onPressed: repuesto == null
                      ? null
                      : () {
                          if (!_formKey.currentState!.validate()) return;
                          Navigator.of(context).pop((
                            repuestoId: repuesto.id,
                            cantidad: int.parse(_cantidad.text),
                          ));
                        },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
