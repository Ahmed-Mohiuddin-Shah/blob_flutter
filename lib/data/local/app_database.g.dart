// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WhatsappPackDraftsTable extends WhatsappPackDrafts
    with TableInfo<$WhatsappPackDraftsTable, WhatsappPackDraft> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WhatsappPackDraftsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _identifierMeta = const VerificationMeta(
    'identifier',
  );
  @override
  late final GeneratedColumn<String> identifier = GeneratedColumn<String>(
    'identifier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publisherMeta = const VerificationMeta(
    'publisher',
  );
  @override
  late final GeneratedColumn<String> publisher = GeneratedColumn<String>(
    'publisher',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trayPathMeta = const VerificationMeta(
    'trayPath',
  );
  @override
  late final GeneratedColumn<String> trayPath = GeneratedColumn<String>(
    'tray_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _animatedMeta = const VerificationMeta(
    'animated',
  );
  @override
  late final GeneratedColumn<bool> animated = GeneratedColumn<bool>(
    'animated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("animated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    identifier,
    name,
    publisher,
    trayPath,
    animated,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'whatsapp_pack_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<WhatsappPackDraft> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('identifier')) {
      context.handle(
        _identifierMeta,
        identifier.isAcceptableOrUnknown(data['identifier']!, _identifierMeta),
      );
    } else if (isInserting) {
      context.missing(_identifierMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('publisher')) {
      context.handle(
        _publisherMeta,
        publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta),
      );
    } else if (isInserting) {
      context.missing(_publisherMeta);
    }
    if (data.containsKey('tray_path')) {
      context.handle(
        _trayPathMeta,
        trayPath.isAcceptableOrUnknown(data['tray_path']!, _trayPathMeta),
      );
    }
    if (data.containsKey('animated')) {
      context.handle(
        _animatedMeta,
        animated.isAcceptableOrUnknown(data['animated']!, _animatedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WhatsappPackDraft map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WhatsappPackDraft(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      identifier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identifier'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      publisher: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}publisher'],
      )!,
      trayPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tray_path'],
      ),
      animated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}animated'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WhatsappPackDraftsTable createAlias(String alias) {
    return $WhatsappPackDraftsTable(attachedDatabase, alias);
  }
}

class WhatsappPackDraft extends DataClass
    implements Insertable<WhatsappPackDraft> {
  final int id;
  final String identifier;
  final String name;
  final String publisher;
  final String? trayPath;
  final bool animated;
  final DateTime updatedAt;
  const WhatsappPackDraft({
    required this.id,
    required this.identifier,
    required this.name,
    required this.publisher,
    this.trayPath,
    required this.animated,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['identifier'] = Variable<String>(identifier);
    map['name'] = Variable<String>(name);
    map['publisher'] = Variable<String>(publisher);
    if (!nullToAbsent || trayPath != null) {
      map['tray_path'] = Variable<String>(trayPath);
    }
    map['animated'] = Variable<bool>(animated);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WhatsappPackDraftsCompanion toCompanion(bool nullToAbsent) {
    return WhatsappPackDraftsCompanion(
      id: Value(id),
      identifier: Value(identifier),
      name: Value(name),
      publisher: Value(publisher),
      trayPath: trayPath == null && nullToAbsent
          ? const Value.absent()
          : Value(trayPath),
      animated: Value(animated),
      updatedAt: Value(updatedAt),
    );
  }

  factory WhatsappPackDraft.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WhatsappPackDraft(
      id: serializer.fromJson<int>(json['id']),
      identifier: serializer.fromJson<String>(json['identifier']),
      name: serializer.fromJson<String>(json['name']),
      publisher: serializer.fromJson<String>(json['publisher']),
      trayPath: serializer.fromJson<String?>(json['trayPath']),
      animated: serializer.fromJson<bool>(json['animated']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'identifier': serializer.toJson<String>(identifier),
      'name': serializer.toJson<String>(name),
      'publisher': serializer.toJson<String>(publisher),
      'trayPath': serializer.toJson<String?>(trayPath),
      'animated': serializer.toJson<bool>(animated),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WhatsappPackDraft copyWith({
    int? id,
    String? identifier,
    String? name,
    String? publisher,
    Value<String?> trayPath = const Value.absent(),
    bool? animated,
    DateTime? updatedAt,
  }) => WhatsappPackDraft(
    id: id ?? this.id,
    identifier: identifier ?? this.identifier,
    name: name ?? this.name,
    publisher: publisher ?? this.publisher,
    trayPath: trayPath.present ? trayPath.value : this.trayPath,
    animated: animated ?? this.animated,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WhatsappPackDraft copyWithCompanion(WhatsappPackDraftsCompanion data) {
    return WhatsappPackDraft(
      id: data.id.present ? data.id.value : this.id,
      identifier: data.identifier.present
          ? data.identifier.value
          : this.identifier,
      name: data.name.present ? data.name.value : this.name,
      publisher: data.publisher.present ? data.publisher.value : this.publisher,
      trayPath: data.trayPath.present ? data.trayPath.value : this.trayPath,
      animated: data.animated.present ? data.animated.value : this.animated,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WhatsappPackDraft(')
          ..write('id: $id, ')
          ..write('identifier: $identifier, ')
          ..write('name: $name, ')
          ..write('publisher: $publisher, ')
          ..write('trayPath: $trayPath, ')
          ..write('animated: $animated, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    identifier,
    name,
    publisher,
    trayPath,
    animated,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WhatsappPackDraft &&
          other.id == this.id &&
          other.identifier == this.identifier &&
          other.name == this.name &&
          other.publisher == this.publisher &&
          other.trayPath == this.trayPath &&
          other.animated == this.animated &&
          other.updatedAt == this.updatedAt);
}

class WhatsappPackDraftsCompanion extends UpdateCompanion<WhatsappPackDraft> {
  final Value<int> id;
  final Value<String> identifier;
  final Value<String> name;
  final Value<String> publisher;
  final Value<String?> trayPath;
  final Value<bool> animated;
  final Value<DateTime> updatedAt;
  const WhatsappPackDraftsCompanion({
    this.id = const Value.absent(),
    this.identifier = const Value.absent(),
    this.name = const Value.absent(),
    this.publisher = const Value.absent(),
    this.trayPath = const Value.absent(),
    this.animated = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  WhatsappPackDraftsCompanion.insert({
    this.id = const Value.absent(),
    required String identifier,
    required String name,
    required String publisher,
    this.trayPath = const Value.absent(),
    this.animated = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : identifier = Value(identifier),
       name = Value(name),
       publisher = Value(publisher);
  static Insertable<WhatsappPackDraft> custom({
    Expression<int>? id,
    Expression<String>? identifier,
    Expression<String>? name,
    Expression<String>? publisher,
    Expression<String>? trayPath,
    Expression<bool>? animated,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (identifier != null) 'identifier': identifier,
      if (name != null) 'name': name,
      if (publisher != null) 'publisher': publisher,
      if (trayPath != null) 'tray_path': trayPath,
      if (animated != null) 'animated': animated,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  WhatsappPackDraftsCompanion copyWith({
    Value<int>? id,
    Value<String>? identifier,
    Value<String>? name,
    Value<String>? publisher,
    Value<String?>? trayPath,
    Value<bool>? animated,
    Value<DateTime>? updatedAt,
  }) {
    return WhatsappPackDraftsCompanion(
      id: id ?? this.id,
      identifier: identifier ?? this.identifier,
      name: name ?? this.name,
      publisher: publisher ?? this.publisher,
      trayPath: trayPath ?? this.trayPath,
      animated: animated ?? this.animated,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (identifier.present) {
      map['identifier'] = Variable<String>(identifier.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String>(publisher.value);
    }
    if (trayPath.present) {
      map['tray_path'] = Variable<String>(trayPath.value);
    }
    if (animated.present) {
      map['animated'] = Variable<bool>(animated.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WhatsappPackDraftsCompanion(')
          ..write('id: $id, ')
          ..write('identifier: $identifier, ')
          ..write('name: $name, ')
          ..write('publisher: $publisher, ')
          ..write('trayPath: $trayPath, ')
          ..write('animated: $animated, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WhatsappPackStickersTable extends WhatsappPackStickers
    with TableInfo<$WhatsappPackStickersTable, WhatsappPackSticker> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WhatsappPackStickersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<int> packId = GeneratedColumn<int>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stickerIdMeta = const VerificationMeta(
    'stickerId',
  );
  @override
  late final GeneratedColumn<String> stickerId = GeneratedColumn<String>(
    'sticker_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('🙂'),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    stickerId,
    localPath,
    emoji,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'whatsapp_pack_stickers';
  @override
  VerificationContext validateIntegrity(
    Insertable<WhatsappPackSticker> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('sticker_id')) {
      context.handle(
        _stickerIdMeta,
        stickerId.isAcceptableOrUnknown(data['sticker_id']!, _stickerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stickerIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WhatsappPackSticker map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WhatsappPackSticker(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pack_id'],
      )!,
      stickerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sticker_id'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $WhatsappPackStickersTable createAlias(String alias) {
    return $WhatsappPackStickersTable(attachedDatabase, alias);
  }
}

class WhatsappPackSticker extends DataClass
    implements Insertable<WhatsappPackSticker> {
  final int id;
  final int packId;
  final String stickerId;
  final String localPath;
  final String emoji;
  final int sortOrder;
  const WhatsappPackSticker({
    required this.id,
    required this.packId,
    required this.stickerId,
    required this.localPath,
    required this.emoji,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pack_id'] = Variable<int>(packId);
    map['sticker_id'] = Variable<String>(stickerId);
    map['local_path'] = Variable<String>(localPath);
    map['emoji'] = Variable<String>(emoji);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  WhatsappPackStickersCompanion toCompanion(bool nullToAbsent) {
    return WhatsappPackStickersCompanion(
      id: Value(id),
      packId: Value(packId),
      stickerId: Value(stickerId),
      localPath: Value(localPath),
      emoji: Value(emoji),
      sortOrder: Value(sortOrder),
    );
  }

  factory WhatsappPackSticker.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WhatsappPackSticker(
      id: serializer.fromJson<int>(json['id']),
      packId: serializer.fromJson<int>(json['packId']),
      stickerId: serializer.fromJson<String>(json['stickerId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      emoji: serializer.fromJson<String>(json['emoji']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'packId': serializer.toJson<int>(packId),
      'stickerId': serializer.toJson<String>(stickerId),
      'localPath': serializer.toJson<String>(localPath),
      'emoji': serializer.toJson<String>(emoji),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  WhatsappPackSticker copyWith({
    int? id,
    int? packId,
    String? stickerId,
    String? localPath,
    String? emoji,
    int? sortOrder,
  }) => WhatsappPackSticker(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    stickerId: stickerId ?? this.stickerId,
    localPath: localPath ?? this.localPath,
    emoji: emoji ?? this.emoji,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  WhatsappPackSticker copyWithCompanion(WhatsappPackStickersCompanion data) {
    return WhatsappPackSticker(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      stickerId: data.stickerId.present ? data.stickerId.value : this.stickerId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WhatsappPackSticker(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('stickerId: $stickerId, ')
          ..write('localPath: $localPath, ')
          ..write('emoji: $emoji, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, packId, stickerId, localPath, emoji, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WhatsappPackSticker &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.stickerId == this.stickerId &&
          other.localPath == this.localPath &&
          other.emoji == this.emoji &&
          other.sortOrder == this.sortOrder);
}

class WhatsappPackStickersCompanion
    extends UpdateCompanion<WhatsappPackSticker> {
  final Value<int> id;
  final Value<int> packId;
  final Value<String> stickerId;
  final Value<String> localPath;
  final Value<String> emoji;
  final Value<int> sortOrder;
  const WhatsappPackStickersCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.stickerId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.emoji = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  WhatsappPackStickersCompanion.insert({
    this.id = const Value.absent(),
    required int packId,
    required String stickerId,
    required String localPath,
    this.emoji = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : packId = Value(packId),
       stickerId = Value(stickerId),
       localPath = Value(localPath);
  static Insertable<WhatsappPackSticker> custom({
    Expression<int>? id,
    Expression<int>? packId,
    Expression<String>? stickerId,
    Expression<String>? localPath,
    Expression<String>? emoji,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (stickerId != null) 'sticker_id': stickerId,
      if (localPath != null) 'local_path': localPath,
      if (emoji != null) 'emoji': emoji,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  WhatsappPackStickersCompanion copyWith({
    Value<int>? id,
    Value<int>? packId,
    Value<String>? stickerId,
    Value<String>? localPath,
    Value<String>? emoji,
    Value<int>? sortOrder,
  }) {
    return WhatsappPackStickersCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      stickerId: stickerId ?? this.stickerId,
      localPath: localPath ?? this.localPath,
      emoji: emoji ?? this.emoji,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<int>(packId.value);
    }
    if (stickerId.present) {
      map['sticker_id'] = Variable<String>(stickerId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WhatsappPackStickersCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('stickerId: $stickerId, ')
          ..write('localPath: $localPath, ')
          ..write('emoji: $emoji, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WhatsappPackDraftsTable whatsappPackDrafts =
      $WhatsappPackDraftsTable(this);
  late final $WhatsappPackStickersTable whatsappPackStickers =
      $WhatsappPackStickersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    whatsappPackDrafts,
    whatsappPackStickers,
  ];
}

typedef $$WhatsappPackDraftsTableCreateCompanionBuilder =
    WhatsappPackDraftsCompanion Function({
      Value<int> id,
      required String identifier,
      required String name,
      required String publisher,
      Value<String?> trayPath,
      Value<bool> animated,
      Value<DateTime> updatedAt,
    });
typedef $$WhatsappPackDraftsTableUpdateCompanionBuilder =
    WhatsappPackDraftsCompanion Function({
      Value<int> id,
      Value<String> identifier,
      Value<String> name,
      Value<String> publisher,
      Value<String?> trayPath,
      Value<bool> animated,
      Value<DateTime> updatedAt,
    });

class $$WhatsappPackDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $WhatsappPackDraftsTable> {
  $$WhatsappPackDraftsTableFilterComposer({
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

  ColumnFilters<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trayPath => $composableBuilder(
    column: $table.trayPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get animated => $composableBuilder(
    column: $table.animated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WhatsappPackDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $WhatsappPackDraftsTable> {
  $$WhatsappPackDraftsTableOrderingComposer({
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

  ColumnOrderings<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trayPath => $composableBuilder(
    column: $table.trayPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get animated => $composableBuilder(
    column: $table.animated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WhatsappPackDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WhatsappPackDraftsTable> {
  $$WhatsappPackDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get publisher =>
      $composableBuilder(column: $table.publisher, builder: (column) => column);

  GeneratedColumn<String> get trayPath =>
      $composableBuilder(column: $table.trayPath, builder: (column) => column);

  GeneratedColumn<bool> get animated =>
      $composableBuilder(column: $table.animated, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WhatsappPackDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WhatsappPackDraftsTable,
          WhatsappPackDraft,
          $$WhatsappPackDraftsTableFilterComposer,
          $$WhatsappPackDraftsTableOrderingComposer,
          $$WhatsappPackDraftsTableAnnotationComposer,
          $$WhatsappPackDraftsTableCreateCompanionBuilder,
          $$WhatsappPackDraftsTableUpdateCompanionBuilder,
          (
            WhatsappPackDraft,
            BaseReferences<
              _$AppDatabase,
              $WhatsappPackDraftsTable,
              WhatsappPackDraft
            >,
          ),
          WhatsappPackDraft,
          PrefetchHooks Function()
        > {
  $$WhatsappPackDraftsTableTableManager(
    _$AppDatabase db,
    $WhatsappPackDraftsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WhatsappPackDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WhatsappPackDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WhatsappPackDraftsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> identifier = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> publisher = const Value.absent(),
                Value<String?> trayPath = const Value.absent(),
                Value<bool> animated = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WhatsappPackDraftsCompanion(
                id: id,
                identifier: identifier,
                name: name,
                publisher: publisher,
                trayPath: trayPath,
                animated: animated,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String identifier,
                required String name,
                required String publisher,
                Value<String?> trayPath = const Value.absent(),
                Value<bool> animated = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WhatsappPackDraftsCompanion.insert(
                id: id,
                identifier: identifier,
                name: name,
                publisher: publisher,
                trayPath: trayPath,
                animated: animated,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WhatsappPackDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WhatsappPackDraftsTable,
      WhatsappPackDraft,
      $$WhatsappPackDraftsTableFilterComposer,
      $$WhatsappPackDraftsTableOrderingComposer,
      $$WhatsappPackDraftsTableAnnotationComposer,
      $$WhatsappPackDraftsTableCreateCompanionBuilder,
      $$WhatsappPackDraftsTableUpdateCompanionBuilder,
      (
        WhatsappPackDraft,
        BaseReferences<
          _$AppDatabase,
          $WhatsappPackDraftsTable,
          WhatsappPackDraft
        >,
      ),
      WhatsappPackDraft,
      PrefetchHooks Function()
    >;
typedef $$WhatsappPackStickersTableCreateCompanionBuilder =
    WhatsappPackStickersCompanion Function({
      Value<int> id,
      required int packId,
      required String stickerId,
      required String localPath,
      Value<String> emoji,
      Value<int> sortOrder,
    });
typedef $$WhatsappPackStickersTableUpdateCompanionBuilder =
    WhatsappPackStickersCompanion Function({
      Value<int> id,
      Value<int> packId,
      Value<String> stickerId,
      Value<String> localPath,
      Value<String> emoji,
      Value<int> sortOrder,
    });

class $$WhatsappPackStickersTableFilterComposer
    extends Composer<_$AppDatabase, $WhatsappPackStickersTable> {
  $$WhatsappPackStickersTableFilterComposer({
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

  ColumnFilters<int> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stickerId => $composableBuilder(
    column: $table.stickerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WhatsappPackStickersTableOrderingComposer
    extends Composer<_$AppDatabase, $WhatsappPackStickersTable> {
  $$WhatsappPackStickersTableOrderingComposer({
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

  ColumnOrderings<int> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stickerId => $composableBuilder(
    column: $table.stickerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WhatsappPackStickersTableAnnotationComposer
    extends Composer<_$AppDatabase, $WhatsappPackStickersTable> {
  $$WhatsappPackStickersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get packId =>
      $composableBuilder(column: $table.packId, builder: (column) => column);

  GeneratedColumn<String> get stickerId =>
      $composableBuilder(column: $table.stickerId, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$WhatsappPackStickersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WhatsappPackStickersTable,
          WhatsappPackSticker,
          $$WhatsappPackStickersTableFilterComposer,
          $$WhatsappPackStickersTableOrderingComposer,
          $$WhatsappPackStickersTableAnnotationComposer,
          $$WhatsappPackStickersTableCreateCompanionBuilder,
          $$WhatsappPackStickersTableUpdateCompanionBuilder,
          (
            WhatsappPackSticker,
            BaseReferences<
              _$AppDatabase,
              $WhatsappPackStickersTable,
              WhatsappPackSticker
            >,
          ),
          WhatsappPackSticker,
          PrefetchHooks Function()
        > {
  $$WhatsappPackStickersTableTableManager(
    _$AppDatabase db,
    $WhatsappPackStickersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WhatsappPackStickersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WhatsappPackStickersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WhatsappPackStickersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> packId = const Value.absent(),
                Value<String> stickerId = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => WhatsappPackStickersCompanion(
                id: id,
                packId: packId,
                stickerId: stickerId,
                localPath: localPath,
                emoji: emoji,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int packId,
                required String stickerId,
                required String localPath,
                Value<String> emoji = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => WhatsappPackStickersCompanion.insert(
                id: id,
                packId: packId,
                stickerId: stickerId,
                localPath: localPath,
                emoji: emoji,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WhatsappPackStickersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WhatsappPackStickersTable,
      WhatsappPackSticker,
      $$WhatsappPackStickersTableFilterComposer,
      $$WhatsappPackStickersTableOrderingComposer,
      $$WhatsappPackStickersTableAnnotationComposer,
      $$WhatsappPackStickersTableCreateCompanionBuilder,
      $$WhatsappPackStickersTableUpdateCompanionBuilder,
      (
        WhatsappPackSticker,
        BaseReferences<
          _$AppDatabase,
          $WhatsappPackStickersTable,
          WhatsappPackSticker
        >,
      ),
      WhatsappPackSticker,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WhatsappPackDraftsTableTableManager get whatsappPackDrafts =>
      $$WhatsappPackDraftsTableTableManager(_db, _db.whatsappPackDrafts);
  $$WhatsappPackStickersTableTableManager get whatsappPackStickers =>
      $$WhatsappPackStickersTableTableManager(_db, _db.whatsappPackStickers);
}
