// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskEvent {

 String get id; String get taskId; TaskEventAction get action; DateTime get createdAt; Map<String, Object?> get metadata;
/// Create a copy of TaskEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskEventCopyWith<TaskEvent> get copyWith => _$TaskEventCopyWithImpl<TaskEvent>(this as TaskEvent, _$identity);

  /// Serializes this TaskEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.action, action) || other.action == action)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskId,action,createdAt,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'TaskEvent(id: $id, taskId: $taskId, action: $action, createdAt: $createdAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $TaskEventCopyWith<$Res>  {
  factory $TaskEventCopyWith(TaskEvent value, $Res Function(TaskEvent) _then) = _$TaskEventCopyWithImpl;
@useResult
$Res call({
 String id, String taskId, TaskEventAction action, DateTime createdAt, Map<String, Object?> metadata
});




}
/// @nodoc
class _$TaskEventCopyWithImpl<$Res>
    implements $TaskEventCopyWith<$Res> {
  _$TaskEventCopyWithImpl(this._self, this._then);

  final TaskEvent _self;
  final $Res Function(TaskEvent) _then;

/// Create a copy of TaskEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? taskId = null,Object? action = null,Object? createdAt = null,Object? metadata = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as TaskEventAction,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskEvent].
extension TaskEventPatterns on TaskEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskEvent value)  $default,){
final _that = this;
switch (_that) {
case _TaskEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskEvent value)?  $default,){
final _that = this;
switch (_that) {
case _TaskEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String taskId,  TaskEventAction action,  DateTime createdAt,  Map<String, Object?> metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskEvent() when $default != null:
return $default(_that.id,_that.taskId,_that.action,_that.createdAt,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String taskId,  TaskEventAction action,  DateTime createdAt,  Map<String, Object?> metadata)  $default,) {final _that = this;
switch (_that) {
case _TaskEvent():
return $default(_that.id,_that.taskId,_that.action,_that.createdAt,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String taskId,  TaskEventAction action,  DateTime createdAt,  Map<String, Object?> metadata)?  $default,) {final _that = this;
switch (_that) {
case _TaskEvent() when $default != null:
return $default(_that.id,_that.taskId,_that.action,_that.createdAt,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskEvent implements TaskEvent {
  const _TaskEvent({required this.id, required this.taskId, required this.action, required this.createdAt, final  Map<String, Object?> metadata = const <String, Object?>{}}): _metadata = metadata;
  factory _TaskEvent.fromJson(Map<String, dynamic> json) => _$TaskEventFromJson(json);

@override final  String id;
@override final  String taskId;
@override final  TaskEventAction action;
@override final  DateTime createdAt;
 final  Map<String, Object?> _metadata;
@override@JsonKey() Map<String, Object?> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}


/// Create a copy of TaskEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskEventCopyWith<_TaskEvent> get copyWith => __$TaskEventCopyWithImpl<_TaskEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.action, action) || other.action == action)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskId,action,createdAt,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'TaskEvent(id: $id, taskId: $taskId, action: $action, createdAt: $createdAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$TaskEventCopyWith<$Res> implements $TaskEventCopyWith<$Res> {
  factory _$TaskEventCopyWith(_TaskEvent value, $Res Function(_TaskEvent) _then) = __$TaskEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String taskId, TaskEventAction action, DateTime createdAt, Map<String, Object?> metadata
});




}
/// @nodoc
class __$TaskEventCopyWithImpl<$Res>
    implements _$TaskEventCopyWith<$Res> {
  __$TaskEventCopyWithImpl(this._self, this._then);

  final _TaskEvent _self;
  final $Res Function(_TaskEvent) _then;

/// Create a copy of TaskEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? taskId = null,Object? action = null,Object? createdAt = null,Object? metadata = null,}) {
  return _then(_TaskEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as TaskEventAction,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}

// dart format on
