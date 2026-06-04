// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_feed_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskFeedSnapshot {

 List<TaskEntity> get pinnedTasks; List<TaskEntity> get overdueTasks; List<TaskEntity> get todayTasks; List<TaskEntity> get otherTasks; int get activeCount; int get completedCount; int get deletedCount;
/// Create a copy of TaskFeedSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskFeedSnapshotCopyWith<TaskFeedSnapshot> get copyWith => _$TaskFeedSnapshotCopyWithImpl<TaskFeedSnapshot>(this as TaskFeedSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFeedSnapshot&&const DeepCollectionEquality().equals(other.pinnedTasks, pinnedTasks)&&const DeepCollectionEquality().equals(other.overdueTasks, overdueTasks)&&const DeepCollectionEquality().equals(other.todayTasks, todayTasks)&&const DeepCollectionEquality().equals(other.otherTasks, otherTasks)&&(identical(other.activeCount, activeCount) || other.activeCount == activeCount)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.deletedCount, deletedCount) || other.deletedCount == deletedCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(pinnedTasks),const DeepCollectionEquality().hash(overdueTasks),const DeepCollectionEquality().hash(todayTasks),const DeepCollectionEquality().hash(otherTasks),activeCount,completedCount,deletedCount);

@override
String toString() {
  return 'TaskFeedSnapshot(pinnedTasks: $pinnedTasks, overdueTasks: $overdueTasks, todayTasks: $todayTasks, otherTasks: $otherTasks, activeCount: $activeCount, completedCount: $completedCount, deletedCount: $deletedCount)';
}


}

/// @nodoc
abstract mixin class $TaskFeedSnapshotCopyWith<$Res>  {
  factory $TaskFeedSnapshotCopyWith(TaskFeedSnapshot value, $Res Function(TaskFeedSnapshot) _then) = _$TaskFeedSnapshotCopyWithImpl;
@useResult
$Res call({
 List<TaskEntity> pinnedTasks, List<TaskEntity> overdueTasks, List<TaskEntity> todayTasks, List<TaskEntity> otherTasks, int activeCount, int completedCount, int deletedCount
});




}
/// @nodoc
class _$TaskFeedSnapshotCopyWithImpl<$Res>
    implements $TaskFeedSnapshotCopyWith<$Res> {
  _$TaskFeedSnapshotCopyWithImpl(this._self, this._then);

  final TaskFeedSnapshot _self;
  final $Res Function(TaskFeedSnapshot) _then;

/// Create a copy of TaskFeedSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pinnedTasks = null,Object? overdueTasks = null,Object? todayTasks = null,Object? otherTasks = null,Object? activeCount = null,Object? completedCount = null,Object? deletedCount = null,}) {
  return _then(_self.copyWith(
pinnedTasks: null == pinnedTasks ? _self.pinnedTasks : pinnedTasks // ignore: cast_nullable_to_non_nullable
as List<TaskEntity>,overdueTasks: null == overdueTasks ? _self.overdueTasks : overdueTasks // ignore: cast_nullable_to_non_nullable
as List<TaskEntity>,todayTasks: null == todayTasks ? _self.todayTasks : todayTasks // ignore: cast_nullable_to_non_nullable
as List<TaskEntity>,otherTasks: null == otherTasks ? _self.otherTasks : otherTasks // ignore: cast_nullable_to_non_nullable
as List<TaskEntity>,activeCount: null == activeCount ? _self.activeCount : activeCount // ignore: cast_nullable_to_non_nullable
as int,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,deletedCount: null == deletedCount ? _self.deletedCount : deletedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskFeedSnapshot].
extension TaskFeedSnapshotPatterns on TaskFeedSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskFeedSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskFeedSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskFeedSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _TaskFeedSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskFeedSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _TaskFeedSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TaskEntity> pinnedTasks,  List<TaskEntity> overdueTasks,  List<TaskEntity> todayTasks,  List<TaskEntity> otherTasks,  int activeCount,  int completedCount,  int deletedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskFeedSnapshot() when $default != null:
return $default(_that.pinnedTasks,_that.overdueTasks,_that.todayTasks,_that.otherTasks,_that.activeCount,_that.completedCount,_that.deletedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TaskEntity> pinnedTasks,  List<TaskEntity> overdueTasks,  List<TaskEntity> todayTasks,  List<TaskEntity> otherTasks,  int activeCount,  int completedCount,  int deletedCount)  $default,) {final _that = this;
switch (_that) {
case _TaskFeedSnapshot():
return $default(_that.pinnedTasks,_that.overdueTasks,_that.todayTasks,_that.otherTasks,_that.activeCount,_that.completedCount,_that.deletedCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TaskEntity> pinnedTasks,  List<TaskEntity> overdueTasks,  List<TaskEntity> todayTasks,  List<TaskEntity> otherTasks,  int activeCount,  int completedCount,  int deletedCount)?  $default,) {final _that = this;
switch (_that) {
case _TaskFeedSnapshot() when $default != null:
return $default(_that.pinnedTasks,_that.overdueTasks,_that.todayTasks,_that.otherTasks,_that.activeCount,_that.completedCount,_that.deletedCount);case _:
  return null;

}
}

}

/// @nodoc


class _TaskFeedSnapshot implements TaskFeedSnapshot {
  const _TaskFeedSnapshot({required final  List<TaskEntity> pinnedTasks, required final  List<TaskEntity> overdueTasks, required final  List<TaskEntity> todayTasks, required final  List<TaskEntity> otherTasks, required this.activeCount, required this.completedCount, required this.deletedCount}): _pinnedTasks = pinnedTasks,_overdueTasks = overdueTasks,_todayTasks = todayTasks,_otherTasks = otherTasks;
  

 final  List<TaskEntity> _pinnedTasks;
@override List<TaskEntity> get pinnedTasks {
  if (_pinnedTasks is EqualUnmodifiableListView) return _pinnedTasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pinnedTasks);
}

 final  List<TaskEntity> _overdueTasks;
@override List<TaskEntity> get overdueTasks {
  if (_overdueTasks is EqualUnmodifiableListView) return _overdueTasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_overdueTasks);
}

 final  List<TaskEntity> _todayTasks;
@override List<TaskEntity> get todayTasks {
  if (_todayTasks is EqualUnmodifiableListView) return _todayTasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_todayTasks);
}

 final  List<TaskEntity> _otherTasks;
@override List<TaskEntity> get otherTasks {
  if (_otherTasks is EqualUnmodifiableListView) return _otherTasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_otherTasks);
}

@override final  int activeCount;
@override final  int completedCount;
@override final  int deletedCount;

/// Create a copy of TaskFeedSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskFeedSnapshotCopyWith<_TaskFeedSnapshot> get copyWith => __$TaskFeedSnapshotCopyWithImpl<_TaskFeedSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskFeedSnapshot&&const DeepCollectionEquality().equals(other._pinnedTasks, _pinnedTasks)&&const DeepCollectionEquality().equals(other._overdueTasks, _overdueTasks)&&const DeepCollectionEquality().equals(other._todayTasks, _todayTasks)&&const DeepCollectionEquality().equals(other._otherTasks, _otherTasks)&&(identical(other.activeCount, activeCount) || other.activeCount == activeCount)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.deletedCount, deletedCount) || other.deletedCount == deletedCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_pinnedTasks),const DeepCollectionEquality().hash(_overdueTasks),const DeepCollectionEquality().hash(_todayTasks),const DeepCollectionEquality().hash(_otherTasks),activeCount,completedCount,deletedCount);

@override
String toString() {
  return 'TaskFeedSnapshot(pinnedTasks: $pinnedTasks, overdueTasks: $overdueTasks, todayTasks: $todayTasks, otherTasks: $otherTasks, activeCount: $activeCount, completedCount: $completedCount, deletedCount: $deletedCount)';
}


}

/// @nodoc
abstract mixin class _$TaskFeedSnapshotCopyWith<$Res> implements $TaskFeedSnapshotCopyWith<$Res> {
  factory _$TaskFeedSnapshotCopyWith(_TaskFeedSnapshot value, $Res Function(_TaskFeedSnapshot) _then) = __$TaskFeedSnapshotCopyWithImpl;
@override @useResult
$Res call({
 List<TaskEntity> pinnedTasks, List<TaskEntity> overdueTasks, List<TaskEntity> todayTasks, List<TaskEntity> otherTasks, int activeCount, int completedCount, int deletedCount
});




}
/// @nodoc
class __$TaskFeedSnapshotCopyWithImpl<$Res>
    implements _$TaskFeedSnapshotCopyWith<$Res> {
  __$TaskFeedSnapshotCopyWithImpl(this._self, this._then);

  final _TaskFeedSnapshot _self;
  final $Res Function(_TaskFeedSnapshot) _then;

/// Create a copy of TaskFeedSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pinnedTasks = null,Object? overdueTasks = null,Object? todayTasks = null,Object? otherTasks = null,Object? activeCount = null,Object? completedCount = null,Object? deletedCount = null,}) {
  return _then(_TaskFeedSnapshot(
pinnedTasks: null == pinnedTasks ? _self._pinnedTasks : pinnedTasks // ignore: cast_nullable_to_non_nullable
as List<TaskEntity>,overdueTasks: null == overdueTasks ? _self._overdueTasks : overdueTasks // ignore: cast_nullable_to_non_nullable
as List<TaskEntity>,todayTasks: null == todayTasks ? _self._todayTasks : todayTasks // ignore: cast_nullable_to_non_nullable
as List<TaskEntity>,otherTasks: null == otherTasks ? _self._otherTasks : otherTasks // ignore: cast_nullable_to_non_nullable
as List<TaskEntity>,activeCount: null == activeCount ? _self.activeCount : activeCount // ignore: cast_nullable_to_non_nullable
as int,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,deletedCount: null == deletedCount ? _self.deletedCount : deletedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
