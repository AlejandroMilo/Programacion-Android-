
import 'package:flutter/material.dart';
import '../diseno/sistema.dart';
import '../estado/estado_aplicacion.dart';
import '../modelos/nota.dart';
import '../modelos/proyecto.dart';
import '../componentes/tarjeta_resultado_nota.dart';
import 'detalle_nota.dart';
import 'editar_nota.dart';

class PantallaBusqueda extends StatefulWidget {
final EstadoAplicacion estado;

const PantallaBusqueda({
super.key,
required this.estado,
});

@override
State<PantallaBusqueda> createState() => _PantallaBusquedaState();
}

class _PantallaBusquedaState extends State<PantallaBusqueda> {
final TextEditingController _controladorBusqueda =
TextEditingController();

String? _proyectoIdSeleccionado;
final Set<String> _etiquetasSeleccionadas = {};

// true  -> notas que tienen TODAS las etiquetas elegidas.
// false -> notas que tienen AL MENOS UNA de las etiquetas elegidas.
bool _modoTodas = true;
bool _soloFavoritas = false;

@override
void dispose() {
_controladorBusqueda.dispose();
super.dispose();
}

List<Nota> _obtenerResultados() {
return widget.estado.buscarNotas(
consulta: _controladorBusqueda.text,
proyectoId: _proyectoIdSeleccionado,
etiquetasIds: _etiquetasSeleccionadas.toList(),
modoTodas: _modoTodas,
soloFavoritas: _soloFavoritas,
);
}

void _abrirDetalle(Nota nota) {
abrirPantalla(
context,
PantallaDetalleNota(
estado: widget.estado,
notaId: nota.id,
),
);
}

void _abrirEditor(Nota nota) {
final Proyecto? proyecto =
widget.estado.buscarProyectoPorId(nota.proyectoId);

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
estado: widget.estado,
proyecto: proyecto,
nota: nota,
),
);
}

Future<void> _confirmarEliminar(Nota nota) async {
final paleta = Paleta.of(context);
final bool? confirmar = await showDialog<bool>(
context: context,
builder: (contexto) => AlertDialog(
backgroundColor: paleta.tarjeta,
title: Text(
'Eliminar nota',
style: TextStyle(color: paleta.texto),
),
content: Text(
'¿Seguro que quieres eliminar "${nota.titulo}"?',
style: TextStyle(color: paleta.textoSuave),
),
actions: [
TextButton(
onPressed: () => Navigator.pop(contexto, false),
child: const Text('Cancelar'),
),
FilledButton(
style: FilledButton.styleFrom(
backgroundColor: paleta.borgona,
),
onPressed: () => Navigator.pop(contexto, true),
child: const Text('Eliminar'),
),
],
),
);

if (!mounted || confirmar != true) return;

widget.estado.eliminarNota(nota.id);

if (!mounted) return;
mostrarAviso(
context,
'Nota eliminada.',
accionTexto: 'Deshacer',
alAccion: widget.estado.deshacerBorrado,
);
}

void _limpiarFiltros() {
setState(() {
_controladorBusqueda.clear();
_proyectoIdSeleccionado = null;
_etiquetasSeleccionadas.clear();
_soloFavoritas = false;
});
}

@override
Widget build(BuildContext context) {
return AnimatedBuilder(
animation: widget.estado,
builder: (contexto, hijo) {
final paleta = Paleta.of(context);
final resultados = _obtenerResultados();
final proyectos = widget.estado.proyectos;
final etiquetas = widget.estado.etiquetas;
final hayFiltros = _controladorBusqueda.text.isNotEmpty ||
_proyectoIdSeleccionado != null ||
_etiquetasSeleccionadas.isNotEmpty ||
_soloFavoritas;

return Scaffold(
resizeToAvoidBottomInset: true,
appBar: AppBar(
title: const Text('Buscar notas'),
),
// SingleChildScrollView + lista interna con shrinkWrap:
// toda la pantalla hace scroll y nunca da overflow,
// ni en pantallas pequeñas ni con el teclado abierto.
body: SafeArea(
child: SingleChildScrollView(
key: const PageStorageKey('scroll_busqueda'),
padding: const EdgeInsets.only(bottom: 20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
Padding(
padding: const EdgeInsets.all(16),
child: TextField(
controller: _controladorBusqueda,
onChanged: (texto) => setState(() {}),
style: TextStyle(color: paleta.texto),
decoration: InputDecoration(
hintText: 'Buscar por título o contenido...',
hintStyle: TextStyle(color: paleta.pista),
prefixIcon: Icon(
Icons.search,
color: paleta.doradoTexto,
),
suffixIcon: IconButton(
tooltip: 'Limpiar búsqueda',
icon: const Icon(Icons.clear),
onPressed: () {
_controladorBusqueda.clear();
setState(() {});
},
),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
),
),
),
),

Padding(
padding: const EdgeInsets.symmetric(horizontal: 16),
child: DropdownButtonFormField<String>(
initialValue: _proyectoIdSeleccionado,
isExpanded: true,
decoration: const InputDecoration(
labelText: 'Filtrar por proyecto',
border: OutlineInputBorder(),
prefixIcon: Icon(Icons.folder_outlined),
),
items: [
const DropdownMenuItem<String>(
value: null,
child: Text('Todos los proyectos'),
),
...proyectos.map(
(proyecto) => DropdownMenuItem<String>(
value: proyecto.id,
child: Text(
proyecto.nombre,
overflow: TextOverflow.ellipsis,
),
),
),
],
onChanged: (valor) {
setState(() {
_proyectoIdSeleccionado = valor;
});
},
),
),

Padding(
padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
child: Wrap(
spacing: 8,
children: [
FilterChip(
label: const Text('Favoritas'),
avatar: Icon(
_soloFavoritas
? Icons.star
: Icons.star_border,
size: 18,
color: paleta.estrella,
),
selected: _soloFavoritas,
onSelected: (valor) {
setState(() => _soloFavoritas = valor);
},
),
if (hayFiltros)
ActionChip(
label: const Text('Limpiar filtros'),
avatar: const Icon(Icons.clear, size: 18),
onPressed: _limpiarFiltros,
),
],
),
),

if (etiquetas.isNotEmpty)
Padding(
padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
child: Align(
alignment: Alignment.centerLeft,
child: Text(
'Filtrar por etiquetas',
style: Theme.of(context).textTheme.titleSmall?.copyWith(
color: paleta.texto,
),
),
),
),

if (etiquetas.isNotEmpty)
SizedBox(
height: 48,
child: ListView.builder(
key: const PageStorageKey('filtros_etiquetas_busqueda'),
scrollDirection: Axis.horizontal,
padding: const EdgeInsets.symmetric(horizontal: 12),
// La cantidad de etiquetas siempre se conoce.
itemCount: etiquetas.length,
itemBuilder: (contexto, indice) {
final etiqueta = etiquetas[indice];
final seleccionada =
_etiquetasSeleccionadas.contains(etiqueta.id);

return Padding(
padding: const EdgeInsets.symmetric(horizontal: 4),
child: FilterChip(
label: Text(etiqueta.nombre),
selected: seleccionada,
onSelected: (valor) {
setState(() {
if (valor) {
_etiquetasSeleccionadas.add(etiqueta.id);
} else {
_etiquetasSeleccionadas.remove(etiqueta.id);
}
});
},
),
);
},
),
),

// Modo de agrupación por etiquetas: todas o al menos una.
if (_etiquetasSeleccionadas.length > 1)
Padding(
padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
child: Row(
children: [
Icon(
Icons.filter_alt_outlined,
size: 17,
color: paleta.doradoTexto,
),
const SizedBox(width: 6),
Expanded(
child: SegmentedButton<bool>(
segments: const [
ButtonSegment(
value: true,
label: Text('Todas'),
),
ButtonSegment(
value: false,
label: Text('Al menos una'),
),
],
selected: {_modoTodas},
onSelectionChanged: (valores) {
setState(() => _modoTodas = valores.first);
},
),
),
],
),
),

Padding(
padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
child: Align(
alignment: Alignment.centerLeft,
child: Text(
'${resultados.length} '
'${resultados.length == 1 ? 'resultado' : 'resultados'}',
style: Theme.of(context).textTheme.bodyMedium?.copyWith(
color: paleta.textoSuave,
),
),
),
),

resultados.isEmpty
? EstadoVacio(
icono: Icons.search_off,
titulo: 'No se encontraron notas',
mensaje:
'Prueba otra palabra o cambia los filtros.',
textoAccion: hayFiltros ? 'Limpiar filtros' : null,
alAccion: hayFiltros ? _limpiarFiltros : null,
)
: ListView.separated(
key: const PageStorageKey('resultados_busqueda'),
shrinkWrap: true,
physics: const NeverScrollableScrollPhysics(),
padding: const EdgeInsets.fromLTRB(
16, 0, 16, 0,
),
itemCount: resultados.length,
separatorBuilder: (contexto, indice) =>
const SizedBox(height: 10),
itemBuilder: (contexto, indice) {
final nota = resultados[indice];

final etiquetasNota = etiquetas.where(
(etiqueta) =>
nota.etiquetasIds.contains(etiqueta.id),
).toList();

return TarjetaResultadoNota(
nota: nota,
// RF6: el resultado debe indicar el proyecto de la nota.
nombreProyecto: widget.estado.nombreProyectoDe(nota),
etiquetas: etiquetasNota,
alPresionar: () => _abrirDetalle(nota),
alEditar: () => _abrirEditor(nota),
alEliminar: () => _confirmarEliminar(nota),
alAlternarFavorita: () {
widget.estado.alternarFavorita(nota.id);
},
alAlternarFija: () {
widget.estado.alternarFija(nota.id);
},
);
},
),
],
),
),
),
);
},
);
}
}
