// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_flow_database.dart';

// ignore_for_file: type=lint
class $TaskRecordsTable extends TaskRecords
    with TableInfo<$TaskRecordsTable, TaskRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dueAtEpochMsMeta = const VerificationMeta(
    'dueAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> dueAtEpochMs = GeneratedColumn<int>(
    'due_at_epoch_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderAtEpochMsMeta = const VerificationMeta(
    'reminderAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> reminderAtEpochMs = GeneratedColumn<int>(
    'reminder_at_epoch_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isPrivateMeta = const VerificationMeta(
    'isPrivate',
  );
  @override
  late final GeneratedColumn<bool> isPrivate = GeneratedColumn<bool>(
    'is_private',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_private" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TaskStatus>($TaskRecordsTable.$converterstatus);
  @override
  late final GeneratedColumnWithTypeConverter<TaskReminderMode, String>
  reminderMode = GeneratedColumn<String>(
    'reminder_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TaskReminderMode>($TaskRecordsTable.$converterreminderMode);
  static const VerificationMeta _createdAtEpochMsMeta = const VerificationMeta(
    'createdAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> createdAtEpochMs = GeneratedColumn<int>(
    'created_at_epoch_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtEpochMsMeta = const VerificationMeta(
    'updatedAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtEpochMs = GeneratedColumn<int>(
    'updated_at_epoch_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtEpochMsMeta =
      const VerificationMeta('completedAtEpochMs');
  @override
  late final GeneratedColumn<int> completedAtEpochMs = GeneratedColumn<int>(
    'completed_at_epoch_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtEpochMsMeta = const VerificationMeta(
    'deletedAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> deletedAtEpochMs = GeneratedColumn<int>(
    'deleted_at_epoch_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    note,
    dueAtEpochMs,
    reminderAtEpochMs,
    isPinned,
    isPrivate,
    status,
    reminderMode,
    createdAtEpochMs,
    updatedAtEpochMs,
    completedAtEpochMs,
    deletedAtEpochMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('due_at_epoch_ms')) {
      context.handle(
        _dueAtEpochMsMeta,
        dueAtEpochMs.isAcceptableOrUnknown(
          data['due_at_epoch_ms']!,
          _dueAtEpochMsMeta,
        ),
      );
    }
    if (data.containsKey('reminder_at_epoch_ms')) {
      context.handle(
        _reminderAtEpochMsMeta,
        reminderAtEpochMs.isAcceptableOrUnknown(
          data['reminder_at_epoch_ms']!,
          _reminderAtEpochMsMeta,
        ),
      );
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    if (data.containsKey('is_private')) {
      context.handle(
        _isPrivateMeta,
        isPrivate.isAcceptableOrUnknown(data['is_private']!, _isPrivateMeta),
      );
    }
    if (data.containsKey('created_at_epoch_ms')) {
      context.handle(
        _createdAtEpochMsMeta,
        createdAtEpochMs.isAcceptableOrUnknown(
          data['created_at_epoch_ms']!,
          _createdAtEpochMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtEpochMsMeta);
    }
    if (data.containsKey('updated_at_epoch_ms')) {
      context.handle(
        _updatedAtEpochMsMeta,
        updatedAtEpochMs.isAcceptableOrUnknown(
          data['updated_at_epoch_ms']!,
          _updatedAtEpochMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtEpochMsMeta);
    }
    if (data.containsKey('completed_at_epoch_ms')) {
      context.handle(
        _completedAtEpochMsMeta,
        completedAtEpochMs.isAcceptableOrUnknown(
          data['completed_at_epoch_ms']!,
          _completedAtEpochMsMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at_epoch_ms')) {
      context.handle(
        _deletedAtEpochMsMeta,
        deletedAtEpochMs.isAcceptableOrUnknown(
          data['deleted_at_epoch_ms']!,
          _deletedAtEpochMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      dueAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_at_epoch_ms'],
      ),
      reminderAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_at_epoch_ms'],
      ),
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
      isPrivate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_private'],
      )!,
      status: $TaskRecordsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      reminderMode: $TaskRecordsTable.$converterreminderMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reminder_mode'],
        )!,
      ),
      createdAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_epoch_ms'],
      )!,
      updatedAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_epoch_ms'],
      )!,
      completedAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at_epoch_ms'],
      ),
      deletedAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at_epoch_ms'],
      ),
    );
  }

  @override
  $TaskRecordsTable createAlias(String alias) {
    return $TaskRecordsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskStatus, String, String> $converterstatus =
      const EnumNameConverter<TaskStatus>(TaskStatus.values);
  static JsonTypeConverter2<TaskReminderMode, String, String>
  $converterreminderMode = const EnumNameConverter<TaskReminderMode>(
    TaskReminderMode.values,
  );
}

class TaskRecord extends DataClass implements Insertable<TaskRecord> {
  /// 事项 ID。
  final String id;

  /// 标题。
  final String title;

  /// 备注。
  final String note;

  /// 到期时间毫秒戳。
  final int? dueAtEpochMs;

  /// 提醒时间毫秒戳。
  final int? reminderAtEpochMs;

  /// 是否置顶。
  final bool isPinned;

  /// 是否私密。
  final bool isPrivate;

  /// 持久状态。
  final TaskStatus status;

  /// 提醒模式。
  final TaskReminderMode reminderMode;

  /// 创建时间毫秒戳。
  final int createdAtEpochMs;

  /// 更新时间毫秒戳。
  final int updatedAtEpochMs;

  /// 完成时间毫秒戳。
  final int? completedAtEpochMs;

  /// 删除时间毫秒戳。
  final int? deletedAtEpochMs;
  const TaskRecord({
    required this.id,
    required this.title,
    required this.note,
    this.dueAtEpochMs,
    this.reminderAtEpochMs,
    required this.isPinned,
    required this.isPrivate,
    required this.status,
    required this.reminderMode,
    required this.createdAtEpochMs,
    required this.updatedAtEpochMs,
    this.completedAtEpochMs,
    this.deletedAtEpochMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || dueAtEpochMs != null) {
      map['due_at_epoch_ms'] = Variable<int>(dueAtEpochMs);
    }
    if (!nullToAbsent || reminderAtEpochMs != null) {
      map['reminder_at_epoch_ms'] = Variable<int>(reminderAtEpochMs);
    }
    map['is_pinned'] = Variable<bool>(isPinned);
    map['is_private'] = Variable<bool>(isPrivate);
    {
      map['status'] = Variable<String>(
        $TaskRecordsTable.$converterstatus.toSql(status),
      );
    }
    {
      map['reminder_mode'] = Variable<String>(
        $TaskRecordsTable.$converterreminderMode.toSql(reminderMode),
      );
    }
    map['created_at_epoch_ms'] = Variable<int>(createdAtEpochMs);
    map['updated_at_epoch_ms'] = Variable<int>(updatedAtEpochMs);
    if (!nullToAbsent || completedAtEpochMs != null) {
      map['completed_at_epoch_ms'] = Variable<int>(completedAtEpochMs);
    }
    if (!nullToAbsent || deletedAtEpochMs != null) {
      map['deleted_at_epoch_ms'] = Variable<int>(deletedAtEpochMs);
    }
    return map;
  }

  TaskRecordsCompanion toCompanion(bool nullToAbsent) {
    return TaskRecordsCompanion(
      id: Value(id),
      title: Value(title),
      note: Value(note),
      dueAtEpochMs: dueAtEpochMs == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAtEpochMs),
      reminderAtEpochMs: reminderAtEpochMs == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderAtEpochMs),
      isPinned: Value(isPinned),
      isPrivate: Value(isPrivate),
      status: Value(status),
      reminderMode: Value(reminderMode),
      createdAtEpochMs: Value(createdAtEpochMs),
      updatedAtEpochMs: Value(updatedAtEpochMs),
      completedAtEpochMs: completedAtEpochMs == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAtEpochMs),
      deletedAtEpochMs: deletedAtEpochMs == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtEpochMs),
    );
  }

  factory TaskRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRecord(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      note: serializer.fromJson<String>(json['note']),
      dueAtEpochMs: serializer.fromJson<int?>(json['dueAtEpochMs']),
      reminderAtEpochMs: serializer.fromJson<int?>(json['reminderAtEpochMs']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      isPrivate: serializer.fromJson<bool>(json['isPrivate']),
      status: $TaskRecordsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      reminderMode: $TaskRecordsTable.$converterreminderMode.fromJson(
        serializer.fromJson<String>(json['reminderMode']),
      ),
      createdAtEpochMs: serializer.fromJson<int>(json['createdAtEpochMs']),
      updatedAtEpochMs: serializer.fromJson<int>(json['updatedAtEpochMs']),
      completedAtEpochMs: serializer.fromJson<int?>(json['completedAtEpochMs']),
      deletedAtEpochMs: serializer.fromJson<int?>(json['deletedAtEpochMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'note': serializer.toJson<String>(note),
      'dueAtEpochMs': serializer.toJson<int?>(dueAtEpochMs),
      'reminderAtEpochMs': serializer.toJson<int?>(reminderAtEpochMs),
      'isPinned': serializer.toJson<bool>(isPinned),
      'isPrivate': serializer.toJson<bool>(isPrivate),
      'status': serializer.toJson<String>(
        $TaskRecordsTable.$converterstatus.toJson(status),
      ),
      'reminderMode': serializer.toJson<String>(
        $TaskRecordsTable.$converterreminderMode.toJson(reminderMode),
      ),
      'createdAtEpochMs': serializer.toJson<int>(createdAtEpochMs),
      'updatedAtEpochMs': serializer.toJson<int>(updatedAtEpochMs),
      'completedAtEpochMs': serializer.toJson<int?>(completedAtEpochMs),
      'deletedAtEpochMs': serializer.toJson<int?>(deletedAtEpochMs),
    };
  }

  TaskRecord copyWith({
    String? id,
    String? title,
    String? note,
    Value<int?> dueAtEpochMs = const Value.absent(),
    Value<int?> reminderAtEpochMs = const Value.absent(),
    bool? isPinned,
    bool? isPrivate,
    TaskStatus? status,
    TaskReminderMode? reminderMode,
    int? createdAtEpochMs,
    int? updatedAtEpochMs,
    Value<int?> completedAtEpochMs = const Value.absent(),
    Value<int?> deletedAtEpochMs = const Value.absent(),
  }) => TaskRecord(
    id: id ?? this.id,
    title: title ?? this.title,
    note: note ?? this.note,
    dueAtEpochMs: dueAtEpochMs.present ? dueAtEpochMs.value : this.dueAtEpochMs,
    reminderAtEpochMs: reminderAtEpochMs.present
        ? reminderAtEpochMs.value
        : this.reminderAtEpochMs,
    isPinned: isPinned ?? this.isPinned,
    isPrivate: isPrivate ?? this.isPrivate,
    status: status ?? this.status,
    reminderMode: reminderMode ?? this.reminderMode,
    createdAtEpochMs: createdAtEpochMs ?? this.createdAtEpochMs,
    updatedAtEpochMs: updatedAtEpochMs ?? this.updatedAtEpochMs,
    completedAtEpochMs: completedAtEpochMs.present
        ? completedAtEpochMs.value
        : this.completedAtEpochMs,
    deletedAtEpochMs: deletedAtEpochMs.present
        ? deletedAtEpochMs.value
        : this.deletedAtEpochMs,
  );
  TaskRecord copyWithCompanion(TaskRecordsCompanion data) {
    return TaskRecord(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
      dueAtEpochMs: data.dueAtEpochMs.present
          ? data.dueAtEpochMs.value
          : this.dueAtEpochMs,
      reminderAtEpochMs: data.reminderAtEpochMs.present
          ? data.reminderAtEpochMs.value
          : this.reminderAtEpochMs,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      isPrivate: data.isPrivate.present ? data.isPrivate.value : this.isPrivate,
      status: data.status.present ? data.status.value : this.status,
      reminderMode: data.reminderMode.present
          ? data.reminderMode.value
          : this.reminderMode,
      createdAtEpochMs: data.createdAtEpochMs.present
          ? data.createdAtEpochMs.value
          : this.createdAtEpochMs,
      updatedAtEpochMs: data.updatedAtEpochMs.present
          ? data.updatedAtEpochMs.value
          : this.updatedAtEpochMs,
      completedAtEpochMs: data.completedAtEpochMs.present
          ? data.completedAtEpochMs.value
          : this.completedAtEpochMs,
      deletedAtEpochMs: data.deletedAtEpochMs.present
          ? data.deletedAtEpochMs.value
          : this.deletedAtEpochMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRecord(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('dueAtEpochMs: $dueAtEpochMs, ')
          ..write('reminderAtEpochMs: $reminderAtEpochMs, ')
          ..write('isPinned: $isPinned, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('status: $status, ')
          ..write('reminderMode: $reminderMode, ')
          ..write('createdAtEpochMs: $createdAtEpochMs, ')
          ..write('updatedAtEpochMs: $updatedAtEpochMs, ')
          ..write('completedAtEpochMs: $completedAtEpochMs, ')
          ..write('deletedAtEpochMs: $deletedAtEpochMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    note,
    dueAtEpochMs,
    reminderAtEpochMs,
    isPinned,
    isPrivate,
    status,
    reminderMode,
    createdAtEpochMs,
    updatedAtEpochMs,
    completedAtEpochMs,
    deletedAtEpochMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRecord &&
          other.id == this.id &&
          other.title == this.title &&
          other.note == this.note &&
          other.dueAtEpochMs == this.dueAtEpochMs &&
          other.reminderAtEpochMs == this.reminderAtEpochMs &&
          other.isPinned == this.isPinned &&
          other.isPrivate == this.isPrivate &&
          other.status == this.status &&
          other.reminderMode == this.reminderMode &&
          other.createdAtEpochMs == this.createdAtEpochMs &&
          other.updatedAtEpochMs == this.updatedAtEpochMs &&
          other.completedAtEpochMs == this.completedAtEpochMs &&
          other.deletedAtEpochMs == this.deletedAtEpochMs);
}

class TaskRecordsCompanion extends UpdateCompanion<TaskRecord> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> note;
  final Value<int?> dueAtEpochMs;
  final Value<int?> reminderAtEpochMs;
  final Value<bool> isPinned;
  final Value<bool> isPrivate;
  final Value<TaskStatus> status;
  final Value<TaskReminderMode> reminderMode;
  final Value<int> createdAtEpochMs;
  final Value<int> updatedAtEpochMs;
  final Value<int?> completedAtEpochMs;
  final Value<int?> deletedAtEpochMs;
  final Value<int> rowid;
  const TaskRecordsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.dueAtEpochMs = const Value.absent(),
    this.reminderAtEpochMs = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.status = const Value.absent(),
    this.reminderMode = const Value.absent(),
    this.createdAtEpochMs = const Value.absent(),
    this.updatedAtEpochMs = const Value.absent(),
    this.completedAtEpochMs = const Value.absent(),
    this.deletedAtEpochMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskRecordsCompanion.insert({
    required String id,
    required String title,
    this.note = const Value.absent(),
    this.dueAtEpochMs = const Value.absent(),
    this.reminderAtEpochMs = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isPrivate = const Value.absent(),
    required TaskStatus status,
    required TaskReminderMode reminderMode,
    required int createdAtEpochMs,
    required int updatedAtEpochMs,
    this.completedAtEpochMs = const Value.absent(),
    this.deletedAtEpochMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       status = Value(status),
       reminderMode = Value(reminderMode),
       createdAtEpochMs = Value(createdAtEpochMs),
       updatedAtEpochMs = Value(updatedAtEpochMs);
  static Insertable<TaskRecord> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? note,
    Expression<int>? dueAtEpochMs,
    Expression<int>? reminderAtEpochMs,
    Expression<bool>? isPinned,
    Expression<bool>? isPrivate,
    Expression<String>? status,
    Expression<String>? reminderMode,
    Expression<int>? createdAtEpochMs,
    Expression<int>? updatedAtEpochMs,
    Expression<int>? completedAtEpochMs,
    Expression<int>? deletedAtEpochMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
      if (dueAtEpochMs != null) 'due_at_epoch_ms': dueAtEpochMs,
      if (reminderAtEpochMs != null) 'reminder_at_epoch_ms': reminderAtEpochMs,
      if (isPinned != null) 'is_pinned': isPinned,
      if (isPrivate != null) 'is_private': isPrivate,
      if (status != null) 'status': status,
      if (reminderMode != null) 'reminder_mode': reminderMode,
      if (createdAtEpochMs != null) 'created_at_epoch_ms': createdAtEpochMs,
      if (updatedAtEpochMs != null) 'updated_at_epoch_ms': updatedAtEpochMs,
      if (completedAtEpochMs != null)
        'completed_at_epoch_ms': completedAtEpochMs,
      if (deletedAtEpochMs != null) 'deleted_at_epoch_ms': deletedAtEpochMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? note,
    Value<int?>? dueAtEpochMs,
    Value<int?>? reminderAtEpochMs,
    Value<bool>? isPinned,
    Value<bool>? isPrivate,
    Value<TaskStatus>? status,
    Value<TaskReminderMode>? reminderMode,
    Value<int>? createdAtEpochMs,
    Value<int>? updatedAtEpochMs,
    Value<int?>? completedAtEpochMs,
    Value<int?>? deletedAtEpochMs,
    Value<int>? rowid,
  }) {
    return TaskRecordsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      dueAtEpochMs: dueAtEpochMs ?? this.dueAtEpochMs,
      reminderAtEpochMs: reminderAtEpochMs ?? this.reminderAtEpochMs,
      isPinned: isPinned ?? this.isPinned,
      isPrivate: isPrivate ?? this.isPrivate,
      status: status ?? this.status,
      reminderMode: reminderMode ?? this.reminderMode,
      createdAtEpochMs: createdAtEpochMs ?? this.createdAtEpochMs,
      updatedAtEpochMs: updatedAtEpochMs ?? this.updatedAtEpochMs,
      completedAtEpochMs: completedAtEpochMs ?? this.completedAtEpochMs,
      deletedAtEpochMs: deletedAtEpochMs ?? this.deletedAtEpochMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (dueAtEpochMs.present) {
      map['due_at_epoch_ms'] = Variable<int>(dueAtEpochMs.value);
    }
    if (reminderAtEpochMs.present) {
      map['reminder_at_epoch_ms'] = Variable<int>(reminderAtEpochMs.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (isPrivate.present) {
      map['is_private'] = Variable<bool>(isPrivate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $TaskRecordsTable.$converterstatus.toSql(status.value),
      );
    }
    if (reminderMode.present) {
      map['reminder_mode'] = Variable<String>(
        $TaskRecordsTable.$converterreminderMode.toSql(reminderMode.value),
      );
    }
    if (createdAtEpochMs.present) {
      map['created_at_epoch_ms'] = Variable<int>(createdAtEpochMs.value);
    }
    if (updatedAtEpochMs.present) {
      map['updated_at_epoch_ms'] = Variable<int>(updatedAtEpochMs.value);
    }
    if (completedAtEpochMs.present) {
      map['completed_at_epoch_ms'] = Variable<int>(completedAtEpochMs.value);
    }
    if (deletedAtEpochMs.present) {
      map['deleted_at_epoch_ms'] = Variable<int>(deletedAtEpochMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskRecordsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('dueAtEpochMs: $dueAtEpochMs, ')
          ..write('reminderAtEpochMs: $reminderAtEpochMs, ')
          ..write('isPinned: $isPinned, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('status: $status, ')
          ..write('reminderMode: $reminderMode, ')
          ..write('createdAtEpochMs: $createdAtEpochMs, ')
          ..write('updatedAtEpochMs: $updatedAtEpochMs, ')
          ..write('completedAtEpochMs: $completedAtEpochMs, ')
          ..write('deletedAtEpochMs: $deletedAtEpochMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskEventRecordsTable extends TaskEventRecords
    with TableInfo<$TaskEventRecordsTable, TaskEventRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskEventRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskStatus, String> fromStatus =
      GeneratedColumn<String>(
        'from_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TaskStatus>($TaskEventRecordsTable.$converterfromStatus);
  @override
  late final GeneratedColumnWithTypeConverter<TaskStatus, String> toStatus =
      GeneratedColumn<String>(
        'to_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TaskStatus>($TaskEventRecordsTable.$convertertoStatus);
  static const VerificationMeta _occurredAtEpochMsMeta = const VerificationMeta(
    'occurredAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> occurredAtEpochMs = GeneratedColumn<int>(
    'occurred_at_epoch_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    type,
    fromStatus,
    toStatus,
    occurredAtEpochMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_event_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskEventRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('occurred_at_epoch_ms')) {
      context.handle(
        _occurredAtEpochMsMeta,
        occurredAtEpochMs.isAcceptableOrUnknown(
          data['occurred_at_epoch_ms']!,
          _occurredAtEpochMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occurredAtEpochMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskEventRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskEventRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      fromStatus: $TaskEventRecordsTable.$converterfromStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}from_status'],
        )!,
      ),
      toStatus: $TaskEventRecordsTable.$convertertoStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}to_status'],
        )!,
      ),
      occurredAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurred_at_epoch_ms'],
      )!,
    );
  }

  @override
  $TaskEventRecordsTable createAlias(String alias) {
    return $TaskEventRecordsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskStatus, String, String> $converterfromStatus =
      const EnumNameConverter<TaskStatus>(TaskStatus.values);
  static JsonTypeConverter2<TaskStatus, String, String> $convertertoStatus =
      const EnumNameConverter<TaskStatus>(TaskStatus.values);
}

class TaskEventRecord extends DataClass implements Insertable<TaskEventRecord> {
  /// 事件 ID。
  final String id;

  /// 关联事项 ID。
  final String taskId;

  /// 事件类型。
  final String type;

  /// 变化前状态。
  final TaskStatus fromStatus;

  /// 变化后状态。
  final TaskStatus toStatus;

  /// 发生时间毫秒戳。
  final int occurredAtEpochMs;
  const TaskEventRecord({
    required this.id,
    required this.taskId,
    required this.type,
    required this.fromStatus,
    required this.toStatus,
    required this.occurredAtEpochMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['type'] = Variable<String>(type);
    {
      map['from_status'] = Variable<String>(
        $TaskEventRecordsTable.$converterfromStatus.toSql(fromStatus),
      );
    }
    {
      map['to_status'] = Variable<String>(
        $TaskEventRecordsTable.$convertertoStatus.toSql(toStatus),
      );
    }
    map['occurred_at_epoch_ms'] = Variable<int>(occurredAtEpochMs);
    return map;
  }

  TaskEventRecordsCompanion toCompanion(bool nullToAbsent) {
    return TaskEventRecordsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      type: Value(type),
      fromStatus: Value(fromStatus),
      toStatus: Value(toStatus),
      occurredAtEpochMs: Value(occurredAtEpochMs),
    );
  }

  factory TaskEventRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskEventRecord(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      type: serializer.fromJson<String>(json['type']),
      fromStatus: $TaskEventRecordsTable.$converterfromStatus.fromJson(
        serializer.fromJson<String>(json['fromStatus']),
      ),
      toStatus: $TaskEventRecordsTable.$convertertoStatus.fromJson(
        serializer.fromJson<String>(json['toStatus']),
      ),
      occurredAtEpochMs: serializer.fromJson<int>(json['occurredAtEpochMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'type': serializer.toJson<String>(type),
      'fromStatus': serializer.toJson<String>(
        $TaskEventRecordsTable.$converterfromStatus.toJson(fromStatus),
      ),
      'toStatus': serializer.toJson<String>(
        $TaskEventRecordsTable.$convertertoStatus.toJson(toStatus),
      ),
      'occurredAtEpochMs': serializer.toJson<int>(occurredAtEpochMs),
    };
  }

  TaskEventRecord copyWith({
    String? id,
    String? taskId,
    String? type,
    TaskStatus? fromStatus,
    TaskStatus? toStatus,
    int? occurredAtEpochMs,
  }) => TaskEventRecord(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    type: type ?? this.type,
    fromStatus: fromStatus ?? this.fromStatus,
    toStatus: toStatus ?? this.toStatus,
    occurredAtEpochMs: occurredAtEpochMs ?? this.occurredAtEpochMs,
  );
  TaskEventRecord copyWithCompanion(TaskEventRecordsCompanion data) {
    return TaskEventRecord(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      type: data.type.present ? data.type.value : this.type,
      fromStatus: data.fromStatus.present
          ? data.fromStatus.value
          : this.fromStatus,
      toStatus: data.toStatus.present ? data.toStatus.value : this.toStatus,
      occurredAtEpochMs: data.occurredAtEpochMs.present
          ? data.occurredAtEpochMs.value
          : this.occurredAtEpochMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskEventRecord(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('type: $type, ')
          ..write('fromStatus: $fromStatus, ')
          ..write('toStatus: $toStatus, ')
          ..write('occurredAtEpochMs: $occurredAtEpochMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, taskId, type, fromStatus, toStatus, occurredAtEpochMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskEventRecord &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.type == this.type &&
          other.fromStatus == this.fromStatus &&
          other.toStatus == this.toStatus &&
          other.occurredAtEpochMs == this.occurredAtEpochMs);
}

class TaskEventRecordsCompanion extends UpdateCompanion<TaskEventRecord> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> type;
  final Value<TaskStatus> fromStatus;
  final Value<TaskStatus> toStatus;
  final Value<int> occurredAtEpochMs;
  final Value<int> rowid;
  const TaskEventRecordsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.type = const Value.absent(),
    this.fromStatus = const Value.absent(),
    this.toStatus = const Value.absent(),
    this.occurredAtEpochMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskEventRecordsCompanion.insert({
    required String id,
    required String taskId,
    required String type,
    required TaskStatus fromStatus,
    required TaskStatus toStatus,
    required int occurredAtEpochMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       type = Value(type),
       fromStatus = Value(fromStatus),
       toStatus = Value(toStatus),
       occurredAtEpochMs = Value(occurredAtEpochMs);
  static Insertable<TaskEventRecord> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? type,
    Expression<String>? fromStatus,
    Expression<String>? toStatus,
    Expression<int>? occurredAtEpochMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (type != null) 'type': type,
      if (fromStatus != null) 'from_status': fromStatus,
      if (toStatus != null) 'to_status': toStatus,
      if (occurredAtEpochMs != null) 'occurred_at_epoch_ms': occurredAtEpochMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskEventRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<String>? type,
    Value<TaskStatus>? fromStatus,
    Value<TaskStatus>? toStatus,
    Value<int>? occurredAtEpochMs,
    Value<int>? rowid,
  }) {
    return TaskEventRecordsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      type: type ?? this.type,
      fromStatus: fromStatus ?? this.fromStatus,
      toStatus: toStatus ?? this.toStatus,
      occurredAtEpochMs: occurredAtEpochMs ?? this.occurredAtEpochMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (fromStatus.present) {
      map['from_status'] = Variable<String>(
        $TaskEventRecordsTable.$converterfromStatus.toSql(fromStatus.value),
      );
    }
    if (toStatus.present) {
      map['to_status'] = Variable<String>(
        $TaskEventRecordsTable.$convertertoStatus.toSql(toStatus.value),
      );
    }
    if (occurredAtEpochMs.present) {
      map['occurred_at_epoch_ms'] = Variable<int>(occurredAtEpochMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskEventRecordsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('type: $type, ')
          ..write('fromStatus: $fromStatus, ')
          ..write('toStatus: $toStatus, ')
          ..write('occurredAtEpochMs: $occurredAtEpochMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$TaskFlowDatabase extends GeneratedDatabase {
  _$TaskFlowDatabase(QueryExecutor e) : super(e);
  $TaskFlowDatabaseManager get managers => $TaskFlowDatabaseManager(this);
  late final $TaskRecordsTable taskRecords = $TaskRecordsTable(this);
  late final $TaskEventRecordsTable taskEventRecords = $TaskEventRecordsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    taskRecords,
    taskEventRecords,
  ];
}

typedef $$TaskRecordsTableCreateCompanionBuilder =
    TaskRecordsCompanion Function({
      required String id,
      required String title,
      Value<String> note,
      Value<int?> dueAtEpochMs,
      Value<int?> reminderAtEpochMs,
      Value<bool> isPinned,
      Value<bool> isPrivate,
      required TaskStatus status,
      required TaskReminderMode reminderMode,
      required int createdAtEpochMs,
      required int updatedAtEpochMs,
      Value<int?> completedAtEpochMs,
      Value<int?> deletedAtEpochMs,
      Value<int> rowid,
    });
typedef $$TaskRecordsTableUpdateCompanionBuilder =
    TaskRecordsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> note,
      Value<int?> dueAtEpochMs,
      Value<int?> reminderAtEpochMs,
      Value<bool> isPinned,
      Value<bool> isPrivate,
      Value<TaskStatus> status,
      Value<TaskReminderMode> reminderMode,
      Value<int> createdAtEpochMs,
      Value<int> updatedAtEpochMs,
      Value<int?> completedAtEpochMs,
      Value<int?> deletedAtEpochMs,
      Value<int> rowid,
    });

class $$TaskRecordsTableFilterComposer
    extends Composer<_$TaskFlowDatabase, $TaskRecordsTable> {
  $$TaskRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueAtEpochMs => $composableBuilder(
    column: $table.dueAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderAtEpochMs => $composableBuilder(
    column: $table.reminderAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPrivate => $composableBuilder(
    column: $table.isPrivate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskStatus, TaskStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<TaskReminderMode, TaskReminderMode, String>
  get reminderMode => $composableBuilder(
    column: $table.reminderMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtEpochMs => $composableBuilder(
    column: $table.updatedAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAtEpochMs => $composableBuilder(
    column: $table.completedAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAtEpochMs => $composableBuilder(
    column: $table.deletedAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskRecordsTableOrderingComposer
    extends Composer<_$TaskFlowDatabase, $TaskRecordsTable> {
  $$TaskRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueAtEpochMs => $composableBuilder(
    column: $table.dueAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderAtEpochMs => $composableBuilder(
    column: $table.reminderAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPrivate => $composableBuilder(
    column: $table.isPrivate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderMode => $composableBuilder(
    column: $table.reminderMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtEpochMs => $composableBuilder(
    column: $table.updatedAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAtEpochMs => $composableBuilder(
    column: $table.completedAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAtEpochMs => $composableBuilder(
    column: $table.deletedAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskRecordsTableAnnotationComposer
    extends Composer<_$TaskFlowDatabase, $TaskRecordsTable> {
  $$TaskRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get dueAtEpochMs => $composableBuilder(
    column: $table.dueAtEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderAtEpochMs => $composableBuilder(
    column: $table.reminderAtEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<bool> get isPrivate =>
      $composableBuilder(column: $table.isPrivate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskReminderMode, String> get reminderMode =>
      $composableBuilder(
        column: $table.reminderMode,
        builder: (column) => column,
      );

  GeneratedColumn<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtEpochMs => $composableBuilder(
    column: $table.updatedAtEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedAtEpochMs => $composableBuilder(
    column: $table.completedAtEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAtEpochMs => $composableBuilder(
    column: $table.deletedAtEpochMs,
    builder: (column) => column,
  );
}

class $$TaskRecordsTableTableManager
    extends
        RootTableManager<
          _$TaskFlowDatabase,
          $TaskRecordsTable,
          TaskRecord,
          $$TaskRecordsTableFilterComposer,
          $$TaskRecordsTableOrderingComposer,
          $$TaskRecordsTableAnnotationComposer,
          $$TaskRecordsTableCreateCompanionBuilder,
          $$TaskRecordsTableUpdateCompanionBuilder,
          (
            TaskRecord,
            BaseReferences<_$TaskFlowDatabase, $TaskRecordsTable, TaskRecord>,
          ),
          TaskRecord,
          PrefetchHooks Function()
        > {
  $$TaskRecordsTableTableManager(_$TaskFlowDatabase db, $TaskRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int?> dueAtEpochMs = const Value.absent(),
                Value<int?> reminderAtEpochMs = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isPrivate = const Value.absent(),
                Value<TaskStatus> status = const Value.absent(),
                Value<TaskReminderMode> reminderMode = const Value.absent(),
                Value<int> createdAtEpochMs = const Value.absent(),
                Value<int> updatedAtEpochMs = const Value.absent(),
                Value<int?> completedAtEpochMs = const Value.absent(),
                Value<int?> deletedAtEpochMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskRecordsCompanion(
                id: id,
                title: title,
                note: note,
                dueAtEpochMs: dueAtEpochMs,
                reminderAtEpochMs: reminderAtEpochMs,
                isPinned: isPinned,
                isPrivate: isPrivate,
                status: status,
                reminderMode: reminderMode,
                createdAtEpochMs: createdAtEpochMs,
                updatedAtEpochMs: updatedAtEpochMs,
                completedAtEpochMs: completedAtEpochMs,
                deletedAtEpochMs: deletedAtEpochMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String> note = const Value.absent(),
                Value<int?> dueAtEpochMs = const Value.absent(),
                Value<int?> reminderAtEpochMs = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isPrivate = const Value.absent(),
                required TaskStatus status,
                required TaskReminderMode reminderMode,
                required int createdAtEpochMs,
                required int updatedAtEpochMs,
                Value<int?> completedAtEpochMs = const Value.absent(),
                Value<int?> deletedAtEpochMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskRecordsCompanion.insert(
                id: id,
                title: title,
                note: note,
                dueAtEpochMs: dueAtEpochMs,
                reminderAtEpochMs: reminderAtEpochMs,
                isPinned: isPinned,
                isPrivate: isPrivate,
                status: status,
                reminderMode: reminderMode,
                createdAtEpochMs: createdAtEpochMs,
                updatedAtEpochMs: updatedAtEpochMs,
                completedAtEpochMs: completedAtEpochMs,
                deletedAtEpochMs: deletedAtEpochMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$TaskFlowDatabase,
      $TaskRecordsTable,
      TaskRecord,
      $$TaskRecordsTableFilterComposer,
      $$TaskRecordsTableOrderingComposer,
      $$TaskRecordsTableAnnotationComposer,
      $$TaskRecordsTableCreateCompanionBuilder,
      $$TaskRecordsTableUpdateCompanionBuilder,
      (
        TaskRecord,
        BaseReferences<_$TaskFlowDatabase, $TaskRecordsTable, TaskRecord>,
      ),
      TaskRecord,
      PrefetchHooks Function()
    >;
typedef $$TaskEventRecordsTableCreateCompanionBuilder =
    TaskEventRecordsCompanion Function({
      required String id,
      required String taskId,
      required String type,
      required TaskStatus fromStatus,
      required TaskStatus toStatus,
      required int occurredAtEpochMs,
      Value<int> rowid,
    });
typedef $$TaskEventRecordsTableUpdateCompanionBuilder =
    TaskEventRecordsCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<String> type,
      Value<TaskStatus> fromStatus,
      Value<TaskStatus> toStatus,
      Value<int> occurredAtEpochMs,
      Value<int> rowid,
    });

class $$TaskEventRecordsTableFilterComposer
    extends Composer<_$TaskFlowDatabase, $TaskEventRecordsTable> {
  $$TaskEventRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskStatus, TaskStatus, String>
  get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskStatus, TaskStatus, String> get toStatus =>
      $composableBuilder(
        column: $table.toStatus,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get occurredAtEpochMs => $composableBuilder(
    column: $table.occurredAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskEventRecordsTableOrderingComposer
    extends Composer<_$TaskFlowDatabase, $TaskEventRecordsTable> {
  $$TaskEventRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toStatus => $composableBuilder(
    column: $table.toStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get occurredAtEpochMs => $composableBuilder(
    column: $table.occurredAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskEventRecordsTableAnnotationComposer
    extends Composer<_$TaskFlowDatabase, $TaskEventRecordsTable> {
  $$TaskEventRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskStatus, String> get fromStatus =>
      $composableBuilder(
        column: $table.fromStatus,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<TaskStatus, String> get toStatus =>
      $composableBuilder(column: $table.toStatus, builder: (column) => column);

  GeneratedColumn<int> get occurredAtEpochMs => $composableBuilder(
    column: $table.occurredAtEpochMs,
    builder: (column) => column,
  );
}

class $$TaskEventRecordsTableTableManager
    extends
        RootTableManager<
          _$TaskFlowDatabase,
          $TaskEventRecordsTable,
          TaskEventRecord,
          $$TaskEventRecordsTableFilterComposer,
          $$TaskEventRecordsTableOrderingComposer,
          $$TaskEventRecordsTableAnnotationComposer,
          $$TaskEventRecordsTableCreateCompanionBuilder,
          $$TaskEventRecordsTableUpdateCompanionBuilder,
          (
            TaskEventRecord,
            BaseReferences<
              _$TaskFlowDatabase,
              $TaskEventRecordsTable,
              TaskEventRecord
            >,
          ),
          TaskEventRecord,
          PrefetchHooks Function()
        > {
  $$TaskEventRecordsTableTableManager(
    _$TaskFlowDatabase db,
    $TaskEventRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskEventRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskEventRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskEventRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<TaskStatus> fromStatus = const Value.absent(),
                Value<TaskStatus> toStatus = const Value.absent(),
                Value<int> occurredAtEpochMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskEventRecordsCompanion(
                id: id,
                taskId: taskId,
                type: type,
                fromStatus: fromStatus,
                toStatus: toStatus,
                occurredAtEpochMs: occurredAtEpochMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required String type,
                required TaskStatus fromStatus,
                required TaskStatus toStatus,
                required int occurredAtEpochMs,
                Value<int> rowid = const Value.absent(),
              }) => TaskEventRecordsCompanion.insert(
                id: id,
                taskId: taskId,
                type: type,
                fromStatus: fromStatus,
                toStatus: toStatus,
                occurredAtEpochMs: occurredAtEpochMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskEventRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$TaskFlowDatabase,
      $TaskEventRecordsTable,
      TaskEventRecord,
      $$TaskEventRecordsTableFilterComposer,
      $$TaskEventRecordsTableOrderingComposer,
      $$TaskEventRecordsTableAnnotationComposer,
      $$TaskEventRecordsTableCreateCompanionBuilder,
      $$TaskEventRecordsTableUpdateCompanionBuilder,
      (
        TaskEventRecord,
        BaseReferences<
          _$TaskFlowDatabase,
          $TaskEventRecordsTable,
          TaskEventRecord
        >,
      ),
      TaskEventRecord,
      PrefetchHooks Function()
    >;

class $TaskFlowDatabaseManager {
  final _$TaskFlowDatabase _db;
  $TaskFlowDatabaseManager(this._db);
  $$TaskRecordsTableTableManager get taskRecords =>
      $$TaskRecordsTableTableManager(_db, _db.taskRecords);
  $$TaskEventRecordsTableTableManager get taskEventRecords =>
      $$TaskEventRecordsTableTableManager(_db, _db.taskEventRecords);
}
