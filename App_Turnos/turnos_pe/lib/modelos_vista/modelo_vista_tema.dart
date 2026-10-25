import 'package:flutter/foundation.dart';

import '../modelos/filtros.dart';

/// ViewModel del tema global (claro, oscuro o sistema).
class ModeloVistaTema extends ChangeNotifier {
  ModoTema _modo = ModoTema.sistema;

  ModoTema get modo => _modo;

  void cambiar(ModoTema modo) {
    if (_modo == modo) return;
    _modo = modo;
    notifyListeners();
  }
}
