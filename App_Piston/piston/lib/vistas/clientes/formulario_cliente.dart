import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/botones/boton_principal.dart';
import '../../componentes/formularios/campo_texto.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../datos/base_datos.dart';
import '../../modelos_vista/clientes_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/validaciones.dart';

class FormularioCliente extends StatelessWidget {
  const FormularioCliente({super.key, this.cliente});

  final Cliente? cliente;

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => ClientesModeloVista(db, sesion),
      child: _CuerpoFormularioCliente(cliente: cliente),
    );
  }
}

class _CuerpoFormularioCliente extends StatefulWidget {
  const _CuerpoFormularioCliente({this.cliente});

  final Cliente? cliente;

  @override
  State<_CuerpoFormularioCliente> createState() =>
      _CuerpoFormularioClienteState();
}

class _CuerpoFormularioClienteState extends State<_CuerpoFormularioCliente> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _telefono;
  late final TextEditingController _direccion;
  Uint8List? _imagenSeleccionada;
  bool _guardando = false;
  final _picker = ImagePicker();

  bool get _esEdicion => widget.cliente != null;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.cliente?.nombre ?? '');
    _telefono = TextEditingController(text: widget.cliente?.telefono ?? '');
    _direccion = TextEditingController(text: widget.cliente?.direccion ?? '');
  }

  @override
  void dispose() {
    _nombre.dispose();
    _telefono.dispose();
    _direccion.dispose();
    super.dispose();
  }

  Future<void> _seleccionarImagen(ImageSource source) async {
    try {
      final archivo = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (archivo != null && mounted) {
        final bytes = await archivo.readAsBytes();
        setState(() => _imagenSeleccionada = bytes);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo seleccionar la imagen'),
            backgroundColor: Colores.rojo,
          ),
        );
      }
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final modelo = context.read<ClientesModeloVista>();
    setState(() => _guardando = true);
    try {
      if (_esEdicion) {
        await modelo.actualizar(
          cliente: widget.cliente!,
          nombre: _nombre.text,
          telefono: _telefono.text,
          direccion: _direccion.text,
        );
      } else {
        await modelo.crear(
          nombre: _nombre.text,
          telefono: _telefono.text,
          direccion: _direccion.text,
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

  Widget _buildFotoPerfil() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colores.grafitoClaro,
            backgroundImage: _imagenSeleccionada != null
                ? MemoryImage(_imagenSeleccionada!)
                : null,
            child: _imagenSeleccionada == null
                ? const Icon(
                    Icons.person_outline_rounded,
                    size: 40,
                    color: Colores.naranja,
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colores.naranja,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colores.naranja.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => _mostrarSelectorImagen(),
                tooltip: 'Seleccionar foto',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarSelectorImagen() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colores.grafito,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (contexto) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Foto de perfil',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colores.blanco,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(
              Icons.camera_alt_rounded,
              color: Colores.naranja,
            ),
            title: const Text('Cámara', style: TextStyle(color: Colores.blanco)),
            onTap: () {
              Navigator.of(contexto).pop();
              _seleccionarImagen(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.photo_library_rounded,
              color: Colores.naranja,
            ),
            title: const Text(
              'Galería',
              style: TextStyle(color: Colores.blanco),
            ),
            onTap: () {
              Navigator.of(contexto).pop();
              _seleccionarImagen(ImageSource.gallery);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraSuperior(
        titulo: _esEdicion ? 'Editar cliente' : 'Nuevo cliente',
        subtitulo: _esEdicion
            ? widget.cliente!.nombre
            : 'Datos de contacto del propietario',
        mostrarVolver: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            _buildFotoPerfil(),
            const SizedBox(height: 20),
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
              etiqueta: 'Dirección (opcional)',
              controlador: _direccion,
              icono: Icons.place_outlined,
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            BotonPrincipal(
              texto: _esEdicion ? 'Guardar cambios' : 'Registrar cliente',
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
