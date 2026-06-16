// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HistorySnapshot {

 List<TaskEntity> get completedTasks; List<TaskEntity> get deletedTasks;
/// Create a copy of HistorySnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistorySnapshotCopyWith<HistorySnapshot> get copyWith => _$HistorySnapshotCopyWithImpl<HistorySnapshot>(this as HistorySnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistorySnapshot&&const DeepCollectionEquality().equals(other.completedTasks, completedTasks)&&const DeepCollectionEquality().equals(other.deletedTasks, deletedTasks));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(completedTasks),const DeepCollectionEquality().hash(deletedTasks));

@override
String toString() {
  return 'HistorySnapshot(completedTasks: $completedTasks, deletedTasks: $deletedTasks)';
}


}

/// @nodoc
abstract mixin class $HistorySnapshotCopyWith<$Res>  {
  factory $HistorySnapshotCopyWith(HistorySnapshot value, $Res Function(HistorySnapshot) _then) = _$HistorySnapshotCopyWithImpl;
@useResult
$Res call({
 List<TaskEntity> completedTasks, List<TaskEntity> deletedTasks
});




}
/// @nodoc
class _$HistorySnapshotCopyWithImpl<$Res>
    implements $HistorySnapshotCopyWith<$Res> {
  _$HistorySnapshotCopyWithImpl(this._self, this._then);

  final HistorySnapshot _self;
  final $Res Function(HistorySnapshot) _then;

/// Create a copy of HistorySnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? completedTasks = null,Object? deletedTasks = null,}) {
  return _then(_self.copyWith(
completedTasks: null == completedTasks ? _self.completedTasks : completedTasks // ignore: cast_nullable_to_non_nullable
as List<TaskEntity>,deletedTasks: null == deletedTasks ? _self.deletedTasks : deletedTasks // ignore: cast_nullable_to_non_nullable
as List<TaskEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [HistorySnapshot].
extension HistorySnapshotPatterns on HistorySnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistorySnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistorySnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistorySnapshot value)  $default,){
final _that = this;
switch (_that) {
case _HistorySnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistorySnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _HistorySnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TaskEntity> completedTasks,  List<TaskEntity> deletedTasks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistorySnapshot() when $default != null:
return $default(_that.completedTasks,_that.deletedTasks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TaskEntity> completedTasks,  List<TaskEntity> deletedTasks)  $default,) {final _that = this;
switch (_that) {
case _HistorySnapshot():
return $default(_that.completedTasks,_that.deletedTasks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TaskEntity> completedTasks,  List<TaskEntity> deletedTasks)?  $default,) {final _that = this;
switch (_that) {
case _HistorySnapshot() when $default != null:
return $default(_that.completedTasks,_that.deletedTasks);case _:
  return null;

}
}

}

/// @nodoc


class _HistorySnapshot extends HistorySnapshot {
  const _HistorySnapshot({required final  List<TaskEntity> completedTasks, required final  List<TaskEntity> deletedTasks}): _completedTasks = completedTasks,_deletedTasks = deletedTasks,super._();
  

 final  List<TaskEntity> _completedTasks;
@override List<TaskEntity> get completedTasks {
  if (_completedTasks is EqualUnmodifiableListView) return _completedTasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedTasks);
}

 final  List<TaskEntity> _deletedTasks;
@override List<TaskEntity> get deletedTasks {
  if (_deletedTasks is EqualUnmodifiableListView) return _deletedTasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deletedTasks);
}


/// Create a copy of HistorySnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistorySnapshotCopyWith<_HistorySnapshot> get copyWith => __$HistorySnapshotCopyWithImpl<_HistorySnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistorySnapshot&&const DeepCollectionEquality().equals(other._completedTasks, _completedTasks)&&const DeepCollectionEquality().equals(other._deletedTasks, _deletedTasks));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_completedTasks),const DeepCollectionEquality().hash(_deletedTasks));

@override
String toString() {
  return 'HistorySnapshot(completedTasks: $completedTasks, deletedTasks: $deletedTasks)';
}


}

/// @nodoc
abstract mixin class _$HistorySnapshotCopyWith<$Res> implements $HistorySnapshotCopyWith<$Res> {
  factory _$HistorySnapshotCopyWith(_HistorySnapshot value, $Res Function(_HistorySnapshot) _then) = __$HistorySnapshotCopyWithImpl;
@override @useResult
$Res call({
 List<TaskEntity> completedTasks, List<TaskEntity> deletedTasks
});




}
/// @nodoc
class __$HistorySnapshotCopyWithImpl<$Res>
    implements _$HistorySnapshotCopyWith<$Res> {
  __$HistorySnapshotCopyWithImpl(this._self, this._then);

  final _HistorySnapshot _self;
  final $Res Function(_HistorySnapshot) _then;

/// Create a copy of HistorySnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? completedTasks = null,Object? deletedTasks = null,}) {
  return _then(_HistorySnapshot(
completedTasks: null == completedTasks ? _self._completedTasks : completedTasks // ignore: cast_nullable_to_non_nullable
as List<TaskEntity>,deletedTasks: null == deletedTasks ? _self._deletedTasks : deletedTasks // ignore: cast_nullable_to_non_nullable
as List<TaskEntity>,
  ));
}


}

// dart format on
