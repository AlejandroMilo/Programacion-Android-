import 'package:exre_proyecto/modelos/recursos_estudiados.dart';

const List<RecursoEstudio> recursos = [
  RecursoEstudio(
    id: 'flutter-001',
    titulo: 'Introducción a Flutter',
    categoria: 'Flutter',
    autor: 'Equipo ExRE',
    duracionMinutos: 15,
    nivel: NivelRecurso.basico,
    descripcion: 'Introducción a Flutter y a los conceptos fundamentales para crear aplicaciones móviles.',
    tipo: TipoRecurso.video,
    color: 0xFF4F46E5,
  ),

  RecursoEstudio(
    id: 'flutter-002',
    titulo: 'Widgets fundamentales',
    categoria: 'Flutter',
    autor: 'Equipo ExRE',
    duracionMinutos: 20,
    nivel: NivelRecurso.basico,
    descripcion: 'Conoce los widgets fundamentales utilizados para construir interfaces en Flutter.',
    tipo: TipoRecurso.lectura,
    color: 0xFF6366F1,
  ),

  RecursoEstudio(
    id: 'flutter-003',
    titulo: 'Column y Row',
    categoria: 'Layouts',
    autor: 'Equipo ExRE',
    duracionMinutos: 18,
    nivel: NivelRecurso.basico,
    descripcion: 'Aprende a organizar elementos utilizando Column y Row.',
    tipo: TipoRecurso.practica,
    color: 0xFF8B5CF6,
  ),

  RecursoEstudio(
    id: 'flutter-004',
    titulo: 'Container y decoración',
    categoria: 'Layouts',
    autor: 'Equipo ExRE',
    duracionMinutos: 16,
    nivel: NivelRecurso.basico,
    descripcion: 'Uso de Container, bordes, colores, padding y decoración.',
    tipo: TipoRecurso.video,
    color: 0xFFA855F7,
  ),

  RecursoEstudio(
    id: 'flutter-005',
    titulo: 'Diseños adaptables',
    categoria: 'Layouts',
    autor: 'Equipo ExRE',
    duracionMinutos: 25,
    nivel: NivelRecurso.intermedio,
    descripcion: 'Técnicas para crear interfaces que se adapten a diferentes tamaños de pantalla.',
    tipo: TipoRecurso.documento,
    color: 0xFFD946EF,
  ),

  RecursoEstudio(
    id: 'flutter-006',
    titulo: 'ListView básico',
    categoria: 'Scrollables',
    autor: 'Equipo ExRE',
    duracionMinutos: 17,
    nivel: NivelRecurso.basico,
    descripcion:
        'Introducción al uso de ListView para crear listas desplazables.',
    tipo: TipoRecurso.video,
    color: 0xFFEC4899,
  ),

  RecursoEstudio(
    id: 'flutter-007',
    titulo: 'ListView.builder',
    categoria: 'Scrollables',
    autor: 'Equipo ExRE',
    duracionMinutos: 22,
    nivel: NivelRecurso.intermedio,
    descripcion:
        'Construcción eficiente de listas utilizando ListView.builder.',
    tipo: TipoRecurso.practica,
    color: 0xFFF43F5E,
  ),

  RecursoEstudio(
    id: 'flutter-008',
    titulo: 'ListView.separated',
    categoria: 'Scrollables',
    autor: 'Equipo ExRE',
    duracionMinutos: 19,
    nivel: NivelRecurso.intermedio,
    descripcion: 'Cómo construir listas con separadores visuales.',
    tipo: TipoRecurso.lectura,
    color: 0xFFEF4444,
  ),

  RecursoEstudio(
    id: 'flutter-009',
    titulo: 'GridView.builder',
    categoria: 'Scrollables',
    autor: 'Equipo ExRE',
    duracionMinutos: 24,
    nivel: NivelRecurso.intermedio,
    descripcion:
        'Creación de cuadrículas dinámicas utilizando GridView.builder.',
    tipo: TipoRecurso.video,
    color: 0xFFF97316,
  ),

  RecursoEstudio(
    id: 'flutter-010',
    titulo: 'SliverList',
    categoria: 'Slivers',
    autor: 'Equipo ExRE',
    duracionMinutos: 28,
    nivel: NivelRecurso.avanzado,
    descripcion:
        'Introducción a SliverList y a las listas avanzadas de Flutter.',
    tipo: TipoRecurso.documento,
    color: 0xFFF59E0B,
  ),

  RecursoEstudio(
    id: 'flutter-011',
    titulo: 'CustomScrollView',
    categoria: 'Slivers',
    autor: 'Equipo ExRE',
    duracionMinutos: 30,
    nivel: NivelRecurso.avanzado,
    descripcion:
        'Construcción de desplazamientos personalizados con CustomScrollView.',
    tipo: TipoRecurso.practica,
    color: 0xFFEAB308,
  ),

  RecursoEstudio(
    id: 'flutter-012',
    titulo: 'SliverAppBar',
    categoria: 'Slivers',
    autor: 'Equipo ExRE',
    duracionMinutos: 21,
    nivel: NivelRecurso.intermedio,
    descripcion: 'Uso de SliverAppBar para crear barras superiores dinámicas.',
    tipo: TipoRecurso.video,
    color: 0xFF84CC16,
  ),

  RecursoEstudio(
    id: 'flutter-013',
    titulo: 'Navegación con Navigator',
    categoria: 'Navegacion',
    autor: 'Equipo ExRE',
    duracionMinutos: 20,
    nivel: NivelRecurso.basico,
    descripcion:
        'Aprende a navegar entre diferentes pantallas utilizando Navigator.',
    tipo: TipoRecurso.video,
    color: 0xFF22C55E,
  ),

  RecursoEstudio(
    id: 'flutter-014',
    titulo: 'Rutas entre pantallas',
    categoria: 'Navegacion',
    autor: 'Equipo ExRE',
    duracionMinutos: 23,
    nivel: NivelRecurso.intermedio,
    descripcion:
        'Organización de la navegación y rutas de una aplicación Flutter.',
    tipo: TipoRecurso.lectura,
    color: 0xFF10B981,
  ),

  RecursoEstudio(
    id: 'android-001',
    titulo: 'Introducción a Android',
    categoria: 'Android',
    autor: 'Equipo ExRE',
    duracionMinutos: 18,
    nivel: NivelRecurso.basico,
    descripcion:
        'Conceptos fundamentales sobre el desarrollo de aplicaciones Android.',
    tipo: TipoRecurso.documento,
    color: 0xFF14B8A6,
  ),

  RecursoEstudio(
    id: 'android-002',
    titulo: 'Estructura de una aplicación',
    categoria: 'Android',
    autor: 'Equipo ExRE',
    duracionMinutos: 22,
    nivel: NivelRecurso.basico,
    descripcion:
        'Conoce la estructura general de una aplicación móvil Android.',
    tipo: TipoRecurso.lectura,
    color: 0xFF06B6D4,
  ),

  RecursoEstudio(
    id: 'flutter-015',
    titulo: 'Estado en Flutter',
    categoria: 'Flutter',
    autor: 'Equipo ExRE',
    duracionMinutos: 26,
    nivel: NivelRecurso.intermedio,
    descripcion: 'Introducción al manejo del estado utilizando las herramientas propias de Flutter.',
    tipo: TipoRecurso.practica,
    color: 0xFF0EA5E9,
  ),

  RecursoEstudio(
    id: 'flutter-016',
    titulo: 'Ciclo de vida de una aplicación',
    categoria: 'Flutter',
    autor: 'Equipo ExRE',
    duracionMinutos: 24,
    nivel: NivelRecurso.intermedio,
    descripcion: 'Comprende los diferentes estados del ciclo de vida de una aplicación Flutter.',
    tipo: TipoRecurso.video,
    color: 0xFF3B82F6,
  ),

  RecursoEstudio(
    id: 'flutter-017',
    titulo: 'Interfaces sin Overflow',
    categoria: 'Layouts',
    autor: 'Equipo ExRE',
    duracionMinutos: 27,
    nivel: NivelRecurso.intermedio,
    descripcion: 'Buenas prácticas para evitar problemas de overflow en diferentes pantallas.',
    tipo: TipoRecurso.practica,
    color: 0xFF6366F1,
  ),

  RecursoEstudio(
    id: 'flutter-018',
    titulo: 'Componentes reutilizables',
    categoria: 'Flutter',
    autor: 'Equipo ExRE',
    duracionMinutos: 29,
    nivel: NivelRecurso.avanzado,
    descripcion: 'Cómo crear widgets reutilizables para mantener un proyecto organizado.',
    tipo: TipoRecurso.documento,
    color: 0xFF7C3AED,
  ),

  RecursoEstudio(
    id: 'flutter-019',
    titulo: 'Proyecto práctico de navegación',
    categoria: 'Navegacion',
    autor: 'Equipo ExRE',
    duracionMinutos: 35,
    nivel: NivelRecurso.avanzado,
    descripcion:
        'Proyecto práctico para aplicar navegación entre múltiples pantallas.',
    tipo: TipoRecurso.practica,
    color: 0xFF9333EA,
  ),

  RecursoEstudio(
    id: 'flutter-020',
    titulo: 'Repaso general de Flutter',
    categoria: 'Flutter',
    autor: 'Equipo ExRE',
    duracionMinutos: 40,
    nivel: NivelRecurso.intermedio,
    descripcion: 'Repaso de los principales conceptos utilizados durante el desarrollo de aplicaciones Flutter.',
    tipo: TipoRecurso.lectura,
    color: 0xFFA855F7,
  ),
];
