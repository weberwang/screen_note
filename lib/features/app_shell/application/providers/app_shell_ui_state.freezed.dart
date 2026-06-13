// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_shell_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppShellFeedbackMessage {

 AppShellFeedbackLevel get level; String get text;
/// Create a copy of AppShellFeedbackMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppShellFeedbackMessageCopyWith<AppShellFeedbackMessage> get copyWith => _$AppShellFeedbackMessageCopyWithImpl<AppShellFeedbackMessage>(this as AppShellFeedbackMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppShellFeedbackMessage&&(identical(other.level, level) || other.level == level)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,level,text);

@override
String toString() {
  return 'AppShellFeedbackMessage(level: $level, text: $text)';
}


}

/// @nodoc
abstract mixin class $AppShellFeedbackMessageCopyWith<$Res>  {
  factory $AppShellFeedbackMessageCopyWith(AppShellFeedbackMessage value, $Res Function(AppShellFeedbackMessage) _then) = _$AppShellFeedbackMessageCopyWithImpl;
@useResult
$Res call({
 AppShellFeedbackLevel level, String text
});




}
/// @nodoc
class _$AppShellFeedbackMessageCopyWithImpl<$Res>
    implements $AppShellFeedbackMessageCopyWith<$Res> {
  _$AppShellFeedbackMessageCopyWithImpl(this._self, this._then);

  final AppShellFeedbackMessage _self;
  final $Res Function(AppShellFeedbackMessage) _then;

/// Create a copy of AppShellFeedbackMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? text = null,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as AppShellFeedbackLevel,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppShellFeedbackMessage].
extension AppShellFeedbackMessagePatterns on AppShellFeedbackMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppShellFeedbackMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppShellFeedbackMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppShellFeedbackMessage value)  $default,){
final _that = this;
switch (_that) {
case _AppShellFeedbackMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppShellFeedbackMessage value)?  $default,){
final _that = this;
switch (_that) {
case _AppShellFeedbackMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppShellFeedbackLevel level,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppShellFeedbackMessage() when $default != null:
return $default(_that.level,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppShellFeedbackLevel level,  String text)  $default,) {final _that = this;
switch (_that) {
case _AppShellFeedbackMessage():
return $default(_that.level,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppShellFeedbackLevel level,  String text)?  $default,) {final _that = this;
switch (_that) {
case _AppShellFeedbackMessage() when $default != null:
return $default(_that.level,_that.text);case _:
  return null;

}
}

}

/// @nodoc


class _AppShellFeedbackMessage implements AppShellFeedbackMessage {
  const _AppShellFeedbackMessage({required this.level, required this.text});
  

@override final  AppShellFeedbackLevel level;
@override final  String text;

/// Create a copy of AppShellFeedbackMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppShellFeedbackMessageCopyWith<_AppShellFeedbackMessage> get copyWith => __$AppShellFeedbackMessageCopyWithImpl<_AppShellFeedbackMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppShellFeedbackMessage&&(identical(other.level, level) || other.level == level)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,level,text);

@override
String toString() {
  return 'AppShellFeedbackMessage(level: $level, text: $text)';
}


}

/// @nodoc
abstract mixin class _$AppShellFeedbackMessageCopyWith<$Res> implements $AppShellFeedbackMessageCopyWith<$Res> {
  factory _$AppShellFeedbackMessageCopyWith(_AppShellFeedbackMessage value, $Res Function(_AppShellFeedbackMessage) _then) = __$AppShellFeedbackMessageCopyWithImpl;
@override @useResult
$Res call({
 AppShellFeedbackLevel level, String text
});




}
/// @nodoc
class __$AppShellFeedbackMessageCopyWithImpl<$Res>
    implements _$AppShellFeedbackMessageCopyWith<$Res> {
  __$AppShellFeedbackMessageCopyWithImpl(this._self, this._then);

  final _AppShellFeedbackMessage _self;
  final $Res Function(_AppShellFeedbackMessage) _then;

/// Create a copy of AppShellFeedbackMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? text = null,}) {
  return _then(_AppShellFeedbackMessage(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as AppShellFeedbackLevel,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AppShellUiState {

 bool get quickAddSheetOpen; AppShellFeedbackMessage? get feedback;
/// Create a copy of AppShellUiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppShellUiStateCopyWith<AppShellUiState> get copyWith => _$AppShellUiStateCopyWithImpl<AppShellUiState>(this as AppShellUiState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppShellUiState&&(identical(other.quickAddSheetOpen, quickAddSheetOpen) || other.quickAddSheetOpen == quickAddSheetOpen)&&(identical(other.feedback, feedback) || other.feedback == feedback));
}


@override
int get hashCode => Object.hash(runtimeType,quickAddSheetOpen,feedback);

@override
String toString() {
  return 'AppShellUiState(quickAddSheetOpen: $quickAddSheetOpen, feedback: $feedback)';
}


}

/// @nodoc
abstract mixin class $AppShellUiStateCopyWith<$Res>  {
  factory $AppShellUiStateCopyWith(AppShellUiState value, $Res Function(AppShellUiState) _then) = _$AppShellUiStateCopyWithImpl;
@useResult
$Res call({
 bool quickAddSheetOpen, AppShellFeedbackMessage? feedback
});


$AppShellFeedbackMessageCopyWith<$Res>? get feedback;

}
/// @nodoc
class _$AppShellUiStateCopyWithImpl<$Res>
    implements $AppShellUiStateCopyWith<$Res> {
  _$AppShellUiStateCopyWithImpl(this._self, this._then);

  final AppShellUiState _self;
  final $Res Function(AppShellUiState) _then;

/// Create a copy of AppShellUiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quickAddSheetOpen = null,Object? feedback = freezed,}) {
  return _then(_self.copyWith(
quickAddSheetOpen: null == quickAddSheetOpen ? _self.quickAddSheetOpen : quickAddSheetOpen // ignore: cast_nullable_to_non_nullable
as bool,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as AppShellFeedbackMessage?,
  ));
}
/// Create a copy of AppShellUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppShellFeedbackMessageCopyWith<$Res>? get feedback {
    if (_self.feedback == null) {
    return null;
  }

  return $AppShellFeedbackMessageCopyWith<$Res>(_self.feedback!, (value) {
    return _then(_self.copyWith(feedback: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppShellUiState].
extension AppShellUiStatePatterns on AppShellUiState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppShellUiState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppShellUiState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppShellUiState value)  $default,){
final _that = this;
switch (_that) {
case _AppShellUiState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppShellUiState value)?  $default,){
final _that = this;
switch (_that) {
case _AppShellUiState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool quickAddSheetOpen,  AppShellFeedbackMessage? feedback)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppShellUiState() when $default != null:
return $default(_that.quickAddSheetOpen,_that.feedback);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool quickAddSheetOpen,  AppShellFeedbackMessage? feedback)  $default,) {final _that = this;
switch (_that) {
case _AppShellUiState():
return $default(_that.quickAddSheetOpen,_that.feedback);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool quickAddSheetOpen,  AppShellFeedbackMessage? feedback)?  $default,) {final _that = this;
switch (_that) {
case _AppShellUiState() when $default != null:
return $default(_that.quickAddSheetOpen,_that.feedback);case _:
  return null;

}
}

}

/// @nodoc


class _AppShellUiState implements AppShellUiState {
  const _AppShellUiState({this.quickAddSheetOpen = false, this.feedback});
  

@override@JsonKey() final  bool quickAddSheetOpen;
@override final  AppShellFeedbackMessage? feedback;

/// Create a copy of AppShellUiState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppShellUiStateCopyWith<_AppShellUiState> get copyWith => __$AppShellUiStateCopyWithImpl<_AppShellUiState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppShellUiState&&(identical(other.quickAddSheetOpen, quickAddSheetOpen) || other.quickAddSheetOpen == quickAddSheetOpen)&&(identical(other.feedback, feedback) || other.feedback == feedback));
}


@override
int get hashCode => Object.hash(runtimeType,quickAddSheetOpen,feedback);

@override
String toString() {
  return 'AppShellUiState(quickAddSheetOpen: $quickAddSheetOpen, feedback: $feedback)';
}


}

/// @nodoc
abstract mixin class _$AppShellUiStateCopyWith<$Res> implements $AppShellUiStateCopyWith<$Res> {
  factory _$AppShellUiStateCopyWith(_AppShellUiState value, $Res Function(_AppShellUiState) _then) = __$AppShellUiStateCopyWithImpl;
@override @useResult
$Res call({
 bool quickAddSheetOpen, AppShellFeedbackMessage? feedback
});


@override $AppShellFeedbackMessageCopyWith<$Res>? get feedback;

}
/// @nodoc
class __$AppShellUiStateCopyWithImpl<$Res>
    implements _$AppShellUiStateCopyWith<$Res> {
  __$AppShellUiStateCopyWithImpl(this._self, this._then);

  final _AppShellUiState _self;
  final $Res Function(_AppShellUiState) _then;

/// Create a copy of AppShellUiState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quickAddSheetOpen = null,Object? feedback = freezed,}) {
  return _then(_AppShellUiState(
quickAddSheetOpen: null == quickAddSheetOpen ? _self.quickAddSheetOpen : quickAddSheetOpen // ignore: cast_nullable_to_non_nullable
as bool,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as AppShellFeedbackMessage?,
  ));
}

/// Create a copy of AppShellUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppShellFeedbackMessageCopyWith<$Res>? get feedback {
    if (_self.feedback == null) {
    return null;
  }

  return $AppShellFeedbackMessageCopyWith<$Res>(_self.feedback!, (value) {
    return _then(_self.copyWith(feedback: value));
  });
}
}

// dart format on
