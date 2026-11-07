import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/preferencias.dart';
import '../../aplicacion/sesion.dart';
import '../../utilidades/colores.dart';
import 'notificaciones_sheet.dart';

/// Encabezado común: perfil, notificaciones, tema y cierre de sesión.
class BarraSuperior extends StatelessWidget implements PreferredSizeWidget {
  const BarraSuperior({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.mostrarVolver = false,
    this.acciones,
  });

  final String titulo;
  final String? subtitulo;
  final bool mostrarVolver;
  final List<Widget>? acciones;

  @override
  Size get preferredSize =>
      Size.fromHeight(subtitulo == null ? kToolbarHeight + 4 : 70);

  Future<void> _cerrarSesion(BuildContext context) async {
    final sesion = context.read<Sesion>();
    final navegador = Navigator.of(context);
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Deseas salir de tu cuenta en El Pistón?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(contexto).pop(true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      navegador.popUntil((ruta) => ruta.isFirst);
      sesion.cerrarSesion();
    }
  }

  void _verPerfil(BuildContext context) {
    final sesion = context.read<Sesion>();
    showDialog<void>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('Mi perfil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colores.naranja.withValues(alpha: 0.15),
              child: Text(
                _iniciales(sesion.nombre),
                style: const TextStyle(
                  color: Colores.naranja,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              sesion.nombre,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 3),
            Text(
              sesion.rolEtiqueta,
              style: const TextStyle(
                color: Colores.naranja,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            _DatoPerfil(etiqueta: 'Usuario', valor: sesion.nombreUsuario),
            if (sesion.mecanicoId != null)
              _DatoPerfil(
                etiqueta: 'Ficha de mecánico',
                valor: '#${sesion.mecanicoId}',
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  String _iniciales(String nombre) {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return '?';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return '${partes.first[0]}${partes[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final sesion = context.watch<Sesion>();
    final prefs = context.watch<Preferencias>();
    return AppBar(
      automaticallyImplyLeading: mostrarVolver,
      titleSpacing: mostrarVolver ? 0 : 16,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(titulo, maxLines: 1, overflow: TextOverflow.ellipsis),
          if (subtitulo != null)
            Text(
              subtitulo!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).hintColor,
              ),
            ),
        ],
      ),
      actions: [
        ...?acciones,
        IconButton(
          tooltip: 'Notificaciones',
          onPressed: () => NotificacionesSheet.mostrar(context),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        PopupMenuButton<String>(
          tooltip: 'Perfil y opciones',
          icon: const Icon(Icons.account_circle_outlined),
          onSelected: (valor) {
            switch (valor) {
              case 'perfil':
                _verPerfil(context);
              case 'tema_claro':
                prefs.cambiarModo(ThemeMode.light);
              case 'tema_oscuro':
                prefs.cambiarModo(ThemeMode.dark);
              case 'tema_sistema':
                prefs.cambiarModo(ThemeMode.system);
              case 'salir':
                _cerrarSesion(context);
            }
          },
          itemBuilder: (contexto) => [
            PopupMenuItem(
              enabled: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sesion.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13.5,
                    ),
                  ),
                  Text(
                    sesion.rolEtiqueta,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colores.naranja,
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'perfil',
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.badge_outlined, size: 20),
                title: Text('Mi perfil'),
              ),
            ),
            const PopupMenuItem(
              value: 'tema_claro',
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.light_mode_outlined, size: 20),
                title: Text('Tema claro'),
              ),
            ),
            const PopupMenuItem(
              value: 'tema_oscuro',
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.dark_mode_outlined, size: 20),
                title: Text('Tema oscuro'),
              ),
            ),
            const PopupMenuItem(
              value: 'tema_sistema',
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.settings_brightness_outlined, size: 20),
                title: Text('Tema del sistema'),
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'salir',
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.logout_rounded, size: 20),
                title: Text('Cerrar sesión'),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

class _DatoPerfil extends StatelessWidget {
  const _DatoPerfil({required this.etiqueta, required this.valor});

  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            etiqueta,
            style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
          ),
          Text(
            valor,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
