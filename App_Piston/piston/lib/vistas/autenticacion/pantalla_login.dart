import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/preferencias.dart';
import '../../aplicacion/sesion.dart';
import '../../componentes/botones/boton_principal.dart';
import '../../componentes/formularios/campo_texto.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/constantes.dart';
import '../../utilidades/tema.dart';
import '../../utilidades/validaciones.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _usuario = TextEditingController();
  final _clave = TextEditingController();
  bool _verClave = false;

  @override
  void dispose() {
    _usuario.dispose();
    _clave.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await context.read<Sesion>().iniciarSesion(
      _usuario.text,
      _clave.text,
    );
  }

  void _usarDemo(({String usuario, String clave, String rol}) cuenta) {
    setState(() {
      _usuario.text = cuenta.usuario;
      _clave.text = cuenta.clave;
    });
    context.read<Sesion>().limpiarError();
  }

  @override
  Widget build(BuildContext context) {
    final sesion = context.watch<Sesion>();
    final preferencias = context.watch<Preferencias>();

    return Theme(
      data: TemaApp.oscuro(),
      child: Scaffold(
        backgroundColor: Colores.negro,
        body: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colores.negro,
                      Colores.grafito,
                      Colores.naranjaOscuro.withValues(alpha: 0.35),
                      Colores.negro,
                    ],
                    stops: const [0, 0.38, 0.72, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -90,
              right: -60,
              child: _Circulo(
                tamano: 240,
                color: Colores.naranja.withValues(alpha: 0.12),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -80,
              child: _Circulo(
                tamano: 260,
                color: Colores.naranja.withValues(alpha: 0.06),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 26,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _Marca(),
                          const SizedBox(height: 26),
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colores.grafito.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colores.grafitoClaro,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  blurRadius: 30,
                                  offset: const Offset(0, 14),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'Iniciar sesión',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Cada trabajador entra con su cuenta personal.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colores.gris,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                CampoTexto(
                                  etiqueta: 'Usuario',
                                  hint: 'Ej. recepcion',
                                  controlador: _usuario,
                                  icono: Icons.person_outline_rounded,
                                  validator: Validaciones.usuario,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 12),
                                CampoTexto(
                                  etiqueta: 'Contraseña',
                                  controlador: _clave,
                                  icono: Icons.lock_outline_rounded,
                                  obscure: !_verClave,
                                  validator: Validaciones.clave,
                                  textInputAction: TextInputAction.done,
                                  sufijo: IconButton(
                                    tooltip: _verClave
                                        ? 'Ocultar contraseña'
                                        : 'Mostrar contraseña',
                                    onPressed: () => setState(
                                      () => _verClave = !_verClave,
                                    ),
                                    icon: Icon(
                                      _verClave
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                if (sesion.error != null) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(11),
                                    decoration: BoxDecoration(
                                      color: Colores.rojo.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(11),
                                      border: Border.all(
                                        color: Colores.rojo.withValues(alpha: 0.4),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.error_outline_rounded,
                                          color: Colores.rojo,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            sesion.error!,
                                            style: const TextStyle(
                                              fontSize: 11.5,
                                              color: Colores.rojo,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 18),
                                BotonPrincipal(
                                  texto: 'Iniciar sesión',
                                  icono: Icons.login_rounded,
                                  cargando: sesion.cargando,
                                  onPressed: _entrar,
                                ),
                                const SizedBox(height: 4),
                                TextButton(
                                  onPressed: _mostrarAyudaClave,
                                  child: const Text(
                                    '¿Olvidaste tu contraseña?',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                const Divider(height: 22),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.palette_outlined,
                                      size: 16,
                                      color: Colores.gris,
                                    ),
                                    const SizedBox(width: 7),
                                    Text(
                                      'Tema:',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colores.gris,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Wrap(
                                        spacing: 6,
                                        children: [
                                          _ChipTema(
                                            etiqueta: 'Oscuro',
                                            seleccionado:
                                                preferencias.modo ==
                                                ThemeMode.dark,
                                            onTap: () => preferencias
                                                .cambiarModo(ThemeMode.dark),
                                          ),
                                          _ChipTema(
                                            etiqueta: 'Claro',
                                            seleccionado:
                                                preferencias.modo ==
                                                ThemeMode.light,
                                            onTap: () => preferencias
                                                .cambiarModo(ThemeMode.light),
                                          ),
                                          _ChipTema(
                                            etiqueta: 'Sistema',
                                            seleccionado:
                                                preferencias.modo ==
                                                ThemeMode.system,
                                            onTap: () => preferencias
                                                .cambiarModo(ThemeMode.system),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          _CuentasDemo(onSeleccionar: _usarDemo),
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              'El Pistón · v${Constantes.version}',
                              style: TextStyle(
                                color: Colores.gris.withValues(alpha: 0.7),
                                fontSize: 10.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarAyudaClave() {
    showDialog<void>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('Recuperar contraseña'),
        content: const Text(
          'Por seguridad, las contraseñas no se muestran ni se envían por '
          'correo. Solicita al administrador del taller que restablezca tu '
          'clave desde el módulo Usuarios.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}

class _Marca extends StatelessWidget {
  const _Marca();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colores.naranja, Colores.naranjaOscuro],
            ),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colores.naranja.withValues(alpha: 0.35),
                blurRadius: 26,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.car_repair_rounded,
            size: 46,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'EL PISTÓN',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'TALLER AUTOMOTRIZ · GESTIÓN MÓVIL',
          style: TextStyle(
            fontSize: 10.5,
            letterSpacing: 1.8,
            color: Colores.naranja,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CuentasDemo extends StatelessWidget {
  const _CuentasDemo({required this.onSeleccionar});

  final void Function(({String usuario, String clave, String rol})) onSeleccionar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colores.grafito.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colores.grafitoClaro),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.science_outlined,
                size: 16,
                color: Colores.naranja,
              ),
              const SizedBox(width: 6),
              const Text(
                'Cuentas de demostración',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                'toca para autocompletar',
                style: TextStyle(fontSize: 9.5, color: Colores.gris),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final cuenta in Constantes.cuentasDemo)
                ActionChip(
                  backgroundColor: Colores.grafitoClaro,
                  side: BorderSide(
                    color: Colores.naranja.withValues(alpha: 0.25),
                  ),
                  avatar: const Icon(
                    Icons.key_rounded,
                    size: 14,
                    color: Colores.naranja,
                  ),
                  label: Text(
                    '${cuenta.usuario} / ${cuenta.clave}',
                    style: const TextStyle(fontSize: 10.5),
                  ),
                  onPressed: () => onSeleccionar(cuenta),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChipTema extends StatelessWidget {
  const _ChipTema({
    required this.etiqueta,
    required this.seleccionado,
    required this.onTap,
  });

  final String etiqueta;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: seleccionado
              ? Colores.naranja
              : Colores.grafitoClaro,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          etiqueta,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: seleccionado ? Colors.white : Colores.gris,
          ),
        ),
      ),
    );
  }
}

class _Circulo extends StatelessWidget {
  const _Circulo({required this.tamano, required this.color});

  final double tamano;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
