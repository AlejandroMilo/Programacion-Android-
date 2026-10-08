
import 'package:flutter/material.dart';
import '../diseno/sistema.dart';
import '../estado/estado_aplicacion.dart';
import '../modelos/nota.dart';
import '../componentes/etiqueta_visual.dart';
import '../modelos/etiqueta.dart';
import 'editar_nota.dart';
import 'etiquetas.dart';

class PantallaDetalleNota extends StatelessWidget {
final EstadoAplicacion estado;
final String notaId;

const PantallaDetalleNota({
super.key,
required this.estado,
required this.notaId,
});

@override
Widget build(BuildContext context) {
return AnimatedBuilder(
animation: estado,
builder: (context, _) {
final paleta = Paleta.of(context);
final nota = estado.buscarNotaPorId(notaId);

if (nota == null) {
return Scaffold(
backgroundColor: paleta.fondo,
appBar: AppBar(
backgroundColor: paleta.fondo,
foregroundColor: paleta.texto,
),
body: const EstadoVacio(
icono: Icons.note_outlined,
titulo: 'Esta nota ya no existe',
mensaje: 'Vuelve al listado anterior.',
),
);
}

final proyecto = estado.buscarProyectoPorId(nota.proyectoId);
final etiquetas = estado.etiquetasDeNota(nota);

return Scaffold(
backgroundColor: paleta.fondo,
appBar: AppBar(
backgroundColor: paleta.fondo,
foregroundColor: paleta.texto,
title: const Text('Detalle de la nota'),
actions: [
IconButton(
tooltip: nota.esFavorita
? 'Quitar de favoritas'
: 'Marcar como favorita',
onPressed: () => estado.alternarFavorita(nota.id),
icon: Icon(
nota.esFavorita ? Icons.star : Icons.star_border,
color: nota.esFavorita
? paleta.estrella
: paleta.texto,
),
),
IconButton(
tooltip: nota.fija ? 'Desfijar' : 'Fijar arriba',
onPressed: () => estado.alternarFija(nota.id),
icon: Icon(
nota.fija ? Icons.push_pin : Icons.push_pin_outlined,
color:
nota.fija ? paleta.doradoTexto : paleta.texto,
),
),
IconButton(
tooltip: 'Editar nota',
onPressed: () => _editarNota(context, nota),
icon: const Icon(Icons.edit_outlined),
),
IconButton(
tooltip: 'Eliminar nota',
onPressed: () => _confirmarEliminacion(context, nota),
icon: const Icon(Icons.delete_outline),
),
],
),
body: SingleChildScrollView(
padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
if (proyecto != null) ...[
Row(
children: [
Icon(
Icons.folder_outlined,
size: 18,
color: paleta.doradoTexto,
),
const SizedBox(width: 8),
Expanded(
child: Text(
proyecto.nombre,
style: TextStyle(
color: paleta.doradoTexto,
fontSize: 13,
),
),
),
],
),
const SizedBox(height: 20),
],
Text(
nota.titulo,
style: TextStyle(
color: paleta.texto,
fontSize: 27,
fontWeight: FontWeight.bold,
height: 1.25,
letterSpacing: -0.3,
),
),
const SizedBox(height: 8),
Wrap(
spacing: 8,
runSpacing: 8,
children: [
if (nota.fija)
Container(
padding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 4,
),
decoration: BoxDecoration(
color: paleta.dorado.withValues(alpha: 0.14),
borderRadius: BorderRadius.circular(20),
),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [
Icon(
Icons.push_pin,
size: 13,
color: paleta.doradoTexto,
),
const SizedBox(width: 4),
Text(
'Fijada',
style: TextStyle(
color: paleta.doradoTexto,
fontSize: 12,
fontWeight: FontWeight.w700,
),
),
],
),
),
if (nota.esFavorita)
Container(
padding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 4,
),
decoration: BoxDecoration(
color: paleta.estrella.withValues(alpha: 0.14),
borderRadius: BorderRadius.circular(20),
),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [
Icon(
Icons.star_rounded,
size: 14,
color: paleta.estrella,
),
const SizedBox(width: 4),
Text(
'Favorita',
style: TextStyle(
color: paleta.estrella,
fontSize: 12,
fontWeight: FontWeight.w700,
),
),
],
),
),
],
),
const SizedBox(height: 16),
Container(
padding: const EdgeInsets.all(14),
decoration: BoxDecoration(
color: paleta.tarjeta,
borderRadius: BorderRadius.circular(14),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
_construirDato(
context,
Icons.calendar_today_outlined,
'Creada',
_formatearFecha(nota.fechaCreacion),
),
const SizedBox(height: 12),
_construirDato(
context,
Icons.update,
'Última modificación',
_formatearFecha(nota.fechaModificacion),
),
],
),
),
const SizedBox(height: 24),
Text(
'Descripción',
style: TextStyle(
color: paleta.doradoTexto,
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 10),
Container(
width: double.infinity,
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: paleta.tarjeta,
borderRadius: BorderRadius.circular(14),
),
child: SelectableText(
nota.descripcion.trim().isEmpty
? 'Esta nota no tiene descripción.'
    : nota.descripcion,
style: TextStyle(
color: paleta.textoSuave,
fontSize: 15,
height: 1.7,
),
),
),
const SizedBox(height: 24),
Text(
'Etiquetas',
style: TextStyle(
color: paleta.doradoTexto,
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 10),
if (etiquetas.isEmpty)
Text(
'Esta nota no tiene etiquetas.',
style: TextStyle(color: paleta.textoSuave),
)
else
Wrap(
children: etiquetas.map((etiqueta) {
// RF4: al tocar una etiqueta se abre la pantalla de Etiquetas
// filtrada por ella, con las notas de todos los proyectos.
return EtiquetaVisual(
etiqueta: etiqueta,
alPresionar: () => _abrirEtiquetas(context, etiqueta),
);
}).toList(),
),
const SizedBox(height: 28),
SizedBox(
width: double.infinity,
child: FilledButton.icon(
onPressed: () => _editarNota(context, nota),
style: FilledButton.styleFrom(
backgroundColor: paleta.borgona,
foregroundColor: Colors.white,
padding: const EdgeInsets.symmetric(vertical: 15),
),
icon: const Icon(Icons.edit_outlined),
label: const Text('Editar nota'),
),
),
const SizedBox(height: 12),
SizedBox(
width: double.infinity,
child: OutlinedButton.icon(
onPressed: () => Navigator.pop(context),
style: OutlinedButton.styleFrom(
foregroundColor: paleta.doradoTexto,
padding: const EdgeInsets.symmetric(vertical: 14),
),
icon: const Icon(Icons.arrow_back),
label: const Text('Volver al listado'),
),
),
],
),
),
);
},
);
}

Widget _construirDato(
BuildContext context,
IconData icono,
String titulo,
String valor,
) {
final paleta = Paleta.of(context);
return Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Icon(icono, size: 17, color: paleta.doradoTexto),
const SizedBox(width: 10),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
titulo,
style: TextStyle(
color: paleta.textoSuave,
fontSize: 12,
),
),
const SizedBox(height: 3),
Text(
valor,
style: TextStyle(
color: paleta.texto,
fontSize: 13,
),
),
],
),
),
],
);
}

String _formatearFecha(DateTime fecha) {
final dia = fecha.day.toString().padLeft(2, '0');
final mes = fecha.month.toString().padLeft(2, '0');
final anio = fecha.year.toString();
final hora = fecha.hour.toString().padLeft(2, '0');
final minuto = fecha.minute.toString().padLeft(2, '0');

return '$dia/$mes/$anio · $hora:$minuto';
}

/// Abre la pantalla de Etiquetas filtrada por la etiqueta pulsada.
void _abrirEtiquetas(BuildContext context, Etiqueta etiqueta) {
abrirPantalla(
context,
PantallaEtiquetas(
estado: estado,
etiquetaInicialId: etiqueta.id,
),
);
}

void _editarNota(BuildContext context, Nota nota) {
final proyecto = estado.buscarProyectoPorId(nota.proyectoId);

if (proyecto == null) {
mostrarAviso(
context,
'No se encontró el proyecto de esta nota.',
);
return;
}

abrirPantalla(
context,
PantallaEditarNota(
estado: estado,
proyecto: proyecto,
nota: nota,
),
);
}

Future<void> _confirmarEliminacion(
BuildContext context,
Nota nota,
) async {
final paleta = Paleta.of(context);
final confirmar = await showDialog<bool>(
context: context,
builder: (contextoDialogo) {
return AlertDialog(
backgroundColor: paleta.tarjeta,
title: Text(
'Eliminar nota',
style: TextStyle(color: paleta.texto),
),
content: Text(
'¿Quieres eliminar "${nota.titulo}"? Esta acción no se puede deshacer.',
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

if (confirmar == true) {
estado.eliminarNota(nota.id);

if (context.mounted) {
Navigator.pop(context);
}
}
}
}
