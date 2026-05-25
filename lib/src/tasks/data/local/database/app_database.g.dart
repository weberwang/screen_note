// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TasksTableTable extends TasksTable
    with TableInfo<$TasksTableTable, TaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTableTable(this.attachedDatabase, [this._alias]);
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TaskStatus>($TasksTableTable.$converterstatus);
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
  late final GeneratedColumnWithTypeConverter<TaskReminderMode, String>
  reminderMode = GeneratedColumn<String>(
    'reminder_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TaskReminderMode>($TasksTableTable.$converterreminderMode);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    note,
    status,
    dueAt,
    isPinned,
    isPrivate,
    reminderMode,
    createdAt,
    updatedAt,
    completedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRow> instance, {
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
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRow(
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
      ),
      status: $TasksTableTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      ),
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
      isPrivate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_private'],
      )!,
      reminderMode: $TasksTableTable.$converterreminderMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reminder_mode'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $TasksTableTable createAlias(String alias) {
    return $TasksTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskStatus, String, String> $converterstatus =
      const EnumNameConverter<TaskStatus>(TaskStatus.values);
  static JsonTypeConverter2<TaskReminderMode, String, String>
  $converterreminderMode = const EnumNameConverter<TaskReminderMode>(
    TaskReminderMode.values,
  );
}

class TaskRow extends DataClass implements Insertable<TaskRow> {
  /// 事项唯一标识。
  final String id;

  /// 事项标题。
  final String title;

  /// 事项备注。
  final String? note;

  /// 持久状态。
  ///
  /// 这里只允许三种稳定状态，过期展示通过 `dueAt` 在上层派生，不单独落库。
  final TaskStatus status;

  /// 截止或提醒时间。
  final DateTime? dueAt;

  /// 是否置顶。
  final bool isPinned;

  /// 是否隐私事项。
  final bool isPrivate;

  /// 提醒模式。
  final TaskReminderMode reminderMode;

  /// 创建时间。
  final DateTime createdAt;

  /// 更新时间。
  final DateTime updatedAt;

  /// 完成时间。
  final DateTime? completedAt;

  /// 软删除时间。
  final DateTime? deletedAt;
  const TaskRow({
    required this.id,
    required this.title,
    this.note,
    required this.status,
    this.dueAt,
    required this.isPinned,
    required this.isPrivate,
    required this.reminderMode,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    {
      map['status'] = Variable<String>(
        $TasksTableTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<DateTime>(dueAt);
    }
    map['is_pinned'] = Variable<bool>(isPinned);
    map['is_private'] = Variable<bool>(isPrivate);
    {
      map['reminder_mode'] = Variable<String>(
        $TasksTableTable.$converterreminderMode.toSql(reminderMode),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  TasksTableCompanion toCompanion(bool nullToAbsent) {
    return TasksTableCompanion(
      id: Value(id),
      title: Value(title),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      status: Value(status),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      isPinned: Value(isPinned),
      isPrivate: Value(isPrivate),
      reminderMode: Value(reminderMode),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory TaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      note: serializer.fromJson<String?>(json['note']),
      status: $TasksTableTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      dueAt: serializer.fromJson<DateTime?>(json['dueAt']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      isPrivate: serializer.fromJson<bool>(json['isPrivate']),
      reminderMode: $TasksTableTable.$converterreminderMode.fromJson(
        serializer.fromJson<String>(json['reminderMode']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'note': serializer.toJson<String?>(note),
      'status': serializer.toJson<String>(
        $TasksTableTable.$converterstatus.toJson(status),
      ),
      'dueAt': serializer.toJson<DateTime?>(dueAt),
      'isPinned': serializer.toJson<bool>(isPinned),
      'isPrivate': serializer.toJson<bool>(isPrivate),
      'reminderMode': serializer.toJson<String>(
        $TasksTableTable.$converterreminderMode.toJson(reminderMode),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  TaskRow copyWith({
    String? id,
    String? title,
    Value<String?> note = const Value.absent(),
    TaskStatus? status,
    Value<DateTime?> dueAt = const Value.absent(),
    bool? isPinned,
    bool? isPrivate,
    TaskReminderMode? reminderMode,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => TaskRow(
    id: id ?? this.id,
    title: title ?? this.title,
    note: note.present ? note.value : this.note,
    status: status ?? this.status,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    isPinned: isPinned ?? this.isPinned,
    isPrivate: isPrivate ?? this.isPrivate,
    reminderMode: reminderMode ?? this.reminderMode,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  TaskRow copyWithCompanion(TasksTableCompanion data) {
    return TaskRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
      status: data.status.present ? data.status.value : this.status,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      isPrivate: data.isPrivate.present ? data.isPrivate.value : this.isPrivate,
      reminderMode: data.reminderMode.present
          ? data.reminderMode.value
          : this.reminderMode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('dueAt: $dueAt, ')
          ..write('isPinned: $isPinned, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('reminderMode: $reminderMode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    note,
    status,
    dueAt,
    isPinned,
    isPrivate,
    reminderMode,
    createdAt,
    updatedAt,
    completedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.note == this.note &&
          other.status == this.status &&
          other.dueAt == this.dueAt &&
          other.isPinned == this.isPinned &&
          other.isPrivate == this.isPrivate &&
          other.reminderMode == this.reminderMode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.completedAt == this.completedAt &&
          other.deletedAt == this.deletedAt);
}

class TasksTableCompanion extends UpdateCompanion<TaskRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> note;
  final Value<TaskStatus> status;
  final Value<DateTime?> dueAt;
  final Value<bool> isPinned;
  final Value<bool> isPrivate;
  final Value<TaskReminderMode> reminderMode;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const TasksTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.reminderMode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksTableCompanion.insert({
    required String id,
    required String title,
    this.note = const Value.absent(),
    required TaskStatus status,
    this.dueAt = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isPrivate = const Value.absent(),
    required TaskReminderMode reminderMode,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.completedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       status = Value(status),
       reminderMode = Value(reminderMode),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TaskRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? note,
    Expression<String>? status,
    Expression<DateTime>? dueAt,
    Expression<bool>? isPinned,
    Expression<bool>? isPrivate,
    Expression<String>? reminderMode,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
      if (status != null) 'status': status,
      if (dueAt != null) 'due_at': dueAt,
      if (isPinned != null) 'is_pinned': isPinned,
      if (isPrivate != null) 'is_private': isPrivate,
      if (reminderMode != null) 'reminder_mode': reminderMode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? note,
    Value<TaskStatus>? status,
    Value<DateTime?>? dueAt,
    Value<bool>? isPinned,
    Value<bool>? isPrivate,
    Value<TaskReminderMode>? reminderMode,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? completedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return TasksTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      status: status ?? this.status,
      dueAt: dueAt ?? this.dueAt,
      isPinned: isPinned ?? this.isPinned,
      isPrivate: isPrivate ?? this.isPrivate,
      reminderMode: reminderMode ?? this.reminderMode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      deletedAt: deletedAt ?? this.deletedAt,
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
    if (status.present) {
      map['status'] = Variable<String>(
        $TasksTableTable.$converterstatus.toSql(status.value),
      );
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (isPrivate.present) {
      map['is_private'] = Variable<bool>(isPrivate.value);
    }
    if (reminderMode.present) {
      map['reminder_mode'] = Variable<String>(
        $TasksTableTable.$converterreminderMode.toSql(reminderMode.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('dueAt: $dueAt, ')
          ..write('isPinned: $isPinned, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('reminderMode: $reminderMode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskEventsTableTable extends TaskEventsTable
    with TableInfo<$TaskEventsTableTable, TaskEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskEventsTableTable(this.attachedDatabase, [this._alias]);
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks_table (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskEventAction, String> action =
      GeneratedColumn<String>(
        'action',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TaskEventAction>($TaskEventsTableTable.$converteraction);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String>
  metadata =
      GeneratedColumn<String>(
        'metadata',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      ).withConverter<Map<String, Object?>>(
        $TaskEventsTableTable.$convertermetadata,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    action,
    createdAt,
    metadata,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_events_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskEventRow> instance, {
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      action: $TaskEventsTableTable.$converteraction.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}action'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      metadata: $TaskEventsTableTable.$convertermetadata.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}metadata'],
        )!,
      ),
    );
  }

  @override
  $TaskEventsTableTable createAlias(String alias) {
    return $TaskEventsTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskEventAction, String, String> $converteraction =
      const EnumNameConverter<TaskEventAction>(TaskEventAction.values);
  static TypeConverter<Map<String, Object?>, String> $convertermetadata =
      const JsonMapConverter();
}

class TaskEventRow extends DataClass implements Insertable<TaskEventRow> {
  /// 日志唯一标识。
  final String id;

  /// 关联事项 ID。
  final String taskId;

  /// 操作类型。
  ///
  /// `expire` 只表示进入过期显示的记录，不代表事项被写成新的持久状态。
  final TaskEventAction action;

  /// 日志创建时间。
  final DateTime createdAt;

  /// 额外上下文。
  final Map<String, Object?> metadata;
  const TaskEventRow({
    required this.id,
    required this.taskId,
    required this.action,
    required this.createdAt,
    required this.metadata,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    {
      map['action'] = Variable<String>(
        $TaskEventsTableTable.$converteraction.toSql(action),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    {
      map['metadata'] = Variable<String>(
        $TaskEventsTableTable.$convertermetadata.toSql(metadata),
      );
    }
    return map;
  }

  TaskEventsTableCompanion toCompanion(bool nullToAbsent) {
    return TaskEventsTableCompanion(
      id: Value(id),
      taskId: Value(taskId),
      action: Value(action),
      createdAt: Value(createdAt),
      metadata: Value(metadata),
    );
  }

  factory TaskEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskEventRow(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      action: $TaskEventsTableTable.$converteraction.fromJson(
        serializer.fromJson<String>(json['action']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      metadata: serializer.fromJson<Map<String, Object?>>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'action': serializer.toJson<String>(
        $TaskEventsTableTable.$converteraction.toJson(action),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'metadata': serializer.toJson<Map<String, Object?>>(metadata),
    };
  }

  TaskEventRow copyWith({
    String? id,
    String? taskId,
    TaskEventAction? action,
    DateTime? createdAt,
    Map<String, Object?>? metadata,
  }) => TaskEventRow(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    action: action ?? this.action,
    createdAt: createdAt ?? this.createdAt,
    metadata: metadata ?? this.metadata,
  );
  TaskEventRow copyWithCompanion(TaskEventsTableCompanion data) {
    return TaskEventRow(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      action: data.action.present ? data.action.value : this.action,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskEventRow(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('action: $action, ')
          ..write('createdAt: $createdAt, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, action, createdAt, metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskEventRow &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.action == this.action &&
          other.createdAt == this.createdAt &&
          other.metadata == this.metadata);
}

class TaskEventsTableCompanion extends UpdateCompanion<TaskEventRow> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<TaskEventAction> action;
  final Value<DateTime> createdAt;
  final Value<Map<String, Object?>> metadata;
  final Value<int> rowid;
  const TaskEventsTableCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.action = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskEventsTableCompanion.insert({
    required String id,
    required String taskId,
    required TaskEventAction action,
    required DateTime createdAt,
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       action = Value(action),
       createdAt = Value(createdAt);
  static Insertable<TaskEventRow> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? action,
    Expression<DateTime>? createdAt,
    Expression<String>? metadata,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (action != null) 'action': action,
      if (createdAt != null) 'created_at': createdAt,
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskEventsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<TaskEventAction>? action,
    Value<DateTime>? createdAt,
    Value<Map<String, Object?>>? metadata,
    Value<int>? rowid,
  }) {
    return TaskEventsTableCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      action: action ?? this.action,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
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
    if (action.present) {
      map['action'] = Variable<String>(
        $TaskEventsTableTable.$converteraction.toSql(action.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(
        $TaskEventsTableTable.$convertermetadata.toSql(metadata.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskEventsTableCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('action: $action, ')
          ..write('createdAt: $createdAt, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TasksTableTable tasksTable = $TasksTableTable(this);
  late final $TaskEventsTableTable taskEventsTable = $TaskEventsTableTable(
    this,
  );
  late final Index tasksStatusUpdatedAtIdx = Index(
    'tasks_status_updated_at_idx',
    'CREATE INDEX tasks_status_updated_at_idx ON tasks_table (status, updated_at)',
  );
  late final Index tasksDueAtIdx = Index(
    'tasks_due_at_idx',
    'CREATE INDEX tasks_due_at_idx ON tasks_table (due_at)',
  );
  late final Index tasksDeletedAtIdx = Index(
    'tasks_deleted_at_idx',
    'CREATE INDEX tasks_deleted_at_idx ON tasks_table (deleted_at)',
  );
  late final Index taskEventsTaskIdCreatedAtIdx = Index(
    'task_events_task_id_created_at_idx',
    'CREATE INDEX task_events_task_id_created_at_idx ON task_events_table (task_id, created_at)',
  );
  late final Index taskEventsActionIdx = Index(
    'task_events_action_idx',
    'CREATE INDEX task_events_action_idx ON task_events_table ("action")',
  );
  late final TasksDao tasksDao = TasksDao(this as AppDatabase);
  late final TaskEventsDao taskEventsDao = TaskEventsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tasksTable,
    taskEventsTable,
    tasksStatusUpdatedAtIdx,
    tasksDueAtIdx,
    tasksDeletedAtIdx,
    taskEventsTaskIdCreatedAtIdx,
    taskEventsActionIdx,
  ];
}

typedef $$TasksTableTableCreateCompanionBuilder =
    TasksTableCompanion Function({
      required String id,
      required String title,
      Value<String?> note,
      required TaskStatus status,
      Value<DateTime?> dueAt,
      Value<bool> isPinned,
      Value<bool> isPrivate,
      required TaskReminderMode reminderMode,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> completedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$TasksTableTableUpdateCompanionBuilder =
    TasksTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> note,
      Value<TaskStatus> status,
      Value<DateTime?> dueAt,
      Value<bool> isPinned,
      Value<bool> isPrivate,
      Value<TaskReminderMode> reminderMode,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> completedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$TasksTableTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTableTable, TaskRow> {
  $$TasksTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TaskEventsTableTable, List<TaskEventRow>>
  _taskEventsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskEventsTable,
    aliasName: $_aliasNameGenerator(
      db.tasksTable.id,
      db.taskEventsTable.taskId,
    ),
  );

  $$TaskEventsTableTableProcessedTableManager get taskEventsTableRefs {
    final manager = $$TaskEventsTableTableTableManager(
      $_db,
      $_db.taskEventsTable,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskEventsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableTableFilterComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableFilterComposer({
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

  ColumnWithTypeConverterFilters<TaskStatus, TaskStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
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

  ColumnWithTypeConverterFilters<TaskReminderMode, TaskReminderMode, String>
  get reminderMode => $composableBuilder(
    column: $table.reminderMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> taskEventsTableRefs(
    Expression<bool> Function($$TaskEventsTableTableFilterComposer f) f,
  ) {
    final $$TaskEventsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskEventsTable,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEventsTableTableFilterComposer(
            $db: $db,
            $table: $db.taskEventsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableOrderingComposer({
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

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
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

  ColumnOrderings<String> get reminderMode => $composableBuilder(
    column: $table.reminderMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableAnnotationComposer({
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

  GeneratedColumnWithTypeConverter<TaskStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<bool> get isPrivate =>
      $composableBuilder(column: $table.isPrivate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskReminderMode, String> get reminderMode =>
      $composableBuilder(
        column: $table.reminderMode,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> taskEventsTableRefs<T extends Object>(
    Expression<T> Function($$TaskEventsTableTableAnnotationComposer a) f,
  ) {
    final $$TaskEventsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskEventsTable,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEventsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.taskEventsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTableTable,
          TaskRow,
          $$TasksTableTableFilterComposer,
          $$TasksTableTableOrderingComposer,
          $$TasksTableTableAnnotationComposer,
          $$TasksTableTableCreateCompanionBuilder,
          $$TasksTableTableUpdateCompanionBuilder,
          (TaskRow, $$TasksTableTableReferences),
          TaskRow,
          PrefetchHooks Function({bool taskEventsTableRefs})
        > {
  $$TasksTableTableTableManager(_$AppDatabase db, $TasksTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<TaskStatus> status = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isPrivate = const Value.absent(),
                Value<TaskReminderMode> reminderMode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksTableCompanion(
                id: id,
                title: title,
                note: note,
                status: status,
                dueAt: dueAt,
                isPinned: isPinned,
                isPrivate: isPrivate,
                reminderMode: reminderMode,
                createdAt: createdAt,
                updatedAt: updatedAt,
                completedAt: completedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> note = const Value.absent(),
                required TaskStatus status,
                Value<DateTime?> dueAt = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isPrivate = const Value.absent(),
                required TaskReminderMode reminderMode,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksTableCompanion.insert(
                id: id,
                title: title,
                note: note,
                status: status,
                dueAt: dueAt,
                isPinned: isPinned,
                isPrivate: isPrivate,
                reminderMode: reminderMode,
                createdAt: createdAt,
                updatedAt: updatedAt,
                completedAt: completedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TasksTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskEventsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (taskEventsTableRefs) db.taskEventsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskEventsTableRefs)
                    await $_getPrefetchedData<
                      TaskRow,
                      $TasksTableTable,
                      TaskEventRow
                    >(
                      currentTable: table,
                      referencedTable: $$TasksTableTableReferences
                          ._taskEventsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TasksTableTableReferences(
                            db,
                            table,
                            p0,
                          ).taskEventsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.taskId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TasksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTableTable,
      TaskRow,
      $$TasksTableTableFilterComposer,
      $$TasksTableTableOrderingComposer,
      $$TasksTableTableAnnotationComposer,
      $$TasksTableTableCreateCompanionBuilder,
      $$TasksTableTableUpdateCompanionBuilder,
      (TaskRow, $$TasksTableTableReferences),
      TaskRow,
      PrefetchHooks Function({bool taskEventsTableRefs})
    >;
typedef $$TaskEventsTableTableCreateCompanionBuilder =
    TaskEventsTableCompanion Function({
      required String id,
      required String taskId,
      required TaskEventAction action,
      required DateTime createdAt,
      Value<Map<String, Object?>> metadata,
      Value<int> rowid,
    });
typedef $$TaskEventsTableTableUpdateCompanionBuilder =
    TaskEventsTableCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<TaskEventAction> action,
      Value<DateTime> createdAt,
      Value<Map<String, Object?>> metadata,
      Value<int> rowid,
    });

final class $$TaskEventsTableTableReferences
    extends BaseReferences<_$AppDatabase, $TaskEventsTableTable, TaskEventRow> {
  $$TaskEventsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTableTable _taskIdTable(_$AppDatabase db) =>
      db.tasksTable.createAlias(
        $_aliasNameGenerator(db.taskEventsTable.taskId, db.tasksTable.id),
      );

  $$TasksTableTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableTableManager(
      $_db,
      $_db.tasksTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskEventsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TaskEventsTableTable> {
  $$TaskEventsTableTableFilterComposer({
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

  ColumnWithTypeConverterFilters<TaskEventAction, TaskEventAction, String>
  get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>,
    Map<String, Object>,
    String
  >
  get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$TasksTableTableFilterComposer get taskId {
    final $$TasksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableFilterComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskEventsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskEventsTableTable> {
  $$TaskEventsTableTableOrderingComposer({
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

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableTableOrderingComposer get taskId {
    final $$TasksTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableOrderingComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskEventsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskEventsTableTable> {
  $$TaskEventsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskEventAction, String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, Object?>, String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  $$TasksTableTableAnnotationComposer get taskId {
    final $$TasksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskEventsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskEventsTableTable,
          TaskEventRow,
          $$TaskEventsTableTableFilterComposer,
          $$TaskEventsTableTableOrderingComposer,
          $$TaskEventsTableTableAnnotationComposer,
          $$TaskEventsTableTableCreateCompanionBuilder,
          $$TaskEventsTableTableUpdateCompanionBuilder,
          (TaskEventRow, $$TaskEventsTableTableReferences),
          TaskEventRow,
          PrefetchHooks Function({bool taskId})
        > {
  $$TaskEventsTableTableTableManager(
    _$AppDatabase db,
    $TaskEventsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskEventsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskEventsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskEventsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<TaskEventAction> action = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<Map<String, Object?>> metadata = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskEventsTableCompanion(
                id: id,
                taskId: taskId,
                action: action,
                createdAt: createdAt,
                metadata: metadata,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required TaskEventAction action,
                required DateTime createdAt,
                Value<Map<String, Object?>> metadata = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskEventsTableCompanion.insert(
                id: id,
                taskId: taskId,
                action: action,
                createdAt: createdAt,
                metadata: metadata,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskEventsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
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
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable:
                                    $$TaskEventsTableTableReferences
                                        ._taskIdTable(db),
                                referencedColumn:
                                    $$TaskEventsTableTableReferences
                                        ._taskIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$TaskEventsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskEventsTableTable,
      TaskEventRow,
      $$TaskEventsTableTableFilterComposer,
      $$TaskEventsTableTableOrderingComposer,
      $$TaskEventsTableTableAnnotationComposer,
      $$TaskEventsTableTableCreateCompanionBuilder,
      $$TaskEventsTableTableUpdateCompanionBuilder,
      (TaskEventRow, $$TaskEventsTableTableReferences),
      TaskEventRow,
      PrefetchHooks Function({bool taskId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TasksTableTableTableManager get tasksTable =>
      $$TasksTableTableTableManager(_db, _db.tasksTable);
  $$TaskEventsTableTableTableManager get taskEventsTable =>
      $$TaskEventsTableTableTableManager(_db, _db.taskEventsTable);
}
