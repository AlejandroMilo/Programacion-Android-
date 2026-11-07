import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/botones/boton_principal.dart';
import '../../componentes/formularios/campo_numero.dart';
import '../../componentes/formularios/campo_texto.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../datos/base_datos.dart';
import '../../modelos_vista/inventario_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/validaciones.dart';

class FormularioRepuesto extends StatelessWidget {
  const FormularioRepuesto({super.key, this.repuesto});

  final Repuesto? repuesto;

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => InventarioModeloVista(db, sesion),
      child: _CuerpoFormularioRepuesto(repuesto: repuesto),
    );
  }
}

class _CuerpoFormularioRepuesto extends StatefulWidget {
  const _CuerpoFormularioRepuesto({this.repuesto});

  final Repuesto? repuesto;

  @override
  State<_CuerpoFormularioRepuesto> createState() => _CuerpoFormularioRepuestoState();
}

class _CuerpoFormularioRepuestoState extends State<_CuerpoFormularioRepuesto> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _codigo;
  late final TextEditingController _precio;
  late final TextEditingController _existencias;
  late final TextEditingController _umbral;
  bool _guardando = false;

  bool get _esEdicion => widget.repuesto != null;

  @override
  void initState() {
    super.initState();
    final r = widget.repuesto;
    _nombre = TextEditingController(text: r?.nombre ?? '');
    _codigo = TextEditingController(text: r?.codigo ?? '');
    _precio = TextEditingController(text: r?.precioVenta.toStringAsFixed(2) ?? '');
    _existencias = TextEditingController(text: r?.existencias.toString() ?? '');
    _umbral = TextEditingController(text: r?.umbral.toString() ?? '');
  }

  @override
  void dispose() {
    _nombre.dispose();
    _codigo.dispose();
    _precio.dispose();
    _existencias.dispose();
    _umbral.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final modelo = context.read<InventarioModeloVista>();
    setState(() => _guardando = true);
    try {
      final precio = double.parse(_precio.text.replaceAll(',', '.'));
      final existencias = int.tryParse(_existencias.text) ?? 0;
      final umbral = int.tryParse(_umbral.text) ?? 5;
      if (_esEdicion) {
        await modelo.actualizar(
          repuesto: widget.repuesto!,
          nombre: _nombre.text,
          codigo: _codigo.text,
          precioVenta: precio,
          umbral: umbral,
        );
      } else {
        await modelo.crear(
          nombre: _nombre.text,
          codigo: _codigo.text,
          precioVenta: precio,
          existencias: existencias,
          umbral: umbral,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      final texto = e
          .toString()
          .replaceFirst('Bad state: ', '')
          .replaceFirst('Invalid argument(s): ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(texto), backgroundColor: Colores.rojo),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraSuperior(
        titulo: _esEdicion ? 'Editar repuesto' : 'Nuevo repuesto',
        subtitulo: _esEdicion ? widget.repuesto!.nombre : 'Control de existencias y precio de venta',
        mostrarVolver: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            CampoTexto(
              etiqueta: 'Nombre del repuesto',
              controlador: _nombre,
              icono: Icons.inventory_2_outlined,
              validator: Validaciones.nombre,
            ),
            const SizedBox(height: 12),
            CampoTexto(
              etiqueta: 'Código',
              controlador: _codigo,
              icono: Icons.label_outlined,
              validator: (v) => Validaciones.requerido(v, campo: 'El código'),
            ),
            const SizedBox(height: 12),
            CampoNumero(
              etiqueta: 'Precio de venta',
              controlador: _precio,
              decimal: true,
              icono: Icons.attach_money_rounded,
              validator: Validaciones.monto,
            ),
            const SizedBox(height: 12),
            CampoNumero(
              etiqueta: 'Existencias iniciales',
              controlador: _existencias,
              icono: Icons.numbers_rounded,
              validator: (v) => Validaciones.entero(v, campo: 'Las existencias'),
            ),
            const SizedBox(height: 12),
            CampoNumero(
              etiqueta: 'Umbral de stock bajo',
              controlador: _umbral,
              icono: Icons.warning_amber_rounded,
              validator: (v) => Validaciones.entero(v, campo: 'El umbral'),
            ),
            const SizedBox(height: 24),
            BotonPrincipal(
              texto: _esEdicion ? 'Guardar cambios' : 'Registrar repuesto',
              icono: Icons.save_rounded,
              cargando: _guardando,
              onPressed: _guardar,
            ),
          ],
        ),
      ),
    );
  }
}
