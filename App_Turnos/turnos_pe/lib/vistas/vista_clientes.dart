import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../aplicacion/alcance_turnos.dart';
import '../datos/almacen_turnos.dart';
import '../modelos/cliente.dart';
import '../modelos/datos_iniciales_turno.dart';
import '../modelos/filtros.dart';
import '../modelos/reglas_turno.dart';
import '../modelos/turno.dart';
import '../enrutador/rutas.dart';
import '../tema/tema_app.dart';
import '../modelos_vista/modelo_vista_clientes.dart';
import '../componentes/barra_superior.dart';
import '../componentes/componentes.dart';
import '../componentes/dialogo_confirmacion.dart';
import '../componentes/estado_vacio.dart';
import '../componentes/fila_cliente.dart';
import '../componentes/formulario_cliente.dart';
import '../componentes/hoja_cliente.dart';
import '../componentes/iconos.dart';
import '../componentes/selectores.dart';

/// Pantalla Clientes: busqueda, filtro por genero, alta y edicion.
class VistaClientes extends StatefulWidget {
  const VistaClientes({super.key});

  @override
  State<VistaClientes> createState() => _ClientesViewState();
}

class _ClientesViewState extends State<VistaClientes> {
  ModeloVistaClientes? _vm;
  AlmacenTurnos? _store;
  final TextEditingController _busqueda = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = AlcanceTurnos.of(context);
    if (!identical(_store, scope.store)) {
      _store = scope.store;
      _vm = ModeloVistaClientes(scope.store);
    }
  }

  @override
  void dispose() {
    _busqueda.dispose();
    _vm?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = _vm;
    final store = _store;
    if (vm == null || store == null) return const SizedBox.shrink();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: Listenable.merge(<Listenable>[vm, store]),
          builder: (context, _) => _contenido(context, vm),
        ),
      ),
      floatingActionButton: BotonFlotante(
        etiqueta: 'Nuevo cliente',
        icono: Icons.person_add_alt_1,
        onPressed: _nuevoCliente,
      ),
    );
  }

  Widget _contenido(BuildContext context, ModeloVistaClientes vm) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;
    final clientes = vm.clientes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BarraSuperior(
          titulo: 'Clientes',
          acciones: [
            IconButton(
              onPressed: _nuevoCliente,
              icon: const Icon(Icons.person_add_alt_1, size: 22),
              color: esquema.onSurfaceVariant,
              tooltip: 'Nuevo cliente',
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buscador(context, vm),
                const SizedBox(height: 10),
                SegmentedGenero(
                  valor: vm.generoFiltro,
                  onChanged: vm.filtrarGenero,
                ),
                const SizedBox(height: 10),
                Text(
                  vm.resumenTotales,
                  style: textos.bodySmall?.copyWith(
                    fontSize: 12,
                    color: esquema.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: clientes.isEmpty
                      ? _estadoVacio(context, vm)
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 96),
                          itemCount: clientes.length,
                          separatorBuilder: (context, indice) =>
                              const LineaDivisoria(),
                          itemBuilder: (context, indice) {
                            final cliente = clientes[indice];
                            return FilaCliente(
                              cliente: cliente,
                              cantidadTurnos: vm.cantidadTurnos(cliente),
                              onTap: () => _abrirCliente(cliente),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buscador(BuildContext context, ModeloVistaClientes vm) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: esquema.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppTheme.radioFiltro),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 20, color: esquema.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _busqueda,
              textInputAction: TextInputAction.search,
              onChanged: (valor) => setState(() => vm.buscar(valor)),
              style: textos.bodyMedium?.copyWith(color: esquema.onSurface),
              decoration: InputDecoration(
                isDense: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: 'Buscar por nombre o teléfono',
                hintStyle: textos.bodyMedium?.copyWith(
                  color: esquema.onSurfaceVariant,
                ),
              ),
            ),
          ),
          if (_busqueda.text.isNotEmpty)
            InkWell(
              onTap: () {
                _busqueda.clear();
                setState(() => vm.buscar(''));
              },
              borderRadius: BorderRadius.circular(24),
              child: Icon(
                Icons.close,
                size: 18,
                color: esquema.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  Widget _estadoVacio(BuildContext context, ModeloVistaClientes vm) {
    if (vm.busquedaSinResultados) {
      return EstadoVacio(
        titulo: 'No encontramos clientes',
        mensaje: 'Prueba con otro nombre o teléfono, o cambia el filtro.',
        ilustracion: const IconoBuscadorX(size: 52),
        colorIlustracion: Theme.of(context).colorScheme.errorContainer,
        accion: OutlinedButton.icon(
          onPressed: () {
            _busqueda.clear();
            setState(() {
              vm.buscar('');
              vm.filtrarGenero(FiltroGenero.todos);
            });
          },
          icon: const Icon(Icons.filter_alt_off_outlined, size: 18),
          label: const Text('Limpiar búsqueda'),
        ),
      );
    }
    return EstadoVacio(
      titulo: 'Aún no hay clientes',
      mensaje: 'Crea el primer cliente con el botón de abajo.',
      ilustracion: const IconoBuscadorX(size: 52),
      colorIlustracion: Theme.of(context).colorScheme.errorContainer,
      accion: BotonPrincipal(
        etiqueta: 'Nuevo cliente',
        icono: Icons.person_add_alt_1,
        onPressed: _nuevoCliente,
      ),
    );
  }

  Future<void> _nuevoCliente() async {
    final creado = await mostrarFormularioCliente(context);
    if (!mounted || creado == null) return;
    mostrarAviso(context, 'Cliente «${creado.nombre}» creado');
  }

  Future<void> _abrirCliente(Cliente cliente) async {
    final accion = await mostrarHojaCliente(context, cliente.id);
    if (!mounted || accion == null) return;

    if (accion == AccionHojaCliente.nuevoTurno) {
      final turno = await context.push<Object?>(
        Rutas.turnoNuevo,
        extra: DatosInicialesTurno(clienteId: cliente.id),
      );
      if (!mounted || turno is! Turno) return;
      mostrarAviso(
        context,
        'Turno guardado para el ${ReglasTurno.fechaHumana(turno.inicio)}',
      );
    } else if (accion == AccionHojaCliente.editar) {
      final actualizado = await mostrarFormularioCliente(
        context,
        cliente: cliente,
      );
      if (!mounted || actualizado == null) return;
      mostrarAviso(context, 'Cliente actualizado');
    } else {
      mostrarAviso(context, 'Cliente eliminado');
    }
  }
}
