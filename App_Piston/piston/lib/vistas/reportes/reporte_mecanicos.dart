import 'package:flutter/material.dart';

import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../componentes/tarjetas/tarjeta_resumen.dart';
import '../../datos/base_datos.dart';
import '../../modelos/mecanico.dart';
import '../../modelos/resumen_taller.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';

class ReporteMecanicos extends StatelessWidget {
  const ReporteMecanicos({super.key, required this.datos});

  final List<CargaMecanico> datos;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SeccionTitulo(titulo: 'Carga de trabajo por mecánico', icono: Icons.engineering_rounded),
            const SizedBox(height: 10),
            if (datos.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('Sin datos en el período.', style: TextStyle(fontSize: 12, color: tema.hintColor)),
              )
            else
              ...datos.map((c) {
                final m = c.mecanico;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m.nombre, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                            Text(m.especialidad ?? 'Sin especialidad', style: TextStyle(fontSize: 10.5, color: tema.hintColor)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${c.ordenesAbiertas} abiertas', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colores.naranja)),
                          Text('${c.ordenesTerminadas} terminadas', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colores.verde)),
                          Text(Formatos.dineroExacto(c.manoObra), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}
