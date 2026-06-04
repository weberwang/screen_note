// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_event_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskEventEntity {

 String get id; String get taskId; TaskEventType get type; DateTime get occurredAt;
/// Create a copy of TaskEventEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskEventEntityCopyWith<TaskEventEntity> get copyWith => _$TaskEventEntityCopyWithImpl<TaskEventEntity>(this as TaskEventEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskEventEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.type, type) || other.type == type)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,taskId,type,occurredAt);

@override
String toString() {
  return 'TaskEventEntity(id: $id, taskId: $taskId, type: $type, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class $TaskEventEntityCopyWith<$Res>  {
  factory $TaskEventEntityCopyWith(TaskEventEntity value, $Res Function(TaskEventEntity) _then) = _$TaskEventEntityCopyWithImpl;
@useResult
$Res call({
 String id, String taskId, TaskEventType type, DateTime occurredAt
});




}
/// @nodoc
class _$TaskEventEntityCopyWithImpl<$Res>
    implements $TaskEventEntityCopyWith<$Res> {
  _$TaskEventEntityCopyWithImpl(this._self, this._then);

  final TaskEventEntity _self;
  final $Res Function(TaskEventEntity) _then;

/// Create a copy of TaskEventEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? taskId = null,Object? type = null,Object? occurredAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskEventType,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskEventEntity].
extension TaskEventEntityPatterns on TaskEventEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskEventEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskEventEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskEventEntity value)  $default,){
final _that = this;
switch (_that) {
case _TaskEventEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskEventEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TaskEventEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String taskId,  TaskEventType type,  DateTime occurredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskEventEntity() when $default != null:
return $default(_that.id,_that.taskId,_that.type,_that.occurredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String taskId,  TaskEventType type,  DateTime occurredAt)  $default,) {final _that = this;
switch (_that) {
case _TaskEventEntity():
return $default(_that.id,_that.taskId,_that.type,_that.occurredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String taskId,  TaskEventType type,  DateTime occurredAt)?  $default,) {final _that = this;
switch (_that) {
case _TaskEventEntity() when $default != null:
return $default(_that.id,_that.taskId,_that.type,_that.occurredAt);case _:
  return null;

}
}

}

/// @nodoc


class _TaskEventEntity implements TaskEventEntity {
  const _TaskEventEntity({required this.id, required this.taskId, required this.type, required this.occurredAt});
  

@override final  String id;
@override final  String taskId;
@override final  TaskEventType type;
@override final  DateTime occurredAt;

/// Create a copy of TaskEventEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskEventEntityCopyWith<_TaskEventEntity> get copyWith => __$TaskEventEntityCopyWithImpl<_TaskEventEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskEventEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.type, type) || other.type == type)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,taskId,type,occurredAt);

@override
String toString() {
  return 'TaskEventEntity(id: $id, taskId: $taskId, type: $type, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class _$TaskEventEntityCopyWith<$Res> implements $TaskEventEntityCopyWith<$Res> {
  factory _$TaskEventEntityCopyWith(_TaskEventEntity value, $Res Function(_TaskEventEntity) _then) = __$TaskEventEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String taskId, TaskEventType type, DateTime occurredAt
});




}
/// @nodoc
class __$TaskEventEntityCopyWithImpl<$Res>
    implements _$TaskEventEntityCopyWith<$Res> {
  __$TaskEventEntityCopyWithImpl(this._self, this._then);

  final _TaskEventEntity _self;
  final $Res Function(_TaskEventEntity) _then;

/// Create a copy of TaskEventEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? taskId = null,Object? type = null,Object? occurredAt = null,}) {
  return _then(_TaskEventEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskEventType,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
