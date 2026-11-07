import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/botones/boton_principal.dart';
import '../../componentes/formularios/campo_numero.dart';
import '../../componentes/formularios/campo_texto.dart';
import '../../componentes/formularios/selector_fecha.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../datos/base_datos.dart';
import '../../modelos_vista/formulario_orden_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';
import '../../utilidades/validaciones.dart';

class FormularioOrden extends StatelessWidget {
  const FormularioOrden({super.key, this.clientePreselected, this.vehiculoPreselected});

  final int? clientePreselected;
  final int? vehiculoPreselected;

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => FormularioOrdenModeloVista(db, sesion)
        ..cargar(clientePreselected: clientePreselected, vehiculoPreselected: vehiculoPreselected),
      child: const _CuerpoFormularioOrden(),
    );
  }
}

class _CuerpoFormularioOrden extends StatefulWidget {
  const _CuerpoFormularioOrden();

  @override
  State<_CuerpoFormularioOrden> createState() => _CuerpoFormularioOrdenState();
}

class _CuerpoFormularioOrdenState extends State<_CuerpoFormularioOrden> {
  final _formKey = GlobalKey<FormState>();
  final _problema = TextEditingController();
  final _notas = TextEditingController();
  final _kilometraje = TextEditingController();
  DateTime _fecha = DateTime.now();
  int? _mecanicoId;
  bool _guardando = false;

  @override
  void dispose() {
    _problema.dispose();
    _notas.dispose();
    _kilometraje.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final modelo = context.read<FormularioOrdenModeloVista>();
    setState(() => _guardando = true);
    try {
      final id = await modelo.guardar(
        fechaEntrada: _fecha,
        problema: _problema.text,
        kilometrajeEntrada: int.tryParse(_kilometraje.text) ?? 0,
        notas: _notas.text,
        mecanicoId: _mecanicoId,
      );
      if (!mounted) return;
      Navigator.of(context).pop(id);
    } catch (e) {
      if (!mounted) return;
      _mostrarError(context, e);
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<FormularioOrdenModeloVista>();
    final tema = Theme.of(context);
    final vehiculoSeleccionado = modelo.vehiculos
        .where((v) => v.id == modelo.vehiculoId)
        .firstOrNull;

    return Scaffold(
      appBar: const BarraSuperior(
        titulo: 'Nueva orden',
        subtitulo: 'Registrar la entrada de un vehículo',
        mostrarVolver: true,
      ),
      body: modelo.cargando && modelo.clientes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                children: [
                  if (modelo.error != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colores.rojo.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        modelo.error!,
                        style: const TextStyle(
                          color: Colores.rojo,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SeccionTitulo(
                    titulo: 'Cliente',
                    icono: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          DropdownButtonFormField<int>(
                            value: modelo.clienteId,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Cliente',
                              prefixIcon: Icon(
                                Icons.people_outline_rounded,
                                size: 20,
                              ),
                            ),
                            hint: const Text('Selecciona un cliente'),
                            items: [
                              for (final cliente in modelo.clientes)
                                DropdownMenuItem<int>(
                                  value: cliente.id,
                                  child: Text(
                                    '${cliente.nombre} · ${cliente.telefono}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                            onChanged: (valor) async {
                              await modelo.seleccionarCliente(valor);
                              if (mounted) {
                                setState(() => _kilometraje.clear());
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () => _nuevoCliente(modelo),
                              icon: const Icon(Icons.person_add_alt_rounded),
                              label: const Text('Nuevo cliente'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const SeccionTitulo(
                    titulo: 'Vehículo',
                    icono: Icons.directions_car_outlined,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          if (modelo.clienteId == null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Selecciona primero un cliente para ver sus '
                                'vehículos.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: tema.hintColor,
                                ),
                              ),
                            )
                          else if (modelo.vehiculos.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Este cliente no tiene vehículos registrados.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: tema.hintColor,
                                ),
                              ),
                            )
                          else
                            DropdownButtonFormField<int>(
                              value: modelo.vehiculoId,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: 'Vehículo',
                                prefixIcon: Icon(
                                  Icons.directions_car_rounded,
                                  size: 20,
                                ),
                              ),
                              hint: const Text('Selecciona un vehículo'),
                              items: [
                                for (final vehiculo in modelo.vehiculos)
                                  DropdownMenuItem<int>(
                                    value: vehiculo.id,
                                    child: Text(
                                      '${vehiculo.matricula} · '
                                      '${vehiculo.marca} ${vehiculo.modelo}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                              ],
                              onChanged: (valor) {
                                modelo.seleccionarVehiculo(valor);
                                final vehiculo = modelo.vehiculos
                                    .where((v) => v.id == valor)
                                    .firstOrNull;
                                if (vehiculo != null) {
                                  _kilometraje.text =
                                      '${vehiculo.kilometraje}';
                                }
                              },
                            ),
                          if (modelo.clienteId != null) ...[
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () => _nuevoVehiculo(modelo),
                                icon: const Icon(Icons.add_circle_outline),
                                label: const Text('Nuevo vehículo'),
                              ),
                            ),
                          ],
                          if (vehiculoSeleccionado != null) ...[
                            const SizedBox(height: 4),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colores.naranja.withValues(alpha: 0.07),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${vehiculoSeleccionado.marca} '
                                '${vehiculoSeleccionado.modelo} '
                                '${vehiculoSeleccionado.anio} · '
                                'último kilometraje: '
                                '${Formatos.kilometraje(vehiculoSeleccionado.kilometraje)}',
                                style: const TextStyle(fontSize: 11.5),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const SeccionTitulo(
                    titulo: 'Datos de la orden',
                    icono: Icons.assignment_outlined,
                  ),
                  const SizedBox(height: 8),
                  SelectorFecha(
                    etiqueta: 'Fecha de entrada',
                    fecha: _fecha,
                    primera: DateTime(2000),
                    ultima: DateTime.now().add(const Duration(days: 1)),
                    onCambio: (valor) => setState(() => _fecha = valor),
                  ),
                  const SizedBox(height: 12),
                  CampoNumero(
                    etiqueta: 'Kilometraje de entrada',
                    controlador: _kilometraje,
                    icono: Icons.speed_rounded,
                    hint: 'Ej. 85000',
                    validator: (valor) => Validaciones.entero(
                      valor,
                      campo: 'El kilometraje',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int?>(
                    value: _mecanicoId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Mecánico asignado (opcional)',
                      prefixIcon: Icon(Icons.engineering_rounded, size: 20),
                    ),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Asignar después'),
                      ),
                      for (final mecanico in modelo.mecanicos)
                        DropdownMenuItem<int?>(
                          value: mecanico.id,
                          child: Text(mecanico.nombre),
                        ),
                    ],
                    onChanged: (valor) => setState(() => _mecanicoId = valor),
                  ),
                  const SizedBox(height: 12),
                  CampoTexto(
                    etiqueta: 'Problema reportado por el cliente',
                    controlador: _problema,
                    icono: Icons.report_problem_outlined,
                    maxLines: 4,
                    hint: 'Describe el síntoma, ruido o falla…',
                    validator: (valor) =>
                        Validaciones.requerido(valor, campo: 'El problema'),
                  ),
                  const SizedBox(height: 12),
                  CampoTexto(
                    etiqueta: 'Notas internas (opcional)',
                    controlador: _notas,
                    icono: Icons.notes_rounded,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 22),
                  BotonPrincipal(
                    texto: 'Registrar orden',
                    icono: Icons.save_rounded,
                    cargando: _guardando,
                    onPressed: modelo.clientes.isEmpty ? null : _guardar,
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _nuevoCliente(FormularioOrdenModeloVista modelo) async {
    final datos = await showDialog<({String nombre, String telefono, String direccion})>(
      context: context,
      builder: (_) => const _DialogoCliente(),
    );
    if (datos == null) return;
    try {
      await modelo.crearClienteRapido(
        nombre: datos.nombre,
        telefono: datos.telefono,
        direccion: datos.direccion,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente creado y seleccionado')),
        );
      }
    } catch (e) {
      if (mounted) _mostrarError(context, e);
    }
  }

  Future<void> _nuevoVehiculo(FormularioOrdenModeloVista modelo) async {
    final datos = await showDialog<
      ({
        String matricula,
        String marca,
        String modelo,
        int anio,
        int kilometraje,
      })
    >(context: context, builder: (_) => const _DialogoVehiculo());
    if (datos == null) return;
    try {
      await modelo.crearVehiculoRapido(
        matricula: datos.matricula,
        marca: datos.marca,
        modelo: datos.modelo,
        anio: datos.anio,
        kilometraje: datos.kilometraje,
      );
      _kilometraje.text = '${datos.kilometraje}';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehículo creado y seleccionado')),
        );
      }
    } catch (e) {
      if (mounted) _mostrarError(context, e);
    }
  }
}

void _mostrarError(BuildContext context, Object error) {
  final texto = error
      .toString()
      .replaceFirst('Bad state: ', '')
      .replaceFirst('Invalid argument(s): ', '');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(texto),
      backgroundColor: Colores.rojo,
    ),
  );
}

class _DialogoCliente extends StatefulWidget {
  const _DialogoCliente();

  @override
  State<_DialogoCliente> createState() => _DialogoClienteState();
}

class _DialogoClienteState extends State<_DialogoCliente> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _telefono = TextEditingController();
  final _direccion = TextEditingController();

  @override
  void dispose() {
    _nombre.dispose();
    _telefono.dispose();
    _direccion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo cliente'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CampoTexto(
                etiqueta: 'Nombre',
                controlador: _nombre,
                validator: Validaciones.nombre,
              ),
              const SizedBox(height: 10),
              CampoTexto(
                etiqueta: 'Teléfono',
                controlador: _telefono,
                validator: Validaciones.telefono,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              CampoTexto(
                etiqueta: 'Dirección (opcional)',
                controlador: _direccion,
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
            Navigator.of(context).pop((
              nombre: _nombre.text.trim(),
              telefono: _telefono.text.trim(),
              direccion: _direccion.text.trim(),
            ));
          },
          child: const Text('Crear'),
        ),
      ],
    );
  }
}

class _DialogoVehiculo extends StatefulWidget {
  const _DialogoVehiculo();

  @override
  State<_DialogoVehiculo> createState() => _DialogoVehiculoState();
}

class _DialogoVehiculoState extends State<_DialogoVehiculo> {
  final _formKey = GlobalKey<FormState>();
  final _matricula = TextEditingController();
  final _marca = TextEditingController();
  final _modelo = TextEditingController();
  final _anio = TextEditingController();
  final _kilometraje = TextEditingController(text: '0');

  @override
  void dispose() {
    _matricula.dispose();
    _marca.dispose();
    _modelo.dispose();
    _anio.dispose();
    _kilometraje.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo vehículo'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CampoTexto(
                etiqueta: 'Matrícula',
                controlador: _matricula,
                validator: Validaciones.matricula,
              ),
              const SizedBox(height: 10),
              CampoTexto(
                etiqueta: 'Marca',
                controlador: _marca,
                validator: (v) => Validaciones.requerido(v, campo: 'La marca'),
              ),
              const SizedBox(height: 10),
              CampoTexto(
                etiqueta: 'Modelo',
                controlador: _modelo,
                validator: (v) =>
                    Validaciones.requerido(v, campo: 'El modelo'),
              ),
              const SizedBox(height: 10),
              CampoNumero(
                etiqueta: 'Año',
                controlador: _anio,
                icono: Icons.calendar_today_rounded,
                validator: Validaciones.anio,
              ),
              const SizedBox(height: 10),
              CampoNumero(
                etiqueta: 'Kilometraje',
                controlador: _kilometraje,
                icono: Icons.speed_rounded,
                validator: (v) =>
                    Validaciones.entero(v, campo: 'El kilometraje'),
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
            Navigator.of(context).pop((
              matricula: _matricula.text.trim(),
              marca: _marca.text.trim(),
              modelo: _modelo.text.trim(),
              anio: int.parse(_anio.text),
              kilometraje: int.tryParse(_kilometraje.text) ?? 0,
            ));
          },
          child: const Text('Crear'),
        ),
      ],
    );
  }
}
