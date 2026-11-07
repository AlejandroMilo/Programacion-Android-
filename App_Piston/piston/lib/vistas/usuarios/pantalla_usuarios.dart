import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/indicadores/estado_vacio.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../datos/base_datos.dart';
import '../../modelos_vista/usuarios_modelo_vista.dart';
import '../../utilidades/colores.dart';
import 'detalle_usuario.dart';
import 'formulario_usuario.dart';

class PantallaUsuarios extends StatelessWidget {
  const PantallaUsuarios({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => UsuariosModeloVista(db, sesion),
      child: const _CuerpoUsuarios(),
    );
  }
}

class _CuerpoUsuarios extends StatelessWidget {
  const _CuerpoUsuarios();

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<UsuariosModeloVista>();
    final sesion = context.watch<Sesion>();
    final tema = Theme.of(context);
    final admins = modelo.usuarios.where((u) => u.rol.esAdministrador).length;

    return Scaffold(
      appBar: BarraSuperior(
        titulo: 'Usuarios',
        subtitulo: '${modelo.usuarios.length} cuenta(s) · $admins administrador(es)',
      ),
      floatingActionButton: modelo.puedeGestionar
          ? FloatingActionButton.extended(
              onPressed: () async {
                final creado = await Navigator.of(context).push<bool>(
                  MaterialPageRoute<bool>(
                    builder: (_) => const FormularioUsuario(),
                  ),
                );
                if (creado == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Usuario registrado')),
                  );
                }
              },
              icon: const Icon(Icons.person_add_alt_rounded),
              label: const Text('Nuevo usuario'),
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: modelo.cargando && modelo.usuarios.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : modelo.usuarios.isEmpty
                ? const EstadoVacio(
                    titulo: 'Sin usuarios registrados',
                    mensaje: 'Registra las cuentas de acceso del taller.',
                    icono: Icons.person_off_outlined,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                    itemCount: modelo.usuarios.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final usuario = modelo.usuarios[index];
                      return _TarjetaUsuario(
                        usuario: usuario,
                        esYo: usuario.id == sesion.usuario?.id,
                        puedeGestionar: modelo.puedeGestionar,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => DetalleUsuario(usuario: usuario),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaUsuario extends StatelessWidget {
  const _TarjetaUsuario({
    required this.usuario,
    required this.esYo,
    required this.puedeGestionar,
    required this.onTap,
  });

  final Usuario usuario;
  final bool esYo;
  final bool puedeGestionar;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colores.naranja.withValues(alpha: 0.18),
                child: Text(
                  _iniciales(usuario.nombrePersona),
                  style: const TextStyle(color: Colores.naranja, fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            usuario.nombreUsuario,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: usuario.rol.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            usuario.rol.nombreCorto,
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: usuario.rol.color),
                          ),
                        ),
                        if (!usuario.activo)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colores.grisClaro,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('Inactivo', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colores.grafito)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(usuario.nombrePersona,
                        style: TextStyle(fontSize: 11.5, color: tema.hintColor)),
                    if (usuario.mecanicoId != null) ...[
                      const SizedBox(height: 2),
                      Text('Ficha mecánico #${usuario.mecanicoId}',
                          style: TextStyle(fontSize: 10, color: tema.hintColor)),
                    ],
                  ],
                ),
              ),
              if (puedeGestionar && !esYo)
                Icon(Icons.chevron_right_rounded, color: tema.hintColor),
            ],
          ),
        ),
      ),
    );
  }

  String _iniciales(String texto) {
    final partes = texto.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return '?';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return '${partes.first[0]}${partes[1][0]}'.toUpperCase();
  }
}
