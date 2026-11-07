// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_datos.dart';

// ignore_for_file: type=lint
class $MecanicosTable extends Mecanicos
    with TableInfo<$MecanicosTable, Mecanico> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MecanicosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _especialidadMeta = const VerificationMeta(
    'especialidad',
  );
  @override
  late final GeneratedColumn<String> especialidad = GeneratedColumn<String>(
    'especialidad',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _fechaIngresoMeta = const VerificationMeta(
    'fechaIngreso',
  );
  @override
  late final GeneratedColumn<DateTime> fechaIngreso = GeneratedColumn<DateTime>(
    'fecha_ingreso',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    telefono,
    especialidad,
    activo,
    fechaIngreso,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mecanicos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Mecanico> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('especialidad')) {
      context.handle(
        _especialidadMeta,
        especialidad.isAcceptableOrUnknown(
          data['especialidad']!,
          _especialidadMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('fecha_ingreso')) {
      context.handle(
        _fechaIngresoMeta,
        fechaIngreso.isAcceptableOrUnknown(
          data['fecha_ingreso']!,
          _fechaIngresoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Mecanico map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Mecanico(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      ),
      especialidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}especialidad'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      fechaIngreso: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_ingreso'],
      )!,
    );
  }

  @override
  $MecanicosTable createAlias(String alias) {
    return $MecanicosTable(attachedDatabase, alias);
  }
}

class Mecanico extends DataClass implements Insertable<Mecanico> {
  final int id;
  final String nombre;
  final String? telefono;
  final String? especialidad;
  final bool activo;
  final DateTime fechaIngreso;
  const Mecanico({
    required this.id,
    required this.nombre,
    this.telefono,
    this.especialidad,
    required this.activo,
    required this.fechaIngreso,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    if (!nullToAbsent || especialidad != null) {
      map['especialidad'] = Variable<String>(especialidad);
    }
    map['activo'] = Variable<bool>(activo);
    map['fecha_ingreso'] = Variable<DateTime>(fechaIngreso);
    return map;
  }

  MecanicosCompanion toCompanion(bool nullToAbsent) {
    return MecanicosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      especialidad: especialidad == null && nullToAbsent
          ? const Value.absent()
          : Value(especialidad),
      activo: Value(activo),
      fechaIngreso: Value(fechaIngreso),
    );
  }

  factory Mecanico.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Mecanico(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      especialidad: serializer.fromJson<String?>(json['especialidad']),
      activo: serializer.fromJson<bool>(json['activo']),
      fechaIngreso: serializer.fromJson<DateTime>(json['fechaIngreso']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'telefono': serializer.toJson<String?>(telefono),
      'especialidad': serializer.toJson<String?>(especialidad),
      'activo': serializer.toJson<bool>(activo),
      'fechaIngreso': serializer.toJson<DateTime>(fechaIngreso),
    };
  }

  Mecanico copyWith({
    int? id,
    String? nombre,
    Value<String?> telefono = const Value.absent(),
    Value<String?> especialidad = const Value.absent(),
    bool? activo,
    DateTime? fechaIngreso,
  }) => Mecanico(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    telefono: telefono.present ? telefono.value : this.telefono,
    especialidad: especialidad.present ? especialidad.value : this.especialidad,
    activo: activo ?? this.activo,
    fechaIngreso: fechaIngreso ?? this.fechaIngreso,
  );
  Mecanico copyWithCompanion(MecanicosCompanion data) {
    return Mecanico(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      especialidad: data.especialidad.present
          ? data.especialidad.value
          : this.especialidad,
      activo: data.activo.present ? data.activo.value : this.activo,
      fechaIngreso: data.fechaIngreso.present
          ? data.fechaIngreso.value
          : this.fechaIngreso,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Mecanico(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('especialidad: $especialidad, ')
          ..write('activo: $activo, ')
          ..write('fechaIngreso: $fechaIngreso')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, telefono, especialidad, activo, fechaIngreso);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mecanico &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.telefono == this.telefono &&
          other.especialidad == this.especialidad &&
          other.activo == this.activo &&
          other.fechaIngreso == this.fechaIngreso);
}

class MecanicosCompanion extends UpdateCompanion<Mecanico> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> telefono;
  final Value<String?> especialidad;
  final Value<bool> activo;
  final Value<DateTime> fechaIngreso;
  const MecanicosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.telefono = const Value.absent(),
    this.especialidad = const Value.absent(),
    this.activo = const Value.absent(),
    this.fechaIngreso = const Value.absent(),
  });
  MecanicosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.telefono = const Value.absent(),
    this.especialidad = const Value.absent(),
    this.activo = const Value.absent(),
    this.fechaIngreso = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<Mecanico> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? telefono,
    Expression<String>? especialidad,
    Expression<bool>? activo,
    Expression<DateTime>? fechaIngreso,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (telefono != null) 'telefono': telefono,
      if (especialidad != null) 'especialidad': especialidad,
      if (activo != null) 'activo': activo,
      if (fechaIngreso != null) 'fecha_ingreso': fechaIngreso,
    });
  }

  MecanicosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String?>? telefono,
    Value<String?>? especialidad,
    Value<bool>? activo,
    Value<DateTime>? fechaIngreso,
  }) {
    return MecanicosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      especialidad: especialidad ?? this.especialidad,
      activo: activo ?? this.activo,
      fechaIngreso: fechaIngreso ?? this.fechaIngreso,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (especialidad.present) {
      map['especialidad'] = Variable<String>(especialidad.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (fechaIngreso.present) {
      map['fecha_ingreso'] = Variable<DateTime>(fechaIngreso.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MecanicosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('especialidad: $especialidad, ')
          ..write('activo: $activo, ')
          ..write('fechaIngreso: $fechaIngreso')
          ..write(')'))
        .toString();
  }
}

class $UsuariosTable extends Usuarios with TableInfo<$UsuariosTable, Usuario> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsuariosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreUsuarioMeta = const VerificationMeta(
    'nombreUsuario',
  );
  @override
  late final GeneratedColumn<String> nombreUsuario = GeneratedColumn<String>(
    'nombre_usuario',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nombrePersonaMeta = const VerificationMeta(
    'nombrePersona',
  );
  @override
  late final GeneratedColumn<String> nombrePersona = GeneratedColumn<String>(
    'nombre_persona',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RolUsuario, String> rol =
      GeneratedColumn<String>(
        'rol',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RolUsuario>($UsuariosTable.$converterrol);
  static const VerificationMeta _claveHashMeta = const VerificationMeta(
    'claveHash',
  );
  @override
  late final GeneratedColumn<String> claveHash = GeneratedColumn<String>(
    'clave_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salMeta = const VerificationMeta('sal');
  @override
  late final GeneratedColumn<String> sal = GeneratedColumn<String>(
    'sal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _mecanicoIdMeta = const VerificationMeta(
    'mecanicoId',
  );
  @override
  late final GeneratedColumn<int> mecanicoId = GeneratedColumn<int>(
    'mecanico_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mecanicos (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombreUsuario,
    nombrePersona,
    rol,
    claveHash,
    sal,
    activo,
    creadoEn,
    mecanicoId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usuarios';
  @override
  VerificationContext validateIntegrity(
    Insertable<Usuario> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre_usuario')) {
      context.handle(
        _nombreUsuarioMeta,
        nombreUsuario.isAcceptableOrUnknown(
          data['nombre_usuario']!,
          _nombreUsuarioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreUsuarioMeta);
    }
    if (data.containsKey('nombre_persona')) {
      context.handle(
        _nombrePersonaMeta,
        nombrePersona.isAcceptableOrUnknown(
          data['nombre_persona']!,
          _nombrePersonaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombrePersonaMeta);
    }
    if (data.containsKey('clave_hash')) {
      context.handle(
        _claveHashMeta,
        claveHash.isAcceptableOrUnknown(data['clave_hash']!, _claveHashMeta),
      );
    } else if (isInserting) {
      context.missing(_claveHashMeta);
    }
    if (data.containsKey('sal')) {
      context.handle(
        _salMeta,
        sal.isAcceptableOrUnknown(data['sal']!, _salMeta),
      );
    } else if (isInserting) {
      context.missing(_salMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('mecanico_id')) {
      context.handle(
        _mecanicoIdMeta,
        mecanicoId.isAcceptableOrUnknown(data['mecanico_id']!, _mecanicoIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Usuario map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Usuario(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombreUsuario: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_usuario'],
      )!,
      nombrePersona: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_persona'],
      )!,
      rol: $UsuariosTable.$converterrol.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}rol'],
        )!,
      ),
      claveHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clave_hash'],
      )!,
      sal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sal'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      mecanicoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mecanico_id'],
      ),
    );
  }

  @override
  $UsuariosTable createAlias(String alias) {
    return $UsuariosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RolUsuario, String, String> $converterrol =
      const EnumNameConverter<RolUsuario>(RolUsuario.values);
}

class Usuario extends DataClass implements Insertable<Usuario> {
  final int id;
  final String nombreUsuario;
  final String nombrePersona;
  final RolUsuario rol;
  final String claveHash;
  final String sal;
  final bool activo;
  final DateTime creadoEn;
  final int? mecanicoId;
  const Usuario({
    required this.id,
    required this.nombreUsuario,
    required this.nombrePersona,
    required this.rol,
    required this.claveHash,
    required this.sal,
    required this.activo,
    required this.creadoEn,
    this.mecanicoId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre_usuario'] = Variable<String>(nombreUsuario);
    map['nombre_persona'] = Variable<String>(nombrePersona);
    {
      map['rol'] = Variable<String>($UsuariosTable.$converterrol.toSql(rol));
    }
    map['clave_hash'] = Variable<String>(claveHash);
    map['sal'] = Variable<String>(sal);
    map['activo'] = Variable<bool>(activo);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    if (!nullToAbsent || mecanicoId != null) {
      map['mecanico_id'] = Variable<int>(mecanicoId);
    }
    return map;
  }

  UsuariosCompanion toCompanion(bool nullToAbsent) {
    return UsuariosCompanion(
      id: Value(id),
      nombreUsuario: Value(nombreUsuario),
      nombrePersona: Value(nombrePersona),
      rol: Value(rol),
      claveHash: Value(claveHash),
      sal: Value(sal),
      activo: Value(activo),
      creadoEn: Value(creadoEn),
      mecanicoId: mecanicoId == null && nullToAbsent
          ? const Value.absent()
          : Value(mecanicoId),
    );
  }

  factory Usuario.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Usuario(
      id: serializer.fromJson<int>(json['id']),
      nombreUsuario: serializer.fromJson<String>(json['nombreUsuario']),
      nombrePersona: serializer.fromJson<String>(json['nombrePersona']),
      rol: $UsuariosTable.$converterrol.fromJson(
        serializer.fromJson<String>(json['rol']),
      ),
      claveHash: serializer.fromJson<String>(json['claveHash']),
      sal: serializer.fromJson<String>(json['sal']),
      activo: serializer.fromJson<bool>(json['activo']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      mecanicoId: serializer.fromJson<int?>(json['mecanicoId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombreUsuario': serializer.toJson<String>(nombreUsuario),
      'nombrePersona': serializer.toJson<String>(nombrePersona),
      'rol': serializer.toJson<String>(
        $UsuariosTable.$converterrol.toJson(rol),
      ),
      'claveHash': serializer.toJson<String>(claveHash),
      'sal': serializer.toJson<String>(sal),
      'activo': serializer.toJson<bool>(activo),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'mecanicoId': serializer.toJson<int?>(mecanicoId),
    };
  }

  Usuario copyWith({
    int? id,
    String? nombreUsuario,
    String? nombrePersona,
    RolUsuario? rol,
    String? claveHash,
    String? sal,
    bool? activo,
    DateTime? creadoEn,
    Value<int?> mecanicoId = const Value.absent(),
  }) => Usuario(
    id: id ?? this.id,
    nombreUsuario: nombreUsuario ?? this.nombreUsuario,
    nombrePersona: nombrePersona ?? this.nombrePersona,
    rol: rol ?? this.rol,
    claveHash: claveHash ?? this.claveHash,
    sal: sal ?? this.sal,
    activo: activo ?? this.activo,
    creadoEn: creadoEn ?? this.creadoEn,
    mecanicoId: mecanicoId.present ? mecanicoId.value : this.mecanicoId,
  );
  Usuario copyWithCompanion(UsuariosCompanion data) {
    return Usuario(
      id: data.id.present ? data.id.value : this.id,
      nombreUsuario: data.nombreUsuario.present
          ? data.nombreUsuario.value
          : this.nombreUsuario,
      nombrePersona: data.nombrePersona.present
          ? data.nombrePersona.value
          : this.nombrePersona,
      rol: data.rol.present ? data.rol.value : this.rol,
      claveHash: data.claveHash.present ? data.claveHash.value : this.claveHash,
      sal: data.sal.present ? data.sal.value : this.sal,
      activo: data.activo.present ? data.activo.value : this.activo,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      mecanicoId: data.mecanicoId.present
          ? data.mecanicoId.value
          : this.mecanicoId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Usuario(')
          ..write('id: $id, ')
          ..write('nombreUsuario: $nombreUsuario, ')
          ..write('nombrePersona: $nombrePersona, ')
          ..write('rol: $rol, ')
          ..write('claveHash: $claveHash, ')
          ..write('sal: $sal, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('mecanicoId: $mecanicoId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombreUsuario,
    nombrePersona,
    rol,
    claveHash,
    sal,
    activo,
    creadoEn,
    mecanicoId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Usuario &&
          other.id == this.id &&
          other.nombreUsuario == this.nombreUsuario &&
          other.nombrePersona == this.nombrePersona &&
          other.rol == this.rol &&
          other.claveHash == this.claveHash &&
          other.sal == this.sal &&
          other.activo == this.activo &&
          other.creadoEn == this.creadoEn &&
          other.mecanicoId == this.mecanicoId);
}

class UsuariosCompanion extends UpdateCompanion<Usuario> {
  final Value<int> id;
  final Value<String> nombreUsuario;
  final Value<String> nombrePersona;
  final Value<RolUsuario> rol;
  final Value<String> claveHash;
  final Value<String> sal;
  final Value<bool> activo;
  final Value<DateTime> creadoEn;
  final Value<int?> mecanicoId;
  const UsuariosCompanion({
    this.id = const Value.absent(),
    this.nombreUsuario = const Value.absent(),
    this.nombrePersona = const Value.absent(),
    this.rol = const Value.absent(),
    this.claveHash = const Value.absent(),
    this.sal = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.mecanicoId = const Value.absent(),
  });
  UsuariosCompanion.insert({
    this.id = const Value.absent(),
    required String nombreUsuario,
    required String nombrePersona,
    required RolUsuario rol,
    required String claveHash,
    required String sal,
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.mecanicoId = const Value.absent(),
  }) : nombreUsuario = Value(nombreUsuario),
       nombrePersona = Value(nombrePersona),
       rol = Value(rol),
       claveHash = Value(claveHash),
       sal = Value(sal);
  static Insertable<Usuario> custom({
    Expression<int>? id,
    Expression<String>? nombreUsuario,
    Expression<String>? nombrePersona,
    Expression<String>? rol,
    Expression<String>? claveHash,
    Expression<String>? sal,
    Expression<bool>? activo,
    Expression<DateTime>? creadoEn,
    Expression<int>? mecanicoId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombreUsuario != null) 'nombre_usuario': nombreUsuario,
      if (nombrePersona != null) 'nombre_persona': nombrePersona,
      if (rol != null) 'rol': rol,
      if (claveHash != null) 'clave_hash': claveHash,
      if (sal != null) 'sal': sal,
      if (activo != null) 'activo': activo,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (mecanicoId != null) 'mecanico_id': mecanicoId,
    });
  }

  UsuariosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombreUsuario,
    Value<String>? nombrePersona,
    Value<RolUsuario>? rol,
    Value<String>? claveHash,
    Value<String>? sal,
    Value<bool>? activo,
    Value<DateTime>? creadoEn,
    Value<int?>? mecanicoId,
  }) {
    return UsuariosCompanion(
      id: id ?? this.id,
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
      nombrePersona: nombrePersona ?? this.nombrePersona,
      rol: rol ?? this.rol,
      claveHash: claveHash ?? this.claveHash,
      sal: sal ?? this.sal,
      activo: activo ?? this.activo,
      creadoEn: creadoEn ?? this.creadoEn,
      mecanicoId: mecanicoId ?? this.mecanicoId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombreUsuario.present) {
      map['nombre_usuario'] = Variable<String>(nombreUsuario.value);
    }
    if (nombrePersona.present) {
      map['nombre_persona'] = Variable<String>(nombrePersona.value);
    }
    if (rol.present) {
      map['rol'] = Variable<String>(
        $UsuariosTable.$converterrol.toSql(rol.value),
      );
    }
    if (claveHash.present) {
      map['clave_hash'] = Variable<String>(claveHash.value);
    }
    if (sal.present) {
      map['sal'] = Variable<String>(sal.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (mecanicoId.present) {
      map['mecanico_id'] = Variable<int>(mecanicoId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsuariosCompanion(')
          ..write('id: $id, ')
          ..write('nombreUsuario: $nombreUsuario, ')
          ..write('nombrePersona: $nombrePersona, ')
          ..write('rol: $rol, ')
          ..write('claveHash: $claveHash, ')
          ..write('sal: $sal, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('mecanicoId: $mecanicoId')
          ..write(')'))
        .toString();
  }
}

class $ClientesTable extends Clientes with TableInfo<$ClientesTable, Cliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 7,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _fechaRegistroMeta = const VerificationMeta(
    'fechaRegistro',
  );
  @override
  late final GeneratedColumn<DateTime> fechaRegistro =
      GeneratedColumn<DateTime>(
        'fecha_registro',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    telefono,
    direccion,
    activo,
    fechaRegistro,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cliente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    } else if (isInserting) {
      context.missing(_telefonoMeta);
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('fecha_registro')) {
      context.handle(
        _fechaRegistroMeta,
        fechaRegistro.isAcceptableOrUnknown(
          data['fecha_registro']!,
          _fechaRegistroMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cliente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cliente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      )!,
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      fechaRegistro: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_registro'],
      )!,
    );
  }

  @override
  $ClientesTable createAlias(String alias) {
    return $ClientesTable(attachedDatabase, alias);
  }
}

class Cliente extends DataClass implements Insertable<Cliente> {
  final int id;
  final String nombre;
  final String telefono;
  final String? direccion;
  final bool activo;
  final DateTime fechaRegistro;
  const Cliente({
    required this.id,
    required this.nombre,
    required this.telefono,
    this.direccion,
    required this.activo,
    required this.fechaRegistro,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['telefono'] = Variable<String>(telefono);
    if (!nullToAbsent || direccion != null) {
      map['direccion'] = Variable<String>(direccion);
    }
    map['activo'] = Variable<bool>(activo);
    map['fecha_registro'] = Variable<DateTime>(fechaRegistro);
    return map;
  }

  ClientesCompanion toCompanion(bool nullToAbsent) {
    return ClientesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      telefono: Value(telefono),
      direccion: direccion == null && nullToAbsent
          ? const Value.absent()
          : Value(direccion),
      activo: Value(activo),
      fechaRegistro: Value(fechaRegistro),
    );
  }

  factory Cliente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cliente(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      telefono: serializer.fromJson<String>(json['telefono']),
      direccion: serializer.fromJson<String?>(json['direccion']),
      activo: serializer.fromJson<bool>(json['activo']),
      fechaRegistro: serializer.fromJson<DateTime>(json['fechaRegistro']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'telefono': serializer.toJson<String>(telefono),
      'direccion': serializer.toJson<String?>(direccion),
      'activo': serializer.toJson<bool>(activo),
      'fechaRegistro': serializer.toJson<DateTime>(fechaRegistro),
    };
  }

  Cliente copyWith({
    int? id,
    String? nombre,
    String? telefono,
    Value<String?> direccion = const Value.absent(),
    bool? activo,
    DateTime? fechaRegistro,
  }) => Cliente(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    telefono: telefono ?? this.telefono,
    direccion: direccion.present ? direccion.value : this.direccion,
    activo: activo ?? this.activo,
    fechaRegistro: fechaRegistro ?? this.fechaRegistro,
  );
  Cliente copyWithCompanion(ClientesCompanion data) {
    return Cliente(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      activo: data.activo.present ? data.activo.value : this.activo,
      fechaRegistro: data.fechaRegistro.present
          ? data.fechaRegistro.value
          : this.fechaRegistro,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cliente(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('direccion: $direccion, ')
          ..write('activo: $activo, ')
          ..write('fechaRegistro: $fechaRegistro')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, telefono, direccion, activo, fechaRegistro);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cliente &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.telefono == this.telefono &&
          other.direccion == this.direccion &&
          other.activo == this.activo &&
          other.fechaRegistro == this.fechaRegistro);
}

class ClientesCompanion extends UpdateCompanion<Cliente> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> telefono;
  final Value<String?> direccion;
  final Value<bool> activo;
  final Value<DateTime> fechaRegistro;
  const ClientesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.telefono = const Value.absent(),
    this.direccion = const Value.absent(),
    this.activo = const Value.absent(),
    this.fechaRegistro = const Value.absent(),
  });
  ClientesCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String telefono,
    this.direccion = const Value.absent(),
    this.activo = const Value.absent(),
    this.fechaRegistro = const Value.absent(),
  }) : nombre = Value(nombre),
       telefono = Value(telefono);
  static Insertable<Cliente> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? telefono,
    Expression<String>? direccion,
    Expression<bool>? activo,
    Expression<DateTime>? fechaRegistro,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (telefono != null) 'telefono': telefono,
      if (direccion != null) 'direccion': direccion,
      if (activo != null) 'activo': activo,
      if (fechaRegistro != null) 'fecha_registro': fechaRegistro,
    });
  }

  ClientesCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? telefono,
    Value<String?>? direccion,
    Value<bool>? activo,
    Value<DateTime>? fechaRegistro,
  }) {
    return ClientesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      activo: activo ?? this.activo,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (fechaRegistro.present) {
      map['fecha_registro'] = Variable<DateTime>(fechaRegistro.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('direccion: $direccion, ')
          ..write('activo: $activo, ')
          ..write('fechaRegistro: $fechaRegistro')
          ..write(')'))
        .toString();
  }
}

class $VehiculosTable extends Vehiculos
    with TableInfo<$VehiculosTable, Vehiculo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiculosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id)',
    ),
  );
  static const VerificationMeta _matriculaMeta = const VerificationMeta(
    'matricula',
  );
  @override
  late final GeneratedColumn<String> matricula = GeneratedColumn<String>(
    'matricula',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _marcaMeta = const VerificationMeta('marca');
  @override
  late final GeneratedColumn<String> marca = GeneratedColumn<String>(
    'marca',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeloMeta = const VerificationMeta('modelo');
  @override
  late final GeneratedColumn<String> modelo = GeneratedColumn<String>(
    'modelo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anioMeta = const VerificationMeta('anio');
  @override
  late final GeneratedColumn<int> anio = GeneratedColumn<int>(
    'anio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kilometrajeMeta = const VerificationMeta(
    'kilometraje',
  );
  @override
  late final GeneratedColumn<int> kilometraje = GeneratedColumn<int>(
    'kilometraje',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clienteId,
    matricula,
    marca,
    modelo,
    anio,
    kilometraje,
    activo,
    creadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehiculos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vehiculo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('matricula')) {
      context.handle(
        _matriculaMeta,
        matricula.isAcceptableOrUnknown(data['matricula']!, _matriculaMeta),
      );
    } else if (isInserting) {
      context.missing(_matriculaMeta);
    }
    if (data.containsKey('marca')) {
      context.handle(
        _marcaMeta,
        marca.isAcceptableOrUnknown(data['marca']!, _marcaMeta),
      );
    } else if (isInserting) {
      context.missing(_marcaMeta);
    }
    if (data.containsKey('modelo')) {
      context.handle(
        _modeloMeta,
        modelo.isAcceptableOrUnknown(data['modelo']!, _modeloMeta),
      );
    } else if (isInserting) {
      context.missing(_modeloMeta);
    }
    if (data.containsKey('anio')) {
      context.handle(
        _anioMeta,
        anio.isAcceptableOrUnknown(data['anio']!, _anioMeta),
      );
    } else if (isInserting) {
      context.missing(_anioMeta);
    }
    if (data.containsKey('kilometraje')) {
      context.handle(
        _kilometrajeMeta,
        kilometraje.isAcceptableOrUnknown(
          data['kilometraje']!,
          _kilometrajeMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehiculo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehiculo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
      matricula: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}matricula'],
      )!,
      marca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marca'],
      )!,
      modelo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modelo'],
      )!,
      anio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anio'],
      )!,
      kilometraje: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kilometraje'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
    );
  }

  @override
  $VehiculosTable createAlias(String alias) {
    return $VehiculosTable(attachedDatabase, alias);
  }
}

class Vehiculo extends DataClass implements Insertable<Vehiculo> {
  final int id;
  final int clienteId;
  final String matricula;
  final String marca;
  final String modelo;
  final int anio;
  final int kilometraje;
  final bool activo;
  final DateTime creadoEn;
  const Vehiculo({
    required this.id,
    required this.clienteId,
    required this.matricula,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.kilometraje,
    required this.activo,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cliente_id'] = Variable<int>(clienteId);
    map['matricula'] = Variable<String>(matricula);
    map['marca'] = Variable<String>(marca);
    map['modelo'] = Variable<String>(modelo);
    map['anio'] = Variable<int>(anio);
    map['kilometraje'] = Variable<int>(kilometraje);
    map['activo'] = Variable<bool>(activo);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    return map;
  }

  VehiculosCompanion toCompanion(bool nullToAbsent) {
    return VehiculosCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      matricula: Value(matricula),
      marca: Value(marca),
      modelo: Value(modelo),
      anio: Value(anio),
      kilometraje: Value(kilometraje),
      activo: Value(activo),
      creadoEn: Value(creadoEn),
    );
  }

  factory Vehiculo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehiculo(
      id: serializer.fromJson<int>(json['id']),
      clienteId: serializer.fromJson<int>(json['clienteId']),
      matricula: serializer.fromJson<String>(json['matricula']),
      marca: serializer.fromJson<String>(json['marca']),
      modelo: serializer.fromJson<String>(json['modelo']),
      anio: serializer.fromJson<int>(json['anio']),
      kilometraje: serializer.fromJson<int>(json['kilometraje']),
      activo: serializer.fromJson<bool>(json['activo']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clienteId': serializer.toJson<int>(clienteId),
      'matricula': serializer.toJson<String>(matricula),
      'marca': serializer.toJson<String>(marca),
      'modelo': serializer.toJson<String>(modelo),
      'anio': serializer.toJson<int>(anio),
      'kilometraje': serializer.toJson<int>(kilometraje),
      'activo': serializer.toJson<bool>(activo),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
    };
  }

  Vehiculo copyWith({
    int? id,
    int? clienteId,
    String? matricula,
    String? marca,
    String? modelo,
    int? anio,
    int? kilometraje,
    bool? activo,
    DateTime? creadoEn,
  }) => Vehiculo(
    id: id ?? this.id,
    clienteId: clienteId ?? this.clienteId,
    matricula: matricula ?? this.matricula,
    marca: marca ?? this.marca,
    modelo: modelo ?? this.modelo,
    anio: anio ?? this.anio,
    kilometraje: kilometraje ?? this.kilometraje,
    activo: activo ?? this.activo,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  Vehiculo copyWithCompanion(VehiculosCompanion data) {
    return Vehiculo(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      matricula: data.matricula.present ? data.matricula.value : this.matricula,
      marca: data.marca.present ? data.marca.value : this.marca,
      modelo: data.modelo.present ? data.modelo.value : this.modelo,
      anio: data.anio.present ? data.anio.value : this.anio,
      kilometraje: data.kilometraje.present
          ? data.kilometraje.value
          : this.kilometraje,
      activo: data.activo.present ? data.activo.value : this.activo,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehiculo(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('matricula: $matricula, ')
          ..write('marca: $marca, ')
          ..write('modelo: $modelo, ')
          ..write('anio: $anio, ')
          ..write('kilometraje: $kilometraje, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clienteId,
    matricula,
    marca,
    modelo,
    anio,
    kilometraje,
    activo,
    creadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehiculo &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.matricula == this.matricula &&
          other.marca == this.marca &&
          other.modelo == this.modelo &&
          other.anio == this.anio &&
          other.kilometraje == this.kilometraje &&
          other.activo == this.activo &&
          other.creadoEn == this.creadoEn);
}

class VehiculosCompanion extends UpdateCompanion<Vehiculo> {
  final Value<int> id;
  final Value<int> clienteId;
  final Value<String> matricula;
  final Value<String> marca;
  final Value<String> modelo;
  final Value<int> anio;
  final Value<int> kilometraje;
  final Value<bool> activo;
  final Value<DateTime> creadoEn;
  const VehiculosCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.matricula = const Value.absent(),
    this.marca = const Value.absent(),
    this.modelo = const Value.absent(),
    this.anio = const Value.absent(),
    this.kilometraje = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
  });
  VehiculosCompanion.insert({
    this.id = const Value.absent(),
    required int clienteId,
    required String matricula,
    required String marca,
    required String modelo,
    required int anio,
    this.kilometraje = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
  }) : clienteId = Value(clienteId),
       matricula = Value(matricula),
       marca = Value(marca),
       modelo = Value(modelo),
       anio = Value(anio);
  static Insertable<Vehiculo> custom({
    Expression<int>? id,
    Expression<int>? clienteId,
    Expression<String>? matricula,
    Expression<String>? marca,
    Expression<String>? modelo,
    Expression<int>? anio,
    Expression<int>? kilometraje,
    Expression<bool>? activo,
    Expression<DateTime>? creadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (matricula != null) 'matricula': matricula,
      if (marca != null) 'marca': marca,
      if (modelo != null) 'modelo': modelo,
      if (anio != null) 'anio': anio,
      if (kilometraje != null) 'kilometraje': kilometraje,
      if (activo != null) 'activo': activo,
      if (creadoEn != null) 'creado_en': creadoEn,
    });
  }

  VehiculosCompanion copyWith({
    Value<int>? id,
    Value<int>? clienteId,
    Value<String>? matricula,
    Value<String>? marca,
    Value<String>? modelo,
    Value<int>? anio,
    Value<int>? kilometraje,
    Value<bool>? activo,
    Value<DateTime>? creadoEn,
  }) {
    return VehiculosCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      matricula: matricula ?? this.matricula,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      anio: anio ?? this.anio,
      kilometraje: kilometraje ?? this.kilometraje,
      activo: activo ?? this.activo,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (matricula.present) {
      map['matricula'] = Variable<String>(matricula.value);
    }
    if (marca.present) {
      map['marca'] = Variable<String>(marca.value);
    }
    if (modelo.present) {
      map['modelo'] = Variable<String>(modelo.value);
    }
    if (anio.present) {
      map['anio'] = Variable<int>(anio.value);
    }
    if (kilometraje.present) {
      map['kilometraje'] = Variable<int>(kilometraje.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiculosCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('matricula: $matricula, ')
          ..write('marca: $marca, ')
          ..write('modelo: $modelo, ')
          ..write('anio: $anio, ')
          ..write('kilometraje: $kilometraje, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }
}

class $OrdenesServicioTable extends OrdenesServicio
    with TableInfo<$OrdenesServicioTable, OrdenServicio> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdenesServicioTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<String> numero = GeneratedColumn<String>(
    'numero',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id)',
    ),
  );
  static const VerificationMeta _vehiculoIdMeta = const VerificationMeta(
    'vehiculoId',
  );
  @override
  late final GeneratedColumn<int> vehiculoId = GeneratedColumn<int>(
    'vehiculo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehiculos (id)',
    ),
  );
  static const VerificationMeta _mecanicoIdMeta = const VerificationMeta(
    'mecanicoId',
  );
  @override
  late final GeneratedColumn<int> mecanicoId = GeneratedColumn<int>(
    'mecanico_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mecanicos (id)',
    ),
  );
  static const VerificationMeta _fechaEntradaMeta = const VerificationMeta(
    'fechaEntrada',
  );
  @override
  late final GeneratedColumn<DateTime> fechaEntrada = GeneratedColumn<DateTime>(
    'fecha_entrada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _problemaMeta = const VerificationMeta(
    'problema',
  );
  @override
  late final GeneratedColumn<String> problema = GeneratedColumn<String>(
    'problema',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EstadoOrden, String> estado =
      GeneratedColumn<String>(
        'estado',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EstadoOrden>($OrdenesServicioTable.$converterestado);
  static const VerificationMeta _kilometrajeEntradaMeta =
      const VerificationMeta('kilometrajeEntrada');
  @override
  late final GeneratedColumn<int> kilometrajeEntrada = GeneratedColumn<int>(
    'kilometraje_entrada',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
    'notas',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _fechaCierreMeta = const VerificationMeta(
    'fechaCierre',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCierre = GeneratedColumn<DateTime>(
    'fecha_cierre',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    numero,
    clienteId,
    vehiculoId,
    mecanicoId,
    fechaEntrada,
    problema,
    estado,
    kilometrajeEntrada,
    notas,
    creadoEn,
    actualizadoEn,
    fechaCierre,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ordenes_servicio';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrdenServicio> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('numero')) {
      context.handle(
        _numeroMeta,
        numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta),
      );
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('vehiculo_id')) {
      context.handle(
        _vehiculoIdMeta,
        vehiculoId.isAcceptableOrUnknown(data['vehiculo_id']!, _vehiculoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehiculoIdMeta);
    }
    if (data.containsKey('mecanico_id')) {
      context.handle(
        _mecanicoIdMeta,
        mecanicoId.isAcceptableOrUnknown(data['mecanico_id']!, _mecanicoIdMeta),
      );
    }
    if (data.containsKey('fecha_entrada')) {
      context.handle(
        _fechaEntradaMeta,
        fechaEntrada.isAcceptableOrUnknown(
          data['fecha_entrada']!,
          _fechaEntradaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaEntradaMeta);
    }
    if (data.containsKey('problema')) {
      context.handle(
        _problemaMeta,
        problema.isAcceptableOrUnknown(data['problema']!, _problemaMeta),
      );
    } else if (isInserting) {
      context.missing(_problemaMeta);
    }
    if (data.containsKey('kilometraje_entrada')) {
      context.handle(
        _kilometrajeEntradaMeta,
        kilometrajeEntrada.isAcceptableOrUnknown(
          data['kilometraje_entrada']!,
          _kilometrajeEntradaMeta,
        ),
      );
    }
    if (data.containsKey('notas')) {
      context.handle(
        _notasMeta,
        notas.isAcceptableOrUnknown(data['notas']!, _notasMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    if (data.containsKey('fecha_cierre')) {
      context.handle(
        _fechaCierreMeta,
        fechaCierre.isAcceptableOrUnknown(
          data['fecha_cierre']!,
          _fechaCierreMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrdenServicio map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrdenServicio(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      numero: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
      vehiculoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehiculo_id'],
      )!,
      mecanicoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mecanico_id'],
      ),
      fechaEntrada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_entrada'],
      )!,
      problema: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}problema'],
      )!,
      estado: $OrdenesServicioTable.$converterestado.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}estado'],
        )!,
      ),
      kilometrajeEntrada: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kilometraje_entrada'],
      )!,
      notas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notas'],
      ),
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
      fechaCierre: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_cierre'],
      ),
    );
  }

  @override
  $OrdenesServicioTable createAlias(String alias) {
    return $OrdenesServicioTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EstadoOrden, String, String> $converterestado =
      const EnumNameConverter<EstadoOrden>(EstadoOrden.values);
}

class OrdenServicio extends DataClass implements Insertable<OrdenServicio> {
  final int id;
  final String numero;
  final int clienteId;
  final int vehiculoId;
  final int? mecanicoId;
  final DateTime fechaEntrada;
  final String problema;
  final EstadoOrden estado;
  final int kilometrajeEntrada;
  final String? notas;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  final DateTime? fechaCierre;
  const OrdenServicio({
    required this.id,
    required this.numero,
    required this.clienteId,
    required this.vehiculoId,
    this.mecanicoId,
    required this.fechaEntrada,
    required this.problema,
    required this.estado,
    required this.kilometrajeEntrada,
    this.notas,
    required this.creadoEn,
    required this.actualizadoEn,
    this.fechaCierre,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['numero'] = Variable<String>(numero);
    map['cliente_id'] = Variable<int>(clienteId);
    map['vehiculo_id'] = Variable<int>(vehiculoId);
    if (!nullToAbsent || mecanicoId != null) {
      map['mecanico_id'] = Variable<int>(mecanicoId);
    }
    map['fecha_entrada'] = Variable<DateTime>(fechaEntrada);
    map['problema'] = Variable<String>(problema);
    {
      map['estado'] = Variable<String>(
        $OrdenesServicioTable.$converterestado.toSql(estado),
      );
    }
    map['kilometraje_entrada'] = Variable<int>(kilometrajeEntrada);
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    if (!nullToAbsent || fechaCierre != null) {
      map['fecha_cierre'] = Variable<DateTime>(fechaCierre);
    }
    return map;
  }

  OrdenesServicioCompanion toCompanion(bool nullToAbsent) {
    return OrdenesServicioCompanion(
      id: Value(id),
      numero: Value(numero),
      clienteId: Value(clienteId),
      vehiculoId: Value(vehiculoId),
      mecanicoId: mecanicoId == null && nullToAbsent
          ? const Value.absent()
          : Value(mecanicoId),
      fechaEntrada: Value(fechaEntrada),
      problema: Value(problema),
      estado: Value(estado),
      kilometrajeEntrada: Value(kilometrajeEntrada),
      notas: notas == null && nullToAbsent
          ? const Value.absent()
          : Value(notas),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
      fechaCierre: fechaCierre == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaCierre),
    );
  }

  factory OrdenServicio.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrdenServicio(
      id: serializer.fromJson<int>(json['id']),
      numero: serializer.fromJson<String>(json['numero']),
      clienteId: serializer.fromJson<int>(json['clienteId']),
      vehiculoId: serializer.fromJson<int>(json['vehiculoId']),
      mecanicoId: serializer.fromJson<int?>(json['mecanicoId']),
      fechaEntrada: serializer.fromJson<DateTime>(json['fechaEntrada']),
      problema: serializer.fromJson<String>(json['problema']),
      estado: $OrdenesServicioTable.$converterestado.fromJson(
        serializer.fromJson<String>(json['estado']),
      ),
      kilometrajeEntrada: serializer.fromJson<int>(json['kilometrajeEntrada']),
      notas: serializer.fromJson<String?>(json['notas']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
      fechaCierre: serializer.fromJson<DateTime?>(json['fechaCierre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'numero': serializer.toJson<String>(numero),
      'clienteId': serializer.toJson<int>(clienteId),
      'vehiculoId': serializer.toJson<int>(vehiculoId),
      'mecanicoId': serializer.toJson<int?>(mecanicoId),
      'fechaEntrada': serializer.toJson<DateTime>(fechaEntrada),
      'problema': serializer.toJson<String>(problema),
      'estado': serializer.toJson<String>(
        $OrdenesServicioTable.$converterestado.toJson(estado),
      ),
      'kilometrajeEntrada': serializer.toJson<int>(kilometrajeEntrada),
      'notas': serializer.toJson<String?>(notas),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
      'fechaCierre': serializer.toJson<DateTime?>(fechaCierre),
    };
  }

  OrdenServicio copyWith({
    int? id,
    String? numero,
    int? clienteId,
    int? vehiculoId,
    Value<int?> mecanicoId = const Value.absent(),
    DateTime? fechaEntrada,
    String? problema,
    EstadoOrden? estado,
    int? kilometrajeEntrada,
    Value<String?> notas = const Value.absent(),
    DateTime? creadoEn,
    DateTime? actualizadoEn,
    Value<DateTime?> fechaCierre = const Value.absent(),
  }) => OrdenServicio(
    id: id ?? this.id,
    numero: numero ?? this.numero,
    clienteId: clienteId ?? this.clienteId,
    vehiculoId: vehiculoId ?? this.vehiculoId,
    mecanicoId: mecanicoId.present ? mecanicoId.value : this.mecanicoId,
    fechaEntrada: fechaEntrada ?? this.fechaEntrada,
    problema: problema ?? this.problema,
    estado: estado ?? this.estado,
    kilometrajeEntrada: kilometrajeEntrada ?? this.kilometrajeEntrada,
    notas: notas.present ? notas.value : this.notas,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    fechaCierre: fechaCierre.present ? fechaCierre.value : this.fechaCierre,
  );
  OrdenServicio copyWithCompanion(OrdenesServicioCompanion data) {
    return OrdenServicio(
      id: data.id.present ? data.id.value : this.id,
      numero: data.numero.present ? data.numero.value : this.numero,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      vehiculoId: data.vehiculoId.present
          ? data.vehiculoId.value
          : this.vehiculoId,
      mecanicoId: data.mecanicoId.present
          ? data.mecanicoId.value
          : this.mecanicoId,
      fechaEntrada: data.fechaEntrada.present
          ? data.fechaEntrada.value
          : this.fechaEntrada,
      problema: data.problema.present ? data.problema.value : this.problema,
      estado: data.estado.present ? data.estado.value : this.estado,
      kilometrajeEntrada: data.kilometrajeEntrada.present
          ? data.kilometrajeEntrada.value
          : this.kilometrajeEntrada,
      notas: data.notas.present ? data.notas.value : this.notas,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
      fechaCierre: data.fechaCierre.present
          ? data.fechaCierre.value
          : this.fechaCierre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrdenServicio(')
          ..write('id: $id, ')
          ..write('numero: $numero, ')
          ..write('clienteId: $clienteId, ')
          ..write('vehiculoId: $vehiculoId, ')
          ..write('mecanicoId: $mecanicoId, ')
          ..write('fechaEntrada: $fechaEntrada, ')
          ..write('problema: $problema, ')
          ..write('estado: $estado, ')
          ..write('kilometrajeEntrada: $kilometrajeEntrada, ')
          ..write('notas: $notas, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('fechaCierre: $fechaCierre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    numero,
    clienteId,
    vehiculoId,
    mecanicoId,
    fechaEntrada,
    problema,
    estado,
    kilometrajeEntrada,
    notas,
    creadoEn,
    actualizadoEn,
    fechaCierre,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdenServicio &&
          other.id == this.id &&
          other.numero == this.numero &&
          other.clienteId == this.clienteId &&
          other.vehiculoId == this.vehiculoId &&
          other.mecanicoId == this.mecanicoId &&
          other.fechaEntrada == this.fechaEntrada &&
          other.problema == this.problema &&
          other.estado == this.estado &&
          other.kilometrajeEntrada == this.kilometrajeEntrada &&
          other.notas == this.notas &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn &&
          other.fechaCierre == this.fechaCierre);
}

class OrdenesServicioCompanion extends UpdateCompanion<OrdenServicio> {
  final Value<int> id;
  final Value<String> numero;
  final Value<int> clienteId;
  final Value<int> vehiculoId;
  final Value<int?> mecanicoId;
  final Value<DateTime> fechaEntrada;
  final Value<String> problema;
  final Value<EstadoOrden> estado;
  final Value<int> kilometrajeEntrada;
  final Value<String?> notas;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  final Value<DateTime?> fechaCierre;
  const OrdenesServicioCompanion({
    this.id = const Value.absent(),
    this.numero = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.vehiculoId = const Value.absent(),
    this.mecanicoId = const Value.absent(),
    this.fechaEntrada = const Value.absent(),
    this.problema = const Value.absent(),
    this.estado = const Value.absent(),
    this.kilometrajeEntrada = const Value.absent(),
    this.notas = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.fechaCierre = const Value.absent(),
  });
  OrdenesServicioCompanion.insert({
    this.id = const Value.absent(),
    required String numero,
    required int clienteId,
    required int vehiculoId,
    this.mecanicoId = const Value.absent(),
    required DateTime fechaEntrada,
    required String problema,
    required EstadoOrden estado,
    this.kilometrajeEntrada = const Value.absent(),
    this.notas = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.fechaCierre = const Value.absent(),
  }) : numero = Value(numero),
       clienteId = Value(clienteId),
       vehiculoId = Value(vehiculoId),
       fechaEntrada = Value(fechaEntrada),
       problema = Value(problema),
       estado = Value(estado);
  static Insertable<OrdenServicio> custom({
    Expression<int>? id,
    Expression<String>? numero,
    Expression<int>? clienteId,
    Expression<int>? vehiculoId,
    Expression<int>? mecanicoId,
    Expression<DateTime>? fechaEntrada,
    Expression<String>? problema,
    Expression<String>? estado,
    Expression<int>? kilometrajeEntrada,
    Expression<String>? notas,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
    Expression<DateTime>? fechaCierre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (numero != null) 'numero': numero,
      if (clienteId != null) 'cliente_id': clienteId,
      if (vehiculoId != null) 'vehiculo_id': vehiculoId,
      if (mecanicoId != null) 'mecanico_id': mecanicoId,
      if (fechaEntrada != null) 'fecha_entrada': fechaEntrada,
      if (problema != null) 'problema': problema,
      if (estado != null) 'estado': estado,
      if (kilometrajeEntrada != null) 'kilometraje_entrada': kilometrajeEntrada,
      if (notas != null) 'notas': notas,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (fechaCierre != null) 'fecha_cierre': fechaCierre,
    });
  }

  OrdenesServicioCompanion copyWith({
    Value<int>? id,
    Value<String>? numero,
    Value<int>? clienteId,
    Value<int>? vehiculoId,
    Value<int?>? mecanicoId,
    Value<DateTime>? fechaEntrada,
    Value<String>? problema,
    Value<EstadoOrden>? estado,
    Value<int>? kilometrajeEntrada,
    Value<String?>? notas,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
    Value<DateTime?>? fechaCierre,
  }) {
    return OrdenesServicioCompanion(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      clienteId: clienteId ?? this.clienteId,
      vehiculoId: vehiculoId ?? this.vehiculoId,
      mecanicoId: mecanicoId ?? this.mecanicoId,
      fechaEntrada: fechaEntrada ?? this.fechaEntrada,
      problema: problema ?? this.problema,
      estado: estado ?? this.estado,
      kilometrajeEntrada: kilometrajeEntrada ?? this.kilometrajeEntrada,
      notas: notas ?? this.notas,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      fechaCierre: fechaCierre ?? this.fechaCierre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (numero.present) {
      map['numero'] = Variable<String>(numero.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (vehiculoId.present) {
      map['vehiculo_id'] = Variable<int>(vehiculoId.value);
    }
    if (mecanicoId.present) {
      map['mecanico_id'] = Variable<int>(mecanicoId.value);
    }
    if (fechaEntrada.present) {
      map['fecha_entrada'] = Variable<DateTime>(fechaEntrada.value);
    }
    if (problema.present) {
      map['problema'] = Variable<String>(problema.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(
        $OrdenesServicioTable.$converterestado.toSql(estado.value),
      );
    }
    if (kilometrajeEntrada.present) {
      map['kilometraje_entrada'] = Variable<int>(kilometrajeEntrada.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (fechaCierre.present) {
      map['fecha_cierre'] = Variable<DateTime>(fechaCierre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdenesServicioCompanion(')
          ..write('id: $id, ')
          ..write('numero: $numero, ')
          ..write('clienteId: $clienteId, ')
          ..write('vehiculoId: $vehiculoId, ')
          ..write('mecanicoId: $mecanicoId, ')
          ..write('fechaEntrada: $fechaEntrada, ')
          ..write('problema: $problema, ')
          ..write('estado: $estado, ')
          ..write('kilometrajeEntrada: $kilometrajeEntrada, ')
          ..write('notas: $notas, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('fechaCierre: $fechaCierre')
          ..write(')'))
        .toString();
  }
}

class $TrabajosTable extends Trabajos with TableInfo<$TrabajosTable, Trabajo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrabajosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ordenIdMeta = const VerificationMeta(
    'ordenId',
  );
  @override
  late final GeneratedColumn<int> ordenId = GeneratedColumn<int>(
    'orden_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ordenes_servicio (id)',
    ),
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioManoObraMeta = const VerificationMeta(
    'precioManoObra',
  );
  @override
  late final GeneratedColumn<double> precioManoObra = GeneratedColumn<double>(
    'precio_mano_obra',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mecanicoIdMeta = const VerificationMeta(
    'mecanicoId',
  );
  @override
  late final GeneratedColumn<int> mecanicoId = GeneratedColumn<int>(
    'mecanico_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mecanicos (id)',
    ),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ordenId,
    descripcion,
    precioManoObra,
    mecanicoId,
    fecha,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trabajos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Trabajo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orden_id')) {
      context.handle(
        _ordenIdMeta,
        ordenId.isAcceptableOrUnknown(data['orden_id']!, _ordenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenIdMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('precio_mano_obra')) {
      context.handle(
        _precioManoObraMeta,
        precioManoObra.isAcceptableOrUnknown(
          data['precio_mano_obra']!,
          _precioManoObraMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioManoObraMeta);
    }
    if (data.containsKey('mecanico_id')) {
      context.handle(
        _mecanicoIdMeta,
        mecanicoId.isAcceptableOrUnknown(data['mecanico_id']!, _mecanicoIdMeta),
      );
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Trabajo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trabajo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ordenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden_id'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      precioManoObra: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_mano_obra'],
      )!,
      mecanicoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mecanico_id'],
      ),
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
    );
  }

  @override
  $TrabajosTable createAlias(String alias) {
    return $TrabajosTable(attachedDatabase, alias);
  }
}

class Trabajo extends DataClass implements Insertable<Trabajo> {
  final int id;
  final int ordenId;
  final String descripcion;
  final double precioManoObra;
  final int? mecanicoId;
  final DateTime fecha;
  const Trabajo({
    required this.id,
    required this.ordenId,
    required this.descripcion,
    required this.precioManoObra,
    this.mecanicoId,
    required this.fecha,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orden_id'] = Variable<int>(ordenId);
    map['descripcion'] = Variable<String>(descripcion);
    map['precio_mano_obra'] = Variable<double>(precioManoObra);
    if (!nullToAbsent || mecanicoId != null) {
      map['mecanico_id'] = Variable<int>(mecanicoId);
    }
    map['fecha'] = Variable<DateTime>(fecha);
    return map;
  }

  TrabajosCompanion toCompanion(bool nullToAbsent) {
    return TrabajosCompanion(
      id: Value(id),
      ordenId: Value(ordenId),
      descripcion: Value(descripcion),
      precioManoObra: Value(precioManoObra),
      mecanicoId: mecanicoId == null && nullToAbsent
          ? const Value.absent()
          : Value(mecanicoId),
      fecha: Value(fecha),
    );
  }

  factory Trabajo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trabajo(
      id: serializer.fromJson<int>(json['id']),
      ordenId: serializer.fromJson<int>(json['ordenId']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      precioManoObra: serializer.fromJson<double>(json['precioManoObra']),
      mecanicoId: serializer.fromJson<int?>(json['mecanicoId']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ordenId': serializer.toJson<int>(ordenId),
      'descripcion': serializer.toJson<String>(descripcion),
      'precioManoObra': serializer.toJson<double>(precioManoObra),
      'mecanicoId': serializer.toJson<int?>(mecanicoId),
      'fecha': serializer.toJson<DateTime>(fecha),
    };
  }

  Trabajo copyWith({
    int? id,
    int? ordenId,
    String? descripcion,
    double? precioManoObra,
    Value<int?> mecanicoId = const Value.absent(),
    DateTime? fecha,
  }) => Trabajo(
    id: id ?? this.id,
    ordenId: ordenId ?? this.ordenId,
    descripcion: descripcion ?? this.descripcion,
    precioManoObra: precioManoObra ?? this.precioManoObra,
    mecanicoId: mecanicoId.present ? mecanicoId.value : this.mecanicoId,
    fecha: fecha ?? this.fecha,
  );
  Trabajo copyWithCompanion(TrabajosCompanion data) {
    return Trabajo(
      id: data.id.present ? data.id.value : this.id,
      ordenId: data.ordenId.present ? data.ordenId.value : this.ordenId,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      precioManoObra: data.precioManoObra.present
          ? data.precioManoObra.value
          : this.precioManoObra,
      mecanicoId: data.mecanicoId.present
          ? data.mecanicoId.value
          : this.mecanicoId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trabajo(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('descripcion: $descripcion, ')
          ..write('precioManoObra: $precioManoObra, ')
          ..write('mecanicoId: $mecanicoId, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ordenId, descripcion, precioManoObra, mecanicoId, fecha);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trabajo &&
          other.id == this.id &&
          other.ordenId == this.ordenId &&
          other.descripcion == this.descripcion &&
          other.precioManoObra == this.precioManoObra &&
          other.mecanicoId == this.mecanicoId &&
          other.fecha == this.fecha);
}

class TrabajosCompanion extends UpdateCompanion<Trabajo> {
  final Value<int> id;
  final Value<int> ordenId;
  final Value<String> descripcion;
  final Value<double> precioManoObra;
  final Value<int?> mecanicoId;
  final Value<DateTime> fecha;
  const TrabajosCompanion({
    this.id = const Value.absent(),
    this.ordenId = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.precioManoObra = const Value.absent(),
    this.mecanicoId = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  TrabajosCompanion.insert({
    this.id = const Value.absent(),
    required int ordenId,
    required String descripcion,
    required double precioManoObra,
    this.mecanicoId = const Value.absent(),
    this.fecha = const Value.absent(),
  }) : ordenId = Value(ordenId),
       descripcion = Value(descripcion),
       precioManoObra = Value(precioManoObra);
  static Insertable<Trabajo> custom({
    Expression<int>? id,
    Expression<int>? ordenId,
    Expression<String>? descripcion,
    Expression<double>? precioManoObra,
    Expression<int>? mecanicoId,
    Expression<DateTime>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ordenId != null) 'orden_id': ordenId,
      if (descripcion != null) 'descripcion': descripcion,
      if (precioManoObra != null) 'precio_mano_obra': precioManoObra,
      if (mecanicoId != null) 'mecanico_id': mecanicoId,
      if (fecha != null) 'fecha': fecha,
    });
  }

  TrabajosCompanion copyWith({
    Value<int>? id,
    Value<int>? ordenId,
    Value<String>? descripcion,
    Value<double>? precioManoObra,
    Value<int?>? mecanicoId,
    Value<DateTime>? fecha,
  }) {
    return TrabajosCompanion(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      descripcion: descripcion ?? this.descripcion,
      precioManoObra: precioManoObra ?? this.precioManoObra,
      mecanicoId: mecanicoId ?? this.mecanicoId,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ordenId.present) {
      map['orden_id'] = Variable<int>(ordenId.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (precioManoObra.present) {
      map['precio_mano_obra'] = Variable<double>(precioManoObra.value);
    }
    if (mecanicoId.present) {
      map['mecanico_id'] = Variable<int>(mecanicoId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrabajosCompanion(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('descripcion: $descripcion, ')
          ..write('precioManoObra: $precioManoObra, ')
          ..write('mecanicoId: $mecanicoId, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class $RepuestosTable extends Repuestos
    with TableInfo<$RepuestosTable, Repuesto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepuestosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _precioVentaMeta = const VerificationMeta(
    'precioVenta',
  );
  @override
  late final GeneratedColumn<double> precioVenta = GeneratedColumn<double>(
    'precio_venta',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _existenciasMeta = const VerificationMeta(
    'existencias',
  );
  @override
  late final GeneratedColumn<int> existencias = GeneratedColumn<int>(
    'existencias',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _umbralMeta = const VerificationMeta('umbral');
  @override
  late final GeneratedColumn<int> umbral = GeneratedColumn<int>(
    'umbral',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    codigo,
    precioVenta,
    existencias,
    umbral,
    activo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repuestos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Repuesto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('precio_venta')) {
      context.handle(
        _precioVentaMeta,
        precioVenta.isAcceptableOrUnknown(
          data['precio_venta']!,
          _precioVentaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioVentaMeta);
    }
    if (data.containsKey('existencias')) {
      context.handle(
        _existenciasMeta,
        existencias.isAcceptableOrUnknown(
          data['existencias']!,
          _existenciasMeta,
        ),
      );
    }
    if (data.containsKey('umbral')) {
      context.handle(
        _umbralMeta,
        umbral.isAcceptableOrUnknown(data['umbral']!, _umbralMeta),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Repuesto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Repuesto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      precioVenta: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_venta'],
      )!,
      existencias: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}existencias'],
      )!,
      umbral: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}umbral'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
    );
  }

  @override
  $RepuestosTable createAlias(String alias) {
    return $RepuestosTable(attachedDatabase, alias);
  }
}

class Repuesto extends DataClass implements Insertable<Repuesto> {
  final int id;
  final String nombre;
  final String codigo;
  final double precioVenta;
  final int existencias;
  final int umbral;
  final bool activo;
  const Repuesto({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.precioVenta,
    required this.existencias,
    required this.umbral,
    required this.activo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['codigo'] = Variable<String>(codigo);
    map['precio_venta'] = Variable<double>(precioVenta);
    map['existencias'] = Variable<int>(existencias);
    map['umbral'] = Variable<int>(umbral);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  RepuestosCompanion toCompanion(bool nullToAbsent) {
    return RepuestosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      codigo: Value(codigo),
      precioVenta: Value(precioVenta),
      existencias: Value(existencias),
      umbral: Value(umbral),
      activo: Value(activo),
    );
  }

  factory Repuesto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Repuesto(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      codigo: serializer.fromJson<String>(json['codigo']),
      precioVenta: serializer.fromJson<double>(json['precioVenta']),
      existencias: serializer.fromJson<int>(json['existencias']),
      umbral: serializer.fromJson<int>(json['umbral']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'codigo': serializer.toJson<String>(codigo),
      'precioVenta': serializer.toJson<double>(precioVenta),
      'existencias': serializer.toJson<int>(existencias),
      'umbral': serializer.toJson<int>(umbral),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  Repuesto copyWith({
    int? id,
    String? nombre,
    String? codigo,
    double? precioVenta,
    int? existencias,
    int? umbral,
    bool? activo,
  }) => Repuesto(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    codigo: codigo ?? this.codigo,
    precioVenta: precioVenta ?? this.precioVenta,
    existencias: existencias ?? this.existencias,
    umbral: umbral ?? this.umbral,
    activo: activo ?? this.activo,
  );
  Repuesto copyWithCompanion(RepuestosCompanion data) {
    return Repuesto(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      precioVenta: data.precioVenta.present
          ? data.precioVenta.value
          : this.precioVenta,
      existencias: data.existencias.present
          ? data.existencias.value
          : this.existencias,
      umbral: data.umbral.present ? data.umbral.value : this.umbral,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Repuesto(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('precioVenta: $precioVenta, ')
          ..write('existencias: $existencias, ')
          ..write('umbral: $umbral, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, codigo, precioVenta, existencias, umbral, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Repuesto &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.codigo == this.codigo &&
          other.precioVenta == this.precioVenta &&
          other.existencias == this.existencias &&
          other.umbral == this.umbral &&
          other.activo == this.activo);
}

class RepuestosCompanion extends UpdateCompanion<Repuesto> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> codigo;
  final Value<double> precioVenta;
  final Value<int> existencias;
  final Value<int> umbral;
  final Value<bool> activo;
  const RepuestosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.codigo = const Value.absent(),
    this.precioVenta = const Value.absent(),
    this.existencias = const Value.absent(),
    this.umbral = const Value.absent(),
    this.activo = const Value.absent(),
  });
  RepuestosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String codigo,
    required double precioVenta,
    this.existencias = const Value.absent(),
    this.umbral = const Value.absent(),
    this.activo = const Value.absent(),
  }) : nombre = Value(nombre),
       codigo = Value(codigo),
       precioVenta = Value(precioVenta);
  static Insertable<Repuesto> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? codigo,
    Expression<double>? precioVenta,
    Expression<int>? existencias,
    Expression<int>? umbral,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (codigo != null) 'codigo': codigo,
      if (precioVenta != null) 'precio_venta': precioVenta,
      if (existencias != null) 'existencias': existencias,
      if (umbral != null) 'umbral': umbral,
      if (activo != null) 'activo': activo,
    });
  }

  RepuestosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? codigo,
    Value<double>? precioVenta,
    Value<int>? existencias,
    Value<int>? umbral,
    Value<bool>? activo,
  }) {
    return RepuestosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      precioVenta: precioVenta ?? this.precioVenta,
      existencias: existencias ?? this.existencias,
      umbral: umbral ?? this.umbral,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (precioVenta.present) {
      map['precio_venta'] = Variable<double>(precioVenta.value);
    }
    if (existencias.present) {
      map['existencias'] = Variable<int>(existencias.value);
    }
    if (umbral.present) {
      map['umbral'] = Variable<int>(umbral.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepuestosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('precioVenta: $precioVenta, ')
          ..write('existencias: $existencias, ')
          ..write('umbral: $umbral, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $RepuestosOrdenTable extends RepuestosOrden
    with TableInfo<$RepuestosOrdenTable, RepuestoOrden> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepuestosOrdenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ordenIdMeta = const VerificationMeta(
    'ordenId',
  );
  @override
  late final GeneratedColumn<int> ordenId = GeneratedColumn<int>(
    'orden_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ordenes_servicio (id)',
    ),
  );
  static const VerificationMeta _repuestoIdMeta = const VerificationMeta(
    'repuestoId',
  );
  @override
  late final GeneratedColumn<int> repuestoId = GeneratedColumn<int>(
    'repuesto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES repuestos (id)',
    ),
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioUnitarioMeta = const VerificationMeta(
    'precioUnitario',
  );
  @override
  late final GeneratedColumn<double> precioUnitario = GeneratedColumn<double>(
    'precio_unitario',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ordenId,
    repuestoId,
    cantidad,
    precioUnitario,
    fecha,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repuestos_orden';
  @override
  VerificationContext validateIntegrity(
    Insertable<RepuestoOrden> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orden_id')) {
      context.handle(
        _ordenIdMeta,
        ordenId.isAcceptableOrUnknown(data['orden_id']!, _ordenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenIdMeta);
    }
    if (data.containsKey('repuesto_id')) {
      context.handle(
        _repuestoIdMeta,
        repuestoId.isAcceptableOrUnknown(data['repuesto_id']!, _repuestoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_repuestoIdMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('precio_unitario')) {
      context.handle(
        _precioUnitarioMeta,
        precioUnitario.isAcceptableOrUnknown(
          data['precio_unitario']!,
          _precioUnitarioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioUnitarioMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RepuestoOrden map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepuestoOrden(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ordenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden_id'],
      )!,
      repuestoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repuesto_id'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      precioUnitario: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_unitario'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
    );
  }

  @override
  $RepuestosOrdenTable createAlias(String alias) {
    return $RepuestosOrdenTable(attachedDatabase, alias);
  }
}

class RepuestoOrden extends DataClass implements Insertable<RepuestoOrden> {
  final int id;
  final int ordenId;
  final int repuestoId;
  final int cantidad;
  final double precioUnitario;
  final DateTime fecha;
  const RepuestoOrden({
    required this.id,
    required this.ordenId,
    required this.repuestoId,
    required this.cantidad,
    required this.precioUnitario,
    required this.fecha,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orden_id'] = Variable<int>(ordenId);
    map['repuesto_id'] = Variable<int>(repuestoId);
    map['cantidad'] = Variable<int>(cantidad);
    map['precio_unitario'] = Variable<double>(precioUnitario);
    map['fecha'] = Variable<DateTime>(fecha);
    return map;
  }

  RepuestosOrdenCompanion toCompanion(bool nullToAbsent) {
    return RepuestosOrdenCompanion(
      id: Value(id),
      ordenId: Value(ordenId),
      repuestoId: Value(repuestoId),
      cantidad: Value(cantidad),
      precioUnitario: Value(precioUnitario),
      fecha: Value(fecha),
    );
  }

  factory RepuestoOrden.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepuestoOrden(
      id: serializer.fromJson<int>(json['id']),
      ordenId: serializer.fromJson<int>(json['ordenId']),
      repuestoId: serializer.fromJson<int>(json['repuestoId']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      precioUnitario: serializer.fromJson<double>(json['precioUnitario']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ordenId': serializer.toJson<int>(ordenId),
      'repuestoId': serializer.toJson<int>(repuestoId),
      'cantidad': serializer.toJson<int>(cantidad),
      'precioUnitario': serializer.toJson<double>(precioUnitario),
      'fecha': serializer.toJson<DateTime>(fecha),
    };
  }

  RepuestoOrden copyWith({
    int? id,
    int? ordenId,
    int? repuestoId,
    int? cantidad,
    double? precioUnitario,
    DateTime? fecha,
  }) => RepuestoOrden(
    id: id ?? this.id,
    ordenId: ordenId ?? this.ordenId,
    repuestoId: repuestoId ?? this.repuestoId,
    cantidad: cantidad ?? this.cantidad,
    precioUnitario: precioUnitario ?? this.precioUnitario,
    fecha: fecha ?? this.fecha,
  );
  RepuestoOrden copyWithCompanion(RepuestosOrdenCompanion data) {
    return RepuestoOrden(
      id: data.id.present ? data.id.value : this.id,
      ordenId: data.ordenId.present ? data.ordenId.value : this.ordenId,
      repuestoId: data.repuestoId.present
          ? data.repuestoId.value
          : this.repuestoId,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioUnitario: data.precioUnitario.present
          ? data.precioUnitario.value
          : this.precioUnitario,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RepuestoOrden(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('repuestoId: $repuestoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ordenId, repuestoId, cantidad, precioUnitario, fecha);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepuestoOrden &&
          other.id == this.id &&
          other.ordenId == this.ordenId &&
          other.repuestoId == this.repuestoId &&
          other.cantidad == this.cantidad &&
          other.precioUnitario == this.precioUnitario &&
          other.fecha == this.fecha);
}

class RepuestosOrdenCompanion extends UpdateCompanion<RepuestoOrden> {
  final Value<int> id;
  final Value<int> ordenId;
  final Value<int> repuestoId;
  final Value<int> cantidad;
  final Value<double> precioUnitario;
  final Value<DateTime> fecha;
  const RepuestosOrdenCompanion({
    this.id = const Value.absent(),
    this.ordenId = const Value.absent(),
    this.repuestoId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  RepuestosOrdenCompanion.insert({
    this.id = const Value.absent(),
    required int ordenId,
    required int repuestoId,
    required int cantidad,
    required double precioUnitario,
    this.fecha = const Value.absent(),
  }) : ordenId = Value(ordenId),
       repuestoId = Value(repuestoId),
       cantidad = Value(cantidad),
       precioUnitario = Value(precioUnitario);
  static Insertable<RepuestoOrden> custom({
    Expression<int>? id,
    Expression<int>? ordenId,
    Expression<int>? repuestoId,
    Expression<int>? cantidad,
    Expression<double>? precioUnitario,
    Expression<DateTime>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ordenId != null) 'orden_id': ordenId,
      if (repuestoId != null) 'repuesto_id': repuestoId,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioUnitario != null) 'precio_unitario': precioUnitario,
      if (fecha != null) 'fecha': fecha,
    });
  }

  RepuestosOrdenCompanion copyWith({
    Value<int>? id,
    Value<int>? ordenId,
    Value<int>? repuestoId,
    Value<int>? cantidad,
    Value<double>? precioUnitario,
    Value<DateTime>? fecha,
  }) {
    return RepuestosOrdenCompanion(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      repuestoId: repuestoId ?? this.repuestoId,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ordenId.present) {
      map['orden_id'] = Variable<int>(ordenId.value);
    }
    if (repuestoId.present) {
      map['repuesto_id'] = Variable<int>(repuestoId.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (precioUnitario.present) {
      map['precio_unitario'] = Variable<double>(precioUnitario.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepuestosOrdenCompanion(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('repuestoId: $repuestoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class $PagosTable extends Pagos with TableInfo<$PagosTable, Pago> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PagosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ordenIdMeta = const VerificationMeta(
    'ordenId',
  );
  @override
  late final GeneratedColumn<int> ordenId = GeneratedColumn<int>(
    'orden_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ordenes_servicio (id)',
    ),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _importeMeta = const VerificationMeta(
    'importe',
  );
  @override
  late final GeneratedColumn<double> importe = GeneratedColumn<double>(
    'importe',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metodoMeta = const VerificationMeta('metodo');
  @override
  late final GeneratedColumn<String> metodo = GeneratedColumn<String>(
    'metodo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
    'nota',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _registradoPorMeta = const VerificationMeta(
    'registradoPor',
  );
  @override
  late final GeneratedColumn<String> registradoPor = GeneratedColumn<String>(
    'registrado_por',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ordenId,
    fecha,
    importe,
    metodo,
    nota,
    registradoPor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pagos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pago> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orden_id')) {
      context.handle(
        _ordenIdMeta,
        ordenId.isAcceptableOrUnknown(data['orden_id']!, _ordenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenIdMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    if (data.containsKey('importe')) {
      context.handle(
        _importeMeta,
        importe.isAcceptableOrUnknown(data['importe']!, _importeMeta),
      );
    } else if (isInserting) {
      context.missing(_importeMeta);
    }
    if (data.containsKey('metodo')) {
      context.handle(
        _metodoMeta,
        metodo.isAcceptableOrUnknown(data['metodo']!, _metodoMeta),
      );
    } else if (isInserting) {
      context.missing(_metodoMeta);
    }
    if (data.containsKey('nota')) {
      context.handle(
        _notaMeta,
        nota.isAcceptableOrUnknown(data['nota']!, _notaMeta),
      );
    }
    if (data.containsKey('registrado_por')) {
      context.handle(
        _registradoPorMeta,
        registradoPor.isAcceptableOrUnknown(
          data['registrado_por']!,
          _registradoPorMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pago map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pago(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ordenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden_id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      importe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}importe'],
      )!,
      metodo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metodo'],
      )!,
      nota: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nota'],
      ),
      registradoPor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registrado_por'],
      ),
    );
  }

  @override
  $PagosTable createAlias(String alias) {
    return $PagosTable(attachedDatabase, alias);
  }
}

class Pago extends DataClass implements Insertable<Pago> {
  final int id;
  final int ordenId;
  final DateTime fecha;
  final double importe;
  final String metodo;
  final String? nota;
  final String? registradoPor;
  const Pago({
    required this.id,
    required this.ordenId,
    required this.fecha,
    required this.importe,
    required this.metodo,
    this.nota,
    this.registradoPor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orden_id'] = Variable<int>(ordenId);
    map['fecha'] = Variable<DateTime>(fecha);
    map['importe'] = Variable<double>(importe);
    map['metodo'] = Variable<String>(metodo);
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<String>(nota);
    }
    if (!nullToAbsent || registradoPor != null) {
      map['registrado_por'] = Variable<String>(registradoPor);
    }
    return map;
  }

  PagosCompanion toCompanion(bool nullToAbsent) {
    return PagosCompanion(
      id: Value(id),
      ordenId: Value(ordenId),
      fecha: Value(fecha),
      importe: Value(importe),
      metodo: Value(metodo),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
      registradoPor: registradoPor == null && nullToAbsent
          ? const Value.absent()
          : Value(registradoPor),
    );
  }

  factory Pago.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pago(
      id: serializer.fromJson<int>(json['id']),
      ordenId: serializer.fromJson<int>(json['ordenId']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      importe: serializer.fromJson<double>(json['importe']),
      metodo: serializer.fromJson<String>(json['metodo']),
      nota: serializer.fromJson<String?>(json['nota']),
      registradoPor: serializer.fromJson<String?>(json['registradoPor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ordenId': serializer.toJson<int>(ordenId),
      'fecha': serializer.toJson<DateTime>(fecha),
      'importe': serializer.toJson<double>(importe),
      'metodo': serializer.toJson<String>(metodo),
      'nota': serializer.toJson<String?>(nota),
      'registradoPor': serializer.toJson<String?>(registradoPor),
    };
  }

  Pago copyWith({
    int? id,
    int? ordenId,
    DateTime? fecha,
    double? importe,
    String? metodo,
    Value<String?> nota = const Value.absent(),
    Value<String?> registradoPor = const Value.absent(),
  }) => Pago(
    id: id ?? this.id,
    ordenId: ordenId ?? this.ordenId,
    fecha: fecha ?? this.fecha,
    importe: importe ?? this.importe,
    metodo: metodo ?? this.metodo,
    nota: nota.present ? nota.value : this.nota,
    registradoPor: registradoPor.present
        ? registradoPor.value
        : this.registradoPor,
  );
  Pago copyWithCompanion(PagosCompanion data) {
    return Pago(
      id: data.id.present ? data.id.value : this.id,
      ordenId: data.ordenId.present ? data.ordenId.value : this.ordenId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      importe: data.importe.present ? data.importe.value : this.importe,
      metodo: data.metodo.present ? data.metodo.value : this.metodo,
      nota: data.nota.present ? data.nota.value : this.nota,
      registradoPor: data.registradoPor.present
          ? data.registradoPor.value
          : this.registradoPor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pago(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('fecha: $fecha, ')
          ..write('importe: $importe, ')
          ..write('metodo: $metodo, ')
          ..write('nota: $nota, ')
          ..write('registradoPor: $registradoPor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ordenId, fecha, importe, metodo, nota, registradoPor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pago &&
          other.id == this.id &&
          other.ordenId == this.ordenId &&
          other.fecha == this.fecha &&
          other.importe == this.importe &&
          other.metodo == this.metodo &&
          other.nota == this.nota &&
          other.registradoPor == this.registradoPor);
}

class PagosCompanion extends UpdateCompanion<Pago> {
  final Value<int> id;
  final Value<int> ordenId;
  final Value<DateTime> fecha;
  final Value<double> importe;
  final Value<String> metodo;
  final Value<String?> nota;
  final Value<String?> registradoPor;
  const PagosCompanion({
    this.id = const Value.absent(),
    this.ordenId = const Value.absent(),
    this.fecha = const Value.absent(),
    this.importe = const Value.absent(),
    this.metodo = const Value.absent(),
    this.nota = const Value.absent(),
    this.registradoPor = const Value.absent(),
  });
  PagosCompanion.insert({
    this.id = const Value.absent(),
    required int ordenId,
    this.fecha = const Value.absent(),
    required double importe,
    required String metodo,
    this.nota = const Value.absent(),
    this.registradoPor = const Value.absent(),
  }) : ordenId = Value(ordenId),
       importe = Value(importe),
       metodo = Value(metodo);
  static Insertable<Pago> custom({
    Expression<int>? id,
    Expression<int>? ordenId,
    Expression<DateTime>? fecha,
    Expression<double>? importe,
    Expression<String>? metodo,
    Expression<String>? nota,
    Expression<String>? registradoPor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ordenId != null) 'orden_id': ordenId,
      if (fecha != null) 'fecha': fecha,
      if (importe != null) 'importe': importe,
      if (metodo != null) 'metodo': metodo,
      if (nota != null) 'nota': nota,
      if (registradoPor != null) 'registrado_por': registradoPor,
    });
  }

  PagosCompanion copyWith({
    Value<int>? id,
    Value<int>? ordenId,
    Value<DateTime>? fecha,
    Value<double>? importe,
    Value<String>? metodo,
    Value<String?>? nota,
    Value<String?>? registradoPor,
  }) {
    return PagosCompanion(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      fecha: fecha ?? this.fecha,
      importe: importe ?? this.importe,
      metodo: metodo ?? this.metodo,
      nota: nota ?? this.nota,
      registradoPor: registradoPor ?? this.registradoPor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ordenId.present) {
      map['orden_id'] = Variable<int>(ordenId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (importe.present) {
      map['importe'] = Variable<double>(importe.value);
    }
    if (metodo.present) {
      map['metodo'] = Variable<String>(metodo.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    if (registradoPor.present) {
      map['registrado_por'] = Variable<String>(registradoPor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PagosCompanion(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('fecha: $fecha, ')
          ..write('importe: $importe, ')
          ..write('metodo: $metodo, ')
          ..write('nota: $nota, ')
          ..write('registradoPor: $registradoPor')
          ..write(')'))
        .toString();
  }
}

class $MovimientosInventarioTable extends MovimientosInventario
    with TableInfo<$MovimientosInventarioTable, MovimientoInventario> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovimientosInventarioTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _repuestoIdMeta = const VerificationMeta(
    'repuestoId',
  );
  @override
  late final GeneratedColumn<int> repuestoId = GeneratedColumn<int>(
    'repuesto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES repuestos (id)',
    ),
  );
  static const VerificationMeta _ordenIdMeta = const VerificationMeta(
    'ordenId',
  );
  @override
  late final GeneratedColumn<int> ordenId = GeneratedColumn<int>(
    'orden_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ordenes_servicio (id)',
    ),
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
    'nota',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usuarioMeta = const VerificationMeta(
    'usuario',
  );
  @override
  late final GeneratedColumn<String> usuario = GeneratedColumn<String>(
    'usuario',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    repuestoId,
    ordenId,
    tipo,
    cantidad,
    fecha,
    nota,
    usuario,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movimientos_inventario';
  @override
  VerificationContext validateIntegrity(
    Insertable<MovimientoInventario> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('repuesto_id')) {
      context.handle(
        _repuestoIdMeta,
        repuestoId.isAcceptableOrUnknown(data['repuesto_id']!, _repuestoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_repuestoIdMeta);
    }
    if (data.containsKey('orden_id')) {
      context.handle(
        _ordenIdMeta,
        ordenId.isAcceptableOrUnknown(data['orden_id']!, _ordenIdMeta),
      );
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    if (data.containsKey('nota')) {
      context.handle(
        _notaMeta,
        nota.isAcceptableOrUnknown(data['nota']!, _notaMeta),
      );
    }
    if (data.containsKey('usuario')) {
      context.handle(
        _usuarioMeta,
        usuario.isAcceptableOrUnknown(data['usuario']!, _usuarioMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MovimientoInventario map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovimientoInventario(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      repuestoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repuesto_id'],
      )!,
      ordenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden_id'],
      ),
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      nota: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nota'],
      ),
      usuario: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario'],
      ),
    );
  }

  @override
  $MovimientosInventarioTable createAlias(String alias) {
    return $MovimientosInventarioTable(attachedDatabase, alias);
  }
}

class MovimientoInventario extends DataClass
    implements Insertable<MovimientoInventario> {
  final int id;
  final int repuestoId;
  final int? ordenId;
  final String tipo;
  final int cantidad;
  final DateTime fecha;
  final String? nota;
  final String? usuario;
  const MovimientoInventario({
    required this.id,
    required this.repuestoId,
    this.ordenId,
    required this.tipo,
    required this.cantidad,
    required this.fecha,
    this.nota,
    this.usuario,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['repuesto_id'] = Variable<int>(repuestoId);
    if (!nullToAbsent || ordenId != null) {
      map['orden_id'] = Variable<int>(ordenId);
    }
    map['tipo'] = Variable<String>(tipo);
    map['cantidad'] = Variable<int>(cantidad);
    map['fecha'] = Variable<DateTime>(fecha);
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<String>(nota);
    }
    if (!nullToAbsent || usuario != null) {
      map['usuario'] = Variable<String>(usuario);
    }
    return map;
  }

  MovimientosInventarioCompanion toCompanion(bool nullToAbsent) {
    return MovimientosInventarioCompanion(
      id: Value(id),
      repuestoId: Value(repuestoId),
      ordenId: ordenId == null && nullToAbsent
          ? const Value.absent()
          : Value(ordenId),
      tipo: Value(tipo),
      cantidad: Value(cantidad),
      fecha: Value(fecha),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
      usuario: usuario == null && nullToAbsent
          ? const Value.absent()
          : Value(usuario),
    );
  }

  factory MovimientoInventario.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovimientoInventario(
      id: serializer.fromJson<int>(json['id']),
      repuestoId: serializer.fromJson<int>(json['repuestoId']),
      ordenId: serializer.fromJson<int?>(json['ordenId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      nota: serializer.fromJson<String?>(json['nota']),
      usuario: serializer.fromJson<String?>(json['usuario']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'repuestoId': serializer.toJson<int>(repuestoId),
      'ordenId': serializer.toJson<int?>(ordenId),
      'tipo': serializer.toJson<String>(tipo),
      'cantidad': serializer.toJson<int>(cantidad),
      'fecha': serializer.toJson<DateTime>(fecha),
      'nota': serializer.toJson<String?>(nota),
      'usuario': serializer.toJson<String?>(usuario),
    };
  }

  MovimientoInventario copyWith({
    int? id,
    int? repuestoId,
    Value<int?> ordenId = const Value.absent(),
    String? tipo,
    int? cantidad,
    DateTime? fecha,
    Value<String?> nota = const Value.absent(),
    Value<String?> usuario = const Value.absent(),
  }) => MovimientoInventario(
    id: id ?? this.id,
    repuestoId: repuestoId ?? this.repuestoId,
    ordenId: ordenId.present ? ordenId.value : this.ordenId,
    tipo: tipo ?? this.tipo,
    cantidad: cantidad ?? this.cantidad,
    fecha: fecha ?? this.fecha,
    nota: nota.present ? nota.value : this.nota,
    usuario: usuario.present ? usuario.value : this.usuario,
  );
  MovimientoInventario copyWithCompanion(MovimientosInventarioCompanion data) {
    return MovimientoInventario(
      id: data.id.present ? data.id.value : this.id,
      repuestoId: data.repuestoId.present
          ? data.repuestoId.value
          : this.repuestoId,
      ordenId: data.ordenId.present ? data.ordenId.value : this.ordenId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      nota: data.nota.present ? data.nota.value : this.nota,
      usuario: data.usuario.present ? data.usuario.value : this.usuario,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovimientoInventario(')
          ..write('id: $id, ')
          ..write('repuestoId: $repuestoId, ')
          ..write('ordenId: $ordenId, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('fecha: $fecha, ')
          ..write('nota: $nota, ')
          ..write('usuario: $usuario')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    repuestoId,
    ordenId,
    tipo,
    cantidad,
    fecha,
    nota,
    usuario,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovimientoInventario &&
          other.id == this.id &&
          other.repuestoId == this.repuestoId &&
          other.ordenId == this.ordenId &&
          other.tipo == this.tipo &&
          other.cantidad == this.cantidad &&
          other.fecha == this.fecha &&
          other.nota == this.nota &&
          other.usuario == this.usuario);
}

class MovimientosInventarioCompanion
    extends UpdateCompanion<MovimientoInventario> {
  final Value<int> id;
  final Value<int> repuestoId;
  final Value<int?> ordenId;
  final Value<String> tipo;
  final Value<int> cantidad;
  final Value<DateTime> fecha;
  final Value<String?> nota;
  final Value<String?> usuario;
  const MovimientosInventarioCompanion({
    this.id = const Value.absent(),
    this.repuestoId = const Value.absent(),
    this.ordenId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.fecha = const Value.absent(),
    this.nota = const Value.absent(),
    this.usuario = const Value.absent(),
  });
  MovimientosInventarioCompanion.insert({
    this.id = const Value.absent(),
    required int repuestoId,
    this.ordenId = const Value.absent(),
    required String tipo,
    required int cantidad,
    this.fecha = const Value.absent(),
    this.nota = const Value.absent(),
    this.usuario = const Value.absent(),
  }) : repuestoId = Value(repuestoId),
       tipo = Value(tipo),
       cantidad = Value(cantidad);
  static Insertable<MovimientoInventario> custom({
    Expression<int>? id,
    Expression<int>? repuestoId,
    Expression<int>? ordenId,
    Expression<String>? tipo,
    Expression<int>? cantidad,
    Expression<DateTime>? fecha,
    Expression<String>? nota,
    Expression<String>? usuario,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (repuestoId != null) 'repuesto_id': repuestoId,
      if (ordenId != null) 'orden_id': ordenId,
      if (tipo != null) 'tipo': tipo,
      if (cantidad != null) 'cantidad': cantidad,
      if (fecha != null) 'fecha': fecha,
      if (nota != null) 'nota': nota,
      if (usuario != null) 'usuario': usuario,
    });
  }

  MovimientosInventarioCompanion copyWith({
    Value<int>? id,
    Value<int>? repuestoId,
    Value<int?>? ordenId,
    Value<String>? tipo,
    Value<int>? cantidad,
    Value<DateTime>? fecha,
    Value<String?>? nota,
    Value<String?>? usuario,
  }) {
    return MovimientosInventarioCompanion(
      id: id ?? this.id,
      repuestoId: repuestoId ?? this.repuestoId,
      ordenId: ordenId ?? this.ordenId,
      tipo: tipo ?? this.tipo,
      cantidad: cantidad ?? this.cantidad,
      fecha: fecha ?? this.fecha,
      nota: nota ?? this.nota,
      usuario: usuario ?? this.usuario,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (repuestoId.present) {
      map['repuesto_id'] = Variable<int>(repuestoId.value);
    }
    if (ordenId.present) {
      map['orden_id'] = Variable<int>(ordenId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    if (usuario.present) {
      map['usuario'] = Variable<String>(usuario.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovimientosInventarioCompanion(')
          ..write('id: $id, ')
          ..write('repuestoId: $repuestoId, ')
          ..write('ordenId: $ordenId, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('fecha: $fecha, ')
          ..write('nota: $nota, ')
          ..write('usuario: $usuario')
          ..write(')'))
        .toString();
  }
}

class $ConfiguracionTable extends Configuracion
    with TableInfo<$ConfiguracionTable, ConfiguracionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfiguracionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _claveMeta = const VerificationMeta('clave');
  @override
  late final GeneratedColumn<String> clave = GeneratedColumn<String>(
    'clave',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<String> valor = GeneratedColumn<String>(
    'valor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [clave, valor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'configuracion';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConfiguracionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('clave')) {
      context.handle(
        _claveMeta,
        clave.isAcceptableOrUnknown(data['clave']!, _claveMeta),
      );
    } else if (isInserting) {
      context.missing(_claveMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clave};
  @override
  ConfiguracionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfiguracionItem(
      clave: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clave'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valor'],
      )!,
    );
  }

  @override
  $ConfiguracionTable createAlias(String alias) {
    return $ConfiguracionTable(attachedDatabase, alias);
  }
}

class ConfiguracionItem extends DataClass
    implements Insertable<ConfiguracionItem> {
  final String clave;
  final String valor;
  const ConfiguracionItem({required this.clave, required this.valor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['clave'] = Variable<String>(clave);
    map['valor'] = Variable<String>(valor);
    return map;
  }

  ConfiguracionCompanion toCompanion(bool nullToAbsent) {
    return ConfiguracionCompanion(clave: Value(clave), valor: Value(valor));
  }

  factory ConfiguracionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfiguracionItem(
      clave: serializer.fromJson<String>(json['clave']),
      valor: serializer.fromJson<String>(json['valor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clave': serializer.toJson<String>(clave),
      'valor': serializer.toJson<String>(valor),
    };
  }

  ConfiguracionItem copyWith({String? clave, String? valor}) =>
      ConfiguracionItem(clave: clave ?? this.clave, valor: valor ?? this.valor);
  ConfiguracionItem copyWithCompanion(ConfiguracionCompanion data) {
    return ConfiguracionItem(
      clave: data.clave.present ? data.clave.value : this.clave,
      valor: data.valor.present ? data.valor.value : this.valor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracionItem(')
          ..write('clave: $clave, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(clave, valor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfiguracionItem &&
          other.clave == this.clave &&
          other.valor == this.valor);
}

class ConfiguracionCompanion extends UpdateCompanion<ConfiguracionItem> {
  final Value<String> clave;
  final Value<String> valor;
  final Value<int> rowid;
  const ConfiguracionCompanion({
    this.clave = const Value.absent(),
    this.valor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConfiguracionCompanion.insert({
    required String clave,
    required String valor,
    this.rowid = const Value.absent(),
  }) : clave = Value(clave),
       valor = Value(valor);
  static Insertable<ConfiguracionItem> custom({
    Expression<String>? clave,
    Expression<String>? valor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clave != null) 'clave': clave,
      if (valor != null) 'valor': valor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConfiguracionCompanion copyWith({
    Value<String>? clave,
    Value<String>? valor,
    Value<int>? rowid,
  }) {
    return ConfiguracionCompanion(
      clave: clave ?? this.clave,
      valor: valor ?? this.valor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clave.present) {
      map['clave'] = Variable<String>(clave.value);
    }
    if (valor.present) {
      map['valor'] = Variable<String>(valor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracionCompanion(')
          ..write('clave: $clave, ')
          ..write('valor: $valor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$BaseDatos extends GeneratedDatabase {
  _$BaseDatos(QueryExecutor e) : super(e);
  $BaseDatosManager get managers => $BaseDatosManager(this);
  late final $MecanicosTable mecanicos = $MecanicosTable(this);
  late final $UsuariosTable usuarios = $UsuariosTable(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final $VehiculosTable vehiculos = $VehiculosTable(this);
  late final $OrdenesServicioTable ordenesServicio = $OrdenesServicioTable(
    this,
  );
  late final $TrabajosTable trabajos = $TrabajosTable(this);
  late final $RepuestosTable repuestos = $RepuestosTable(this);
  late final $RepuestosOrdenTable repuestosOrden = $RepuestosOrdenTable(this);
  late final $PagosTable pagos = $PagosTable(this);
  late final $MovimientosInventarioTable movimientosInventario =
      $MovimientosInventarioTable(this);
  late final $ConfiguracionTable configuracion = $ConfiguracionTable(this);
  late final UsuariosDao usuariosDao = UsuariosDao(this as BaseDatos);
  late final ClientesDao clientesDao = ClientesDao(this as BaseDatos);
  late final VehiculosDao vehiculosDao = VehiculosDao(this as BaseDatos);
  late final MecanicosDao mecanicosDao = MecanicosDao(this as BaseDatos);
  late final OrdenesDao ordenesDao = OrdenesDao(this as BaseDatos);
  late final TrabajosDao trabajosDao = TrabajosDao(this as BaseDatos);
  late final RepuestosDao repuestosDao = RepuestosDao(this as BaseDatos);
  late final RepuestosOrdenDao repuestosOrdenDao = RepuestosOrdenDao(
    this as BaseDatos,
  );
  late final PagosDao pagosDao = PagosDao(this as BaseDatos);
  late final ReportesDao reportesDao = ReportesDao(this as BaseDatos);
  late final ConfiguracionDao configuracionDao = ConfiguracionDao(
    this as BaseDatos,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    mecanicos,
    usuarios,
    clientes,
    vehiculos,
    ordenesServicio,
    trabajos,
    repuestos,
    repuestosOrden,
    pagos,
    movimientosInventario,
    configuracion,
  ];
}

typedef $$MecanicosTableCreateCompanionBuilder = MecanicosCompanion Function({
  Value<int> id,
  required String nombre,
  Value<String?> telefono,
  Value<String?> especialidad,
  Value<bool> activo,
  Value<DateTime> fechaIngreso,
});
typedef $$MecanicosTableUpdateCompanionBuilder = MecanicosCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String?> telefono,
  Value<String?> especialidad,
  Value<bool> activo,
  Value<DateTime> fechaIngreso,
});

final class $$MecanicosTableReferences
    extends BaseReferences<_$BaseDatos, $MecanicosTable, Mecanico> {
  $$MecanicosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UsuariosTable, List<Usuario>> _usuariosRefsTable(
    _$BaseDatos db,
  ) => MultiTypedResultKey.fromTable(
    db.usuarios,
    aliasName: 'mecanicos__id__usuarios__mecanico_id',
  );

  $$UsuariosTableProcessedTableManager get usuariosRefs {
    final manager = $$UsuariosTableTableManager(
      $_db,
      $_db.usuarios,
    ).filter((f) => f.mecanicoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_usuariosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrdenesServicioTable, List<OrdenServicio>>
  _ordenesServicioRefsTable(_$BaseDatos db) => MultiTypedResultKey.fromTable(
    db.ordenesServicio,
    aliasName: 'mecanicos__id__ordenes_servicio__mecanico_id',
  );

  $$OrdenesServicioTableProcessedTableManager get ordenesServicioRefs {
    final manager = $$OrdenesServicioTableTableManager(
      $_db,
      $_db.ordenesServicio,
    ).filter((f) => f.mecanicoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ordenesServicioRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TrabajosTable, List<Trabajo>> _trabajosRefsTable(
    _$BaseDatos db,
  ) => MultiTypedResultKey.fromTable(
    db.trabajos,
    aliasName: 'mecanicos__id__trabajos__mecanico_id',
  );

  $$TrabajosTableProcessedTableManager get trabajosRefs {
    final manager = $$TrabajosTableTableManager(
      $_db,
      $_db.trabajos,
    ).filter((f) => f.mecanicoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_trabajosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MecanicosTableFilterComposer
    extends Composer<_$BaseDatos, $MecanicosTable> {
  $$MecanicosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get especialidad => $composableBuilder(
    column: $table.especialidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaIngreso => $composableBuilder(
    column: $table.fechaIngreso,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> usuariosRefs(
    Expression<bool> Function($$UsuariosTableFilterComposer f) f,
  ) {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.mecanicoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableFilterComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ordenesServicioRefs(
    Expression<bool> Function($$OrdenesServicioTableFilterComposer f) f,
  ) {
    final $$OrdenesServicioTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ordenesServicio,
      getReferencedColumn: (t) => t.mecanicoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesServicioTableFilterComposer(
            $db: $db,
            $table: $db.ordenesServicio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> trabajosRefs(
    Expression<bool> Function($$TrabajosTableFilterComposer f) f,
  ) {
    final $$TrabajosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trabajos,
      getReferencedColumn: (t) => t.mecanicoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrabajosTableFilterComposer(
            $db: $db,
            $table: $db.trabajos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MecanicosTableOrderingComposer
    extends Composer<_$BaseDatos, $MecanicosTable> {
  $$MecanicosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get especialidad => $composableBuilder(
    column: $table.especialidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaIngreso => $composableBuilder(
    column: $table.fechaIngreso,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MecanicosTableAnnotationComposer
    extends Composer<_$BaseDatos, $MecanicosTable> {
  $$MecanicosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get especialidad => $composableBuilder(
    column: $table.especialidad,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaIngreso => $composableBuilder(
    column: $table.fechaIngreso,
    builder: (column) => column,
  );

  Expression<T> usuariosRefs<T extends Object>(
    Expression<T> Function($$UsuariosTableAnnotationComposer a) f,
  ) {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.mecanicoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableAnnotationComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ordenesServicioRefs<T extends Object>(
    Expression<T> Function($$OrdenesServicioTableAnnotationComposer a) f,
  ) {
    final $$OrdenesServicioTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ordenesServicio,
      getReferencedColumn: (t) => t.mecanicoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesServicioTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenesServicio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> trabajosRefs<T extends Object>(
    Expression<T> Function($$TrabajosTableAnnotationComposer a) f,
  ) {
    final $$TrabajosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trabajos,
      getReferencedColumn: (t) => t.mecanicoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrabajosTableAnnotationComposer(
            $db: $db,
            $table: $db.trabajos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MecanicosTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $MecanicosTable,
          Mecanico,
          $$MecanicosTableFilterComposer,
          $$MecanicosTableOrderingComposer,
          $$MecanicosTableAnnotationComposer,
          $$MecanicosTableCreateCompanionBuilder,
          $$MecanicosTableUpdateCompanionBuilder,
          (Mecanico, $$MecanicosTableReferences),
          Mecanico,
          PrefetchHooks Function({
            bool usuariosRefs,
            bool ordenesServicioRefs,
            bool trabajosRefs,
          })
        > {
  $$MecanicosTableTableManager(_$BaseDatos db, $MecanicosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MecanicosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MecanicosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MecanicosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> especialidad = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> fechaIngreso = const Value.absent(),
              }) => MecanicosCompanion(
                id: id,
                nombre: nombre,
                telefono: telefono,
                especialidad: especialidad,
                activo: activo,
                fechaIngreso: fechaIngreso,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String?> telefono = const Value.absent(),
                Value<String?> especialidad = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> fechaIngreso = const Value.absent(),
              }) => MecanicosCompanion.insert(
                id: id,
                nombre: nombre,
                telefono: telefono,
                especialidad: especialidad,
                activo: activo,
                fechaIngreso: fechaIngreso,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MecanicosTable, Mecanico>(table),
                  $$MecanicosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                usuariosRefs = false,
                ordenesServicioRefs = false,
                trabajosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (usuariosRefs) db.usuarios,
                    if (ordenesServicioRefs) db.ordenesServicio,
                    if (trabajosRefs) db.trabajos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (usuariosRefs)
                        await $_getPrefetchedDataByColumns<
                          Mecanico,
                          $MecanicosTable,
                          Usuario,
                          $UsuariosTable
                        >(
                          currentTable: table,
                          referencedTable: $$MecanicosTableReferences
                              ._usuariosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MecanicosTableReferences(
                                db,
                                table,
                                p0,
                              ).usuariosRefs,
                          currentColumn: 'id',
                          referencedColumn: 'mecanico_id',
                          typedResults: items,
                        ),
                      if (ordenesServicioRefs)
                        await $_getPrefetchedDataByColumns<
                          Mecanico,
                          $MecanicosTable,
                          OrdenServicio,
                          $OrdenesServicioTable
                        >(
                          currentTable: table,
                          referencedTable: $$MecanicosTableReferences
                              ._ordenesServicioRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MecanicosTableReferences(
                                db,
                                table,
                                p0,
                              ).ordenesServicioRefs,
                          currentColumn: 'id',
                          referencedColumn: 'mecanico_id',
                          typedResults: items,
                        ),
                      if (trabajosRefs)
                        await $_getPrefetchedDataByColumns<
                          Mecanico,
                          $MecanicosTable,
                          Trabajo,
                          $TrabajosTable
                        >(
                          currentTable: table,
                          referencedTable: $$MecanicosTableReferences
                              ._trabajosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MecanicosTableReferences(
                                db,
                                table,
                                p0,
                              ).trabajosRefs,
                          currentColumn: 'id',
                          referencedColumn: 'mecanico_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MecanicosTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $MecanicosTable,
      Mecanico,
      $$MecanicosTableFilterComposer,
      $$MecanicosTableOrderingComposer,
      $$MecanicosTableAnnotationComposer,
      $$MecanicosTableCreateCompanionBuilder,
      $$MecanicosTableUpdateCompanionBuilder,
      (Mecanico, $$MecanicosTableReferences),
      Mecanico,
      PrefetchHooks Function({
        bool usuariosRefs,
        bool ordenesServicioRefs,
        bool trabajosRefs,
      })
    >;
typedef $$UsuariosTableCreateCompanionBuilder = UsuariosCompanion Function({
  Value<int> id,
  required String nombreUsuario,
  required String nombrePersona,
  required RolUsuario rol,
  required String claveHash,
  required String sal,
  Value<bool> activo,
  Value<DateTime> creadoEn,
  Value<int?> mecanicoId,
});
typedef $$UsuariosTableUpdateCompanionBuilder = UsuariosCompanion Function({
  Value<int> id,
  Value<String> nombreUsuario,
  Value<String> nombrePersona,
  Value<RolUsuario> rol,
  Value<String> claveHash,
  Value<String> sal,
  Value<bool> activo,
  Value<DateTime> creadoEn,
  Value<int?> mecanicoId,
});

final class $$UsuariosTableReferences
    extends BaseReferences<_$BaseDatos, $UsuariosTable, Usuario> {
  $$UsuariosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MecanicosTable _mecanicoIdTable(_$BaseDatos db) =>
      db.mecanicos.createAlias('usuarios__mecanico_id__mecanicos__id');

  $$MecanicosTableProcessedTableManager? get mecanicoId {
    final $_column = $_itemColumn<int>('mecanico_id');
    if ($_column == null) return null;
    final manager = $$MecanicosTableTableManager(
      $_db,
      $_db.mecanicos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mecanicoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UsuariosTableFilterComposer
    extends Composer<_$BaseDatos, $UsuariosTable> {
  $$UsuariosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreUsuario => $composableBuilder(
    column: $table.nombreUsuario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombrePersona => $composableBuilder(
    column: $table.nombrePersona,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RolUsuario, RolUsuario, String> get rol =>
      $composableBuilder(
        column: $table.rol,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get claveHash => $composableBuilder(
    column: $table.claveHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sal => $composableBuilder(
    column: $table.sal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  $$MecanicosTableFilterComposer get mecanicoId {
    final $$MecanicosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mecanicoId,
      referencedTable: $db.mecanicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MecanicosTableFilterComposer(
            $db: $db,
            $table: $db.mecanicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsuariosTableOrderingComposer
    extends Composer<_$BaseDatos, $UsuariosTable> {
  $$UsuariosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreUsuario => $composableBuilder(
    column: $table.nombreUsuario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombrePersona => $composableBuilder(
    column: $table.nombrePersona,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rol => $composableBuilder(
    column: $table.rol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get claveHash => $composableBuilder(
    column: $table.claveHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sal => $composableBuilder(
    column: $table.sal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$MecanicosTableOrderingComposer get mecanicoId {
    final $$MecanicosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mecanicoId,
      referencedTable: $db.mecanicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MecanicosTableOrderingComposer(
            $db: $db,
            $table: $db.mecanicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsuariosTableAnnotationComposer
    extends Composer<_$BaseDatos, $UsuariosTable> {
  $$UsuariosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombreUsuario => $composableBuilder(
    column: $table.nombreUsuario,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombrePersona => $composableBuilder(
    column: $table.nombrePersona,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<RolUsuario, String> get rol =>
      $composableBuilder(column: $table.rol, builder: (column) => column);

  GeneratedColumn<String> get claveHash =>
      $composableBuilder(column: $table.claveHash, builder: (column) => column);

  GeneratedColumn<String> get sal =>
      $composableBuilder(column: $table.sal, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  $$MecanicosTableAnnotationComposer get mecanicoId {
    final $$MecanicosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mecanicoId,
      referencedTable: $db.mecanicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MecanicosTableAnnotationComposer(
            $db: $db,
            $table: $db.mecanicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsuariosTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $UsuariosTable,
          Usuario,
          $$UsuariosTableFilterComposer,
          $$UsuariosTableOrderingComposer,
          $$UsuariosTableAnnotationComposer,
          $$UsuariosTableCreateCompanionBuilder,
          $$UsuariosTableUpdateCompanionBuilder,
          (Usuario, $$UsuariosTableReferences),
          Usuario,
          PrefetchHooks Function({bool mecanicoId})
        > {
  $$UsuariosTableTableManager(_$BaseDatos db, $UsuariosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsuariosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsuariosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsuariosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombreUsuario = const Value.absent(),
                Value<String> nombrePersona = const Value.absent(),
                Value<RolUsuario> rol = const Value.absent(),
                Value<String> claveHash = const Value.absent(),
                Value<String> sal = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<int?> mecanicoId = const Value.absent(),
              }) => UsuariosCompanion(
                id: id,
                nombreUsuario: nombreUsuario,
                nombrePersona: nombrePersona,
                rol: rol,
                claveHash: claveHash,
                sal: sal,
                activo: activo,
                creadoEn: creadoEn,
                mecanicoId: mecanicoId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombreUsuario,
                required String nombrePersona,
                required RolUsuario rol,
                required String claveHash,
                required String sal,
                Value<bool> activo = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<int?> mecanicoId = const Value.absent(),
              }) => UsuariosCompanion.insert(
                id: id,
                nombreUsuario: nombreUsuario,
                nombrePersona: nombrePersona,
                rol: rol,
                claveHash: claveHash,
                sal: sal,
                activo: activo,
                creadoEn: creadoEn,
                mecanicoId: mecanicoId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsuariosTable, Usuario>(table),
                  $$UsuariosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mecanicoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (mecanicoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.mecanicoId,
                        referencedTable: $$UsuariosTableReferences
                            ._mecanicoIdTable(db),
                        referencedColumn: $$UsuariosTableReferences
                            ._mecanicoIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UsuariosTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $UsuariosTable,
      Usuario,
      $$UsuariosTableFilterComposer,
      $$UsuariosTableOrderingComposer,
      $$UsuariosTableAnnotationComposer,
      $$UsuariosTableCreateCompanionBuilder,
      $$UsuariosTableUpdateCompanionBuilder,
      (Usuario, $$UsuariosTableReferences),
      Usuario,
      PrefetchHooks Function({bool mecanicoId})
    >;
typedef $$ClientesTableCreateCompanionBuilder = ClientesCompanion Function({
  Value<int> id,
  required String nombre,
  required String telefono,
  Value<String?> direccion,
  Value<bool> activo,
  Value<DateTime> fechaRegistro,
});
typedef $$ClientesTableUpdateCompanionBuilder = ClientesCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String> telefono,
  Value<String?> direccion,
  Value<bool> activo,
  Value<DateTime> fechaRegistro,
});

final class $$ClientesTableReferences
    extends BaseReferences<_$BaseDatos, $ClientesTable, Cliente> {
  $$ClientesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VehiculosTable, List<Vehiculo>>
  _vehiculosRefsTable(_$BaseDatos db) => MultiTypedResultKey.fromTable(
    db.vehiculos,
    aliasName: 'clientes__id__vehiculos__cliente_id',
  );

  $$VehiculosTableProcessedTableManager get vehiculosRefs {
    final manager = $$VehiculosTableTableManager(
      $_db,
      $_db.vehiculos,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_vehiculosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrdenesServicioTable, List<OrdenServicio>>
  _ordenesServicioRefsTable(_$BaseDatos db) => MultiTypedResultKey.fromTable(
    db.ordenesServicio,
    aliasName: 'clientes__id__ordenes_servicio__cliente_id',
  );

  $$OrdenesServicioTableProcessedTableManager get ordenesServicioRefs {
    final manager = $$OrdenesServicioTableTableManager(
      $_db,
      $_db.ordenesServicio,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ordenesServicioRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClientesTableFilterComposer
    extends Composer<_$BaseDatos, $ClientesTable> {
  $$ClientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaRegistro => $composableBuilder(
    column: $table.fechaRegistro,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> vehiculosRefs(
    Expression<bool> Function($$VehiculosTableFilterComposer f) f,
  ) {
    final $$VehiculosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vehiculos,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculosTableFilterComposer(
            $db: $db,
            $table: $db.vehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ordenesServicioRefs(
    Expression<bool> Function($$OrdenesServicioTableFilterComposer f) f,
  ) {
    final $$OrdenesServicioTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ordenesServicio,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesServicioTableFilterComposer(
            $db: $db,
            $table: $db.ordenesServicio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableOrderingComposer
    extends Composer<_$BaseDatos, $ClientesTable> {
  $$ClientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaRegistro => $composableBuilder(
    column: $table.fechaRegistro,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientesTableAnnotationComposer
    extends Composer<_$BaseDatos, $ClientesTable> {
  $$ClientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaRegistro => $composableBuilder(
    column: $table.fechaRegistro,
    builder: (column) => column,
  );

  Expression<T> vehiculosRefs<T extends Object>(
    Expression<T> Function($$VehiculosTableAnnotationComposer a) f,
  ) {
    final $$VehiculosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vehiculos,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculosTableAnnotationComposer(
            $db: $db,
            $table: $db.vehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ordenesServicioRefs<T extends Object>(
    Expression<T> Function($$OrdenesServicioTableAnnotationComposer a) f,
  ) {
    final $$OrdenesServicioTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ordenesServicio,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesServicioTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenesServicio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $ClientesTable,
          Cliente,
          $$ClientesTableFilterComposer,
          $$ClientesTableOrderingComposer,
          $$ClientesTableAnnotationComposer,
          $$ClientesTableCreateCompanionBuilder,
          $$ClientesTableUpdateCompanionBuilder,
          (Cliente, $$ClientesTableReferences),
          Cliente,
          PrefetchHooks Function({bool vehiculosRefs, bool ordenesServicioRefs})
        > {
  $$ClientesTableTableManager(_$BaseDatos db, $ClientesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String?> direccion = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> fechaRegistro = const Value.absent(),
              }) => ClientesCompanion(
                id: id,
                nombre: nombre,
                telefono: telefono,
                direccion: direccion,
                activo: activo,
                fechaRegistro: fechaRegistro,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String telefono,
                Value<String?> direccion = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> fechaRegistro = const Value.absent(),
              }) => ClientesCompanion.insert(
                id: id,
                nombre: nombre,
                telefono: telefono,
                direccion: direccion,
                activo: activo,
                fechaRegistro: fechaRegistro,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ClientesTable, Cliente>(table),
                  $$ClientesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({vehiculosRefs = false, ordenesServicioRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (vehiculosRefs) db.vehiculos,
                    if (ordenesServicioRefs) db.ordenesServicio,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (vehiculosRefs)
                        await $_getPrefetchedDataByColumns<
                          Cliente,
                          $ClientesTable,
                          Vehiculo,
                          $VehiculosTable
                        >(
                          currentTable: table,
                          referencedTable: $$ClientesTableReferences
                              ._vehiculosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientesTableReferences(
                                db,
                                table,
                                p0,
                              ).vehiculosRefs,
                          currentColumn: 'id',
                          referencedColumn: 'cliente_id',
                          typedResults: items,
                        ),
                      if (ordenesServicioRefs)
                        await $_getPrefetchedDataByColumns<
                          Cliente,
                          $ClientesTable,
                          OrdenServicio,
                          $OrdenesServicioTable
                        >(
                          currentTable: table,
                          referencedTable: $$ClientesTableReferences
                              ._ordenesServicioRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientesTableReferences(
                                db,
                                table,
                                p0,
                              ).ordenesServicioRefs,
                          currentColumn: 'id',
                          referencedColumn: 'cliente_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ClientesTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $ClientesTable,
      Cliente,
      $$ClientesTableFilterComposer,
      $$ClientesTableOrderingComposer,
      $$ClientesTableAnnotationComposer,
      $$ClientesTableCreateCompanionBuilder,
      $$ClientesTableUpdateCompanionBuilder,
      (Cliente, $$ClientesTableReferences),
      Cliente,
      PrefetchHooks Function({bool vehiculosRefs, bool ordenesServicioRefs})
    >;
typedef $$VehiculosTableCreateCompanionBuilder = VehiculosCompanion Function({
  Value<int> id,
  required int clienteId,
  required String matricula,
  required String marca,
  required String modelo,
  required int anio,
  Value<int> kilometraje,
  Value<bool> activo,
  Value<DateTime> creadoEn,
});
typedef $$VehiculosTableUpdateCompanionBuilder = VehiculosCompanion Function({
  Value<int> id,
  Value<int> clienteId,
  Value<String> matricula,
  Value<String> marca,
  Value<String> modelo,
  Value<int> anio,
  Value<int> kilometraje,
  Value<bool> activo,
  Value<DateTime> creadoEn,
});

final class $$VehiculosTableReferences
    extends BaseReferences<_$BaseDatos, $VehiculosTable, Vehiculo> {
  $$VehiculosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientesTable _clienteIdTable(_$BaseDatos db) =>
      db.clientes.createAlias('vehiculos__cliente_id__clientes__id');

  $$ClientesTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<int>('cliente_id')!;

    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrdenesServicioTable, List<OrdenServicio>>
  _ordenesServicioRefsTable(_$BaseDatos db) => MultiTypedResultKey.fromTable(
    db.ordenesServicio,
    aliasName: 'vehiculos__id__ordenes_servicio__vehiculo_id',
  );

  $$OrdenesServicioTableProcessedTableManager get ordenesServicioRefs {
    final manager = $$OrdenesServicioTableTableManager(
      $_db,
      $_db.ordenesServicio,
    ).filter((f) => f.vehiculoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ordenesServicioRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VehiculosTableFilterComposer
    extends Composer<_$BaseDatos, $VehiculosTable> {
  $$VehiculosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get matricula => $composableBuilder(
    column: $table.matricula,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelo => $composableBuilder(
    column: $table.modelo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anio => $composableBuilder(
    column: $table.anio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kilometraje => $composableBuilder(
    column: $table.kilometraje,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ordenesServicioRefs(
    Expression<bool> Function($$OrdenesServicioTableFilterComposer f) f,
  ) {
    final $$OrdenesServicioTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ordenesServicio,
      getReferencedColumn: (t) => t.vehiculoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesServicioTableFilterComposer(
            $db: $db,
            $table: $db.ordenesServicio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiculosTableOrderingComposer
    extends Composer<_$BaseDatos, $VehiculosTable> {
  $$VehiculosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matricula => $composableBuilder(
    column: $table.matricula,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelo => $composableBuilder(
    column: $table.modelo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anio => $composableBuilder(
    column: $table.anio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kilometraje => $composableBuilder(
    column: $table.kilometraje,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VehiculosTableAnnotationComposer
    extends Composer<_$BaseDatos, $VehiculosTable> {
  $$VehiculosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get matricula =>
      $composableBuilder(column: $table.matricula, builder: (column) => column);

  GeneratedColumn<String> get marca =>
      $composableBuilder(column: $table.marca, builder: (column) => column);

  GeneratedColumn<String> get modelo =>
      $composableBuilder(column: $table.modelo, builder: (column) => column);

  GeneratedColumn<int> get anio =>
      $composableBuilder(column: $table.anio, builder: (column) => column);

  GeneratedColumn<int> get kilometraje => $composableBuilder(
    column: $table.kilometraje,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ordenesServicioRefs<T extends Object>(
    Expression<T> Function($$OrdenesServicioTableAnnotationComposer a) f,
  ) {
    final $$OrdenesServicioTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ordenesServicio,
      getReferencedColumn: (t) => t.vehiculoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesServicioTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenesServicio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiculosTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $VehiculosTable,
          Vehiculo,
          $$VehiculosTableFilterComposer,
          $$VehiculosTableOrderingComposer,
          $$VehiculosTableAnnotationComposer,
          $$VehiculosTableCreateCompanionBuilder,
          $$VehiculosTableUpdateCompanionBuilder,
          (Vehiculo, $$VehiculosTableReferences),
          Vehiculo,
          PrefetchHooks Function({bool clienteId, bool ordenesServicioRefs})
        > {
  $$VehiculosTableTableManager(_$BaseDatos db, $VehiculosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiculosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiculosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiculosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> clienteId = const Value.absent(),
                Value<String> matricula = const Value.absent(),
                Value<String> marca = const Value.absent(),
                Value<String> modelo = const Value.absent(),
                Value<int> anio = const Value.absent(),
                Value<int> kilometraje = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
              }) => VehiculosCompanion(
                id: id,
                clienteId: clienteId,
                matricula: matricula,
                marca: marca,
                modelo: modelo,
                anio: anio,
                kilometraje: kilometraje,
                activo: activo,
                creadoEn: creadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int clienteId,
                required String matricula,
                required String marca,
                required String modelo,
                required int anio,
                Value<int> kilometraje = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
              }) => VehiculosCompanion.insert(
                id: id,
                clienteId: clienteId,
                matricula: matricula,
                marca: marca,
                modelo: modelo,
                anio: anio,
                kilometraje: kilometraje,
                activo: activo,
                creadoEn: creadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VehiculosTable, Vehiculo>(table),
                  $$VehiculosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({clienteId = false, ordenesServicioRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ordenesServicioRefs) db.ordenesServicio,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (clienteId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.clienteId,
                            referencedTable: $$VehiculosTableReferences
                                ._clienteIdTable(db),
                            referencedColumn: $$VehiculosTableReferences
                                ._clienteIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ordenesServicioRefs)
                        await $_getPrefetchedDataByColumns<
                          Vehiculo,
                          $VehiculosTable,
                          OrdenServicio,
                          $OrdenesServicioTable
                        >(
                          currentTable: table,
                          referencedTable: $$VehiculosTableReferences
                              ._ordenesServicioRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiculosTableReferences(
                                db,
                                table,
                                p0,
                              ).ordenesServicioRefs,
                          currentColumn: 'id',
                          referencedColumn: 'vehiculo_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VehiculosTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $VehiculosTable,
      Vehiculo,
      $$VehiculosTableFilterComposer,
      $$VehiculosTableOrderingComposer,
      $$VehiculosTableAnnotationComposer,
      $$VehiculosTableCreateCompanionBuilder,
      $$VehiculosTableUpdateCompanionBuilder,
      (Vehiculo, $$VehiculosTableReferences),
      Vehiculo,
      PrefetchHooks Function({bool clienteId, bool ordenesServicioRefs})
    >;
typedef $$OrdenesServicioTableCreateCompanionBuilder =
    OrdenesServicioCompanion Function({
      Value<int> id,
      required String numero,
      required int clienteId,
      required int vehiculoId,
      Value<int?> mecanicoId,
      required DateTime fechaEntrada,
      required String problema,
      required EstadoOrden estado,
      Value<int> kilometrajeEntrada,
      Value<String?> notas,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<DateTime?> fechaCierre,
    });
typedef $$OrdenesServicioTableUpdateCompanionBuilder =
    OrdenesServicioCompanion Function({
      Value<int> id,
      Value<String> numero,
      Value<int> clienteId,
      Value<int> vehiculoId,
      Value<int?> mecanicoId,
      Value<DateTime> fechaEntrada,
      Value<String> problema,
      Value<EstadoOrden> estado,
      Value<int> kilometrajeEntrada,
      Value<String?> notas,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<DateTime?> fechaCierre,
    });

final class $$OrdenesServicioTableReferences
    extends BaseReferences<_$BaseDatos, $OrdenesServicioTable, OrdenServicio> {
  $$OrdenesServicioTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ClientesTable _clienteIdTable(_$BaseDatos db) =>
      db.clientes.createAlias('ordenes_servicio__cliente_id__clientes__id');

  $$ClientesTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<int>('cliente_id')!;

    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $VehiculosTable _vehiculoIdTable(_$BaseDatos db) =>
      db.vehiculos.createAlias('ordenes_servicio__vehiculo_id__vehiculos__id');

  $$VehiculosTableProcessedTableManager get vehiculoId {
    final $_column = $_itemColumn<int>('vehiculo_id')!;

    final manager = $$VehiculosTableTableManager(
      $_db,
      $_db.vehiculos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehiculoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MecanicosTable _mecanicoIdTable(_$BaseDatos db) =>
      db.mecanicos.createAlias('ordenes_servicio__mecanico_id__mecanicos__id');

  $$MecanicosTableProcessedTableManager? get mecanicoId {
    final $_column = $_itemColumn<int>('mecanico_id');
    if ($_column == null) return null;
    final manager = $$MecanicosTableTableManager(
      $_db,
      $_db.mecanicos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mecanicoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TrabajosTable, List<Trabajo>> _trabajosRefsTable(
    _$BaseDatos db,
  ) => MultiTypedResultKey.fromTable(
    db.trabajos,
    aliasName: 'ordenes_servicio__id__trabajos__orden_id',
  );

  $$TrabajosTableProcessedTableManager get trabajosRefs {
    final manager = $$TrabajosTableTableManager(
      $_db,
      $_db.trabajos,
    ).filter((f) => f.ordenId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_trabajosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RepuestosOrdenTable, List<RepuestoOrden>>
  _repuestosOrdenRefsTable(_$BaseDatos db) => MultiTypedResultKey.fromTable(
    db.repuestosOrden,
    aliasName: 'ordenes_servicio__id__repuestos_orden__orden_id',
  );

  $$RepuestosOrdenTableProcessedTableManager get repuestosOrdenRefs {
    final manager = $$RepuestosOrdenTableTableManager(
      $_db,
      $_db.repuestosOrden,
    ).filter((f) => f.ordenId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_repuestosOrdenRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PagosTable, List<Pago>> _pagosRefsTable(
    _$BaseDatos db,
  ) => MultiTypedResultKey.fromTable(
    db.pagos,
    aliasName: 'ordenes_servicio__id__pagos__orden_id',
  );

  $$PagosTableProcessedTableManager get pagosRefs {
    final manager = $$PagosTableTableManager(
      $_db,
      $_db.pagos,
    ).filter((f) => f.ordenId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pagosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MovimientosInventarioTable,
    List<MovimientoInventario>
  >
  _movimientosInventarioRefsTable(_$BaseDatos db) =>
      MultiTypedResultKey.fromTable(
        db.movimientosInventario,
        aliasName: 'ordenes_servicio__id__movimientos_inventario__orden_id',
      );

  $$MovimientosInventarioTableProcessedTableManager
  get movimientosInventarioRefs {
    final manager = $$MovimientosInventarioTableTableManager(
      $_db,
      $_db.movimientosInventario,
    ).filter((f) => f.ordenId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _movimientosInventarioRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrdenesServicioTableFilterComposer
    extends Composer<_$BaseDatos, $OrdenesServicioTable> {
  $$OrdenesServicioTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaEntrada => $composableBuilder(
    column: $table.fechaEntrada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get problema => $composableBuilder(
    column: $table.problema,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EstadoOrden, EstadoOrden, String> get estado =>
      $composableBuilder(
        column: $table.estado,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get kilometrajeEntrada => $composableBuilder(
    column: $table.kilometrajeEntrada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCierre => $composableBuilder(
    column: $table.fechaCierre,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VehiculosTableFilterComposer get vehiculoId {
    final $$VehiculosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehiculoId,
      referencedTable: $db.vehiculos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculosTableFilterComposer(
            $db: $db,
            $table: $db.vehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MecanicosTableFilterComposer get mecanicoId {
    final $$MecanicosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mecanicoId,
      referencedTable: $db.mecanicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MecanicosTableFilterComposer(
            $db: $db,
            $table: $db.mecanicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> trabajosRefs(
    Expression<bool> Function($$TrabajosTableFilterComposer f) f,
  ) {
    final $$TrabajosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trabajos,
      getReferencedColumn: (t) => t.ordenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrabajosTableFilterComposer(
            $db: $db,
            $table: $db.trabajos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> repuestosOrdenRefs(
    Expression<bool> Function($$RepuestosOrdenTableFilterComposer f) f,
  ) {
    final $$RepuestosOrdenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repuestosOrden,
      getReferencedColumn: (t) => t.ordenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepuestosOrdenTableFilterComposer(
            $db: $db,
            $table: $db.repuestosOrden,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pagosRefs(
    Expression<bool> Function($$PagosTableFilterComposer f) f,
  ) {
    final $$PagosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pagos,
      getReferencedColumn: (t) => t.ordenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagosTableFilterComposer(
            $db: $db,
            $table: $db.pagos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> movimientosInventarioRefs(
    Expression<bool> Function($$MovimientosInventarioTableFilterComposer f) f,
  ) {
    final $$MovimientosInventarioTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.movimientosInventario,
          getReferencedColumn: (t) => t.ordenId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MovimientosInventarioTableFilterComposer(
                $db: $db,
                $table: $db.movimientosInventario,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$OrdenesServicioTableOrderingComposer
    extends Composer<_$BaseDatos, $OrdenesServicioTable> {
  $$OrdenesServicioTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaEntrada => $composableBuilder(
    column: $table.fechaEntrada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get problema => $composableBuilder(
    column: $table.problema,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kilometrajeEntrada => $composableBuilder(
    column: $table.kilometrajeEntrada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCierre => $composableBuilder(
    column: $table.fechaCierre,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VehiculosTableOrderingComposer get vehiculoId {
    final $$VehiculosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehiculoId,
      referencedTable: $db.vehiculos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculosTableOrderingComposer(
            $db: $db,
            $table: $db.vehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MecanicosTableOrderingComposer get mecanicoId {
    final $$MecanicosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mecanicoId,
      referencedTable: $db.mecanicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MecanicosTableOrderingComposer(
            $db: $db,
            $table: $db.mecanicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrdenesServicioTableAnnotationComposer
    extends Composer<_$BaseDatos, $OrdenesServicioTable> {
  $$OrdenesServicioTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaEntrada => $composableBuilder(
    column: $table.fechaEntrada,
    builder: (column) => column,
  );

  GeneratedColumn<String> get problema =>
      $composableBuilder(column: $table.problema, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EstadoOrden, String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<int> get kilometrajeEntrada => $composableBuilder(
    column: $table.kilometrajeEntrada,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaCierre => $composableBuilder(
    column: $table.fechaCierre,
    builder: (column) => column,
  );

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VehiculosTableAnnotationComposer get vehiculoId {
    final $$VehiculosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehiculoId,
      referencedTable: $db.vehiculos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculosTableAnnotationComposer(
            $db: $db,
            $table: $db.vehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MecanicosTableAnnotationComposer get mecanicoId {
    final $$MecanicosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mecanicoId,
      referencedTable: $db.mecanicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MecanicosTableAnnotationComposer(
            $db: $db,
            $table: $db.mecanicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> trabajosRefs<T extends Object>(
    Expression<T> Function($$TrabajosTableAnnotationComposer a) f,
  ) {
    final $$TrabajosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trabajos,
      getReferencedColumn: (t) => t.ordenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrabajosTableAnnotationComposer(
            $db: $db,
            $table: $db.trabajos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> repuestosOrdenRefs<T extends Object>(
    Expression<T> Function($$RepuestosOrdenTableAnnotationComposer a) f,
  ) {
    final $$RepuestosOrdenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repuestosOrden,
      getReferencedColumn: (t) => t.ordenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepuestosOrdenTableAnnotationComposer(
            $db: $db,
            $table: $db.repuestosOrden,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pagosRefs<T extends Object>(
    Expression<T> Function($$PagosTableAnnotationComposer a) f,
  ) {
    final $$PagosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pagos,
      getReferencedColumn: (t) => t.ordenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagosTableAnnotationComposer(
            $db: $db,
            $table: $db.pagos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> movimientosInventarioRefs<T extends Object>(
    Expression<T> Function($$MovimientosInventarioTableAnnotationComposer a) f,
  ) {
    final $$MovimientosInventarioTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.movimientosInventario,
          getReferencedColumn: (t) => t.ordenId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MovimientosInventarioTableAnnotationComposer(
                $db: $db,
                $table: $db.movimientosInventario,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$OrdenesServicioTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $OrdenesServicioTable,
          OrdenServicio,
          $$OrdenesServicioTableFilterComposer,
          $$OrdenesServicioTableOrderingComposer,
          $$OrdenesServicioTableAnnotationComposer,
          $$OrdenesServicioTableCreateCompanionBuilder,
          $$OrdenesServicioTableUpdateCompanionBuilder,
          (OrdenServicio, $$OrdenesServicioTableReferences),
          OrdenServicio,
          PrefetchHooks Function({
            bool clienteId,
            bool vehiculoId,
            bool mecanicoId,
            bool trabajosRefs,
            bool repuestosOrdenRefs,
            bool pagosRefs,
            bool movimientosInventarioRefs,
          })
        > {
  $$OrdenesServicioTableTableManager(
    _$BaseDatos db,
    $OrdenesServicioTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdenesServicioTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdenesServicioTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdenesServicioTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> numero = const Value.absent(),
                Value<int> clienteId = const Value.absent(),
                Value<int> vehiculoId = const Value.absent(),
                Value<int?> mecanicoId = const Value.absent(),
                Value<DateTime> fechaEntrada = const Value.absent(),
                Value<String> problema = const Value.absent(),
                Value<EstadoOrden> estado = const Value.absent(),
                Value<int> kilometrajeEntrada = const Value.absent(),
                Value<String?> notas = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<DateTime?> fechaCierre = const Value.absent(),
              }) => OrdenesServicioCompanion(
                id: id,
                numero: numero,
                clienteId: clienteId,
                vehiculoId: vehiculoId,
                mecanicoId: mecanicoId,
                fechaEntrada: fechaEntrada,
                problema: problema,
                estado: estado,
                kilometrajeEntrada: kilometrajeEntrada,
                notas: notas,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                fechaCierre: fechaCierre,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String numero,
                required int clienteId,
                required int vehiculoId,
                Value<int?> mecanicoId = const Value.absent(),
                required DateTime fechaEntrada,
                required String problema,
                required EstadoOrden estado,
                Value<int> kilometrajeEntrada = const Value.absent(),
                Value<String?> notas = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<DateTime?> fechaCierre = const Value.absent(),
              }) => OrdenesServicioCompanion.insert(
                id: id,
                numero: numero,
                clienteId: clienteId,
                vehiculoId: vehiculoId,
                mecanicoId: mecanicoId,
                fechaEntrada: fechaEntrada,
                problema: problema,
                estado: estado,
                kilometrajeEntrada: kilometrajeEntrada,
                notas: notas,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                fechaCierre: fechaCierre,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrdenesServicioTable, OrdenServicio>(table),
                  $$OrdenesServicioTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                clienteId = false,
                vehiculoId = false,
                mecanicoId = false,
                trabajosRefs = false,
                repuestosOrdenRefs = false,
                pagosRefs = false,
                movimientosInventarioRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (trabajosRefs) db.trabajos,
                    if (repuestosOrdenRefs) db.repuestosOrden,
                    if (pagosRefs) db.pagos,
                    if (movimientosInventarioRefs) db.movimientosInventario,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (clienteId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.clienteId,
                            referencedTable: $$OrdenesServicioTableReferences
                                ._clienteIdTable(db),
                            referencedColumn: $$OrdenesServicioTableReferences
                                ._clienteIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (vehiculoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.vehiculoId,
                            referencedTable: $$OrdenesServicioTableReferences
                                ._vehiculoIdTable(db),
                            referencedColumn: $$OrdenesServicioTableReferences
                                ._vehiculoIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (mecanicoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.mecanicoId,
                            referencedTable: $$OrdenesServicioTableReferences
                                ._mecanicoIdTable(db),
                            referencedColumn: $$OrdenesServicioTableReferences
                                ._mecanicoIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (trabajosRefs)
                        await $_getPrefetchedDataByColumns<
                          OrdenServicio,
                          $OrdenesServicioTable,
                          Trabajo,
                          $TrabajosTable
                        >(
                          currentTable: table,
                          referencedTable: $$OrdenesServicioTableReferences
                              ._trabajosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdenesServicioTableReferences(
                                db,
                                table,
                                p0,
                              ).trabajosRefs,
                          currentColumn: 'id',
                          referencedColumn: 'orden_id',
                          typedResults: items,
                        ),
                      if (repuestosOrdenRefs)
                        await $_getPrefetchedDataByColumns<
                          OrdenServicio,
                          $OrdenesServicioTable,
                          RepuestoOrden,
                          $RepuestosOrdenTable
                        >(
                          currentTable: table,
                          referencedTable: $$OrdenesServicioTableReferences
                              ._repuestosOrdenRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdenesServicioTableReferences(
                                db,
                                table,
                                p0,
                              ).repuestosOrdenRefs,
                          currentColumn: 'id',
                          referencedColumn: 'orden_id',
                          typedResults: items,
                        ),
                      if (pagosRefs)
                        await $_getPrefetchedDataByColumns<
                          OrdenServicio,
                          $OrdenesServicioTable,
                          Pago,
                          $PagosTable
                        >(
                          currentTable: table,
                          referencedTable: $$OrdenesServicioTableReferences
                              ._pagosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdenesServicioTableReferences(
                                db,
                                table,
                                p0,
                              ).pagosRefs,
                          currentColumn: 'id',
                          referencedColumn: 'orden_id',
                          typedResults: items,
                        ),
                      if (movimientosInventarioRefs)
                        await $_getPrefetchedDataByColumns<
                          OrdenServicio,
                          $OrdenesServicioTable,
                          MovimientoInventario,
                          $MovimientosInventarioTable
                        >(
                          currentTable: table,
                          referencedTable: $$OrdenesServicioTableReferences
                              ._movimientosInventarioRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdenesServicioTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosInventarioRefs,
                          currentColumn: 'id',
                          referencedColumn: 'orden_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrdenesServicioTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $OrdenesServicioTable,
      OrdenServicio,
      $$OrdenesServicioTableFilterComposer,
      $$OrdenesServicioTableOrderingComposer,
      $$OrdenesServicioTableAnnotationComposer,
      $$OrdenesServicioTableCreateCompanionBuilder,
      $$OrdenesServicioTableUpdateCompanionBuilder,
      (OrdenServicio, $$OrdenesServicioTableReferences),
      OrdenServicio,
      PrefetchHooks Function({
        bool clienteId,
        bool vehiculoId,
        bool mecanicoId,
        bool trabajosRefs,
        bool repuestosOrdenRefs,
        bool pagosRefs,
        bool movimientosInventarioRefs,
      })
    >;
typedef $$TrabajosTableCreateCompanionBuilder = TrabajosCompanion Function({
  Value<int> id,
  required int ordenId,
  required String descripcion,
  required double precioManoObra,
  Value<int?> mecanicoId,
  Value<DateTime> fecha,
});
typedef $$TrabajosTableUpdateCompanionBuilder = TrabajosCompanion Function({
  Value<int> id,
  Value<int> ordenId,
  Value<String> descripcion,
  Value<double> precioManoObra,
  Value<int?> mecanicoId,
  Value<DateTime> fecha,
});

final class $$TrabajosTableReferences
    extends BaseReferences<_$BaseDatos, $TrabajosTable, Trabajo> {
  $$TrabajosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdenesServicioTable _ordenIdTable(_$BaseDatos db) => db
      .ordenesServicio
      .createAlias('trabajos__orden_id__ordenes_servicio__id');

  $$OrdenesServicioTableProcessedTableManager get ordenId {
    final $_column = $_itemColumn<int>('orden_id')!;

    final manager = $$OrdenesServicioTableTableManager(
      $_db,
      $_db.ordenesServicio,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MecanicosTable _mecanicoIdTable(_$BaseDatos db) =>
      db.mecanicos.createAlias('trabajos__mecanico_id__mecanicos__id');

  $$MecanicosTableProcessedTableManager? get mecanicoId {
    final $_column = $_itemColumn<int>('mecanico_id');
    if ($_column == null) return null;
    final manager = $$MecanicosTableTableManager(
      $_db,
      $_db.mecanicos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mecanicoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrabajosTableFilterComposer
    extends Composer<_$BaseDatos, $TrabajosTable> {
  $$TrabajosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioManoObra => $composableBuilder(
    column: $table.precioManoObra,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdenesServicioTableFilterComposer get ordenId {
    final $$OrdenesServicioTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesServicio,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesServicioTableFilterComposer(
            $db: $db,
            $table: $db.ordenesServicio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MecanicosTableFilterComposer get mecanicoId {
    final $$MecanicosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mecanicoId,
      referencedTable: $db.mecanicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MecanicosTableFilterComposer(
            $db: $db,
            $table: $db.mecanicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrabajosTableOrderingComposer
    extends Composer<_$BaseDatos, $TrabajosTable> {
  $$TrabajosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioManoObra => $composableBuilder(
    column: $table.precioManoObra,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdenesServicioTableOrderingComposer get ordenId {
    final $$OrdenesServicioTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesServicio,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesServicioTableOrderingComposer(
            $db: $db,
            $table: $db.ordenesServicio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MecanicosTableOrderingComposer get mecanicoId {
    final $$MecanicosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mecanicoId,
      referencedTable: $db.mecanicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MecanicosTableOrderingComposer(
            $db: $db,
            $table: $db.mecanicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrabajosTableAnnotationComposer
    extends Composer<_$BaseDatos, $TrabajosTable> {
  $$TrabajosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<double> get precioManoObra => $composableBuilder(
    column: $table.precioManoObra,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  $$OrdenesServicioTableAnnotationComposer get ordenId {
    final $$OrdenesServicioTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesServicio,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesServicioTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenesServicio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MecanicosTableAnnotationComposer get mecanicoId {
    final $$MecanicosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mecanicoId,
      referencedTable: $db.mecanicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MecanicosTableAnnotationComposer(
            $db: $db,
            $table: $db.mecanicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrabajosTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $TrabajosTable,
          Trabajo,
          $$TrabajosTableFilterComposer,
          $$TrabajosTableOrderingComposer,
          $$TrabajosTableAnnotationComposer,
          $$TrabajosTableCreateCompanionBuilder,
          $$TrabajosTableUpdateCompanionBuilder,
          (Trabajo, $$TrabajosTableReferences),
          Trabajo,
          PrefetchHooks Function({bool ordenId, bool mecanicoId})
        > {
  $$TrabajosTableTableManager(_$BaseDatos db, $TrabajosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrabajosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrabajosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrabajosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ordenId = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<double> precioManoObra = const Value.absent(),
                Value<int?> mecanicoId = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
              }) => TrabajosCompanion(
                id: id,
                ordenId: ordenId,
                descripcion: descripcion,
                precioManoObra: precioManoObra,
                mecanicoId: mecanicoId,
                fecha: fecha,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ordenId,
                required String descripcion,
                required double precioManoObra,
                Value<int?> mecanicoId = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
              }) => TrabajosCompanion.insert(
                id: id,
                ordenId: ordenId,
                descripcion: descripcion,
                precioManoObra: precioManoObra,
                mecanicoId: mecanicoId,
                fecha: fecha,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TrabajosTable, Trabajo>(table),
                  $$TrabajosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordenId = false, mecanicoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ordenId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ordenId,
                        referencedTable: $$TrabajosTableReferences
                            ._ordenIdTable(db),
                        referencedColumn: $$TrabajosTableReferences
                            ._ordenIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (mecanicoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.mecanicoId,
                        referencedTable: $$TrabajosTableReferences
                            ._mecanicoIdTable(db),
                        referencedColumn: $$TrabajosTableReferences
                            ._mecanicoIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TrabajosTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $TrabajosTable,
      Trabajo,
      $$TrabajosTableFilterComposer,
      $$TrabajosTableOrderingComposer,
      $$TrabajosTableAnnotationComposer,
      $$TrabajosTableCreateCompanionBuilder,
      $$TrabajosTableUpdateCompanionBuilder,
      (Trabajo, $$TrabajosTableReferences),
      Trabajo,
      PrefetchHooks Function({bool ordenId, bool mecanicoId})
    >;
typedef $$RepuestosTableCreateCompanionBuilder = RepuestosCompanion Function({
  Value<int> id,
  required String nombre,
  required String codigo,
  required double precioVenta,
  Value<int> existencias,
  Value<int> umbral,
  Value<bool> activo,
});
typedef $$RepuestosTableUpdateCompanionBuilder = RepuestosCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String> codigo,
  Value<double> precioVenta,
  Value<int> existencias,
  Value<int> umbral,
  Value<bool> activo,
});

final class $$RepuestosTableReferences
    extends BaseReferences<_$BaseDatos, $RepuestosTable, Repuesto> {
  $$RepuestosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RepuestosOrdenTable, List<RepuestoOrden>>
  _repuestosOrdenRefsTable(_$BaseDatos db) => MultiTypedResultKey.fromTable(
    db.repuestosOrden,
    aliasName: 'repuestos__id__repuestos_orden__repuesto_id',
  );

  $$RepuestosOrdenTableProcessedTableManager get repuestosOrdenRefs {
    final manager = $$RepuestosOrdenTableTableManager(
      $_db,
      $_db.repuestosOrden,
    ).filter((f) => f.repuestoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_repuestosOrdenRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MovimientosInventarioTable,
    List<MovimientoInventario>
  >
  _movimientosInventarioRefsTable(_$BaseDatos db) =>
      MultiTypedResultKey.fromTable(
        db.movimientosInventario,
        aliasName: 'repuestos__id__movimientos_inventario__repuesto_id',
      );

  $$MovimientosInventarioTableProcessedTableManager
  get movimientosInventarioRefs {
    final manager = $$MovimientosInventarioTableTableManager(
      $_db,
      $_db.movimientosInventario,
    ).filter((f) => f.repuestoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _movimientosInventarioRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RepuestosTableFilterComposer
    extends Composer<_$BaseDatos, $RepuestosTable> {
  $$RepuestosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioVenta => $composableBuilder(
    column: $table.precioVenta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get existencias => $composableBuilder(
    column: $table.existencias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get umbral => $composableBuilder(
    column: $table.umbral,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> repuestosOrdenRefs(
    Expression<bool> Function($$RepuestosOrdenTableFilterComposer f) f,
  ) {
    final $$RepuestosOrdenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repuestosOrden,
      getReferencedColumn: (t) => t.repuestoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepuestosOrdenTableFilterComposer(
            $db: $db,
            $table: $db.repuestosOrden,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> movimientosInventarioRefs(
    Expression<bool> Function($$MovimientosInventarioTableFilterComposer f) f,
  ) {
    final $$MovimientosInventarioTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.movimientosInventario,
          getReferencedColumn: (t) => t.repuestoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MovimientosInventarioTableFilterComposer(
                $db: $db,
                $table: $db.movimientosInventario,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RepuestosTableOrderingComposer
    extends Composer<_$BaseDatos, $RepuestosTable> {
  $$RepuestosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioVenta => $composableBuilder(
    column: $table.precioVenta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get existencias => $composableBuilder(
    column: $table.existencias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get umbral => $composableBuilder(
    column: $table.umbral,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RepuestosTableAnnotationComposer
    extends Composer<_$BaseDatos, $RepuestosTable> {
  $$RepuestosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<double> get precioVenta => $composableBuilder(
    column: $table.precioVenta,
    builder: (column) => column,
  );

  GeneratedColumn<int> get existencias => $composableBuilder(
    column: $table.existencias,
    builder: (column) => column,
  );

  GeneratedColumn<int> get umbral =>
      $composableBuilder(column: $table.umbral, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  Expression<T> repuestosOrdenRefs<T extends Object>(
    Expression<T> Function($$RepuestosOrdenTableAnnotationComposer a) f,
  ) {
    final $$RepuestosOrdenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repuestosOrden,
      getReferencedColumn: (t) => t.repuestoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepuestosOrdenTableAnnotationComposer(
            $db: $db,
            $table: $db.repuestosOrden,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> movimientosInventarioRefs<T extends Object>(
    Expression<T> Function($$MovimientosInventarioTableAnnotationComposer a) f,
  ) {
    final $$MovimientosInventarioTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.movimientosInventario,
          getReferencedColumn: (t) => t.repuestoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MovimientosInventarioTableAnnotationComposer(
                $db: $db,
                $table: $db.movimientosInventario,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RepuestosTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $RepuestosTable,
          Repuesto,
          $$RepuestosTableFilterComposer,
          $$RepuestosTableOrderingComposer,
          $$RepuestosTableAnnotationComposer,
          $$RepuestosTableCreateCompanionBuilder,
          $$RepuestosTableUpdateCompanionBuilder,
          (Repuesto, $$RepuestosTableReferences),
          Repuesto,
          PrefetchHooks Function({
            bool repuestosOrdenRefs,
            bool movimientosInventarioRefs,
          })
        > {
  $$RepuestosTableTableManager(_$BaseDatos db, $RepuestosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepuestosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepuestosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepuestosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<double> precioVenta = const Value.absent(),
                Value<int> existencias = const Value.absent(),
                Value<int> umbral = const Value.absent(),
                Value<bool> activo = const Value.absent(),
              }) => RepuestosCompanion(
                id: id,
                nombre: nombre,
                codigo: codigo,
                precioVenta: precioVenta,
                existencias: existencias,
                umbral: umbral,
                activo: activo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String codigo,
                required double precioVenta,
                Value<int> existencias = const Value.absent(),
                Value<int> umbral = const Value.absent(),
                Value<bool> activo = const Value.absent(),
              }) => RepuestosCompanion.insert(
                id: id,
                nombre: nombre,
                codigo: codigo,
                precioVenta: precioVenta,
                existencias: existencias,
                umbral: umbral,
                activo: activo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RepuestosTable, Repuesto>(table),
                  $$RepuestosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                repuestosOrdenRefs = false,
                movimientosInventarioRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (repuestosOrdenRefs) db.repuestosOrden,
                    if (movimientosInventarioRefs) db.movimientosInventario,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (repuestosOrdenRefs)
                        await $_getPrefetchedDataByColumns<
                          Repuesto,
                          $RepuestosTable,
                          RepuestoOrden,
                          $RepuestosOrdenTable
                        >(
                          currentTable: table,
                          referencedTable: $$RepuestosTableReferences
                              ._repuestosOrdenRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RepuestosTableReferences(
                                db,
                                table,
                                p0,
                              ).repuestosOrdenRefs,
                          currentColumn: 'id',
                          referencedColumn: 'repuesto_id',
                          typedResults: items,
                        ),
                      if (movimientosInventarioRefs)
                        await $_getPrefetchedDataByColumns<
                          Repuesto,
                          $RepuestosTable,
                          MovimientoInventario,
                          $MovimientosInventarioTable
                        >(
                          currentTable: table,
                          referencedTable: $$RepuestosTableReferences
                              ._movimientosInventarioRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RepuestosTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosInventarioRefs,
                          currentColumn: 'id',
                          referencedColumn: 'repuesto_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RepuestosTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $RepuestosTable,
      Repuesto,
      $$RepuestosTableFilterComposer,
      $$RepuestosTableOrderingComposer,
      $$RepuestosTableAnnotationComposer,
      $$RepuestosTableCreateCompanionBuilder,
      $$RepuestosTableUpdateCompanionBuilder,
      (Repuesto, $$RepuestosTableReferences),
      Repuesto,
      PrefetchHooks Function({
        bool repuestosOrdenRefs,
        bool movimientosInventarioRefs,
      })
    >;
typedef $$RepuestosOrdenTableCreateCompanionBuilder =
    RepuestosOrdenCompanion Function({
      Value<int> id,
      required int ordenId,
      required int repuestoId,
      required int cantidad,
      required double precioUnitario,
      Value<DateTime> fecha,
    });
typedef $$RepuestosOrdenTableUpdateCompanionBuilder =
    RepuestosOrdenCompanion Function({
      Value<int> id,
      Value<int> ordenId,
      Value<int> repuestoId,
      Value<int> cantidad,
      Value<double> precioUnitario,
      Value<DateTime> fecha,
    });

final class $$RepuestosOrdenTableReferences
    extends BaseReferences<_$BaseDatos, $RepuestosOrdenTable, RepuestoOrden> {
  $$RepuestosOrdenTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrdenesServicioTable _ordenIdTable(_$BaseDatos db) => db
      .ordenesServicio
      .createAlias('repuestos_orden__orden_id__ordenes_servicio__id');

  $$OrdenesServicioTableProcessedTableManager get ordenId {
    final $_column = $_itemColumn<int>('orden_id')!;

    final manager = $$OrdenesServicioTableTableManager(
      $_db,
      $_db.ordenesServicio,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RepuestosTable _repuestoIdTable(_$BaseDatos db) =>
      db.repuestos.createAlias('repuestos_orden__repuesto_id__repuestos__id');

  $$RepuestosTableProcessedTableManager get repuestoId {
    final $_column = $_itemColumn<int>('repuesto_id')!;

    final manager = $$RepuestosTableTableManager(
      $_db,
      $_db.repuestos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_repuestoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RepuestosOrdenTableFilterComposer
    extends Composer<_$BaseDatos, $RepuestosOrdenTable> {
  $$RepuestosOrdenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdenesServicioTableFilterComposer get ordenId {
    final $$OrdenesServicioTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesServicio,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesServicioTableFilterComposer(
            $db: $db,
            $table: $db.ordenesServicio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RepuestosTableFilterComposer get repuestoId {
    final $$RepuestosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repuestoId,
      referencedTable: $db.repuestos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepuestosTableFilterComposer(
            $db: $db,
            $table: $db.repuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepuestosOrdenTableOrderingComposer
    extends Composer<_$BaseDatos, $RepuestosOrdenTable> {
  $$RepuestosOrdenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdenesServicioTableOrderingComposer get ordenId {
    final $$OrdenesServicioTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesServicio,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesServicioTableOrderingComposer(
            $db: $db,
            $table: $db.ordenesServicio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RepuestosTableOrderingComposer get repuestoId {
    final $$RepuestosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repuestoId,
      referencedTable: $db.repuestos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepuestosTableOrderingComposer(
            $db: $db,
            $table: $db.repuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepuestosOrdenTableAnnotationComposer
    extends Composer<_$BaseDatos, $RepuestosOrdenTable> {
  $$RepuestosOrdenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  $$OrdenesServicioTableAnnotationComposer get ordenId {
    final $$OrdenesServicioTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesServicio,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesServicioTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenesServicio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RepuestosTableAnnotationComposer get repuestoId {
    final $$RepuestosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repuestoId,
      referencedTable: $db.repuestos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepuestosTableAnnotationComposer(
            $db: $db,
            $table: $db.repuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepuestosOrdenTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $RepuestosOrdenTable,
          RepuestoOrden,
          $$RepuestosOrdenTableFilterComposer,
          $$RepuestosOrdenTableOrderingComposer,
          $$RepuestosOrdenTableAnnotationComposer,
          $$RepuestosOrdenTableCreateCompanionBuilder,
          $$RepuestosOrdenTableUpdateCompanionBuilder,
          (RepuestoOrden, $$RepuestosOrdenTableReferences),
          RepuestoOrden,
          PrefetchHooks Function({bool ordenId, bool repuestoId})
        > {
  $$RepuestosOrdenTableTableManager(_$BaseDatos db, $RepuestosOrdenTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepuestosOrdenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepuestosOrdenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepuestosOrdenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ordenId = const Value.absent(),
                Value<int> repuestoId = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<double> precioUnitario = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
              }) => RepuestosOrdenCompanion(
                id: id,
                ordenId: ordenId,
                repuestoId: repuestoId,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                fecha: fecha,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ordenId,
                required int repuestoId,
                required int cantidad,
                required double precioUnitario,
                Value<DateTime> fecha = const Value.absent(),
              }) => RepuestosOrdenCompanion.insert(
                id: id,
                ordenId: ordenId,
                repuestoId: repuestoId,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                fecha: fecha,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RepuestosOrdenTable, RepuestoOrden>(table),
                  $$RepuestosOrdenTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordenId = false, repuestoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ordenId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ordenId,
                        referencedTable: $$RepuestosOrdenTableReferences
                            ._ordenIdTable(db),
                        referencedColumn: $$RepuestosOrdenTableReferences
                            ._ordenIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (repuestoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.repuestoId,
                        referencedTable: $$RepuestosOrdenTableReferences
                            ._repuestoIdTable(db),
                        referencedColumn: $$RepuestosOrdenTableReferences
                            ._repuestoIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RepuestosOrdenTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $RepuestosOrdenTable,
      RepuestoOrden,
      $$RepuestosOrdenTableFilterComposer,
      $$RepuestosOrdenTableOrderingComposer,
      $$RepuestosOrdenTableAnnotationComposer,
      $$RepuestosOrdenTableCreateCompanionBuilder,
      $$RepuestosOrdenTableUpdateCompanionBuilder,
      (RepuestoOrden, $$RepuestosOrdenTableReferences),
      RepuestoOrden,
      PrefetchHooks Function({bool ordenId, bool repuestoId})
    >;
typedef $$PagosTableCreateCompanionBuilder = PagosCompanion Function({
  Value<int> id,
  required int ordenId,
  Value<DateTime> fecha,
  required double importe,
  required String metodo,
  Value<String?> nota,
  Value<String?> registradoPor,
});
typedef $$PagosTableUpdateCompanionBuilder = PagosCompanion Function({
  Value<int> id,
  Value<int> ordenId,
  Value<DateTime> fecha,
  Value<double> importe,
  Value<String> metodo,
  Value<String?> nota,
  Value<String?> registradoPor,
});

final class $$PagosTableReferences
    extends BaseReferences<_$BaseDatos, $PagosTable, Pago> {
  $$PagosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdenesServicioTable _ordenIdTable(_$BaseDatos db) =>
      db.ordenesServicio.createAlias('pagos__orden_id__ordenes_servicio__id');

  $$OrdenesServicioTableProcessedTableManager get ordenId {
    final $_column = $_itemColumn<int>('orden_id')!;

    final manager = $$OrdenesServicioTableTableManager(
      $_db,
      $_db.ordenesServicio,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PagosTableFilterComposer extends Composer<_$BaseDatos, $PagosTable> {
  $$PagosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get importe => $composableBuilder(
    column: $table.importe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metodo => $composableBuilder(
    column: $table.metodo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get registradoPor => $composableBuilder(
    column: $table.registradoPor,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdenesServicioTableFilterComposer get ordenId {
    final $$OrdenesServicioTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesServicio,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesServicioTableFilterComposer(
            $db: $db,
            $table: $db.ordenesServicio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PagosTableOrderingComposer extends Composer<_$BaseDatos, $PagosTable> {
  $$PagosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get importe => $composableBuilder(
    column: $table.importe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metodo => $composableBuilder(
    column: $table.metodo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registradoPor => $composableBuilder(
    column: $table.registradoPor,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdenesServicioTableOrderingComposer get ordenId {
    final $$OrdenesServicioTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesServicio,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesServicioTableOrderingComposer(
            $db: $db,
            $table: $db.ordenesServicio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PagosTableAnnotationComposer
    extends Composer<_$BaseDatos, $PagosTable> {
  $$PagosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<double> get importe =>
      $composableBuilder(column: $table.importe, builder: (column) => column);

  GeneratedColumn<String> get metodo =>
      $composableBuilder(column: $table.metodo, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  GeneratedColumn<String> get registradoPor => $composableBuilder(
    column: $table.registradoPor,
    builder: (column) => column,
  );

  $$OrdenesServicioTableAnnotationComposer get ordenId {
    final $$OrdenesServicioTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesServicio,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesServicioTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenesServicio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PagosTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $PagosTable,
          Pago,
          $$PagosTableFilterComposer,
          $$PagosTableOrderingComposer,
          $$PagosTableAnnotationComposer,
          $$PagosTableCreateCompanionBuilder,
          $$PagosTableUpdateCompanionBuilder,
          (Pago, $$PagosTableReferences),
          Pago,
          PrefetchHooks Function({bool ordenId})
        > {
  $$PagosTableTableManager(_$BaseDatos db, $PagosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PagosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PagosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PagosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ordenId = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<double> importe = const Value.absent(),
                Value<String> metodo = const Value.absent(),
                Value<String?> nota = const Value.absent(),
                Value<String?> registradoPor = const Value.absent(),
              }) => PagosCompanion(
                id: id,
                ordenId: ordenId,
                fecha: fecha,
                importe: importe,
                metodo: metodo,
                nota: nota,
                registradoPor: registradoPor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ordenId,
                Value<DateTime> fecha = const Value.absent(),
                required double importe,
                required String metodo,
                Value<String?> nota = const Value.absent(),
                Value<String?> registradoPor = const Value.absent(),
              }) => PagosCompanion.insert(
                id: id,
                ordenId: ordenId,
                fecha: fecha,
                importe: importe,
                metodo: metodo,
                nota: nota,
                registradoPor: registradoPor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PagosTable, Pago>(table),
                  $$PagosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordenId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ordenId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ordenId,
                        referencedTable: $$PagosTableReferences._ordenIdTable(
                          db,
                        ),
                        referencedColumn: $$PagosTableReferences
                            ._ordenIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PagosTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $PagosTable,
      Pago,
      $$PagosTableFilterComposer,
      $$PagosTableOrderingComposer,
      $$PagosTableAnnotationComposer,
      $$PagosTableCreateCompanionBuilder,
      $$PagosTableUpdateCompanionBuilder,
      (Pago, $$PagosTableReferences),
      Pago,
      PrefetchHooks Function({bool ordenId})
    >;
typedef $$MovimientosInventarioTableCreateCompanionBuilder =
    MovimientosInventarioCompanion Function({
      Value<int> id,
      required int repuestoId,
      Value<int?> ordenId,
      required String tipo,
      required int cantidad,
      Value<DateTime> fecha,
      Value<String?> nota,
      Value<String?> usuario,
    });
typedef $$MovimientosInventarioTableUpdateCompanionBuilder =
    MovimientosInventarioCompanion Function({
      Value<int> id,
      Value<int> repuestoId,
      Value<int?> ordenId,
      Value<String> tipo,
      Value<int> cantidad,
      Value<DateTime> fecha,
      Value<String?> nota,
      Value<String?> usuario,
    });

final class $$MovimientosInventarioTableReferences
    extends
        BaseReferences<
          _$BaseDatos,
          $MovimientosInventarioTable,
          MovimientoInventario
        > {
  $$MovimientosInventarioTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RepuestosTable _repuestoIdTable(_$BaseDatos db) => db.repuestos
      .createAlias('movimientos_inventario__repuesto_id__repuestos__id');

  $$RepuestosTableProcessedTableManager get repuestoId {
    final $_column = $_itemColumn<int>('repuesto_id')!;

    final manager = $$RepuestosTableTableManager(
      $_db,
      $_db.repuestos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_repuestoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $OrdenesServicioTable _ordenIdTable(_$BaseDatos db) => db
      .ordenesServicio
      .createAlias('movimientos_inventario__orden_id__ordenes_servicio__id');

  $$OrdenesServicioTableProcessedTableManager? get ordenId {
    final $_column = $_itemColumn<int>('orden_id');
    if ($_column == null) return null;
    final manager = $$OrdenesServicioTableTableManager(
      $_db,
      $_db.ordenesServicio,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MovimientosInventarioTableFilterComposer
    extends Composer<_$BaseDatos, $MovimientosInventarioTable> {
  $$MovimientosInventarioTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuario => $composableBuilder(
    column: $table.usuario,
    builder: (column) => ColumnFilters(column),
  );

  $$RepuestosTableFilterComposer get repuestoId {
    final $$RepuestosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repuestoId,
      referencedTable: $db.repuestos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepuestosTableFilterComposer(
            $db: $db,
            $table: $db.repuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OrdenesServicioTableFilterComposer get ordenId {
    final $$OrdenesServicioTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesServicio,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesServicioTableFilterComposer(
            $db: $db,
            $table: $db.ordenesServicio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosInventarioTableOrderingComposer
    extends Composer<_$BaseDatos, $MovimientosInventarioTable> {
  $$MovimientosInventarioTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuario => $composableBuilder(
    column: $table.usuario,
    builder: (column) => ColumnOrderings(column),
  );

  $$RepuestosTableOrderingComposer get repuestoId {
    final $$RepuestosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repuestoId,
      referencedTable: $db.repuestos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepuestosTableOrderingComposer(
            $db: $db,
            $table: $db.repuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OrdenesServicioTableOrderingComposer get ordenId {
    final $$OrdenesServicioTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesServicio,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesServicioTableOrderingComposer(
            $db: $db,
            $table: $db.ordenesServicio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosInventarioTableAnnotationComposer
    extends Composer<_$BaseDatos, $MovimientosInventarioTable> {
  $$MovimientosInventarioTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  GeneratedColumn<String> get usuario =>
      $composableBuilder(column: $table.usuario, builder: (column) => column);

  $$RepuestosTableAnnotationComposer get repuestoId {
    final $$RepuestosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repuestoId,
      referencedTable: $db.repuestos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepuestosTableAnnotationComposer(
            $db: $db,
            $table: $db.repuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OrdenesServicioTableAnnotationComposer get ordenId {
    final $$OrdenesServicioTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesServicio,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesServicioTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenesServicio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosInventarioTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $MovimientosInventarioTable,
          MovimientoInventario,
          $$MovimientosInventarioTableFilterComposer,
          $$MovimientosInventarioTableOrderingComposer,
          $$MovimientosInventarioTableAnnotationComposer,
          $$MovimientosInventarioTableCreateCompanionBuilder,
          $$MovimientosInventarioTableUpdateCompanionBuilder,
          (MovimientoInventario, $$MovimientosInventarioTableReferences),
          MovimientoInventario,
          PrefetchHooks Function({bool repuestoId, bool ordenId})
        > {
  $$MovimientosInventarioTableTableManager(
    _$BaseDatos db,
    $MovimientosInventarioTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovimientosInventarioTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$MovimientosInventarioTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MovimientosInventarioTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> repuestoId = const Value.absent(),
                Value<int?> ordenId = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String?> nota = const Value.absent(),
                Value<String?> usuario = const Value.absent(),
              }) => MovimientosInventarioCompanion(
                id: id,
                repuestoId: repuestoId,
                ordenId: ordenId,
                tipo: tipo,
                cantidad: cantidad,
                fecha: fecha,
                nota: nota,
                usuario: usuario,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int repuestoId,
                Value<int?> ordenId = const Value.absent(),
                required String tipo,
                required int cantidad,
                Value<DateTime> fecha = const Value.absent(),
                Value<String?> nota = const Value.absent(),
                Value<String?> usuario = const Value.absent(),
              }) => MovimientosInventarioCompanion.insert(
                id: id,
                repuestoId: repuestoId,
                ordenId: ordenId,
                tipo: tipo,
                cantidad: cantidad,
                fecha: fecha,
                nota: nota,
                usuario: usuario,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $MovimientosInventarioTable,
                    MovimientoInventario
                  >(table),
                  $$MovimientosInventarioTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({repuestoId = false, ordenId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (repuestoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.repuestoId,
                        referencedTable: $$MovimientosInventarioTableReferences
                            ._repuestoIdTable(db),
                        referencedColumn: $$MovimientosInventarioTableReferences
                            ._repuestoIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (ordenId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ordenId,
                        referencedTable: $$MovimientosInventarioTableReferences
                            ._ordenIdTable(db),
                        referencedColumn: $$MovimientosInventarioTableReferences
                            ._ordenIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MovimientosInventarioTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $MovimientosInventarioTable,
      MovimientoInventario,
      $$MovimientosInventarioTableFilterComposer,
      $$MovimientosInventarioTableOrderingComposer,
      $$MovimientosInventarioTableAnnotationComposer,
      $$MovimientosInventarioTableCreateCompanionBuilder,
      $$MovimientosInventarioTableUpdateCompanionBuilder,
      (MovimientoInventario, $$MovimientosInventarioTableReferences),
      MovimientoInventario,
      PrefetchHooks Function({bool repuestoId, bool ordenId})
    >;
typedef $$ConfiguracionTableCreateCompanionBuilder =
    ConfiguracionCompanion Function({
      required String clave,
      required String valor,
      Value<int> rowid,
    });
typedef $$ConfiguracionTableUpdateCompanionBuilder =
    ConfiguracionCompanion Function({
      Value<String> clave,
      Value<String> valor,
      Value<int> rowid,
    });

class $$ConfiguracionTableFilterComposer
    extends Composer<_$BaseDatos, $ConfiguracionTable> {
  $$ConfiguracionTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clave => $composableBuilder(
    column: $table.clave,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConfiguracionTableOrderingComposer
    extends Composer<_$BaseDatos, $ConfiguracionTable> {
  $$ConfiguracionTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clave => $composableBuilder(
    column: $table.clave,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConfiguracionTableAnnotationComposer
    extends Composer<_$BaseDatos, $ConfiguracionTable> {
  $$ConfiguracionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clave =>
      $composableBuilder(column: $table.clave, builder: (column) => column);

  GeneratedColumn<String> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);
}

class $$ConfiguracionTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $ConfiguracionTable,
          ConfiguracionItem,
          $$ConfiguracionTableFilterComposer,
          $$ConfiguracionTableOrderingComposer,
          $$ConfiguracionTableAnnotationComposer,
          $$ConfiguracionTableCreateCompanionBuilder,
          $$ConfiguracionTableUpdateCompanionBuilder,
          (
            ConfiguracionItem,
            BaseReferences<_$BaseDatos, $ConfiguracionTable, ConfiguracionItem>,
          ),
          ConfiguracionItem,
          PrefetchHooks Function()
        > {
  $$ConfiguracionTableTableManager(_$BaseDatos db, $ConfiguracionTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfiguracionTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfiguracionTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConfiguracionTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> clave = const Value.absent(),
                Value<String> valor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConfiguracionCompanion(
                clave: clave,
                valor: valor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clave,
                required String valor,
                Value<int> rowid = const Value.absent(),
              }) => ConfiguracionCompanion.insert(
                clave: clave,
                valor: valor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ConfiguracionTable, ConfiguracionItem>(table),
                  BaseReferences<
                    _$BaseDatos,
                    $ConfiguracionTable,
                    ConfiguracionItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConfiguracionTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $ConfiguracionTable,
      ConfiguracionItem,
      $$ConfiguracionTableFilterComposer,
      $$ConfiguracionTableOrderingComposer,
      $$ConfiguracionTableAnnotationComposer,
      $$ConfiguracionTableCreateCompanionBuilder,
      $$ConfiguracionTableUpdateCompanionBuilder,
      (
        ConfiguracionItem,
        BaseReferences<_$BaseDatos, $ConfiguracionTable, ConfiguracionItem>,
      ),
      ConfiguracionItem,
      PrefetchHooks Function()
    >;

class $BaseDatosManager {
  final _$BaseDatos _db;
  $BaseDatosManager(this._db);
  $$MecanicosTableTableManager get mecanicos =>
      $$MecanicosTableTableManager(_db, _db.mecanicos);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db, _db.usuarios);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
  $$VehiculosTableTableManager get vehiculos =>
      $$VehiculosTableTableManager(_db, _db.vehiculos);
  $$OrdenesServicioTableTableManager get ordenesServicio =>
      $$OrdenesServicioTableTableManager(_db, _db.ordenesServicio);
  $$TrabajosTableTableManager get trabajos =>
      $$TrabajosTableTableManager(_db, _db.trabajos);
  $$RepuestosTableTableManager get repuestos =>
      $$RepuestosTableTableManager(_db, _db.repuestos);
  $$RepuestosOrdenTableTableManager get repuestosOrden =>
      $$RepuestosOrdenTableTableManager(_db, _db.repuestosOrden);
  $$PagosTableTableManager get pagos =>
      $$PagosTableTableManager(_db, _db.pagos);
  $$MovimientosInventarioTableTableManager get movimientosInventario =>
      $$MovimientosInventarioTableTableManager(_db, _db.movimientosInventario);
  $$ConfiguracionTableTableManager get configuracion =>
      $$ConfiguracionTableTableManager(_db, _db.configuracion);
}
