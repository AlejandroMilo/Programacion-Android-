import 'package:flutter/material.dart';

import '../../modelos/orden_servicio.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';
import '../indicadores/indicador_estado.dart';

class TarjetaOrden extends StatelessWidget {
  const TarjetaOrden({
    super.key,
    required this.orden,
    this.onTap,
    this.acciones,
    this.total,
  });

  final OrdenResumen orden;
  final VoidCallback? onTap;
  final List<Widget>? acciones;
  final double? total;

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
                children: [
                  Expanded(
                    child: Text(
                      orden.numero,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  IndicadorEstado(estado: orden.estado, compacto: true),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                orden.cliente.nombre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _MiniaturaVehiculo(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${orden.vehiculoTexto} · ${orden.matricula}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: tema.hintColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              Icons.engineering_rounded,
                              size: 13,
                              color: tema.hintColor,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                orden.mecanicoTexto,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: tema.hintColor,
                                ),
                              ),
                            ),
                            Text(
                              Formatos.haceCuanto(orden.orden.fechaEntrada),
                              style: TextStyle(
                                fontSize: 11,
                                color: tema.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (total != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.attach_money_rounded,
                      size: 14,
                      color: Colores.naranja,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Total: ${Formatos.dineroExacto(total!)}',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: Colores.naranja,
                      ),
                    ),
                  ],
                ),
              ],
              if (acciones != null && acciones!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(children: acciones!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniaturaVehiculo extends StatelessWidget {
  const _MiniaturaVehiculo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colores.grafitoClaro,
        border: Border.all(color: Colores.naranja.withValues(alpha: 0.25)),
      ),
      child: const Icon(
        Icons.directions_car_rounded,
        size: 20,
        color: Colores.naranja,
      ),
    );
  }
}
