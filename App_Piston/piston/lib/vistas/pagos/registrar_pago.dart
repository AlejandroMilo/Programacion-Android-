import 'package:flutter/material.dart';

import '../../componentes/botones/boton_principal.dart';
import '../../componentes/formularios/campo_numero.dart';
import '../../componentes/formularios/campo_texto.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/constantes.dart';
import '../../utilidades/formatos.dart';
import '../../utilidades/validaciones.dart';

class RegistrarPago extends StatefulWidget {
  const RegistrarPago({
    super.key,
    required this.saldo,
    required this.total,
    required this.pagado,
  });

  final double saldo;
  final double total;
  final double pagado;

  static Future<({double importe, String metodo, String nota})?> mostrar(
    BuildContext context, {
    required double saldo,
    required double total,
    required double pagado,
  }) {
    return showModalBottomSheet<({double importe, String metodo, String nota})>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: RegistrarPago(saldo: saldo, total: total, pagado: pagado),
      ),
    );
  }

  @override
  State<RegistrarPago> createState() => _RegistrarPagoState();
}

class _RegistrarPagoState extends State<RegistrarPago> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _importe;
  final _nota = TextEditingController();
  String _metodo = Constantes.metodosPago.first;

  @override
  void initState() {
    super.initState();
    _importe = TextEditingController(
      text: widget.saldo.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _importe.dispose();
    _nota.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 18),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Registrar pago',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'Puedes cobrar el total o registrar un abono.',
                style: TextStyle(fontSize: 12, color: tema.hintColor),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colores.naranja.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _Dato(
                        etiqueta: 'Total',
                        valor: Formatos.dineroExacto(widget.total),
                      ),
                    ),
                    Expanded(
                      child: _Dato(
                        etiqueta: 'Pagado',
                        valor: Formatos.dineroExacto(widget.pagado),
                      ),
                    ),
                    Expanded(
                      child: _Dato(
                        etiqueta: 'Saldo',
                        valor: Formatos.dineroExacto(widget.saldo),
                        color: Colores.naranja,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              CampoNumero(
                etiqueta: 'Importe a pagar',
                controlador: _importe,
                decimal: true,
                icono: Icons.attach_money_rounded,
                validator: (valor) {
                  final base = Validaciones.monto(valor);
                  if (base != null) return base;
                  final numero = double.tryParse(
                    valor!.replaceAll(',', '.'),
                  );
                  if (numero != null && numero > widget.saldo + 0.009) {
                    return 'El saldo pendiente es '
                        '${Formatos.dineroExacto(widget.saldo)}';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _metodo,
                decoration: const InputDecoration(
                  labelText: 'Método de pago',
                  prefixIcon: Icon(Icons.payments_outlined, size: 20),
                ),
                items: [
                  for (final metodo in Constantes.metodosPago)
                    DropdownMenuItem(
                      value: metodo,
                      child: Text(
                        switch (metodo) {
                          'efectivo' => 'Efectivo',
                          'tarjeta' => 'Tarjeta',
                          'transferencia' => 'Transferencia',
                          _ => metodo,
                        },
                      ),
                    ),
                ],
                onChanged: (valor) {
                  if (valor != null) setState(() => _metodo = valor);
                },
              ),
              const SizedBox(height: 12),
              CampoTexto(
                etiqueta: 'Nota (opcional)',
                controlador: _nota,
                icono: Icons.notes_rounded,
              ),
              const SizedBox(height: 18),
              BotonPrincipal(
                texto: 'Registrar pago',
                icono: Icons.payments_rounded,
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  Navigator.of(context).pop((
                    importe: double.parse(
                      _importe.text.replaceAll(',', '.'),
                    ),
                    metodo: _metodo,
                    nota: _nota.text.trim(),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({required this.etiqueta, required this.valor, this.color});

  final String etiqueta;
  final String valor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: TextStyle(fontSize: 10, color: Theme.of(context).hintColor),
        ),
        const SizedBox(height: 2),
        Text(
          valor,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}
