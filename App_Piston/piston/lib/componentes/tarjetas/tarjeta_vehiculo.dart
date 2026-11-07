import 'package:flutter/material.dart';

import '../../modelos/vehiculo.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';

class TarjetaVehiculo extends StatelessWidget {
  const TarjetaVehiculo({
    super.key,
    required this.vehiculo,
    this.onTap,
    this.acciones,
  });

  final VehiculoConDueno vehiculo;
  final VoidCallback? onTap;
  final List<Widget>? acciones;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final v = vehiculo.vehiculo;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [
                      Colores.grafitoClaro,
                      Colores.grafito,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colores.naranja.withValues(alpha: 0.3)),
                ),
                child: const Icon(
                  Icons.directions_car_filled_rounded,
                  size: 24,
                  color: Colores.naranja,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v.matricula,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${v.marca} ${v.modelo} · ${v.anio}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.5, color: tema.hintColor),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${vehiculo.cliente.nombre} · ${Formatos.kilometraje(v.kilometraje)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11.5, color: tema.hintColor),
                    ),
                    if (acciones != null && acciones!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(children: acciones!),
                    ],
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.chevron_right_rounded, color: tema.hintColor),
            ],
          ),
        ),
      ),
    );
  }
}
