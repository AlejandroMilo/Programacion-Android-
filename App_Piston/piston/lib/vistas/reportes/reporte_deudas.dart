import 'package:flutter/material.dart';

import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../modelos/resumen_taller.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';

class ReporteDeudas extends StatelessWidget {
  const ReporteDeudas({super.key, required this.deudas});

  final List<DeudaCliente> deudas;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SeccionTitulo(titulo: 'Deudas por cliente', icono: Icons.account_balance_wallet_rounded),
            const SizedBox(height: 10),
            if (deudas.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('Sin deudas pendientes.', style: TextStyle(fontSize: 12, color: tema.hintColor)),
              )
            else
              ...deudas.take(6).map((d) {
                final total = d.saldo;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d.cliente.nombre, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                            Text(d.cliente.telefono, style: TextStyle(fontSize: 10.5, color: tema.hintColor)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${d.ordenes} orden(es)', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          Text(Formatos.dineroExacto(total), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colores.rojo)),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            if (deudas.length > 6)
              Align(
                alignment: Alignment.centerRight,
                child: Text('+${deudas.length - 6} más', style: TextStyle(fontSize: 10, color: tema.hintColor)),
              ),
          ],
        ),
      ),
    );
  }
}
