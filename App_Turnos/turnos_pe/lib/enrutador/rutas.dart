/// Rutas de la aplicacion (go_router).
class Rutas {
  const Rutas._();

  static const String agenda = '/agenda';
  static const String clientes = '/clientes';
  static const String servicios = '/servicios';
  static const String estilistas = '/estilistas';

  static const String turnoNuevo = '/turno/nuevo';

  static String turno(String id) => '/turno/$id';

  static String turnoEditar(String id) => '/turno/$id/editar';

  /// Agenda con el filtro de un estilista aplicado (parametro de consulta).
  static String agendaConEstilista(String estilistaId) =>
      '$agenda?estilista=$estilistaId';
}
