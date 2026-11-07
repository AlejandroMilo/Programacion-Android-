import 'package:flutter/material.dart';

import '../../datos/base_datos.dart';
import '../../modelos/repuesto.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';
import '../indicadores/indicador_inventario.dart';

class TarjetaRepuesto extends StatelessWidget {
  const TarjetaRepuesto({
    super.key,
    required this.repuesto,
    this.onTap,
    this.acciones,
  });

  final Repuesto repuesto;
  final VoidCallback? onTap;
  final List<Widget>? acciones;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          repuesto.nombre,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          repuesto.codigo,
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 0.5,
                            color: tema.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IndicadorInventario(repuesto: repuesto),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    Formatos.dineroExacto(repuesto.precioVenta),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colores.naranja,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Umbral: ${repuesto.umbral}',
                    style: TextStyle(fontSize: 11, color: tema.hintColor),
                  ),
                ],
              ),
              if (acciones != null && acciones!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(children: acciones!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
