// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_add_defaults.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuickAddDefaults {

 DateTime? get dueAt; bool get isPinned; bool get isPrivate;
/// Create a copy of QuickAddDefaults
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickAddDefaultsCopyWith<QuickAddDefaults> get copyWith => _$QuickAddDefaultsCopyWithImpl<QuickAddDefaults>(this as QuickAddDefaults, _$identity);

  /// Serializes this QuickAddDefaults to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickAddDefaults&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dueAt,isPinned,isPrivate);

@override
String toString() {
  return 'QuickAddDefaults(dueAt: $dueAt, isPinned: $isPinned, isPrivate: $isPrivate)';
}


}

/// @nodoc
abstract mixin class $QuickAddDefaultsCopyWith<$Res>  {
  factory $QuickAddDefaultsCopyWith(QuickAddDefaults value, $Res Function(QuickAddDefaults) _then) = _$QuickAddDefaultsCopyWithImpl;
@useResult
$Res call({
 DateTime? dueAt, bool isPinned, bool isPrivate
});




}
/// @nodoc
class _$QuickAddDefaultsCopyWithImpl<$Res>
    implements $QuickAddDefaultsCopyWith<$Res> {
  _$QuickAddDefaultsCopyWithImpl(this._self, this._then);

  final QuickAddDefaults _self;
  final $Res Function(QuickAddDefaults) _then;

/// Create a copy of QuickAddDefaults
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dueAt = freezed,Object? isPinned = null,Object? isPrivate = null,}) {
  return _then(_self.copyWith(
dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickAddDefaults].
extension QuickAddDefaultsPatterns on QuickAddDefaults {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickAddDefaults value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickAddDefaults() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickAddDefaults value)  $default,){
final _that = this;
switch (_that) {
case _QuickAddDefaults():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickAddDefaults value)?  $default,){
final _that = this;
switch (_that) {
case _QuickAddDefaults() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? dueAt,  bool isPinned,  bool isPrivate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickAddDefaults() when $default != null:
return $default(_that.dueAt,_that.isPinned,_that.isPrivate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? dueAt,  bool isPinned,  bool isPrivate)  $default,) {final _that = this;
switch (_that) {
case _QuickAddDefaults():
return $default(_that.dueAt,_that.isPinned,_that.isPrivate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? dueAt,  bool isPinned,  bool isPrivate)?  $default,) {final _that = this;
switch (_that) {
case _QuickAddDefaults() when $default != null:
return $default(_that.dueAt,_that.isPinned,_that.isPrivate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuickAddDefaults implements QuickAddDefaults {
  const _QuickAddDefaults({this.dueAt, this.isPinned = false, this.isPrivate = false});
  factory _QuickAddDefaults.fromJson(Map<String, dynamic> json) => _$QuickAddDefaultsFromJson(json);

@override final  DateTime? dueAt;
@override@JsonKey() final  bool isPinned;
@override@JsonKey() final  bool isPrivate;

/// Create a copy of QuickAddDefaults
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickAddDefaultsCopyWith<_QuickAddDefaults> get copyWith => __$QuickAddDefaultsCopyWithImpl<_QuickAddDefaults>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuickAddDefaultsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickAddDefaults&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dueAt,isPinned,isPrivate);

@override
String toString() {
  return 'QuickAddDefaults(dueAt: $dueAt, isPinned: $isPinned, isPrivate: $isPrivate)';
}


}

/// @nodoc
abstract mixin class _$QuickAddDefaultsCopyWith<$Res> implements $QuickAddDefaultsCopyWith<$Res> {
  factory _$QuickAddDefaultsCopyWith(_QuickAddDefaults value, $Res Function(_QuickAddDefaults) _then) = __$QuickAddDefaultsCopyWithImpl;
@override @useResult
$Res call({
 DateTime? dueAt, bool isPinned, bool isPrivate
});




}
/// @nodoc
class __$QuickAddDefaultsCopyWithImpl<$Res>
    implements _$QuickAddDefaultsCopyWith<$Res> {
  __$QuickAddDefaultsCopyWithImpl(this._self, this._then);

  final _QuickAddDefaults _self;
  final $Res Function(_QuickAddDefaults) _then;

/// Create a copy of QuickAddDefaults
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dueAt = freezed,Object? isPinned = null,Object? isPrivate = null,}) {
  return _then(_QuickAddDefaults(
dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
