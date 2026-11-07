import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/preferencias.dart';
import '../../aplicacion/sesion.dart';
import '../../componentes/botones/boton_principal.dart';
import '../../componentes/botones/boton_secundario.dart';
import '../../componentes/formularios/campo_texto.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/constantes.dart';
import '../../utilidades/formatos.dart';

class PantallaConfiguracion extends StatelessWidget {
  const PantallaConfiguracion({super.key});

  @override
  Widget build(BuildContext context) {
    final sesion = context.watch<Sesion>();
    final prefs = context.watch<Preferencias>();
    return Scaffold(
      appBar: const BarraSuperior(
        titulo: 'Configuración',
        subtitulo: 'Ajustes de la aplicación y del taller',
        mostrarVolver: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          const SeccionTitulo(titulo: 'Tema de la aplicación', icono: Icons.dark_mode_outlined),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _ModoChip(
                etiqueta: 'Oscuro',
                valor: ThemeMode.dark,
                actual: prefs.modo,
                icono: Icons.dark_mode_outlined,
                onTap: () => prefs.cambiarModo(ThemeMode.dark),
              ),
              _ModoChip(
                etiqueta: 'Claro',
                valor: ThemeMode.light,
                actual: prefs.modo,
                icono: Icons.light_mode_outlined,
                onTap: () => prefs.cambiarModo(ThemeMode.light),
              ),
              _ModoChip(
                etiqueta: 'Sistema',
                valor: ThemeMode.system,
                actual: prefs.modo,
                icono: Icons.settings_brightness_outlined,
                onTap: () => prefs.cambiarModo(ThemeMode.system),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const SeccionTitulo(titulo: 'Datos del taller', icono: Icons.storefront_outlined),
          const SizedBox(height: 8),
          Text('Nombre, teléfono y dirección aparecen en reportes y recibos.',
              style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor)),
          const SizedBox(height: 10),
          _CampoTaller(
            etiqueta: 'Nombre del taller',
            valorInicial: prefs.nombreTaller,
            icono: Icons.store_rounded,
            editable: sesion.esAdministrador,
            onGuardar: (valor) => _guardarTaller(context, prefs, nombre: valor),
          ),
          const SizedBox(height: 10),
          _CampoTaller(
            etiqueta: 'Teléfono',
            valorInicial: prefs.telefonoTaller,
            icono: Icons.phone_rounded,
            editable: sesion.esAdministrador,
            teclado: TextInputType.phone,
            onGuardar: (valor) => _guardarTaller(context, prefs, telefono: valor),
          ),
          const SizedBox(height: 10),
          _CampoTaller(
            etiqueta: 'Dirección',
            valorInicial: prefs.direccionTaller,
            icono: Icons.location_on_rounded,
            editable: sesion.esAdministrador,
            onGuardar: (valor) => _guardarTaller(context, prefs, direccion: valor),
          ),
          if (!sesion.esAdministrador) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colores.naranja.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
              child: const Text('Solo el administrador puede editar los datos del taller.', style: TextStyle(fontSize: 10.5, color: Colores.naranja)),
            ),
          ],
          const SizedBox(height: 22),
          const SeccionTitulo(titulo: 'Inventario', icono: Icons.inventory_2_outlined),
          const SizedBox(height: 8),
          Text('Umbral por defecto para considerar que un repuesto tiene stock bajo.',
              style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, size: 20, color: Colores.amarillo),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: prefs.umbralInventario.toDouble(),
                  min: 0,
                  max: 20,
                  divisions: 20,
                  label: '${prefs.umbralInventario} unidades',
                  onChanged: sesion.esAdministrador
                      ? (v) => prefs.cambiarUmbral(v.round())
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Text('${prefs.umbralInventario}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
            ],
          ),
          if (!sesion.esAdministrador) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colores.naranja.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
              child: const Text('Solo el administrador puede cambiar el umbral de inventario.', style: TextStyle(fontSize: 10.5, color: Colores.naranja)),
            ),
          ],
          const SizedBox(height: 22),
          const SeccionTitulo(titulo: 'Acerca de', icono: Icons.info_outlined),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.car_repair_rounded, color: Colores.naranja, size: 24),
                      const SizedBox(width: 10),
                      const Text('El Pistón', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Taller Automotriz · Gestión móvil', style: TextStyle(fontSize: 11.5, color: Theme.of(context).hintColor)),
                  const SizedBox(height: 4),
                  Text('Versión ${Constantes.version}', style: TextStyle(fontSize: 10, color: Theme.of(context).hintColor)),
                  const SizedBox(height: 4),
                  Text('Persistencia local con Drift/SQLite. La información sobrevive al cierre de la app.',
                      style: TextStyle(fontSize: 9.5, color: Theme.of(context).hintColor)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          BotonSecundario(
            texto: 'Cerrar sesión',
            icono: Icons.logout_rounded,
            expandido: true,
            onPressed: () {
              final navegador = Navigator.of(context);
              navegador.popUntil((r) => r.isFirst);
              context.read<Sesion>().cerrarSesion();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _guardarTaller(BuildContext context, Preferencias prefs, {String? nombre, String? telefono, String? direccion}) async {
    await prefs.guardarDatosTaller(
      nombre: nombre ?? prefs.nombreTaller,
      telefono: telefono ?? prefs.telefonoTaller,
      direccion: direccion ?? prefs.direccionTaller,
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Datos del taller guardados')));
    }
  }
}

class _ModoChip extends StatelessWidget {
  const _ModoChip({
    required this.etiqueta,
    required this.valor,
    required this.actual,
    required this.icono,
    required this.onTap,
  });

  final String etiqueta;
  final ThemeMode valor;
  final ThemeMode actual;
  final IconData icono;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final seleccionado = actual == valor;
    return ChoiceChip(
      selected: seleccionado,
      onSelected: (_) => onTap(),
      avatar: Icon(icono, size: 17, color: seleccionado ? Colors.white : null),
      label: Text(etiqueta, style: const TextStyle(fontSize: 11.5)),
      selectedColor: Colores.naranja,
      showCheckmark: false,
    );
  }
}

class _CampoTaller extends StatefulWidget {
  const _CampoTaller({
    required this.etiqueta,
    required this.valorInicial,
    required this.icono,
    required this.editable,
    required this.onGuardar,
    this.teclado,
  });

  final String etiqueta;
  final String valorInicial;
  final IconData icono;
  final bool editable;
  final TextInputType? teclado;
  final ValueChanged<String> onGuardar;

  @override
  State<_CampoTaller> createState() => _CampoTallerState();
}

class _CampoTallerState extends State<_CampoTaller> {
  late final TextEditingController _controlador;
  bool _editando = false;

  @override
  void initState() {
    super.initState();
    _controlador = TextEditingController(text: widget.valorInicial);
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controlador,
                      enabled: widget.editable && _editando,
                      keyboardType: widget.teclado,
                      decoration: InputDecoration(
                        labelText: widget.etiqueta,
                        prefixIcon: Icon(widget.icono, size: 18),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  if (widget.editable) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: _editando ? 'Cancelar' : 'Editar',
                      onPressed: () {
                        if (_editando) {
                          _controlador.text = widget.valorInicial;
                          setState(() => _editando = false);
                        } else {
                          setState(() => _editando = true);
                        }
                      },
                      icon: Icon(_editando ? Icons.close_rounded : Icons.edit_outlined, size: 20),
                    ),
                    const SizedBox(width: 4),
                    if (_editando) ...[
                      IconButton(
                        tooltip: 'Guardar',
                        onPressed: () => widget.onGuardar(_controlador.text),
                        icon: const Icon(Icons.save_rounded, size: 20, color: Colores.naranja),
                      ),
                    ],
                  ],
                ],
              ),
            ],
          ),
      ),
    ],
  );
  }
}
