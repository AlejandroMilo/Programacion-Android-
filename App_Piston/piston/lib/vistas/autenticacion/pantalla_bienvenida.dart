import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/preferencias.dart';
import '../../componentes/botones/boton_principal.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/constantes.dart';
import '../../utilidades/tema.dart';
import '../autenticacion/pantalla_login.dart';

class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
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
              top: -60,
              right: -40,
              child: _Circulo(
                tamano: 200,
                color: Colores.naranja.withValues(alpha: 0.12),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -50,
              child: _Circulo(
                tamano: 240,
                color: Colores.naranja.withValues(alpha: 0.06),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 26,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        const _Marca(),
                        const SizedBox(height: 34),
                        const Text(
                          'Gestiona tu taller automotriz',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colores.blanco,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Órdenes, clientes, inventario, pagos y reportes '
                          'todo en un solo lugar.',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colores.blanco.withValues(alpha: 0.65),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        BotonPrincipal(
                          texto: 'Comenzar',
                          icono: Icons.login_rounded,
                          expandido: true,
                          onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (_) => const PantallaLogin(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
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
                                        preferencias.modo == ThemeMode.dark,
                                    onTap: () => preferencias
                                        .cambiarModo(ThemeMode.dark),
                                  ),
                                  _ChipTema(
                                    etiqueta: 'Claro',
                                    seleccionado:
                                        preferencias.modo == ThemeMode.light,
                                    onTap: () => preferencias
                                        .cambiarModo(ThemeMode.light),
                                  ),
                                  _ChipTema(
                                    etiqueta: 'Sistema',
                                    seleccionado:
                                        preferencias.modo == ThemeMode.system,
                                    onTap: () => preferencias
                                        .cambiarModo(ThemeMode.system),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            'El Pistón · v${Constantes.version}',
                            style: TextStyle(
                              color: Colores.gris.withValues(alpha: 0.7),
                              fontSize: 10.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
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
}

class _Marca extends StatelessWidget {
  const _Marca();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colores.naranja, Colores.naranjaOscuro],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colores.naranja.withValues(alpha: 0.4),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: const Icon(
            Icons.car_repair_rounded,
            size: 48,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'EL PISTÓN',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'TALLER AUTOMOTRIZ',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 2,
            color: Colores.naranja,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
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
          color: seleccionado ? Colores.naranja : Colores.grafitoClaro,
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
