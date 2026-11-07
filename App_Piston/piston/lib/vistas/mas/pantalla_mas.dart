import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/botones/boton_principal.dart';
import '../../componentes/botones/boton_secundario.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';
import '../clientes/pantalla_clientes.dart';
import '../configuracion/pantalla_configuracion.dart';
import '../historial/pantalla_historial.dart';
import '../inicio/pantalla_inicio.dart';
import '../inventario/pantalla_inventario.dart';
import '../mecanicos/pantalla_mecanicos.dart';
import '../ordenes/pantalla_ordenes.dart';
import '../pagos/pantalla_pagos.dart';
import '../reportes/pantalla_reportes.dart';
import '../usuarios/pantalla_usuarios.dart';
import '../ordenes/formulario_orden.dart';
import '../vehiculos/pantalla_vehiculos.dart';

class PantallaMas extends StatelessWidget {
  const PantallaMas({super.key, required this.onCambiarPestana});

  final ValueChanged<int> onCambiarPestana;

  @override
  Widget build(BuildContext context) {
    final sesion = context.watch<Sesion>();
    return Scaffold(
      appBar: const BarraSuperior(
        titulo: 'Más',
        subtitulo: 'Módulos, configuración y cierre de sesión',
        mostrarVolver: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          _TarjetaPerfil(sesion: sesion),
          const SizedBox(height: 18),
          const SeccionTitulo(titulo: 'Accesos rápidos', icono: Icons.flash_on_rounded),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _BotonRapido(
                  etiqueta: 'Órdenes',
                  icono: Icons.assignment_rounded,
                  color: Colores.naranja,
                  onTap: () => onCambiarPestana(1),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _BotonRapido(
                  etiqueta: 'Clientes',
                  icono: Icons.people_rounded,
                  color: Colores.azul,
                  onTap: () => onCambiarPestana(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _BotonRapido(
                  etiqueta: 'Inventario',
                  icono: Icons.inventory_2_rounded,
                  color: Colores.morado,
                  onTap: () => onCambiarPestana(3),
                ),
              ),
            ],
          ),
          if (sesion.puede(Permiso.crearOrden)) ...[
            const SizedBox(height: 10),
            BotonPrincipal(
              texto: 'Nueva orden de servicio',
              icono: Icons.add_rounded,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const FormularioOrden()),
              ),
            ),
          ],
          const SizedBox(height: 22),
          const SeccionTitulo(titulo: 'Módulos', icono: Icons.grid_view_rounded),
          const SizedBox(height: 8),
          ..._modulos(context, sesion),
          const SizedBox(height: 22),
          const SeccionTitulo(titulo: 'Cuenta', icono: Icons.account_circle_outlined),
          const SizedBox(height: 8),
          _BotonLista(
            etiqueta: 'Mi perfil',
            icono: Icons.badge_outlined,
            onTap: () => _verPerfil(context),
          ),
          _BotonLista(
            etiqueta: 'Cerrar sesión',
            icono: Icons.logout_rounded,
            color: Colores.rojo,
            onTap: () => _cerrar(context),
          ),
        ],
      ),
    );
  }

  List<Widget> _modulos(BuildContext context, Sesion sesion) {
    final items = <Widget>[];
    items.add(_BotonLista(
      etiqueta: 'Vehículos',
      subtitulo: 'Registro de autos y motos',
      icono: Icons.directions_car_rounded,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const PantallaVehiculos()),
      ),
    ));
    items.add(_BotonLista(
      etiqueta: 'Historial',
      subtitulo: 'Órdenes por cliente o vehículo',
      icono: Icons.history_rounded,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => PantallaHistorial(titulo: 'Historial de órdenes'),
        ),
      ),
    ));
    if (sesion.puede(Permiso.verPagos)) {
      items.add(_BotonLista(
        etiqueta: 'Pagos',
        subtitulo: 'Saldos pendientes y cobros',
        icono: Icons.payments_rounded,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const PantallaPagos()),
        ),
      ));
    }
    if (sesion.puede(Permiso.verReportes)) {
      items.add(_BotonLista(
        etiqueta: 'Reportes',
        subtitulo: 'Facturación, mecánicos y deudas (solo admin)',
        icono: Icons.insights_rounded,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const PantallaReportes()),
        ),
      ));
    }
    items.add(_BotonLista(
      etiqueta: 'Mecánicos',
      subtitulo: 'Personal operativo y carga de trabajo',
      icono: Icons.engineering_rounded,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const PantallaMecanicos()),
      ),
    ));
    if (sesion.puede(Permiso.gestionarUsuarios)) {
      items.add(_BotonLista(
        etiqueta: 'Usuarios',
        subtitulo: 'Cuentas de acceso (solo admin)',
        icono: Icons.people_alt_outlined,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const PantallaUsuarios()),
        ),
      ));
    }
    items.add(_BotonLista(
      etiqueta: 'Configuración',
      subtitulo: 'Tema, datos del taller e inventario',
      icono: Icons.settings_rounded,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const PantallaConfiguracion()),
      ),
    ));
    return items;
  }

  void _verPerfil(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Mi perfil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colores.naranja.withValues(alpha: 0.15),
              child: Text(
                _iniciales(context.read<Sesion>().nombre),
                style: const TextStyle(
                  color: Colores.naranja,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(context.read<Sesion>().nombre,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 3),
            Text(context.read<Sesion>().rolEtiqueta,
                style: const TextStyle(color: Colores.naranja, fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(height: 12),
            Text('Usuario: ${context.read<Sesion>().nombreUsuario}',
                style: const TextStyle(fontSize: 12)),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar'))],
      ),
    );
  }

  void _cerrar(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Deseas salir de tu cuenta en El Pistón?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Cerrar sesión')),
        ],
      ),
    ).then((confirmar) {
      if (confirmar == true) {
        Navigator.of(context).popUntil((ruta) => ruta.isFirst);
        context.read<Sesion>().cerrarSesion();
      }
    });
  }

  String _iniciales(String texto) {
    final partes = texto.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return '?';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return '${partes.first[0]}${partes[1][0]}'.toUpperCase();
  }
}

class _TarjetaPerfil extends StatelessWidget {
  const _TarjetaPerfil({required this.sesion});

  final Sesion sesion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colores.grafito, Colores.negro],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colores.naranja.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colores.naranja.withValues(alpha: 0.18),
            child: Text(
              _iniciales(sesion.nombre),
              style: const TextStyle(color: Colores.naranja, fontWeight: FontWeight.w900, fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sesion.nombre, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(sesion.rolEtiqueta, style: const TextStyle(color: Colores.naranja, fontWeight: FontWeight.w700, fontSize: 12)),
                const SizedBox(height: 4),
                Text('Usuario: ${sesion.nombreUsuario}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BotonRapido extends StatelessWidget {
  const _BotonRapido({
    required this.etiqueta,
    required this.icono,
    required this.color,
    required this.onTap,
  });

  final String etiqueta;
  final IconData icono;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.12),
        foregroundColor: color,
        minimumSize: const Size(double.infinity, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icono, size: 19),
      label: Text(etiqueta, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
    );
  }
}

class _BotonLista extends StatelessWidget {
  const _BotonLista({
    required this.etiqueta,
    this.subtitulo,
    required this.icono,
    required this.onTap,
    this.color,
  });

  final String etiqueta;
  final String? subtitulo;
  final IconData icono;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: (color ?? context.watch<Sesion>().rol?.color ?? Colores.naranja)
              .withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(
          icono,
          size: 20,
          color: color ?? context.watch<Sesion>().rol?.color ?? Colores.naranja,
        ),
      ),
      title: Text(etiqueta, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
      subtitle: subtitulo == null ? null : Text(subtitulo!, style: TextStyle(fontSize: 11.5, color: Theme.of(context).hintColor)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: onTap,
    );
  }
}

String _iniciales(String texto) {
  final partes = texto.trim().split(RegExp(r'\s+'));
  if (partes.isEmpty || partes.first.isEmpty) return '?';
  if (partes.length == 1) return partes.first[0].toUpperCase();
  return '${partes.first[0]}${partes[1][0]}'.toUpperCase();
}


