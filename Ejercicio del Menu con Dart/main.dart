class Tarea {
  int id;
  String titulo;
  bool hecho;

  Tarea({required this.id, required this.titulo, required this.hecho});
}

List<Tarea> tareas = [];
void listarTareas() {
  for (var tarea in tareas) {
    if (tarea.hecho == true) {
      print("${tarea.id}.${tarea.titulo}.${tarea == "Tarea Hecha"}");
    } else {
      print("${tarea.id}.${tarea.titulo}.${tarea == "Tarea no hecha"}");
    }
  }
}

void agregarTarea(String titulo) {
  int nuevoID = tareas.length + 1;
  tareas.add(Tarea(id: nuevoID, titulo: titulo, hecho: false));
}

void actualizarTarea(int id, String nuevoTitulo) {
  for (var tarea in tareas) {
    if (tarea.id == id) {
      tarea.titulo = nuevoTitulo;
      break;
    }
  }
}

void cambiarEstado(int id) {
  for (var tarea in tareas) {
    if (tarea.id == id) {
      tarea.hecho = !tarea.hecho;
      break;
    }
  }
}

void main() {
  agregarTarea("Estudiar Programacion");
  agregarTarea("Practicar programacion ");

  print("Lista inical:");
  listarTareas();

  print("\n Acualizar tareas:");
  actualizarTarea(1, "Estudiar Programacion WEP");
  listarTareas();

  print("\n CAmbiar estado de tareas:");
  cambiarEstado(2);
  listarTareas();
}
