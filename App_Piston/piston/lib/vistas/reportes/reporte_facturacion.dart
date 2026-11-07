import 'package:flutter/material.dart';

import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../modelos/resumen_taller.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';

class ReporteFacturacion extends StatelessWidget {
  const ReporteFacturacion({super.key, required this.datos});

  final FacturacionPeriodo datos;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SeccionTitulo(titulo: 'Facturación', icono: Icons.receipt_long_rounded),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _Dato(etiqueta: 'Mano de obra', valor: Formatos.dineroExacto(datos.manoObra))),
                Expanded(child: _Dato(etiqueta: 'Repuestos', valor: Formatos.dineroExacto(datos.repuestos))),
                Expanded(child: _Dato(etiqueta: 'Total facturado', valor: Formatos.dineroExacto(datos.facturado), color: Colores.naranja, grande: true)),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _Dato(etiqueta: 'Cobrado', valor: Formatos.dineroExacto(datos.cobrado), color: Colores.verde)),
                Expanded(child: _Dato(etiqueta: 'Pendiente', valor: Formatos.dineroExacto(datos.pendiente), color: Colores.rojo)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Órdenes', style: TextStyle(fontSize: 9, color: tema.hintColor)),
                      const SizedBox(height: 2),
                      Text('${datos.abiertas} abiertas · ${datos.cerradas} cerradas', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({required this.etiqueta, required this.valor, this.color, this.grande = false});

  final String etiqueta;
  final String valor;
  final Color? color;
  final bool grande;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: TextStyle(fontSize: 9, color: Theme.of(context).hintColor)),
        const SizedBox(height: 2),
        Text(valor, style: TextStyle(fontSize: grande ? 15 : 12.5, fontWeight: FontWeight.w800, color: color)),
      ],
    );
  }
}
