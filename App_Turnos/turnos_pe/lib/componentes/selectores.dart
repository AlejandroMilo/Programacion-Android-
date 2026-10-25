import 'package:flutter/material.dart';

import '../modelos/filtros.dart';
import 'componentes.dart';

/// Filtro de estado de la Agenda (Todos, Programados, Completados, Cancelados).
class SegmentedEstado extends StatelessWidget {
  const SegmentedEstado({
    super.key,
    required this.valor,
    required this.onChanged,
  });

  final FiltroEstado valor;
  final ValueChanged<FiltroEstado> onChanged;

  @override
  Widget build(BuildContext context) {
    return Segmentado<FiltroEstado>(
      valor: valor,
      onChanged: onChanged,
      opciones: [
        for (final filtro in FiltroEstado.values) (filtro, filtro.etiquetaCorta),
      ],
    );
  }
}

/// Filtro por genero (Todos, Mujeres, Hombres).
class SegmentedGenero extends StatelessWidget {
  const SegmentedGenero({
    super.key,
    required this.valor,
    required this.onChanged,
  });

  final FiltroGenero valor;
  final ValueChanged<FiltroGenero> onChanged;

  @override
  Widget build(BuildContext context) {
    return Segmentado<FiltroGenero>(
      valor: valor,
      onChanged: onChanged,
      opciones: [
        for (final filtro in FiltroGenero.values) (filtro, filtro.etiqueta),
      ],
    );
  }
}

/// Filtro por publico del servicio (Todos, Mujeres, Hombres).
class SegmentedPublico extends StatelessWidget {
  const SegmentedPublico({
    super.key,
    required this.valor,
    required this.onChanged,
  });

  final FiltroPublico valor;
  final ValueChanged<FiltroPublico> onChanged;

  @override
  Widget build(BuildContext context) {
    return Segmentado<FiltroPublico>(
      valor: valor,
      onChanged: onChanged,
      opciones: [
        for (final filtro in FiltroPublico.values) (filtro, filtro.etiqueta),
      ],
    );
  }
}
