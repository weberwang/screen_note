// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskEntity {

 String get id; String get title; String get note; DateTime? get dueAt; DateTime? get reminderAt; bool get isPinned; bool get isPrivate; TaskStatus get status; TaskReminderMode get reminderMode; DateTime get createdAt; DateTime get updatedAt; DateTime? get completedAt; DateTime? get deletedAt;
/// Create a copy of TaskEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskEntityCopyWith<TaskEntity> get copyWith => _$TaskEntityCopyWithImpl<TaskEntity>(this as TaskEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.reminderAt, reminderAt) || other.reminderAt == reminderAt)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.status, status) || other.status == status)&&(identical(other.reminderMode, reminderMode) || other.reminderMode == reminderMode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,note,dueAt,reminderAt,isPinned,isPrivate,status,reminderMode,createdAt,updatedAt,completedAt,deletedAt);

@override
String toString() {
  return 'TaskEntity(id: $id, title: $title, note: $note, dueAt: $dueAt, reminderAt: $reminderAt, isPinned: $isPinned, isPrivate: $isPrivate, status: $status, reminderMode: $reminderMode, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $TaskEntityCopyWith<$Res>  {
  factory $TaskEntityCopyWith(TaskEntity value, $Res Function(TaskEntity) _then) = _$TaskEntityCopyWithImpl;
@useResult
$Res call({
 String id, String title, String note, DateTime? dueAt, DateTime? reminderAt, bool isPinned, bool isPrivate, TaskStatus status, TaskReminderMode reminderMode, DateTime createdAt, DateTime updatedAt, DateTime? completedAt, DateTime? deletedAt
});




}
/// @nodoc
class _$TaskEntityCopyWithImpl<$Res>
    implements $TaskEntityCopyWith<$Res> {
  _$TaskEntityCopyWithImpl(this._self, this._then);

  final TaskEntity _self;
  final $Res Function(TaskEntity) _then;

/// Create a copy of TaskEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? note = null,Object? dueAt = freezed,Object? reminderAt = freezed,Object? isPinned = null,Object? isPrivate = null,Object? status = null,Object? reminderMode = null,Object? createdAt = null,Object? updatedAt = null,Object? completedAt = freezed,Object? deletedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reminderAt: freezed == reminderAt ? _self.reminderAt : reminderAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,reminderMode: null == reminderMode ? _self.reminderMode : reminderMode // ignore: cast_nullable_to_non_nullable
as TaskReminderMode,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskEntity].
extension TaskEntityPatterns on TaskEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskEntity value)  $default,){
final _that = this;
switch (_that) {
case _TaskEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TaskEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String note,  DateTime? dueAt,  DateTime? reminderAt,  bool isPinned,  bool isPrivate,  TaskStatus status,  TaskReminderMode reminderMode,  DateTime createdAt,  DateTime updatedAt,  DateTime? completedAt,  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskEntity() when $default != null:
return $default(_that.id,_that.title,_that.note,_that.dueAt,_that.reminderAt,_that.isPinned,_that.isPrivate,_that.status,_that.reminderMode,_that.createdAt,_that.updatedAt,_that.completedAt,_that.deletedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String note,  DateTime? dueAt,  DateTime? reminderAt,  bool isPinned,  bool isPrivate,  TaskStatus status,  TaskReminderMode reminderMode,  DateTime createdAt,  DateTime updatedAt,  DateTime? completedAt,  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _TaskEntity():
return $default(_that.id,_that.title,_that.note,_that.dueAt,_that.reminderAt,_that.isPinned,_that.isPrivate,_that.status,_that.reminderMode,_that.createdAt,_that.updatedAt,_that.completedAt,_that.deletedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String note,  DateTime? dueAt,  DateTime? reminderAt,  bool isPinned,  bool isPrivate,  TaskStatus status,  TaskReminderMode reminderMode,  DateTime createdAt,  DateTime updatedAt,  DateTime? completedAt,  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _TaskEntity() when $default != null:
return $default(_that.id,_that.title,_that.note,_that.dueAt,_that.reminderAt,_that.isPinned,_that.isPrivate,_that.status,_that.reminderMode,_that.createdAt,_that.updatedAt,_that.completedAt,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc


class _TaskEntity implements TaskEntity {
  const _TaskEntity({required this.id, required this.title, required this.note, required this.dueAt, required this.reminderAt, required this.isPinned, required this.isPrivate, required this.status, required this.reminderMode, required this.createdAt, required this.updatedAt, required this.completedAt, required this.deletedAt});
  

@override final  String id;
@override final  String title;
@override final  String note;
@override final  DateTime? dueAt;
@override final  DateTime? reminderAt;
@override final  bool isPinned;
@override final  bool isPrivate;
@override final  TaskStatus status;
@override final  TaskReminderMode reminderMode;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  DateTime? completedAt;
@override final  DateTime? deletedAt;

/// Create a copy of TaskEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskEntityCopyWith<_TaskEntity> get copyWith => __$TaskEntityCopyWithImpl<_TaskEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.reminderAt, reminderAt) || other.reminderAt == reminderAt)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.status, status) || other.status == status)&&(identical(other.reminderMode, reminderMode) || other.reminderMode == reminderMode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,note,dueAt,reminderAt,isPinned,isPrivate,status,reminderMode,createdAt,updatedAt,completedAt,deletedAt);

@override
String toString() {
  return 'TaskEntity(id: $id, title: $title, note: $note, dueAt: $dueAt, reminderAt: $reminderAt, isPinned: $isPinned, isPrivate: $isPrivate, status: $status, reminderMode: $reminderMode, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$TaskEntityCopyWith<$Res> implements $TaskEntityCopyWith<$Res> {
  factory _$TaskEntityCopyWith(_TaskEntity value, $Res Function(_TaskEntity) _then) = __$TaskEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String note, DateTime? dueAt, DateTime? reminderAt, bool isPinned, bool isPrivate, TaskStatus status, TaskReminderMode reminderMode, DateTime createdAt, DateTime updatedAt, DateTime? completedAt, DateTime? deletedAt
});




}
/// @nodoc
class __$TaskEntityCopyWithImpl<$Res>
    implements _$TaskEntityCopyWith<$Res> {
  __$TaskEntityCopyWithImpl(this._self, this._then);

  final _TaskEntity _self;
  final $Res Function(_TaskEntity) _then;

/// Create a copy of TaskEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? note = null,Object? dueAt = freezed,Object? reminderAt = freezed,Object? isPinned = null,Object? isPrivate = null,Object? status = null,Object? reminderMode = null,Object? createdAt = null,Object? updatedAt = null,Object? completedAt = freezed,Object? deletedAt = freezed,}) {
  return _then(_TaskEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reminderAt: freezed == reminderAt ? _self.reminderAt : reminderAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,reminderMode: null == reminderMode ? _self.reminderMode : reminderMode // ignore: cast_nullable_to_non_nullable
as TaskReminderMode,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
