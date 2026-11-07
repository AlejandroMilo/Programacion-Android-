import 'package:flutter/material.dart';

import '../../datos/base_datos.dart';
import '../../utilidades/colores.dart';

/// Devuelve el id del mecánico elegido, 0 para "sin asignar" o null si se
/// cierra el panel sin elegir.
class AsignarMecanicoSheet extends StatelessWidget {
  const AsignarMecanicoSheet({
    super.key,
    required this.mecanicos,
    this.actualId,
  });

  final List<Mecanico> mecanicos;
  final int? actualId;

  static Future<int?> mostrar(
    BuildContext context, {
    required List<Mecanico> mecanicos,
    int? actualId,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (_) =>
          AsignarMecanicoSheet(mecanicos: mecanicos, actualId: actualId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Asignar mecánico',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              'Solo los mecánicos activos aparecen en la lista.',
              style: TextStyle(fontSize: 12, color: tema.hintColor),
            ),
            const SizedBox(height: 12),
            ListTile(
              onTap: () => Navigator.of(context).pop(0),
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Colores.grisClaro,
                child: Icon(
                  Icons.person_off_outlined,
                  color: Colores.grafito,
                  size: 19,
                ),
              ),
              title: const Text('Sin asignar'),
              trailing: actualId == null
                  ? const Icon(Icons.check_circle_rounded, color: Colores.verde)
                  : null,
            ),
            for (final mecanico in mecanicos)
              ListTile(
                onTap: () => Navigator.of(context).pop(mecanico.id),
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Colores.naranja.withValues(alpha: 0.15),
                  child: const Icon(
                    Icons.engineering_rounded,
                    color: Colores.naranja,
                    size: 20,
                  ),
                ),
                title: Text(mecanico.nombre),
                subtitle: mecanico.especialidad == null
                    ? null
                    : Text(mecanico.especialidad!),
                trailing: actualId == mecanico.id
                    ? const Icon(Icons.check_circle_rounded, color: Colores.verde)
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
