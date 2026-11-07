import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/indicadores/estado_vacio.dart';
import '../../componentes/indicadores/indicador_inventario.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../componentes/tarjetas/tarjeta_repuesto.dart';
import '../../datos/base_datos.dart';
import '../../modelos_vista/inventario_modelo_vista.dart';
import '../../utilidades/colores.dart';
import 'detalle_repuesto.dart';
import 'formulario_repuesto.dart';

class PantallaInventario extends StatelessWidget {
  const PantallaInventario({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => InventarioModeloVista(db, sesion),
      child: const _CuerpoInventario(),
    );
  }
}

class _CuerpoInventario extends StatelessWidget {
  const _CuerpoInventario();

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<InventarioModeloVista>();
    final tema = Theme.of(context);

    return Scaffold(
      appBar: BarraSuperior(
        titulo: 'Inventario',
        subtitulo:
            '${modelo.repuestos.length} repuestos · ${modelo.bajos} bajo stock · ${modelo.agotados} agotados',
      ),
      floatingActionButton: modelo.puedeGestionar
          ? FloatingActionButton.extended(
              onPressed: () async {
                final creado = await Navigator.of(context).push<bool>(
                  MaterialPageRoute<bool>(
                    builder: (_) => const FormularioRepuesto(),
                  ),
                );
                if (creado == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Repuesto registrado')),
                  );
                }
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Nuevo repuesto'),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
            child: TextField(
              onChanged: modelo.cambiarBusqueda,
              decoration: const InputDecoration(
                hintText: 'Buscar repuesto por nombre o código…',
                prefixIcon: Icon(Icons.search_rounded, size: 21),
              ),
            ),
          ),
          if (modelo.bajos > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colores.amarillo.withValues(alpha: 0.1),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colores.amarillo, size: 18),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      '${modelo.bajos} repuesto(s) bajo stock o agotado(s). Revisa antes de asignar a una orden.',
                      style: const TextStyle(fontSize: 11.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Expanded(
            child: modelo.cargando && modelo.repuestos.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : modelo.repuestos.isEmpty
                ? EstadoVacio(
                    titulo: modelo.busqueda.isEmpty
                        ? 'Sin repuestos registrados'
                        : 'Sin coincidencias',
                    mensaje: modelo.busqueda.isEmpty
                        ? 'Agrega repuestos para controlar existencias.'
                        : 'Prueba con otro nombre o código.',
                    icono: Icons.inventory_2_outlined,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                    itemCount: modelo.repuestos.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final repuesto = modelo.repuestos[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: TarjetaRepuesto(
                          repuesto: repuesto,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => DetalleRepuesto(repuestoId: repuesto.id),
                            ),
                          ),
                          acciones: [
                            if (modelo.puedeGestionar)
                              IconButton(
                                tooltip: 'Ajustar stock',
                                onPressed: () => _ajustar(context, modelo, repuesto),
                                icon: const Icon(Icons.inventory_outlined, size: 18),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _ajustar(BuildContext context, InventarioModeloVista modelo, Repuesto repuesto) async {
    final datos = await showDialog<({int delta, String nota})>(
      context: context,
      builder: (_) => AjustarStockDialog(repuesto: repuesto),
    );
    if (datos == null) return;
    try {
      await modelo.ajustarStock(repuesto: repuesto, delta: datos.delta, nota: datos.nota);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e'), backgroundColor: Colores.rojo),
        );
      }
    }
  }
}

class AjustarStockDialog extends StatefulWidget {
  const AjustarStockDialog({super.key, required this.repuesto});

  final Repuesto repuesto;

  @override
  State<AjustarStockDialog> createState() => _AjustarStockDialogState();
}

class _AjustarStockDialogState extends State<AjustarStockDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _delta;
  late final TextEditingController _nota;

  @override
  void initState() {
    super.initState();
    _delta = TextEditingController(text: '0');
    _nota = TextEditingController();
  }

  @override
  void dispose() {
    _delta.dispose();
    _nota.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajustar stock: ${widget.repuesto.nombre}'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Existencias actuales: ${widget.repuesto.existencias}',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _delta,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cambio (ej. +5 o -2)',
                  hintText: '0',
                  prefixIcon: const Icon(Icons.compare_arrows_rounded),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nota,
                decoration: const InputDecoration(
                  labelText: 'Nota (opcional)',
                  hintText: 'Compra a proveedor',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            final texto = _delta.text.trim();
            final valor = texto.startsWith('+') || texto.startsWith('-')
                ? int.tryParse(texto)
                : int.tryParse(texto);
            if (valor == null) {
              Navigator.of(context).pop();
              return;
            }
            Navigator.of(context).pop((delta: valor, nota: _nota.text.trim()));
          },
          child: const Text('Aplicar'),
        ),
      ],
    );
  }
}
