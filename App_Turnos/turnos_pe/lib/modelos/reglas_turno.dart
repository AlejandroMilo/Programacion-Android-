import 'servicio.dart';

/// Reglas de negocio del salon. Viven en el modelo, nunca en los widgets.
class ReglasTurno {
  const ReglasTurno._();

  static const int horaApertura = 9;
  static const int horaCierre = 19;
  static const int minutosFranja = 30;

  static const List<String> _dias = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  static const List<String> _meses = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  static int duracionTotal(Iterable<Servicio> servicios) =>
      servicios.fold(0, (total, servicio) => total + servicio.duracionMinutos);

  static double precioTotal(Iterable<Servicio> servicios) =>
      servicios.fold(0, (total, servicio) => total + servicio.precio);

  static DateTime horaFin(DateTime inicio, int duracionMinutos) =>
      inicio.add(Duration(minutes: duracionMinutos));

  static bool esDomingo(DateTime fecha) => fecha.weekday == DateTime.sunday;

  static DateTime soloFecha(DateTime fecha) =>
      DateTime(fecha.year, fecha.month, fecha.day);

  static bool mismoDia(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Un turno que termina a las 10:00 no se solapa con otro que empieza a las 10:00.
  static bool seSolapan(
    DateTime inicioA,
    DateTime finA,
    DateTime inicioB,
    DateTime finB,
  ) => inicioA.isBefore(finB) && inicioB.isBefore(finA);

  static String formatearHora(DateTime hora) =>
      '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';

  static String formatearDuracion(int minutos) {
    final horas = minutos ~/ 60;
    final resto = minutos % 60;
    if (horas == 0) return '$resto min';
    if (resto == 0) return '$horas h';
    return '$horas h $resto min';
  }

  static String formatearFechaLarga(DateTime fecha) =>
      '${_dias[fecha.weekday - 1]} ${fecha.day} de ${_meses[fecha.month - 1]} de ${fecha.year}';

  static String formatearFechaCorta(DateTime fecha) =>
      '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';

  /// "19/10", para el historial del cliente.
  static String formatearDiaMes(DateTime fecha) =>
      '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}';

  static String nombreMes(DateTime fecha) => _meses[fecha.month - 1];

  /// "mié 21 de octubre", para mensajes y avisos.
  static String fechaHumana(DateTime fecha) =>
      '${inicialDia(fecha).toLowerCase()} ${fecha.day} de ${nombreMes(fecha)}';

  static String formatearMes(DateTime fecha) =>
      '${_meses[fecha.month - 1][0].toUpperCase()}${_meses[fecha.month - 1].substring(1)} ${fecha.year}';

  static String inicialDia(DateTime fecha) => switch (fecha.weekday) {
    DateTime.monday => 'Lun',
    DateTime.tuesday => 'Mar',
    DateTime.wednesday => 'Mié',
    DateTime.thursday => 'Jue',
    DateTime.friday => 'Vie',
    DateTime.saturday => 'Sáb',
    _ => 'Dom',
  };
}
