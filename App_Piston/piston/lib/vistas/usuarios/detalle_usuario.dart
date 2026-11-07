import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../datos/base_datos.dart';
import '../../modelos/rol_usuario.dart';
import '../../modelos_vista/usuarios_modelo_vista.dart';
import '../../utilidades/colores.dart';

class DetalleUsuario extends StatelessWidget {
  const DetalleUsuario({super.key, required this.usuario});

  final Usuario usuario;

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => UsuariosModeloVista(db, sesion),
      child: _CuerpoDetalleUsuario(usuario: usuario),
    );
  }
}

class _CuerpoDetalleUsuario extends StatelessWidget {
  const _CuerpoDetalleUsuario({required this.usuario});

  final Usuario usuario;

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<UsuariosModeloVista>();
    final sesion = context.watch<Sesion>();
    final tema = Theme.of(context);
    final esYo = usuario.id == sesion.usuario?.id;

    return Scaffold(
      appBar: BarraSuperior(
        titulo: 'Usuario',
        subtitulo: usuario.nombrePersona,
        mostrarVolver: true,
        acciones: [
          if (modelo.puedeGestionar && !esYo)
            IconButton(
              tooltip: 'Cambiar rol',
              onPressed: () => _cambiarRol(context, modelo),
              icon: const Icon(Icons.shield_outlined),
            ),
          if (modelo.puedeGestionar && !esYo)
            IconButton(
              tooltip: 'Restablecer contraseña',
              onPressed: () => _restablecer(context, modelo),
              icon: const Icon(Icons.lock_reset_outlined),
            ),
          if (modelo.puedeGestionar && !esYo)
            IconButton(
              tooltip: usuario.activo ? 'Desactivar' : 'Activar',
              onPressed: () => _cambiarActivo(context, modelo),
              icon: Icon(usuario.activo ? Icons.person_off_outlined : Icons.person_outline_rounded),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: usuario.rol.color.withValues(alpha: 0.18),
                      child: Text(
                        _iniciales(usuario.nombrePersona),
                        style: TextStyle(color: usuario.rol.color, fontWeight: FontWeight.w900, fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(usuario.nombrePersona, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 2),
                          Text(usuario.nombreUsuario, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(color: usuario.rol.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                            child: Text(usuario.rol.nombreCorto, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: usuario.rol.color)),
                          ),
                          if (!usuario.activo) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(color: Colores.gris.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(6)),
                              child: const Text('Inactivo', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colores.gris)),
                            ),
                          ],
                          if (esYo) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(color: Colores.naranja.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                              child: const Text('Tu cuenta', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colores.naranja)),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (usuario.mecanicoId != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.engineering_outlined, size: 14, color: Colors.white60),
                      const SizedBox(width: 5),
                      Expanded(child: Text('Vinculado a ficha mecánico #${usuario.mecanicoId}', style: const TextStyle(color: Colors.white70, fontSize: 12))),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (modelo.puedeGestionar && !esYo) ...[
            const Text('Acciones de administración', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.6)),
            const SizedBox(height: 8),
            _BotonAccion(
              etiqueta: 'Cambiar rol',
              icono: Icons.shield_outlined,
              onTap: () => _cambiarRol(context, modelo),
            ),
            _BotonAccion(
              etiqueta: 'Restablecer contraseña',
              icono: Icons.lock_reset_outlined,
              onTap: () => _restablecer(context, modelo),
            ),
            _BotonAccion(
              etiqueta: usuario.activo ? 'Desactivar cuenta' : 'Activar cuenta',
              icono: usuario.activo ? Icons.person_off_outlined : Icons.person_outline_rounded,
              color: usuario.activo ? Colores.rojo : Colores.verde,
              onTap: () => _cambiarActivo(context, modelo),
            ),
            if (usuario.rol == RolUsuario.mecanico)
              _BotonAccion(
                etiqueta: 'Vincular ficha de mecánico',
                icono: Icons.engineering_outlined,
                onTap: () => _vincularMecanico(context, modelo),
              ),
          ] else if (!modelo.puedeGestionar) ...[
            Text('Solo el administrador puede gestionar usuarios.', style: TextStyle(fontSize: 12, color: tema.hintColor)),
          ],
          if (esYo) ...[
            const SizedBox(height: 18),
            Text('Esta es tu propia cuenta. Algunas acciones están bloqueadas por seguridad.', style: TextStyle(fontSize: 12, color: tema.hintColor)),
          ],
        ],
      ),
    );
  }

  String _iniciales(String texto) {
    final partes = texto.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return '?';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return '${partes.first[0]}${partes[1][0]}'.toUpperCase();
  }

  Future<void> _cambiarRol(BuildContext context, UsuariosModeloVista modelo) async {
    final nuevo = await showDialog<RolUsuario>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cambiar rol'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final rol in RolUsuario.values)
              if (rol != RolUsuario.administrador || usuario.id != context.read<Sesion>().usuario?.id)
                ListTile(
                  title: Text(rol.etiqueta),
                  trailing: usuario.rol == rol ? const Icon(Icons.check, color: Colores.naranja) : null,
                  onTap: () => Navigator.of(context).pop(rol),
                ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar'))],
      ),
    );
    if (nuevo == null) return;
    try {
      await modelo.cambiarRol(usuario, nuevo);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rol actualizado')));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'), backgroundColor: Colores.rojo));
      }
    }
  }

  Future<void> _restablecer(BuildContext context, UsuariosModeloVista modelo) async {
    final claveCtrl = TextEditingController();
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Restablecer contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: claveCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Nueva contraseña'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Restablecer')),
        ],
      ),
    );
    if (confirmado != true) return;
    final clave = claveCtrl.text.trim();
    if (clave.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Escribe una contraseña'), backgroundColor: Colores.rojo));
      return;
    }
    try {
      await modelo.restablecerClave(usuario, clave);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contraseña restablecida')));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'), backgroundColor: Colores.rojo));
      }
    }
  }

  Future<void> _cambiarActivo(BuildContext context, UsuariosModeloVista modelo) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(usuario.activo ? 'Desactivar cuenta' : 'Activar cuenta'),
        content: Text(usuario.activo
            ? 'El usuario no podrá iniciar sesión, pero su historial se conserva.'
            : 'El usuario volverá a poder iniciar sesión.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(usuario.activo ? 'Desactivar' : 'Activar')),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await modelo.cambiarActivo(usuario, !usuario.activo);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Estado actualizado')));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'), backgroundColor: Colores.rojo));
      }
    }
  }

  Future<void> _vincularMecanico(BuildContext context, UsuariosModeloVista modelo) async {
    final elegido = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Vincular mecánico'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text('Sin vincular'), trailing: usuario.mecanicoId == null ? const Icon(Icons.check) : null, onTap: () => Navigator.of(context).pop(null)),
            for (final m in modelo.mecanicos)
              ListTile(
                title: Text(m.nombre),
                trailing: usuario.mecanicoId == m.id ? const Icon(Icons.check, color: Colores.naranja) : null,
                onTap: () => Navigator.of(context).pop(m.id),
              ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar'))],
      ),
    );
    if (elegido == null) return;
    try {
      await modelo.vincularMecanico(usuario, elegido);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mecánico vinculado')));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'), backgroundColor: Colores.rojo));
      }
    }
  }
}

class _BotonAccion extends StatelessWidget {
  const _BotonAccion({required this.etiqueta, required this.icono, required this.onTap, this.color});

  final String etiqueta;
  final IconData icono;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icono, color: color ?? Colores.naranja, size: 20),
      title: Text(etiqueta, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 18),
      onTap: onTap,
    );
  }
}
