import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/botones/boton_principal.dart';
import '../../componentes/formularios/campo_texto.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../datos/base_datos.dart';
import '../../modelos_vista/mecanicos_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/validaciones.dart';

class FormularioMecanico extends StatelessWidget {
  const FormularioMecanico({super.key, this.mecanico});

  final Mecanico? mecanico;

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => MecanicosModeloVista(db, sesion),
      child: _CuerpoFormularioMecanico(mecanico: mecanico),
    );
  }
}

class _CuerpoFormularioMecanico extends StatefulWidget {
  const _CuerpoFormularioMecanico({this.mecanico});

  final Mecanico? mecanico;

  @override
  State<_CuerpoFormularioMecanico> createState() => _CuerpoFormularioMecanicoState();
}

class _CuerpoFormularioMecanicoState extends State<_CuerpoFormularioMecanico> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _telefono;
  late final TextEditingController _especialidad;
  bool _guardando = false;

  bool get _esEdicion => widget.mecanico != null;

  @override
  void initState() {
    super.initState();
    final m = widget.mecanico;
    _nombre = TextEditingController(text: m?.nombre ?? '');
    _telefono = TextEditingController(text: m?.telefono ?? '');
    _especialidad = TextEditingController(text: m?.especialidad ?? '');
  }

  @override
  void dispose() {
    _nombre.dispose();
    _telefono.dispose();
    _especialidad.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final modelo = context.read<MecanicosModeloVista>();
    setState(() => _guardando = true);
    try {
      if (_esEdicion) {
        await modelo.actualizar(
          mecanico: widget.mecanico!,
          nombre: _nombre.text,
          telefono: _telefono.text,
          especialidad: _especialidad.text,
        );
      } else {
        await modelo.crear(
          nombre: _nombre.text,
          telefono: _telefono.text,
          especialidad: _especialidad.text,
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
        titulo: _esEdicion ? 'Editar mecánico' : 'Nuevo mecánico',
        subtitulo: _esEdicion ? widget.mecanico!.nombre : 'Personal operativo del taller',
        mostrarVolver: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            CampoTexto(
              etiqueta: 'Nombre completo',
              controlador: _nombre,
              icono: Icons.person_outline_rounded,
              validator: Validaciones.nombre,
            ),
            const SizedBox(height: 12),
            CampoTexto(
              etiqueta: 'Teléfono',
              controlador: _telefono,
              icono: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: Validaciones.telefono,
            ),
            const SizedBox(height: 12),
            CampoTexto(
              etiqueta: 'Especialidad (opcional)',
              controlador: _especialidad,
              icono: Icons.build_rounded,
              hint: 'Ej. Frenos y suspensión',
            ),
            const SizedBox(height: 24),
            BotonPrincipal(
              texto: _esEdicion ? 'Guardar cambios' : 'Registrar mecánico',
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
