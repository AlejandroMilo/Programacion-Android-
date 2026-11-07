import 'package:flutter/material.dart';

import '../datos/acceso_datos/configuracion_dao.dart';
import '../utilidades/constantes.dart';

/// Preferencias persistentes (Drift) y datos del taller.
///
/// El tema y los datos generales sobreviven al cierre de la aplicación.
class Preferencias extends ChangeNotifier {
  Preferencias(this._dao);

  final ConfiguracionDao _dao;

  ThemeMode _modo = ThemeMode.dark;
  bool _cargado = false;

  String nombreTaller = Constantes.nombreTaller;
  String telefonoTaller = '';
  String direccionTaller = '';
  int umbralInventario = 5;

  ThemeMode get modo => _modo;
  bool get cargado => _cargado;

  Future<void> cargar() async {
    final valores = await _dao.leer();
    _aplicar(valores);
    _cargado = true;
    notifyListeners();
  }

  void _aplicar(Map<String, String> valores) {
    _modo = switch (valores[Constantes.claveTema]) {
      Constantes.temaClaro => ThemeMode.light,
      Constantes.temaSistema => ThemeMode.system,
      _ => ThemeMode.dark,
    };
    nombreTaller = valores[Constantes.claveNombreTaller] ?? Constantes.nombreTaller;
    telefonoTaller = valores[Constantes.claveTelefonoTaller] ?? '';
    direccionTaller = valores[Constantes.claveDireccionTaller] ?? '';
    umbralInventario =
        int.tryParse(valores[Constantes.claveUmbral] ?? '') ?? 5;
  }

  String get etiquetaModo => switch (_modo) {
    ThemeMode.light => 'Claro',
    ThemeMode.dark => 'Oscuro',
    ThemeMode.system => 'Sistema',
  };

  Future<void> cambiarModo(ThemeMode modo) async {
    if (_modo == modo) return;
    _modo = modo;
    notifyListeners();
    await _dao.guardar(Constantes.claveTema, _textoModo(modo));
  }

  String _textoModo(ThemeMode modo) => switch (modo) {
    ThemeMode.light => Constantes.temaClaro,
    ThemeMode.dark => Constantes.temaOscuro,
    ThemeMode.system => Constantes.temaSistema,
  };

  Future<void> guardarDatosTaller({
    required String nombre,
    required String telefono,
    required String direccion,
  }) async {
    nombreTaller = nombre.trim();
    telefonoTaller = telefono.trim();
    direccionTaller = direccion.trim();
    notifyListeners();
    await _dao.guardarVarios({
      Constantes.claveNombreTaller: nombreTaller,
      Constantes.claveTelefonoTaller: telefonoTaller,
      Constantes.claveDireccionTaller: direccionTaller,
    });
  }

  Future<void> cambiarUmbral(int umbral) async {
    if (umbral < 0) return;
    umbralInventario = umbral;
    notifyListeners();
    await _dao.guardar(Constantes.claveUmbral, '$umbral');
  }
}
