import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/botones/boton_principal.dart';
import '../../componentes/formularios/campo_numero.dart';
import '../../componentes/formularios/campo_texto.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../datos/base_datos.dart';
import '../../modelos_vista/vehiculos_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/validaciones.dart';

class FormularioVehiculo extends StatelessWidget {
  const FormularioVehiculo({super.key, this.clienteId, this.vehiculo});

  final int? clienteId;
  final Vehiculo? vehiculo;

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => VehiculosModeloVista(db, sesion),
      child: _CuerpoFormularioVehiculo(clienteId: clienteId, vehiculo: vehiculo),
    );
  }
}

class _CuerpoFormularioVehiculo extends StatefulWidget {
  const _CuerpoFormularioVehiculo({this.clienteId, this.vehiculo});

  final int? clienteId;
  final Vehiculo? vehiculo;

  @override
  State<_CuerpoFormularioVehiculo> createState() =>
      _CuerpoFormularioVehiculoState();
}

class _CuerpoFormularioVehiculoState extends State<_CuerpoFormularioVehiculo> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _matricula;
  late final TextEditingController _marca;
  late final TextEditingController _modelo;
  late final TextEditingController _anio;
  late final TextEditingController _kilometraje;
  int? _clienteId;
  bool _guardando = false;

  bool get _esEdicion => widget.vehiculo != null;

  @override
  void initState() {
    super.initState();
    final v = widget.vehiculo;
    _clienteId = widget.clienteId ?? v?.clienteId;
    _matricula = TextEditingController(text: v?.matricula ?? '');
    _marca = TextEditingController(text: v?.marca ?? '');
    _modelo = TextEditingController(text: v?.modelo ?? '');
    _anio = TextEditingController(text: v?.anio.toString() ?? '');
    _kilometraje =
        TextEditingController(text: v?.kilometraje.toString() ?? '');
  }

  @override
  void dispose() {
    _matricula.dispose();
    _marca.dispose();
    _modelo.dispose();
    _anio.dispose();
    _kilometraje.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final modelo = context.read<VehiculosModeloVista>();
    setState(() => _guardando = true);
    try {
      final anio = int.parse(_anio.text);
      final kilometraje = int.tryParse(_kilometraje.text) ?? 0;
      if (_esEdicion) {
        await modelo.actualizar(
          vehiculo: widget.vehiculo!,
          clienteId: _clienteId ?? widget.vehiculo!.clienteId,
          matricula: _matricula.text,
          marca: _marca.text,
          modelo: _modelo.text,
          anio: anio,
          kilometraje: kilometraje,
        );
      } else {
        if (_clienteId == null) {
          throw StateError('Selecciona un propietario');
        }
        await modelo.crear(
          clienteId: _clienteId!,
          matricula: _matricula.text,
          marca: _marca.text,
          modelo: _modelo.text,
          anio: anio,
          kilometraje: kilometraje,
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
    final modelo = context.watch<VehiculosModeloVista>();
    return Scaffold(
      appBar: BarraSuperior(
        titulo: _esEdicion ? 'Editar vehículo' : 'Nuevo vehículo',
        subtitulo: _esEdicion
            ? widget.vehiculo!.matricula
            : 'Registra el auto o moto del cliente',
        mostrarVolver: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            DropdownButtonFormField<int>(
              value: _clienteId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Propietario (cliente)',
                prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
              ),
              items: [
                for (final cliente in modelo.clientes)
                  DropdownMenuItem<int>(
                    value: cliente.id,
                    child: Text(
                      '${cliente.nombre} · ${cliente.telefono}'
                      '${cliente.activo ? '' : ' (inactivo)'}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (valor) => setState(() => _clienteId = valor),
            ),
            const SizedBox(height: 12),
            CampoTexto(
              etiqueta: 'Matrícula',
              controlador: _matricula,
              icono: Icons.confirmation_number_rounded,
              validator: Validaciones.matricula,
            ),
            const SizedBox(height: 12),
            CampoTexto(
              etiqueta: 'Marca',
              controlador: _marca,
              icono: Icons.directions_car_filled_rounded,
              validator: (v) => Validaciones.requerido(v, campo: 'La marca'),
            ),
            const SizedBox(height: 12),
            CampoTexto(
              etiqueta: 'Modelo',
              controlador: _modelo,
              icono: Icons.model_training_rounded,
              validator: (v) => Validaciones.requerido(v, campo: 'El modelo'),
            ),
            const SizedBox(height: 12),
            CampoNumero(
              etiqueta: 'Año',
              controlador: _anio,
              icono: Icons.calendar_today_rounded,
              validator: Validaciones.anio,
            ),
            const SizedBox(height: 12),
            CampoNumero(
              etiqueta: 'Kilometraje actual',
              controlador: _kilometraje,
              icono: Icons.speed_rounded,
              validator: (v) =>
                  Validaciones.entero(v, campo: 'El kilometraje'),
            ),
            const SizedBox(height: 24),
            BotonPrincipal(
              texto: _esEdicion ? 'Guardar cambios' : 'Registrar vehículo',
              icono: Icons.save_rounded,
              cargando: _guardando,
              onPressed: _clienteId == null && !_esEdicion ? null : _guardar,
            ),
          ],
        ),
      ),
    );
  }
}
