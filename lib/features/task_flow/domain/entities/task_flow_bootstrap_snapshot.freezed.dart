// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_flow_bootstrap_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskFlowBootstrapSnapshot {

 int get activePreviewCount; int get completedPreviewCount; int get deletedPreviewCount; bool get widgetProjectionReady; bool get privacySafeByDefault;
/// Create a copy of TaskFlowBootstrapSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskFlowBootstrapSnapshotCopyWith<TaskFlowBootstrapSnapshot> get copyWith => _$TaskFlowBootstrapSnapshotCopyWithImpl<TaskFlowBootstrapSnapshot>(this as TaskFlowBootstrapSnapshot, _$identity);

  /// Serializes this TaskFlowBootstrapSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFlowBootstrapSnapshot&&(identical(other.activePreviewCount, activePreviewCount) || other.activePreviewCount == activePreviewCount)&&(identical(other.completedPreviewCount, completedPreviewCount) || other.completedPreviewCount == completedPreviewCount)&&(identical(other.deletedPreviewCount, deletedPreviewCount) || other.deletedPreviewCount == deletedPreviewCount)&&(identical(other.widgetProjectionReady, widgetProjectionReady) || other.widgetProjectionReady == widgetProjectionReady)&&(identical(other.privacySafeByDefault, privacySafeByDefault) || other.privacySafeByDefault == privacySafeByDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activePreviewCount,completedPreviewCount,deletedPreviewCount,widgetProjectionReady,privacySafeByDefault);

@override
String toString() {
  return 'TaskFlowBootstrapSnapshot(activePreviewCount: $activePreviewCount, completedPreviewCount: $completedPreviewCount, deletedPreviewCount: $deletedPreviewCount, widgetProjectionReady: $widgetProjectionReady, privacySafeByDefault: $privacySafeByDefault)';
}


}

/// @nodoc
abstract mixin class $TaskFlowBootstrapSnapshotCopyWith<$Res>  {
  factory $TaskFlowBootstrapSnapshotCopyWith(TaskFlowBootstrapSnapshot value, $Res Function(TaskFlowBootstrapSnapshot) _then) = _$TaskFlowBootstrapSnapshotCopyWithImpl;
@useResult
$Res call({
 int activePreviewCount, int completedPreviewCount, int deletedPreviewCount, bool widgetProjectionReady, bool privacySafeByDefault
});




}
/// @nodoc
class _$TaskFlowBootstrapSnapshotCopyWithImpl<$Res>
    implements $TaskFlowBootstrapSnapshotCopyWith<$Res> {
  _$TaskFlowBootstrapSnapshotCopyWithImpl(this._self, this._then);

  final TaskFlowBootstrapSnapshot _self;
  final $Res Function(TaskFlowBootstrapSnapshot) _then;

/// Create a copy of TaskFlowBootstrapSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activePreviewCount = null,Object? completedPreviewCount = null,Object? deletedPreviewCount = null,Object? widgetProjectionReady = null,Object? privacySafeByDefault = null,}) {
  return _then(_self.copyWith(
activePreviewCount: null == activePreviewCount ? _self.activePreviewCount : activePreviewCount // ignore: cast_nullable_to_non_nullable
as int,completedPreviewCount: null == completedPreviewCount ? _self.completedPreviewCount : completedPreviewCount // ignore: cast_nullable_to_non_nullable
as int,deletedPreviewCount: null == deletedPreviewCount ? _self.deletedPreviewCount : deletedPreviewCount // ignore: cast_nullable_to_non_nullable
as int,widgetProjectionReady: null == widgetProjectionReady ? _self.widgetProjectionReady : widgetProjectionReady // ignore: cast_nullable_to_non_nullable
as bool,privacySafeByDefault: null == privacySafeByDefault ? _self.privacySafeByDefault : privacySafeByDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskFlowBootstrapSnapshot].
extension TaskFlowBootstrapSnapshotPatterns on TaskFlowBootstrapSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskFlowBootstrapSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskFlowBootstrapSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskFlowBootstrapSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _TaskFlowBootstrapSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskFlowBootstrapSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _TaskFlowBootstrapSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int activePreviewCount,  int completedPreviewCount,  int deletedPreviewCount,  bool widgetProjectionReady,  bool privacySafeByDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskFlowBootstrapSnapshot() when $default != null:
return $default(_that.activePreviewCount,_that.completedPreviewCount,_that.deletedPreviewCount,_that.widgetProjectionReady,_that.privacySafeByDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int activePreviewCount,  int completedPreviewCount,  int deletedPreviewCount,  bool widgetProjectionReady,  bool privacySafeByDefault)  $default,) {final _that = this;
switch (_that) {
case _TaskFlowBootstrapSnapshot():
return $default(_that.activePreviewCount,_that.completedPreviewCount,_that.deletedPreviewCount,_that.widgetProjectionReady,_that.privacySafeByDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int activePreviewCount,  int completedPreviewCount,  int deletedPreviewCount,  bool widgetProjectionReady,  bool privacySafeByDefault)?  $default,) {final _that = this;
switch (_that) {
case _TaskFlowBootstrapSnapshot() when $default != null:
return $default(_that.activePreviewCount,_that.completedPreviewCount,_that.deletedPreviewCount,_that.widgetProjectionReady,_that.privacySafeByDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskFlowBootstrapSnapshot implements TaskFlowBootstrapSnapshot {
  const _TaskFlowBootstrapSnapshot({required this.activePreviewCount, required this.completedPreviewCount, required this.deletedPreviewCount, required this.widgetProjectionReady, required this.privacySafeByDefault});
  factory _TaskFlowBootstrapSnapshot.fromJson(Map<String, dynamic> json) => _$TaskFlowBootstrapSnapshotFromJson(json);

@override final  int activePreviewCount;
@override final  int completedPreviewCount;
@override final  int deletedPreviewCount;
@override final  bool widgetProjectionReady;
@override final  bool privacySafeByDefault;

/// Create a copy of TaskFlowBootstrapSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskFlowBootstrapSnapshotCopyWith<_TaskFlowBootstrapSnapshot> get copyWith => __$TaskFlowBootstrapSnapshotCopyWithImpl<_TaskFlowBootstrapSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskFlowBootstrapSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskFlowBootstrapSnapshot&&(identical(other.activePreviewCount, activePreviewCount) || other.activePreviewCount == activePreviewCount)&&(identical(other.completedPreviewCount, completedPreviewCount) || other.completedPreviewCount == completedPreviewCount)&&(identical(other.deletedPreviewCount, deletedPreviewCount) || other.deletedPreviewCount == deletedPreviewCount)&&(identical(other.widgetProjectionReady, widgetProjectionReady) || other.widgetProjectionReady == widgetProjectionReady)&&(identical(other.privacySafeByDefault, privacySafeByDefault) || other.privacySafeByDefault == privacySafeByDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activePreviewCount,completedPreviewCount,deletedPreviewCount,widgetProjectionReady,privacySafeByDefault);

@override
String toString() {
  return 'TaskFlowBootstrapSnapshot(activePreviewCount: $activePreviewCount, completedPreviewCount: $completedPreviewCount, deletedPreviewCount: $deletedPreviewCount, widgetProjectionReady: $widgetProjectionReady, privacySafeByDefault: $privacySafeByDefault)';
}


}

/// @nodoc
abstract mixin class _$TaskFlowBootstrapSnapshotCopyWith<$Res> implements $TaskFlowBootstrapSnapshotCopyWith<$Res> {
  factory _$TaskFlowBootstrapSnapshotCopyWith(_TaskFlowBootstrapSnapshot value, $Res Function(_TaskFlowBootstrapSnapshot) _then) = __$TaskFlowBootstrapSnapshotCopyWithImpl;
@override @useResult
$Res call({
 int activePreviewCount, int completedPreviewCount, int deletedPreviewCount, bool widgetProjectionReady, bool privacySafeByDefault
});




}
/// @nodoc
class __$TaskFlowBootstrapSnapshotCopyWithImpl<$Res>
    implements _$TaskFlowBootstrapSnapshotCopyWith<$Res> {
  __$TaskFlowBootstrapSnapshotCopyWithImpl(this._self, this._then);

  final _TaskFlowBootstrapSnapshot _self;
  final $Res Function(_TaskFlowBootstrapSnapshot) _then;

/// Create a copy of TaskFlowBootstrapSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activePreviewCount = null,Object? completedPreviewCount = null,Object? deletedPreviewCount = null,Object? widgetProjectionReady = null,Object? privacySafeByDefault = null,}) {
  return _then(_TaskFlowBootstrapSnapshot(
activePreviewCount: null == activePreviewCount ? _self.activePreviewCount : activePreviewCount // ignore: cast_nullable_to_non_nullable
as int,completedPreviewCount: null == completedPreviewCount ? _self.completedPreviewCount : completedPreviewCount // ignore: cast_nullable_to_non_nullable
as int,deletedPreviewCount: null == deletedPreviewCount ? _self.deletedPreviewCount : deletedPreviewCount // ignore: cast_nullable_to_non_nullable
as int,widgetProjectionReady: null == widgetProjectionReady ? _self.widgetProjectionReady : widgetProjectionReady // ignore: cast_nullable_to_non_nullable
as bool,privacySafeByDefault: null == privacySafeByDefault ? _self.privacySafeByDefault : privacySafeByDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
