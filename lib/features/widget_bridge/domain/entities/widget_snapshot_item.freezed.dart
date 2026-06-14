// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'widget_snapshot_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WidgetSnapshotItem {

 String get taskId; String get launchTarget; String get title; String get statusLabel; String get dueLabel; bool get isPinned; bool get isOverdue; bool get isPrivate; int get rank;
/// Create a copy of WidgetSnapshotItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WidgetSnapshotItemCopyWith<WidgetSnapshotItem> get copyWith => _$WidgetSnapshotItemCopyWithImpl<WidgetSnapshotItem>(this as WidgetSnapshotItem, _$identity);

  /// Serializes this WidgetSnapshotItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WidgetSnapshotItem&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.launchTarget, launchTarget) || other.launchTarget == launchTarget)&&(identical(other.title, title) || other.title == title)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel)&&(identical(other.dueLabel, dueLabel) || other.dueLabel == dueLabel)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.isOverdue, isOverdue) || other.isOverdue == isOverdue)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.rank, rank) || other.rank == rank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,launchTarget,title,statusLabel,dueLabel,isPinned,isOverdue,isPrivate,rank);

@override
String toString() {
  return 'WidgetSnapshotItem(taskId: $taskId, launchTarget: $launchTarget, title: $title, statusLabel: $statusLabel, dueLabel: $dueLabel, isPinned: $isPinned, isOverdue: $isOverdue, isPrivate: $isPrivate, rank: $rank)';
}


}

/// @nodoc
abstract mixin class $WidgetSnapshotItemCopyWith<$Res>  {
  factory $WidgetSnapshotItemCopyWith(WidgetSnapshotItem value, $Res Function(WidgetSnapshotItem) _then) = _$WidgetSnapshotItemCopyWithImpl;
@useResult
$Res call({
 String taskId, String launchTarget, String title, String statusLabel, String dueLabel, bool isPinned, bool isOverdue, bool isPrivate, int rank
});




}
/// @nodoc
class _$WidgetSnapshotItemCopyWithImpl<$Res>
    implements $WidgetSnapshotItemCopyWith<$Res> {
  _$WidgetSnapshotItemCopyWithImpl(this._self, this._then);

  final WidgetSnapshotItem _self;
  final $Res Function(WidgetSnapshotItem) _then;

/// Create a copy of WidgetSnapshotItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? launchTarget = null,Object? title = null,Object? statusLabel = null,Object? dueLabel = null,Object? isPinned = null,Object? isOverdue = null,Object? isPrivate = null,Object? rank = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,launchTarget: null == launchTarget ? _self.launchTarget : launchTarget // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,statusLabel: null == statusLabel ? _self.statusLabel : statusLabel // ignore: cast_nullable_to_non_nullable
as String,dueLabel: null == dueLabel ? _self.dueLabel : dueLabel // ignore: cast_nullable_to_non_nullable
as String,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,isOverdue: null == isOverdue ? _self.isOverdue : isOverdue // ignore: cast_nullable_to_non_nullable
as bool,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WidgetSnapshotItem].
extension WidgetSnapshotItemPatterns on WidgetSnapshotItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WidgetSnapshotItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WidgetSnapshotItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WidgetSnapshotItem value)  $default,){
final _that = this;
switch (_that) {
case _WidgetSnapshotItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WidgetSnapshotItem value)?  $default,){
final _that = this;
switch (_that) {
case _WidgetSnapshotItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  String launchTarget,  String title,  String statusLabel,  String dueLabel,  bool isPinned,  bool isOverdue,  bool isPrivate,  int rank)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WidgetSnapshotItem() when $default != null:
return $default(_that.taskId,_that.launchTarget,_that.title,_that.statusLabel,_that.dueLabel,_that.isPinned,_that.isOverdue,_that.isPrivate,_that.rank);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  String launchTarget,  String title,  String statusLabel,  String dueLabel,  bool isPinned,  bool isOverdue,  bool isPrivate,  int rank)  $default,) {final _that = this;
switch (_that) {
case _WidgetSnapshotItem():
return $default(_that.taskId,_that.launchTarget,_that.title,_that.statusLabel,_that.dueLabel,_that.isPinned,_that.isOverdue,_that.isPrivate,_that.rank);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  String launchTarget,  String title,  String statusLabel,  String dueLabel,  bool isPinned,  bool isOverdue,  bool isPrivate,  int rank)?  $default,) {final _that = this;
switch (_that) {
case _WidgetSnapshotItem() when $default != null:
return $default(_that.taskId,_that.launchTarget,_that.title,_that.statusLabel,_that.dueLabel,_that.isPinned,_that.isOverdue,_that.isPrivate,_that.rank);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WidgetSnapshotItem implements WidgetSnapshotItem {
  const _WidgetSnapshotItem({required this.taskId, required this.launchTarget, required this.title, required this.statusLabel, required this.dueLabel, required this.isPinned, required this.isOverdue, required this.isPrivate, required this.rank});
  factory _WidgetSnapshotItem.fromJson(Map<String, dynamic> json) => _$WidgetSnapshotItemFromJson(json);

@override final  String taskId;
@override final  String launchTarget;
@override final  String title;
@override final  String statusLabel;
@override final  String dueLabel;
@override final  bool isPinned;
@override final  bool isOverdue;
@override final  bool isPrivate;
@override final  int rank;

/// Create a copy of WidgetSnapshotItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WidgetSnapshotItemCopyWith<_WidgetSnapshotItem> get copyWith => __$WidgetSnapshotItemCopyWithImpl<_WidgetSnapshotItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WidgetSnapshotItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WidgetSnapshotItem&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.launchTarget, launchTarget) || other.launchTarget == launchTarget)&&(identical(other.title, title) || other.title == title)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel)&&(identical(other.dueLabel, dueLabel) || other.dueLabel == dueLabel)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.isOverdue, isOverdue) || other.isOverdue == isOverdue)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.rank, rank) || other.rank == rank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,launchTarget,title,statusLabel,dueLabel,isPinned,isOverdue,isPrivate,rank);

@override
String toString() {
  return 'WidgetSnapshotItem(taskId: $taskId, launchTarget: $launchTarget, title: $title, statusLabel: $statusLabel, dueLabel: $dueLabel, isPinned: $isPinned, isOverdue: $isOverdue, isPrivate: $isPrivate, rank: $rank)';
}


}

/// @nodoc
abstract mixin class _$WidgetSnapshotItemCopyWith<$Res> implements $WidgetSnapshotItemCopyWith<$Res> {
  factory _$WidgetSnapshotItemCopyWith(_WidgetSnapshotItem value, $Res Function(_WidgetSnapshotItem) _then) = __$WidgetSnapshotItemCopyWithImpl;
@override @useResult
$Res call({
 String taskId, String launchTarget, String title, String statusLabel, String dueLabel, bool isPinned, bool isOverdue, bool isPrivate, int rank
});




}
/// @nodoc
class __$WidgetSnapshotItemCopyWithImpl<$Res>
    implements _$WidgetSnapshotItemCopyWith<$Res> {
  __$WidgetSnapshotItemCopyWithImpl(this._self, this._then);

  final _WidgetSnapshotItem _self;
  final $Res Function(_WidgetSnapshotItem) _then;

/// Create a copy of WidgetSnapshotItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? launchTarget = null,Object? title = null,Object? statusLabel = null,Object? dueLabel = null,Object? isPinned = null,Object? isOverdue = null,Object? isPrivate = null,Object? rank = null,}) {
  return _then(_WidgetSnapshotItem(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,launchTarget: null == launchTarget ? _self.launchTarget : launchTarget // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,statusLabel: null == statusLabel ? _self.statusLabel : statusLabel // ignore: cast_nullable_to_non_nullable
as String,dueLabel: null == dueLabel ? _self.dueLabel : dueLabel // ignore: cast_nullable_to_non_nullable
as String,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,isOverdue: null == isOverdue ? _self.isOverdue : isOverdue // ignore: cast_nullable_to_non_nullable
as bool,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
