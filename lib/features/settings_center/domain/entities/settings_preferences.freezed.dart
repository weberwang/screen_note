// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsPreferences {

 bool get maskPrivateContent; bool get notificationsEnabled; WidgetDisplayMode get widgetDisplayMode;
/// Create a copy of SettingsPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsPreferencesCopyWith<SettingsPreferences> get copyWith => _$SettingsPreferencesCopyWithImpl<SettingsPreferences>(this as SettingsPreferences, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsPreferences&&(identical(other.maskPrivateContent, maskPrivateContent) || other.maskPrivateContent == maskPrivateContent)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.widgetDisplayMode, widgetDisplayMode) || other.widgetDisplayMode == widgetDisplayMode));
}


@override
int get hashCode => Object.hash(runtimeType,maskPrivateContent,notificationsEnabled,widgetDisplayMode);

@override
String toString() {
  return 'SettingsPreferences(maskPrivateContent: $maskPrivateContent, notificationsEnabled: $notificationsEnabled, widgetDisplayMode: $widgetDisplayMode)';
}


}

/// @nodoc
abstract mixin class $SettingsPreferencesCopyWith<$Res>  {
  factory $SettingsPreferencesCopyWith(SettingsPreferences value, $Res Function(SettingsPreferences) _then) = _$SettingsPreferencesCopyWithImpl;
@useResult
$Res call({
 bool maskPrivateContent, bool notificationsEnabled, WidgetDisplayMode widgetDisplayMode
});




}
/// @nodoc
class _$SettingsPreferencesCopyWithImpl<$Res>
    implements $SettingsPreferencesCopyWith<$Res> {
  _$SettingsPreferencesCopyWithImpl(this._self, this._then);

  final SettingsPreferences _self;
  final $Res Function(SettingsPreferences) _then;

/// Create a copy of SettingsPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? maskPrivateContent = null,Object? notificationsEnabled = null,Object? widgetDisplayMode = null,}) {
  return _then(_self.copyWith(
maskPrivateContent: null == maskPrivateContent ? _self.maskPrivateContent : maskPrivateContent // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,widgetDisplayMode: null == widgetDisplayMode ? _self.widgetDisplayMode : widgetDisplayMode // ignore: cast_nullable_to_non_nullable
as WidgetDisplayMode,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsPreferences].
extension SettingsPreferencesPatterns on SettingsPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsPreferences value)  $default,){
final _that = this;
switch (_that) {
case _SettingsPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsPreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool maskPrivateContent,  bool notificationsEnabled,  WidgetDisplayMode widgetDisplayMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsPreferences() when $default != null:
return $default(_that.maskPrivateContent,_that.notificationsEnabled,_that.widgetDisplayMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool maskPrivateContent,  bool notificationsEnabled,  WidgetDisplayMode widgetDisplayMode)  $default,) {final _that = this;
switch (_that) {
case _SettingsPreferences():
return $default(_that.maskPrivateContent,_that.notificationsEnabled,_that.widgetDisplayMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool maskPrivateContent,  bool notificationsEnabled,  WidgetDisplayMode widgetDisplayMode)?  $default,) {final _that = this;
switch (_that) {
case _SettingsPreferences() when $default != null:
return $default(_that.maskPrivateContent,_that.notificationsEnabled,_that.widgetDisplayMode);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsPreferences implements SettingsPreferences {
  const _SettingsPreferences({required this.maskPrivateContent, required this.notificationsEnabled, required this.widgetDisplayMode});
  

@override final  bool maskPrivateContent;
@override final  bool notificationsEnabled;
@override final  WidgetDisplayMode widgetDisplayMode;

/// Create a copy of SettingsPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsPreferencesCopyWith<_SettingsPreferences> get copyWith => __$SettingsPreferencesCopyWithImpl<_SettingsPreferences>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsPreferences&&(identical(other.maskPrivateContent, maskPrivateContent) || other.maskPrivateContent == maskPrivateContent)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.widgetDisplayMode, widgetDisplayMode) || other.widgetDisplayMode == widgetDisplayMode));
}


@override
int get hashCode => Object.hash(runtimeType,maskPrivateContent,notificationsEnabled,widgetDisplayMode);

@override
String toString() {
  return 'SettingsPreferences(maskPrivateContent: $maskPrivateContent, notificationsEnabled: $notificationsEnabled, widgetDisplayMode: $widgetDisplayMode)';
}


}

/// @nodoc
abstract mixin class _$SettingsPreferencesCopyWith<$Res> implements $SettingsPreferencesCopyWith<$Res> {
  factory _$SettingsPreferencesCopyWith(_SettingsPreferences value, $Res Function(_SettingsPreferences) _then) = __$SettingsPreferencesCopyWithImpl;
@override @useResult
$Res call({
 bool maskPrivateContent, bool notificationsEnabled, WidgetDisplayMode widgetDisplayMode
});




}
/// @nodoc
class __$SettingsPreferencesCopyWithImpl<$Res>
    implements _$SettingsPreferencesCopyWith<$Res> {
  __$SettingsPreferencesCopyWithImpl(this._self, this._then);

  final _SettingsPreferences _self;
  final $Res Function(_SettingsPreferences) _then;

/// Create a copy of SettingsPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? maskPrivateContent = null,Object? notificationsEnabled = null,Object? widgetDisplayMode = null,}) {
  return _then(_SettingsPreferences(
maskPrivateContent: null == maskPrivateContent ? _self.maskPrivateContent : maskPrivateContent // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,widgetDisplayMode: null == widgetDisplayMode ? _self.widgetDisplayMode : widgetDisplayMode // ignore: cast_nullable_to_non_nullable
as WidgetDisplayMode,
  ));
}


}

// dart format on
