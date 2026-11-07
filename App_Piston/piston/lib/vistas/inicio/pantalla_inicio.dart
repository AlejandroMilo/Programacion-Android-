import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/indicadores/estado_vacio.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../componentes/tarjetas/tarjeta_orden.dart';
import '../../componentes/tarjetas/tarjeta_resumen.dart';
import '../../datos/base_datos.dart';
import '../../modelos/estado_orden.dart';
import '../../modelos/orden_servicio.dart';
import '../../modelos/repuesto.dart';
import '../../modelos_vista/inicio_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';
import '../ordenes/detalle_orden.dart';
import '../ordenes/formulario_orden.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({
    super.key,
    this.onIrAOrdenes,
    this.onIrAInventario,
  });

  final VoidCallback? onIrAOrdenes;
  final VoidCallback? onIrAInventario;

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => InicioModeloVista(db, sesion)..cargar(),
      child: _CuerpoInicio(
        onIrAOrdenes: onIrAOrdenes,
        onIrAInventario: onIrAInventario,
      ),
    );
  }
}

class _CuerpoInicio extends StatelessWidget {
  const _CuerpoInicio({this.onIrAOrdenes, this.onIrAInventario});

  final VoidCallback? onIrAOrdenes;
  final VoidCallback? onIrAInventario;

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<InicioModeloVista>();
    final sesion = context.watch<Sesion>();
    final tema = Theme.of(context);
    final oscuro = tema.brightness == Brightness.dark;
    final primerNombre = sesion.nombre.split(' ').first;

    return Scaffold(
      appBar: BarraSuperior(
        titulo: 'Hola, $primerNombre',
        subtitulo:
            '${sesion.rolEtiqueta} · ${Formatos.fechaLarga(DateTime.now())}',
      ),
      body: RefreshIndicator(
        onRefresh: modelo.cargar,
        child: modelo.cargando && modelo.recientes.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  _HeroPanel(
                    sesion: sesion,
                    modelo: modelo,
                    oscuro: oscuro,
                  ),
                  const SizedBox(height: 16),
                  _Metricas(modelo: modelo),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: sesion.puede(Permiso.crearOrden)
                              ? () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => const FormularioOrden(),
                                    ),
                                  );
                                  if (context.mounted) modelo.cargar();
                                }
                              : null,
                          icon: const Icon(Icons.add_rounded),
                          label: Text(
                            sesion.puede(Permiso.crearOrden)
                                ? 'Nueva orden'
                                : 'Ver órdenes',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onIrAOrdenes,
                          icon: const Icon(Icons.list_alt_rounded),
                          label: const Text('Órdenes'),
                        ),
                      ),
                    ],
                  ),
                  if (modelo.esMecanico) ...[
                    const SizedBox(height: 20),
                    SeccionTitulo(
                      titulo: 'Mis órdenes asignadas',
                      icono: Icons.assignment_ind_rounded,
                      accion: TextButton(
                        onPressed: onIrAOrdenes,
                        child: const Text('Ver todas'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (modelo.asignadas.isEmpty)
                      const EstadoVacio(
                        titulo: 'Sin órdenes asignadas',
                        mensaje: 'Cuando recepción te asigne un vehículo, '
                            'aparecerá aquí.',
                        icono: Icons.assignment_turned_in_outlined,
                      )
                    else
                      for (final orden in modelo.asignadas)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: TarjetaOrden(
                            orden: orden,
                            onTap: () => _abrirOrden(context, orden, modelo),
                          ),
                        ),
                  ] else ...[
                    if (modelo.repuestosBajos.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      SeccionTitulo(
                        titulo: 'Inventario que requiere atención',
                        icono: Icons.warning_amber_rounded,
                        accion: TextButton(
                          onPressed: onIrAInventario,
                          child: const Text('Ver inventario'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (final repuesto in modelo.repuestosBajos.take(3))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _AvisoInventario(
                            nombre: repuesto.nombre,
                            detalle:
                                'Quedan ${repuesto.existencias} unidades · '
                                'umbral ${repuesto.umbral}',
                            agotado: repuesto.sinStock,
                          ),
                        ),
                    ],
                    const SizedBox(height: 20),
                    SeccionTitulo(
                      titulo: 'Órdenes recientes',
                      icono: Icons.history_rounded,
                      accion: TextButton(
                        onPressed: onIrAOrdenes,
                        child: const Text('Ver todas'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (modelo.recientes.isEmpty)
                      const EstadoVacio(
                        titulo: 'Aún no hay órdenes',
                        mensaje: 'Registra la primera visita de un cliente.',
                        icono: Icons.assignment_outlined,
                      )
                    else
                      for (final orden in modelo.recientes)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: TarjetaOrden(
                            orden: orden,
                            onTap: () => _abrirOrden(context, orden, modelo),
                          ),
                        ),
                  ],
                  if (modelo.error != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: Colores.rojo.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: Colores.rojo.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: Colores.rojo,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              modelo.error!,
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: Colores.rojo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Future<void> _abrirOrden(
    BuildContext context,
    OrdenResumen orden,
    InicioModeloVista modelo,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DetalleOrden(ordenId: orden.id),
      ),
    );
    await modelo.cargar();
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.sesion,
    required this.modelo,
    required this.oscuro,
  });

  final Sesion sesion;
  final InicioModeloVista modelo;
  final bool oscuro;

  @override
  Widget build(BuildContext context) {
    final gradienteInicio = oscuro ? Colores.grafito : const Color(0xFFF4F4F6);
    final gradienteFin = oscuro ? Colores.negro : const Color(0xFFE9EBEF);
    final textoPrincipal = oscuro ? Colors.white : const Color(0xFF17181C);
    final textoSecundario = oscuro
        ? Colors.white.withValues(alpha: 0.62)
        : const Color(0xFF17181C).withValues(alpha: 0.6);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [gradienteInicio, gradienteFin],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colores.naranja.withValues(alpha: 0.25)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -22,
            top: -30,
            child: Icon(
              Icons.car_repair_rounded,
              size: 130,
              color: Colores.naranja.withValues(alpha: oscuro ? 0.09 : 0.14),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colores.naranja.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  sesion.rolEtiqueta.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 9.5,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w800,
                    color: Colores.naranja,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'El taller, bajo control.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: textoPrincipal,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sesion.esMecanico
                    ? 'Tus trabajos, repuestos y estados en un solo lugar.'
                    : 'Órdenes, clientes, inventario y cobros sin libreta.',
                style: TextStyle(
                  fontSize: 12,
                  color: textoSecundario,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _DatoHero(
                    valor: '${modelo.resumen.ordenesAbiertas}',
                    etiqueta: 'abiertas',
                  ),
                  const SizedBox(width: 20),
                  _DatoHero(
                    valor: '${modelo.resumen.listasParaEntregar}',
                    etiqueta: 'listas',
                  ),
                  const SizedBox(width: 20),
                  _DatoHero(
                    valor: '${modelo.resumen.ordenesHoy}',
                    etiqueta: 'hoy',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DatoHero extends StatelessWidget {
  const _DatoHero({required this.valor, required this.etiqueta});

  final String valor;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    final oscuro = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          valor,
          style: TextStyle(
            color: Colores.naranja,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          etiqueta,
          style: TextStyle(
            color: oscuro
                ? Colors.white.withValues(alpha: 0.5)
                : const Color(0xFF17181C).withValues(alpha: 0.5),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _Metricas extends StatelessWidget {
  const _Metricas({required this.modelo});

  final InicioModeloVista modelo;

  @override
  Widget build(BuildContext context) {
    final r = modelo.resumen;
    final tarjetas = modelo.esMecanico
        ? <Widget>[
            TarjetaResumen(
              titulo: 'Mis órdenes abiertas',
              valor: '${modelo.asignadas.length}',
              icono: Icons.assignment_ind_rounded,
              color: Colores.naranja,
            ),
            TarjetaResumen(
              titulo: 'Listas para entregar',
              valor:
                  '${modelo.asignadas.where((o) => o.estado == EstadoOrden.listaParaEntregar).length}',
              icono: Icons.task_alt_rounded,
              color: Colores.verde,
            ),
            TarjetaResumen(
              titulo: 'En reparación',
              valor:
                  '${modelo.asignadas.where((o) => o.estado == EstadoOrden.enReparacion).length}',
              icono: Icons.build_rounded,
              color: Colores.azul,
            ),
            TarjetaResumen(
              titulo: 'En diagnóstico',
              valor:
                  '${modelo.asignadas.where((o) => o.estado == EstadoOrden.enDiagnostico).length}',
              icono: Icons.troubleshoot_rounded,
              color: Colores.morado,
            ),
          ]
        : <Widget>[
            TarjetaResumen(
              titulo: 'Órdenes abiertas',
              valor: '${r.ordenesAbiertas}',
              icono: Icons.assignment_rounded,
              color: Colores.naranja,
            ),
            TarjetaResumen(
              titulo: 'Listas para entregar',
              valor: '${r.listasParaEntregar}',
              icono: Icons.task_alt_rounded,
              color: Colores.verde,
            ),
            TarjetaResumen(
              titulo: 'Vehículos en taller',
              valor: '${r.vehiculosEnTaller}',
              icono: Icons.directions_car_rounded,
              color: Colores.azul,
            ),
            TarjetaResumen(
              titulo: 'Por cobrar',
              valor: Formatos.dinero(r.porCobrar),
              icono: Icons.account_balance_wallet_rounded,
              color: Colores.rojo,
            ),
            TarjetaResumen(
              titulo: 'Facturado del mes',
              valor: Formatos.dinero(r.facturadoMes),
              subtitulo: 'Mano de obra + repuestos',
              icono: Icons.receipt_long_rounded,
              color: Colores.morado,
            ),
            TarjetaResumen(
              titulo: 'Cobrado del mes',
              valor: Formatos.dinero(r.cobradoMes),
              subtitulo:
                  '${r.ordenesDelMes} órdenes registradas',
              icono: Icons.payments_rounded,
              color: Colores.verde,
            ),
            TarjetaResumen(
              titulo: 'Repuestos bajos',
              valor: '${r.repuestosBajos}',
              subtitulo: 'Revisa antes del próximo trabajo',
              icono: Icons.inventory_2_rounded,
              color: Colores.amarillo,
            ),
            TarjetaResumen(
              titulo: 'Clientes activos',
              valor: '${r.clientesActivos}',
              icono: Icons.people_rounded,
              color: Colores.azul,
            ),
          ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columnas = constraints.maxWidth >= 760
            ? 4
            : constraints.maxWidth >= 520
            ? 3
            : 2;
        final ancho =
            (constraints.maxWidth - (columnas - 1) * 10) / columnas;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final tarjeta in tarjetas)
              SizedBox(width: ancho, child: tarjeta),
          ],
        );
      },
    );
  }
}

class _AvisoInventario extends StatelessWidget {
  const _AvisoInventario({
    required this.nombre,
    required this.detalle,
    required this.agotado,
  });

  final String nombre;
  final String detalle;
  final bool agotado;

  @override
  Widget build(BuildContext context) {
    final color = agotado ? Colores.rojo : Colores.amarillo;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            agotado ? Icons.error_outline_rounded : Icons.warning_amber_rounded,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  detalle,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
