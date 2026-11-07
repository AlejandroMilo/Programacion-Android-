import 'package:flutter/material.dart';

import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../componentes/tarjetas/tarjeta_resumen.dart';
import '../../datos/base_datos.dart';
import '../../modelos/repuesto.dart';
import '../../modelos/resumen_taller.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';

class ReporteInventario extends StatelessWidget {
  const ReporteInventario({
    super.key,
    required this.inventario,
    required this.bajos,
  });

  final ResumenInventario inventario;
  final List<Repuesto> bajos;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SeccionTitulo(titulo: 'Estado del inventario', icono: Icons.inventory_2_rounded),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                final columnas = constraints.maxWidth >= 760 ? 4 : 2;
                final ancho = (constraints.maxWidth - (columnas - 1) * 10) / columnas;
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    SizedBox(width: ancho, child: TarjetaResumen(titulo: 'Total repuestos', valor: '${inventario.total}', icono: Icons.inventory_2_outlined, color: Colores.azul)),
                    SizedBox(width: ancho, child: TarjetaResumen(titulo: 'Bajo stock', valor: '${inventario.bajos}', icono: Icons.warning_amber_rounded, color: Colores.amarillo)),
                    SizedBox(width: ancho, child: TarjetaResumen(titulo: 'Agotados', valor: '${inventario.agotados}', icono: Icons.error_outline_rounded, color: Colores.rojo)),
                    SizedBox(width: ancho, child: TarjetaResumen(titulo: 'Valor en stock', valor: Formatos.dinero(inventario.valor), icono: Icons.attach_money_rounded, color: Colores.naranja)),
                  ],
                );
              },
            ),
            const SizedBox(height: 14),
            if (bajos.isNotEmpty) ...[
              const Text('Repuestos que requieren atención', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.6)),
              const SizedBox(height: 7),
              ...bajos.take(6).map((r) {
                final color = r.sinStock ? Colores.rojo : Colores.amarillo;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.nombre, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                            Text('${r.codigo} · ${r.existencias} uds.', style: TextStyle(fontSize: 10.5, color: tema.hintColor)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                        child: Text(r.sinStock ? 'Agotado' : 'Bajo', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: color)),
                      ),
                    ],
                  ),
                );
              }).toList(),
              if (bajos.length > 6)
                Align(alignment: Alignment.centerRight, child: Text('+${bajos.length - 6} más', style: TextStyle(fontSize: 10, color: tema.hintColor))),
            ],
          ],
        ),
      ),
    );
  }
}
