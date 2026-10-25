import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../aplicacion/alcance_turnos.dart';
import '../modelos/cliente.dart';
import '../modelos/genero.dart';
import '../tema/tema_app.dart';
import 'componentes.dart';
import 'hoja_cliente.dart';

/// Abre el formulario de cliente en una hoja inferior.
/// Devuelve el cliente creado o actualizado, o null si se cancela.
Future<Cliente?> mostrarFormularioCliente(
  BuildContext context, {
  Cliente? cliente,
}) {
  final esquema = Theme.of(context).colorScheme;
  return showModalBottomSheet<Cliente>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: true,
    backgroundColor: esquema.surface,
    barrierColor: const Color(0x66000000),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppTheme.radioHoja),
      ),
    ),
    builder: (hojaContext) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(hojaContext).viewInsets.bottom,
      ),
      child: FormularioCliente(cliente: cliente),
    ),
  );
}

/// Formulario para crear o editar un cliente.
class FormularioCliente extends StatefulWidget {
  const FormularioCliente({super.key, this.cliente});

  final Cliente? cliente;

  @override
  State<FormularioCliente> createState() => _FormularioClienteState();
}

class _FormularioClienteState extends State<FormularioCliente> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focoNombre = FocusNode();
  final FocusNode _focoTelefono = FocusNode();
  final FocusNode _focoCorreo = FocusNode();

  late final TextEditingController _nombre;
  late final TextEditingController _telefono;
  late final TextEditingController _correo;
  Genero? _genero;

  AutovalidateMode _autovalidar = AutovalidateMode.disabled;
  String? _errorNombre;
  String? _errorTelefono;
  String? _errorGenero;
  String? _errorCorreo;
  bool _falloValidacion = false;

  bool get _esEdicion => widget.cliente != null;

  @override
  void initState() {
    super.initState();
    final cliente = widget.cliente;
    _nombre = TextEditingController(text: cliente?.nombre ?? '');
    _telefono = TextEditingController(text: cliente?.telefono ?? '');
    _correo = TextEditingController(text: cliente?.correo ?? '');
    _genero = cliente?.genero;

    // Si el usuario sale de un campo obligatorio vacio, se marca en el acto.
    _focoNombre.addListener(() {
      if (mounted && !_focoNombre.hasFocus) {
        setState(() => _errorNombre = _mensajeNombre(_nombre.text));
      }
    });
    _focoTelefono.addListener(() {
      if (mounted && !_focoTelefono.hasFocus) {
        setState(() => _errorTelefono = _mensajeTelefono(_telefono.text));
      }
    });
    _focoCorreo.addListener(() {
      if (mounted && !_focoCorreo.hasFocus) {
        setState(() => _errorCorreo = _mensajeCorreo(_correo.text));
      }
    });
  }

  @override
  void dispose() {
    _nombre.dispose();
    _telefono.dispose();
    _correo.dispose();
    _focoNombre.dispose();
    _focoTelefono.dispose();
    _focoCorreo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidar,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AsaHoja(),
                  const SizedBox(height: 14),
                  Text(
                    _esEdicion ? 'Editar cliente' : 'Nuevo cliente',
                    style: textos.titleLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: esquema.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _campoNombre(context),
                  const SizedBox(height: 16),
                  _campoTelefono(context),
                  const SizedBox(height: 16),
                  _campoGenero(context),
                  const SizedBox(height: 16),
                  _campoCorreo(context),
                ],
              ),
            ),
          ),
        ),
        _barraAcciones(context),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Campos
  // ---------------------------------------------------------------------------

  Widget _campoNombre(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EtiquetaCampo('Nombre', error: _errorNombre != null),
        const SizedBox(height: 4),
        _campo(
          context,
          controller: _nombre,
          focusNode: _focoNombre,
          hint: 'Nombre y apellido',
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          maxLength: 60,
          onChanged: (valor) {
            if (_errorNombre != null) {
              setState(() => _errorNombre = _mensajeNombre(valor));
            }
          },
          onSubmitted: (_) => _focoTelefono.requestFocus(),
          validator: (valor) => _mensajeNombre(valor ?? ''),
        ),
      ],
    );
  }

  Widget _campoTelefono(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EtiquetaCampo('Teléfono', error: _errorTelefono != null),
        const SizedBox(height: 4),
        _campo(
          context,
          controller: _telefono,
          focusNode: _focoTelefono,
          hint: '52111222',
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          maxLength: 8,
          formatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(8),
          ],
          onChanged: (valor) {
            if (_errorTelefono != null) {
              setState(() => _errorTelefono = _mensajeTelefono(valor));
            }
          },
          onSubmitted: (_) => _focoCorreo.requestFocus(),
          validator: _validarTelefono,
        ),
      ],
    );
  }

  Widget _campoGenero(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EtiquetaCampo('Género', error: _errorGenero != null),
        const SizedBox(height: 4),
        Segmentado<Genero>(
          valor: _genero,
          onChanged: (valor) {
            setState(() {
              _genero = valor;
              _errorGenero = null;
            });
          },
          opciones: const [(Genero.mujer, 'Mujer'), (Genero.hombre, 'Hombre')],
        ),
        if (_errorGenero != null) ...[
          const SizedBox(height: 4),
          MensajeError(_errorGenero!),
        ],
      ],
    );
  }

  Widget _campoCorreo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EtiquetaCampo('Correo (opcional)', error: _errorCorreo != null),
        const SizedBox(height: 4),
        _campo(
          context,
          controller: _correo,
          focusNode: _focoCorreo,
          hint: 'nombre@correo.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onChanged: (valor) {
            if (_errorCorreo != null) {
              setState(() => _errorCorreo = _mensajeCorreo(valor));
            }
          },
          onSubmitted: (_) => _guardar(),
          validator: (valor) => _mensajeCorreo(valor ?? ''),
        ),
      ],
    );
  }

  /// Caja de texto del formulario: usa [TextFormField] para que el [Form]
  /// valide el campo y muestre el mensaje de error debajo.
  Widget _campo(
    BuildContext context, {
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required FormFieldValidator<String> validator,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction = TextInputAction.done,
    int? maxLength,
    List<TextInputFormatter>? formatters,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      maxLength: maxLength,
      inputFormatters: formatters,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      style: textos.bodyMedium?.copyWith(color: esquema.onSurface),
      decoration: InputDecoration(
        isDense: true,
        counterText: '',
        filled: false,
        hintText: hint,
        hintStyle: textos.bodyMedium?.copyWith(color: esquema.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: _borde(esquema, false),
        enabledBorder: _borde(esquema, false),
        focusedBorder: _borde(esquema, false, activo: true),
        errorBorder: _borde(esquema, true),
        focusedErrorBorder: _borde(esquema, true, activo: true),
        errorStyle: textos.bodySmall?.copyWith(
          fontSize: 12,
          color: esquema.error,
        ),
      ),
    );
  }

  OutlineInputBorder _borde(
    ColorScheme esquema,
    bool error, {
    bool activo = false,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.radioCampos),
      borderSide: BorderSide(
        color: error
            ? esquema.error
            : activo
            ? esquema.primary
            : esquema.outline,
        width: error ? 2 : (activo ? 1.6 : 1),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Validaciones
  // ---------------------------------------------------------------------------

  String? _mensajeNombre(String valor) {
    final texto = valor.trim();
    if (texto.isEmpty) return 'Ingresa el nombre del cliente';
    if (texto.length < 3 || texto.length > 60) {
      return 'Escribe entre 3 y 60 caracteres';
    }
    return null;
  }

  String? _mensajeTelefono(String valor) {
    final texto = valor.trim();
    if (texto.isEmpty) return 'Ingresa el teléfono';
    if (!RegExp(r'^\d{8}$').hasMatch(texto)) {
      return 'Debe tener exactamente 8 dígitos';
    }
    return null;
  }

  String? _mensajeCorreo(String valor) {
    final texto = valor.trim();
    if (texto.isEmpty) return null;
    if (!RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$').hasMatch(texto)) {
      return 'Escribe un correo válido';
    }
    return null;
  }

  /// Valida el teléfono y además que no esté registrado en otro cliente.
  String? _validarTelefono(String? valor) {
    final basico = _mensajeTelefono(valor ?? '');
    if (basico != null) return basico;

    final store = AlcanceTurnos.storeDe(context);
    if (store.telefonoEnUso(valor!.trim(), exceptoId: widget.cliente?.id)) {
      return 'Ese teléfono ya está registrado';
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Acciones
  // ---------------------------------------------------------------------------

  Widget _barraAcciones(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: esquema.surface,
        border: Border(top: BorderSide(color: esquema.outlineVariant)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_falloValidacion)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MensajeError('Revisa los campos marcados en rojo.'),
            ),
          Row(
            children: [
              Expanded(
                child: _Boton(
                  etiqueta: 'Cancelar',
                  relleno: false,
                  color: esquema.primary,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Boton(
                  etiqueta: 'Guardar cliente',
                  relleno: true,
                  color: esquema.onPrimary,
                  onTap: _guardar,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _guardar() {
    // A partir del primer intento, los campos se revalidan al escribir.
    setState(() {
      _autovalidar = AutovalidateMode.onUserInteraction;
      _errorNombre = _mensajeNombre(_nombre.text);
      _errorTelefono = _validarTelefono(_telefono.text);
      _errorGenero = _genero == null ? 'Selecciona un género' : null;
      _errorCorreo = _mensajeCorreo(_correo.text);
      _falloValidacion = false;
    });

    final formulario = _formKey.currentState;
    final valido =
        formulario != null && formulario.validate() && _errorGenero == null;

    if (!valido) {
      setState(() => _falloValidacion = true);
      _enfocarPrimerError();
      return;
    }

    final store = AlcanceTurnos.storeDe(context);
    final nombre = _nombre.text.trim();
    final telefono = _telefono.text.trim();
    final correo = _correo.text.trim();

    if (_esEdicion) {
      store.actualizarCliente(
        widget.cliente!.id,
        nombre: nombre,
        telefono: telefono,
        genero: _genero!,
        correo: correo,
      );
      Navigator.of(context).pop(store.clientePorId(widget.cliente!.id));
    } else {
      final creado = store.agregarCliente(
        nombre: nombre,
        telefono: telefono,
        genero: _genero!,
        correo: correo,
      );
      Navigator.of(context).pop(creado);
    }
  }

  void _enfocarPrimerError() {
    if (_mensajeNombre(_nombre.text) != null) {
      _focoNombre.requestFocus();
      return;
    }
    if (_validarTelefono(_telefono.text) != null) {
      _focoTelefono.requestFocus();
      return;
    }
    if (_mensajeCorreo(_correo.text) != null) {
      _focoCorreo.requestFocus();
    }
  }
}

/// Boton del formulario de cliente: relleno o borde, radio 23 y alto 46.
class _Boton extends StatelessWidget {
  const _Boton({
    required this.etiqueta,
    required this.relleno,
    required this.color,
    required this.onTap,
  });

  final String etiqueta;
  final bool relleno;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Material(
      color: relleno ? esquema.primary : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radioBoton),
        side: relleno ? BorderSide.none : BorderSide(color: esquema.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 46,
          child: Center(
            child: Text(
              etiqueta,
              style: textos.labelLarge?.copyWith(color: color),
            ),
          ),
        ),
      ),
    );
  }
}
