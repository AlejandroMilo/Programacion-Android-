import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/botones/boton_principal.dart';
import '../../componentes/formularios/campo_texto.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../datos/base_datos.dart';
import '../../modelos/mecanico.dart';
import '../../modelos/rol_usuario.dart';
import '../../modelos_vista/usuarios_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/validaciones.dart';

class FormularioUsuario extends StatelessWidget {
  const FormularioUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => UsuariosModeloVista(db, sesion),
      child: const _CuerpoFormularioUsuario(),
    );
  }
}

class _CuerpoFormularioUsuario extends StatefulWidget {
  const _CuerpoFormularioUsuario();

  @override
  State<_CuerpoFormularioUsuario> createState() => _CuerpoFormularioUsuarioState();
}

class _CuerpoFormularioUsuarioState extends State<_CuerpoFormularioUsuario> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombrePersona;
  late final TextEditingController _nombreUsuario;
  late final TextEditingController _clave;
  RolUsuario _rol = RolUsuario.recepcionista;
  int? _mecanicoId;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _nombrePersona = TextEditingController();
    _nombreUsuario = TextEditingController();
    _clave = TextEditingController();
  }

  @override
  void dispose() {
    _nombrePersona.dispose();
    _nombreUsuario.dispose();
    _clave.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final modelo = context.read<UsuariosModeloVista>();
    setState(() => _guardando = true);
    try {
      await modelo.crear(
        nombreUsuario: _nombreUsuario.text,
        nombrePersona: _nombrePersona.text,
        rol: _rol,
        clave: _clave.text,
        mecanicoId: _rol == RolUsuario.mecanico ? _mecanicoId : null,
      );
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
    final modelo = context.watch<UsuariosModeloVista>();
    final tema = Theme.of(context);
    final esMecanicoRol = _rol == RolUsuario.mecanico;

    return Scaffold(
      appBar: const BarraSuperior(
        titulo: 'Nuevo usuario',
        subtitulo: 'Cuenta de acceso del taller',
        mostrarVolver: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            CampoTexto(
              etiqueta: 'Nombre completo',
              controlador: _nombrePersona,
              icono: Icons.person_outline_rounded,
              validator: Validaciones.nombre,
            ),
            const SizedBox(height: 12),
            CampoTexto(
              etiqueta: 'Usuario (login)',
              controlador: _nombreUsuario,
              icono: Icons.account_box_outlined,
              hint: 'recepcion',
              validator: Validaciones.usuario,
            ),
            const SizedBox(height: 12),
            CampoTexto(
              etiqueta: 'Contraseña',
              controlador: _clave,
              icono: Icons.lock_outline_rounded,
              obscure: true,
              validator: Validaciones.clave,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<RolUsuario>(
              value: _rol,
              decoration: const InputDecoration(
                labelText: 'Rol',
                prefixIcon: Icon(Icons.shield_outlined, size: 20),
              ),
              items: [
                DropdownMenuItem(value: RolUsuario.administrador, child: const Text('Administrador · Acceso completo')),
                DropdownMenuItem(value: RolUsuario.recepcionista, child: const Text('Recepcionista · Gestión del taller')),
                DropdownMenuItem(value: RolUsuario.mecanico, child: const Text('Mecánico · Acceso operativo')),
              ],
              onChanged: (valor) {
                if (valor != null) setState(() => _rol = valor);
              },
            ),
            if (esMecanicoRol) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _mecanicoId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Ficha de mecánico (opcional)',
                  prefixIcon: Icon(Icons.engineering_rounded, size: 20),
                ),
                hint: const Text('Selecciona si ya existe'),
                items: [
                  for (final m in modelo.mecanicos)
                    DropdownMenuItem<int>(value: m.id, child: Text(m.nombre)),
                ],
                onChanged: (valor) => setState(() => _mecanicoId = valor),
              ),
            ],
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colores.naranja.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'La contraseña se guarda con hash y sal. Solo el administrador puede restablecerla.',
                style: TextStyle(fontSize: 10.5, color: tema.hintColor),
              ),
            ),
            const SizedBox(height: 10),
            BotonPrincipal(
              texto: 'Registrar usuario',
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
