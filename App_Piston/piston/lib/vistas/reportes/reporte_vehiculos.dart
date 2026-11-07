import 'package:flutter/material.dart';

import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../modelos/resumen_taller.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';

class ReporteVehiculos extends StatelessWidget {
  const ReporteVehiculos({super.key, required this.datos});

  final List<VehiculoAtendido> datos;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SeccionTitulo(titulo: 'Vehículos más atendidos', icono: Icons.directions_car_rounded),
            const SizedBox(height: 10),
            if (datos.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('Sin vehículos atendidos en el período.', style: TextStyle(fontSize: 12, color: tema.hintColor)),
              )
            else
              ...datos.take(6).map((v) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colores.naranja.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.directions_car_rounded, size: 19, color: Colores.naranja),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${v.vehiculo.matricula} · ${v.vehiculo.marca} ${v.vehiculo.modelo}',
                                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                            Text('${v.cliente.nombre} · ${Formatos.kilometraje(v.vehiculo.kilometraje)}',
                                style: TextStyle(fontSize: 10.5, color: tema.hintColor)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${v.visitas} visita(s)', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          Text(Formatos.fecha(v.ultimaEntrada), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            if (datos.length > 6)
              Align(alignment: Alignment.centerRight, child: Text('+${datos.length - 6} más', style: TextStyle(fontSize: 10, color: tema.hintColor))),
          ],
        ),
      ),
    );
  }
}
