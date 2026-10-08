
import 'package:flutter/material.dart';

import '../diseno/sistema.dart';
import '../modelos/etiqueta.dart';

class EtiquetaVisual extends StatelessWidget {
final Etiqueta etiqueta;
final VoidCallback? alPresionar;
final bool mostrarCerrar;

const EtiquetaVisual({
super.key,
required this.etiqueta,
this.alPresionar,
this.mostrarCerrar = false,
});

@override
Widget build(BuildContext context) {
return InkWell(
onTap: alPresionar,
borderRadius: BorderRadius.circular(Radios.chip),
child: Container(
margin: const EdgeInsets.only(right: Esp.s, bottom: Esp.s),
padding: const EdgeInsets.symmetric(
horizontal: Esp.m,
vertical: 7,
),
decoration: BoxDecoration(
color: etiqueta.color.withValues(alpha: 0.15),
border: Border.all(
color: etiqueta.color.withValues(alpha: 0.65),
),
borderRadius: BorderRadius.circular(Radios.chip),
),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [
Container(
width: 8,
height: 8,
decoration: BoxDecoration(
color: etiqueta.color,
shape: BoxShape.circle,
),
),
const SizedBox(width: 7),
Text(
etiqueta.nombre,
style: TextStyle(
color: etiqueta.color,
fontSize: 12,
fontWeight: FontWeight.w600,
),
),
if (mostrarCerrar) ...[
const SizedBox(width: 5),
Icon(
Icons.close,
size: 14,
color: etiqueta.color,
),
],
],
),
),
);
}
}
