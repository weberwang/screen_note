// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_shell_launch_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppShellLaunchIntent {

 AppShellEntrySource get source; AppShellRouteTarget get target; bool get isFallback; String? get invalidTarget;
/// Create a copy of AppShellLaunchIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppShellLaunchIntentCopyWith<AppShellLaunchIntent> get copyWith => _$AppShellLaunchIntentCopyWithImpl<AppShellLaunchIntent>(this as AppShellLaunchIntent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppShellLaunchIntent&&(identical(other.source, source) || other.source == source)&&(identical(other.target, target) || other.target == target)&&(identical(other.isFallback, isFallback) || other.isFallback == isFallback)&&(identical(other.invalidTarget, invalidTarget) || other.invalidTarget == invalidTarget));
}


@override
int get hashCode => Object.hash(runtimeType,source,target,isFallback,invalidTarget);

@override
String toString() {
  return 'AppShellLaunchIntent(source: $source, target: $target, isFallback: $isFallback, invalidTarget: $invalidTarget)';
}


}

/// @nodoc
abstract mixin class $AppShellLaunchIntentCopyWith<$Res>  {
  factory $AppShellLaunchIntentCopyWith(AppShellLaunchIntent value, $Res Function(AppShellLaunchIntent) _then) = _$AppShellLaunchIntentCopyWithImpl;
@useResult
$Res call({
 AppShellEntrySource source, AppShellRouteTarget target, bool isFallback, String? invalidTarget
});




}
/// @nodoc
class _$AppShellLaunchIntentCopyWithImpl<$Res>
    implements $AppShellLaunchIntentCopyWith<$Res> {
  _$AppShellLaunchIntentCopyWithImpl(this._self, this._then);

  final AppShellLaunchIntent _self;
  final $Res Function(AppShellLaunchIntent) _then;

/// Create a copy of AppShellLaunchIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? target = null,Object? isFallback = null,Object? invalidTarget = freezed,}) {
  return _then(_self.copyWith(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as AppShellEntrySource,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as AppShellRouteTarget,isFallback: null == isFallback ? _self.isFallback : isFallback // ignore: cast_nullable_to_non_nullable
as bool,invalidTarget: freezed == invalidTarget ? _self.invalidTarget : invalidTarget // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppShellLaunchIntent].
extension AppShellLaunchIntentPatterns on AppShellLaunchIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppShellLaunchIntent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppShellLaunchIntent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppShellLaunchIntent value)  $default,){
final _that = this;
switch (_that) {
case _AppShellLaunchIntent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppShellLaunchIntent value)?  $default,){
final _that = this;
switch (_that) {
case _AppShellLaunchIntent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppShellEntrySource source,  AppShellRouteTarget target,  bool isFallback,  String? invalidTarget)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppShellLaunchIntent() when $default != null:
return $default(_that.source,_that.target,_that.isFallback,_that.invalidTarget);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppShellEntrySource source,  AppShellRouteTarget target,  bool isFallback,  String? invalidTarget)  $default,) {final _that = this;
switch (_that) {
case _AppShellLaunchIntent():
return $default(_that.source,_that.target,_that.isFallback,_that.invalidTarget);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppShellEntrySource source,  AppShellRouteTarget target,  bool isFallback,  String? invalidTarget)?  $default,) {final _that = this;
switch (_that) {
case _AppShellLaunchIntent() when $default != null:
return $default(_that.source,_that.target,_that.isFallback,_that.invalidTarget);case _:
  return null;

}
}

}

/// @nodoc


class _AppShellLaunchIntent implements AppShellLaunchIntent {
  const _AppShellLaunchIntent({required this.source, required this.target, required this.isFallback, this.invalidTarget});
  

@override final  AppShellEntrySource source;
@override final  AppShellRouteTarget target;
@override final  bool isFallback;
@override final  String? invalidTarget;

/// Create a copy of AppShellLaunchIntent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppShellLaunchIntentCopyWith<_AppShellLaunchIntent> get copyWith => __$AppShellLaunchIntentCopyWithImpl<_AppShellLaunchIntent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppShellLaunchIntent&&(identical(other.source, source) || other.source == source)&&(identical(other.target, target) || other.target == target)&&(identical(other.isFallback, isFallback) || other.isFallback == isFallback)&&(identical(other.invalidTarget, invalidTarget) || other.invalidTarget == invalidTarget));
}


@override
int get hashCode => Object.hash(runtimeType,source,target,isFallback,invalidTarget);

@override
String toString() {
  return 'AppShellLaunchIntent(source: $source, target: $target, isFallback: $isFallback, invalidTarget: $invalidTarget)';
}


}

/// @nodoc
abstract mixin class _$AppShellLaunchIntentCopyWith<$Res> implements $AppShellLaunchIntentCopyWith<$Res> {
  factory _$AppShellLaunchIntentCopyWith(_AppShellLaunchIntent value, $Res Function(_AppShellLaunchIntent) _then) = __$AppShellLaunchIntentCopyWithImpl;
@override @useResult
$Res call({
 AppShellEntrySource source, AppShellRouteTarget target, bool isFallback, String? invalidTarget
});




}
/// @nodoc
class __$AppShellLaunchIntentCopyWithImpl<$Res>
    implements _$AppShellLaunchIntentCopyWith<$Res> {
  __$AppShellLaunchIntentCopyWithImpl(this._self, this._then);

  final _AppShellLaunchIntent _self;
  final $Res Function(_AppShellLaunchIntent) _then;

/// Create a copy of AppShellLaunchIntent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? target = null,Object? isFallback = null,Object? invalidTarget = freezed,}) {
  return _then(_AppShellLaunchIntent(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as AppShellEntrySource,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as AppShellRouteTarget,isFallback: null == isFallback ? _self.isFallback : isFallback // ignore: cast_nullable_to_non_nullable
as bool,invalidTarget: freezed == invalidTarget ? _self.invalidTarget : invalidTarget // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
