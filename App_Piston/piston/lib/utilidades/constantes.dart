/// Constantes visibles de la aplicación y claves de configuración.
class Constantes {
  const Constantes._();

  static const String nombreTaller = 'El Pistón';
  static const String lema = 'Taller automotriz';
  static const String version = '1.0.0';

  static const String claveTema = 'tema';
  static const String claveNombreTaller = 'taller_nombre';
  static const String claveTelefonoTaller = 'taller_telefono';
  static const String claveDireccionTaller = 'taller_direccion';
  static const String claveUmbral = 'umbral_inventario';

  static const String temaSistema = 'sistema';
  static const String temaClaro = 'claro';
  static const String temaOscuro = 'oscuro';

  /// Cuentas de demostración que se crean la primera vez.
  static const List<({String usuario, String clave, String rol})> cuentasDemo =
      [
        (
          usuario: 'admin',
          clave: 'admin123',
          rol: 'Administrador / dueño',
        ),
        (
          usuario: 'recepcion',
          clave: 'recepcion123',
          rol: 'Recepcionista',
        ),
        (
          usuario: 'mecanico',
          clave: 'mecanico123',
          rol: 'Mecánico',
        ),
      ];

  static const List<String> metodosPago = [
    'efectivo',
    'tarjeta',
    'transferencia',
  ];
}
