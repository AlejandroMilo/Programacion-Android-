import 'package:flutter/foundation.dart';

import '../aplicacion/sesion.dart';
import '../datos/base_datos.dart';
import '../modelos/orden_servicio.dart';
import '../modelos/resumen_taller.dart';

/// Estado del panel de inicio. Depende del rol de la sesión.
class InicioModeloVista extends ChangeNotifier {
  InicioModeloVista(this._db, this._sesion);

  final BaseDatos _db;
  final Sesion _sesion;

  ResumenTaller resumen = ResumenTaller.vacio();
  List<OrdenResumen> recientes = const [];
  List<OrdenResumen> asignadas = const [];
  List<Repuesto> repuestosBajos = const [];
  bool cargando = true;
  String? error;

  bool get esMecanico => _sesion.esMecanico;

  Future<void> cargar() async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      resumen = await _db.reportesDao.resumen();
      recientes = await _db.ordenesDao.recientes(limite: 5);
      if (_sesion.esMecanico && _sesion.mecanicoId != null) {
        asignadas = await _db.ordenesDao.asignadas(_sesion.mecanicoId!);
      }
      if (!_sesion.esMecanico) {
        repuestosBajos = await _db.reportesDao.repuestosBajos();
      }
    } on Exception catch (e, s) {
      error = 'No se pudo cargar el panel: $e\nStack: $s';
    } catch (e) {
      error = 'No se pudo cargar el panel: $e';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }
}
