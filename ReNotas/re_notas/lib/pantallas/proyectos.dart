
import 'package:flutter/material.dart';

import '../diseno/sistema.dart';
import '../estado/estado_aplicacion.dart';
import '../modelos/proyecto.dart';

class PantallaProyectos extends StatelessWidget {
final EstadoAplicacion estado;
final ValueChanged<Proyecto> alAbrirProyecto;

const PantallaProyectos({
super.key,
required this.estado,
required this.alAbrirProyecto,
});

@override
Widget build(BuildContext context) {
return AnimatedBuilder(
animation: estado,
builder: (context, _) {
final paleta = Paleta.of(context);
final proyectos = estado.proyectosOrdenados;

return Scaffold(
backgroundColor: paleta.fondo,
appBar: AppBar(
backgroundColor: paleta.fondo,
foregroundColor: paleta.texto,
title: const Text(
'Mis proyectos',
style: TextStyle(fontWeight: FontWeight.bold),
),
actions: [
IconButton(
tooltip:
estado.modoClaro ? 'Tema oscuro' : 'Tema claro',
onPressed: estado.alternarTema,
icon: Icon(
estado.modoClaro
? Icons.dark_mode_outlined
: Icons.light_mode_outlined,
),
),
PopupMenuButton<String>(
tooltip: 'Ordenar proyectos',
icon: const Icon(Icons.sort),
onSelected: estado.cambiarOrdenProyectos,
itemBuilder: (context) => [
_checkedItem(
context,
value: 'recientes',
actual: estado.ordenProyectos,
texto: 'Más recientes',
),
_checkedItem(
context,
value: 'nombre',
actual: estado.ordenProyectos,
texto: 'Por nombre',
),
_checkedItem(
context,
value: 'notas',
actual: estado.ordenProyectos,
texto: 'Más notas',
),
],
),
IconButton(
tooltip: 'Crear proyecto',
onPressed: () => _mostrarFormulario(context),
icon: const Icon(Icons.add),
),
],
),
body: proyectos.isEmpty
? EstadoVacio(
icono: Icons.folder_open_outlined,
titulo: 'Todavía no tienes proyectos',
mensaje:
'Crea un proyecto para comenzar a organizar tus notas.',
textoAccion: 'Crear proyecto',
alAccion: () => _mostrarFormulario(context),
)
    : ListView.builder(
key: const PageStorageKey('lista_proyectos'),
padding: const EdgeInsets.all(Esp.l),
itemCount: proyectos.length,
itemBuilder: (context, indice) {
final proyecto = proyectos[indice];

return Dismissible(
key: ValueKey(proyecto.id),
direction: DismissDirection.endToStart,
background: Container(
alignment: Alignment.centerRight,
padding: const EdgeInsets.only(right: Esp.xl),
margin: const EdgeInsets.only(bottom: Esp.m),
decoration: BoxDecoration(
color: paleta.peligro,
borderRadius:
BorderRadius.circular(Radios.tarjeta),
),
child: const Icon(
Icons.delete_outline,
color: Colors.white,
),
),
confirmDismiss: (_) =>
_conseguirloEliminar(context, proyecto),
onDismissed: (_) =>
_eliminarConDeshacer(context, proyecto),
child: _construirTarjeta(
context,
proyecto,
),
);
},
),
floatingActionButton: FloatingActionButton.extended(
heroTag: 'nuevo_proyecto',
onPressed: () => _mostrarFormulario(context),
backgroundColor: paleta.borgona,
foregroundColor: Colors.white,
icon: const Icon(Icons.create_new_folder_outlined),
label: const Text('Nuevo proyecto'),
),
);
},
);
}

PopupMenuItem<String> _checkedItem(
BuildContext context, {
required String value,
required String actual,
required String texto,
}) {
final paleta = Paleta.of(context);
return PopupMenuItem(
value: value,
child: Row(
children: [
Icon(
value == actual
? Icons.check
: Icons.check_box_outline_blank,
size: 18,
color: paleta.doradoTexto,
),
const SizedBox(width: Esp.s),
Text(
texto,
style: TextStyle(color: paleta.texto),
),
],
),
);
}

Widget _construirTarjeta(
BuildContext context,
Proyecto proyecto,
) {
final paleta = Paleta.of(context);
final cantidadNotas = estado.notasDeProyecto(proyecto.id).length;

return TarjetaBase(
alPresionar: () => alAbrirProyecto(proyecto),
hijo: Row(
children: [
const AzulejoIcono(icono: Icons.folder_outlined),
const SizedBox(width: 14),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const MicroEtiqueta('Proyecto'),
const SizedBox(height: 2),
Text(
proyecto.nombre,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: TextStyle(
color: paleta.texto,
fontSize: 17,
fontWeight: FontWeight.bold,
height: 1.25,
),
),
if (proyecto.descripcion.isNotEmpty) ...[
const SizedBox(height: 5),
Text(
proyecto.descripcion,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: TextStyle(
color: paleta.textoSuave,
fontSize: 13,
height: 1.4,
),
),
],
const SizedBox(height: 10),
Row(
children: [
Container(
padding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 4,
),
decoration: BoxDecoration(
color: paleta.dorado.withValues(alpha: 0.14),
borderRadius: BorderRadius.circular(20),
),
child: Text(
'$cantidadNotas ${cantidadNotas == 1 ? 'nota' : 'notas'}',
style: TextStyle(
color: paleta.doradoTexto,
fontSize: 12,
fontWeight: FontWeight.w700,
),
),
),
const SizedBox(width: 8),
Expanded(
child: Text(
// RF1: fecha de última modificación del proyecto.
'Modificado ${haceCuanto(proyecto.fechaModificacion)}',
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: TextStyle(
color: paleta.textoSuave,
fontSize: 11,
),
),
),
],
),
],
),
),
PopupMenuButton<String>(
icon: Icon(
Icons.more_vert,
color: paleta.textoSuave,
),
onSelected: (opcion) async {
if (opcion == 'editar') {
_mostrarFormulario(
context,
proyecto: proyecto,
);
} else if (opcion == 'eliminar') {
if (await _conseguirloEliminar(
context,
proyecto,
)) {
if (!context.mounted) return;
_eliminarConDeshacer(context, proyecto);
}
}
},
itemBuilder: (context) => [
PopupMenuItem(
value: 'editar',
child: Text(
'Editar proyecto',
style: TextStyle(color: paleta.texto),
),
),
PopupMenuItem(
value: 'eliminar',
child: Text(
'Eliminar proyecto',
style: TextStyle(color: paleta.texto),
),
),
],
),
],
),
);
}

Future<void> _mostrarFormulario(
BuildContext context, {
Proyecto? proyecto,
}) async {
// El diálogo es un StatefulWidget propio que crea y destruye sus
// controladores con su mismo ciclo de vida. Destruirlos fuera (tras
// el showDialog) los mataba mientras la ruta seguía animando su
// salida y provocaba la pantalla roja en el celular.
final resultado = await showDialog<_DatosProyecto>(
context: context,
builder: (contextoDialogo) => _DialogoProyecto(proyecto: proyecto),
);

if (!context.mounted || resultado == null) return;

try {
if (proyecto == null) {
estado.agregarProyecto(
nombre: resultado.nombre,
descripcion: resultado.descripcion,
);
if (context.mounted) {
mostrarAviso(context, 'Proyecto creado.');
}
} else {
estado.editarProyecto(
id: proyecto.id,
nombre: resultado.nombre,
descripcion: resultado.descripcion,
);
if (context.mounted) {
mostrarAviso(context, 'Proyecto actualizado.');
}
}
} on ArgumentError catch (error) {
if (context.mounted) {
mostrarAviso(context, error.message.toString());
}
}
}

Future<bool> _conseguirloEliminar(
BuildContext context,
Proyecto proyecto,
) async {
final paleta = Paleta.of(context);
final confirmar = await showDialog<bool>(
context: context,
builder: (contextoDialogo) {
return AlertDialog(
backgroundColor: paleta.tarjeta,
title: Text(
'Eliminar proyecto',
style: TextStyle(color: paleta.texto),
),
content: Text(
'¿Quieres eliminar "${proyecto.nombre}" y todas sus notas? '
'Esta acción no se puede deshacer.',
style: TextStyle(color: paleta.textoSuave),
),
actions: [
TextButton(
onPressed: () => Navigator.pop(contextoDialogo, false),
child: const Text('Cancelar'),
),
FilledButton(
style: FilledButton.styleFrom(
backgroundColor: paleta.borgona,
),
onPressed: () => Navigator.pop(contextoDialogo, true),
child: const Text('Eliminar'),
),
],
);
},
);

return confirmar == true;
}

void _eliminarConDeshacer(BuildContext context, Proyecto proyecto) {
estado.eliminarProyecto(proyecto.id);
if (!context.mounted) return;
mostrarAviso(
context,
'Proyecto eliminado.',
accionTexto: 'Deshacer',
alAccion: estado.deshacerBorrado,
);
}
}

/// Datos escritos en el diálogo de proyecto.
class _DatosProyecto {
final String nombre;
final String descripcion;

const _DatosProyecto({
required this.nombre,
required this.descripcion,
});
}

/// Diálogo de crear/editar proyecto.
///
/// Es un StatefulWidget para que los TextEditingController vivan lo
/// mismo que el diálogo y se destruyan en [dispose], cuando la ruta
/// ya terminó de salir. Así ningún frame de la animación de salida
/// los usa destruidos.
class _DialogoProyecto extends StatefulWidget {
final Proyecto? proyecto;

const _DialogoProyecto({this.proyecto});

@override
State<_DialogoProyecto> createState() => _DialogoProyectoState();
}

class _DialogoProyectoState extends State<_DialogoProyecto> {
final _formularioClave = GlobalKey<FormState>();

late final TextEditingController _controladorNombre =
TextEditingController(text: widget.proyecto?.nombre ?? '');
late final TextEditingController _controladorDescripcion =
TextEditingController(text: widget.proyecto?.descripcion ?? '');

@override
void dispose() {
_controladorNombre.dispose();
_controladorDescripcion.dispose();
super.dispose();
}

void _cancelar() {
FocusScope.of(context).unfocus();
Navigator.pop(context);
}

void _guardar() {
if (!_formularioClave.currentState!.validate()) return;
FocusScope.of(context).unfocus();
Navigator.pop(
context,
_DatosProyecto(
nombre: _controladorNombre.text,
descripcion: _controladorDescripcion.text,
),
);
}

@override
Widget build(BuildContext context) {
final paleta = Paleta.of(context);
final esNuevo = widget.proyecto == null;

return AlertDialog(
backgroundColor: paleta.tarjeta,
scrollable: true,
title: Text(
esNuevo ? 'Nuevo proyecto' : 'Editar proyecto',
style: TextStyle(color: paleta.texto),
),
content: Form(
key: _formularioClave,
child: SingleChildScrollView(
padding: EdgeInsets.only(
bottom: MediaQuery.of(context).viewInsets.bottom,
),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
TextFormField(
controller: _controladorNombre,
autofocus: true,
textInputAction: TextInputAction.next,
maxLength: 80,
style: TextStyle(color: paleta.texto),
decoration: InputDecoration(
labelText: 'Nombre del proyecto',
labelStyle:
TextStyle(color: paleta.textoSuave),
prefixIcon: const Icon(Icons.folder_outlined),
),
validator: (valor) {
if (valor == null || valor.trim().isEmpty) {
return 'Escribe un nombre para el proyecto.';
}
return null;
},
),
const SizedBox(height: Esp.l),
TextFormField(
controller: _controladorDescripcion,
maxLines: 3,
minLines: 1,
maxLength: 300,
textInputAction: TextInputAction.done,
style: TextStyle(color: paleta.texto),
decoration: InputDecoration(
labelText: 'Descripción (opcional)',
labelStyle:
TextStyle(color: paleta.textoSuave),
alignLabelWithHint: true,
prefixIcon:
const Icon(Icons.description_outlined),
),
),
],
),
),
),
actions: [
TextButton(
onPressed: _cancelar,
child: const Text('Cancelar'),
),
FilledButton(
onPressed: _guardar,
child: const Text('Guardar'),
),
],
);
}
}
