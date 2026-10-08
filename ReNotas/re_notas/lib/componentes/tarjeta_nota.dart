
import 'package:flutter/material.dart';

import '../diseno/sistema.dart';
import '../modelos/nota.dart';
import '../modelos/etiqueta.dart';
import 'etiqueta_visual.dart';

class TarjetaNota extends StatelessWidget {
final Nota nota;
final List<Etiqueta> etiquetas;
final VoidCallback alPresionar;
final VoidCallback? alEditar;
final VoidCallback? alEliminar;
final VoidCallback? alAlternarFavorita;
final VoidCallback? alAlternarFija;

const TarjetaNota({
super.key,
required this.nota,
required this.etiquetas,
required this.alPresionar,
this.alEditar,
this.alEliminar,
this.alAlternarFavorita,
this.alAlternarFija,
});

@override
Widget build(BuildContext context) {
final tema = Theme.of(context);
final paleta = Paleta.of(context);

return TarjetaBase(
alPresionar: alPresionar,
hijo: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
AzulejoIcono(
icono: nota.fija
? Icons.push_pin
: Icons.description_outlined,
lado: 44,
tamanoIcono: 22,
dorado: true,
),
const SizedBox(width: Esp.m),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
if (nota.fija)
const MicroEtiqueta('Fijada'),
Text(
nota.titulo,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: tema.textTheme.titleMedium?.copyWith(
color: paleta.texto,
fontWeight: FontWeight.bold,
height: 1.3,
),
),
],
),
),
if (alAlternarFavorita != null)
IconButton(
tooltip: nota.esFavorita
? 'Quitar de favoritas'
: 'Marcar como favorita',
visualDensity: VisualDensity.compact,
onPressed: alAlternarFavorita,
icon: Icon(
nota.esFavorita ? Icons.star_rounded : Icons.star_border_rounded,
color: nota.esFavorita
? paleta.estrella
: paleta.textoSuave,
),
),
PopupMenuButton<String>(
icon: Icon(
Icons.more_vert,
color: paleta.textoSuave,
),
color: paleta.tarjeta,
onSelected: (opcion) {
if (opcion == 'editar') {
alEditar?.call();
} else if (opcion == 'eliminar') {
alEliminar?.call();
} else if (opcion == 'fijar') {
alAlternarFija?.call();
}
},
itemBuilder: (context) => [
if (alAlternarFija != null)
PopupMenuItem(
value: 'fijar',
child: Text(
nota.fija ? 'Desfijar' : 'Fijar arriba',
style: TextStyle(color: paleta.texto),
),
),
if (alEditar != null)
PopupMenuItem(
value: 'editar',
child: Text(
'Editar nota',
style: TextStyle(color: paleta.texto),
),
),
if (alEliminar != null)
PopupMenuItem(
value: 'eliminar',
child: Text(
'Eliminar nota',
style: TextStyle(color: paleta.texto),
),
),
],
),
],
),
if (nota.descripcion.trim().isNotEmpty) ...[
const SizedBox(height: Esp.s),
Text(
nota.descripcion,
maxLines: 3,
overflow: TextOverflow.ellipsis,
style: tema.textTheme.bodyMedium?.copyWith(
color: paleta.textoSuave,
height: 1.5,
),
),
],
if (etiquetas.isNotEmpty) ...[
const SizedBox(height: Esp.m),
Wrap(
children: etiquetas.map((etiqueta) {
return EtiquetaVisual(etiqueta: etiqueta);
}).toList(),
),
],
const SizedBox(height: Esp.m),
Row(
children: [
Icon(
Icons.schedule_rounded,
size: 14,
color: paleta.textoSuave,
),
const SizedBox(width: 5),
Text(
haceCuanto(nota.fechaModificacion),
style: TextStyle(
fontSize: 11,
color: paleta.textoSuave,
fontWeight: FontWeight.w600,
),
),
if (nota.esFavorita) ...[
const SizedBox(width: Esp.s),
Icon(
Icons.star_rounded,
size: 14,
color: paleta.estrella,
),
],
const Spacer(),
Icon(
Icons.arrow_forward_ios_rounded,
size: 12,
color: paleta.doradoTexto,
),
],
),
],
),
);
}
}
