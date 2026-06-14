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





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppShellLaunchIntent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppShellLaunchIntent()';
}


}

/// @nodoc
class $AppShellLaunchIntentCopyWith<$Res>  {
$AppShellLaunchIntentCopyWith(AppShellLaunchIntent _, $Res Function(AppShellLaunchIntent) __);
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Home value)?  home,TResult Function( _History value)?  history,TResult Function( _Settings value)?  settings,TResult Function( _TaskEditor value)?  taskEditor,TResult Function( _FallbackHome value)?  fallbackHome,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Home() when home != null:
return home(_that);case _History() when history != null:
return history(_that);case _Settings() when settings != null:
return settings(_that);case _TaskEditor() when taskEditor != null:
return taskEditor(_that);case _FallbackHome() when fallbackHome != null:
return fallbackHome(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Home value)  home,required TResult Function( _History value)  history,required TResult Function( _Settings value)  settings,required TResult Function( _TaskEditor value)  taskEditor,required TResult Function( _FallbackHome value)  fallbackHome,}){
final _that = this;
switch (_that) {
case _Home():
return home(_that);case _History():
return history(_that);case _Settings():
return settings(_that);case _TaskEditor():
return taskEditor(_that);case _FallbackHome():
return fallbackHome(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Home value)?  home,TResult? Function( _History value)?  history,TResult? Function( _Settings value)?  settings,TResult? Function( _TaskEditor value)?  taskEditor,TResult? Function( _FallbackHome value)?  fallbackHome,}){
final _that = this;
switch (_that) {
case _Home() when home != null:
return home(_that);case _History() when history != null:
return history(_that);case _Settings() when settings != null:
return settings(_that);case _TaskEditor() when taskEditor != null:
return taskEditor(_that);case _FallbackHome() when fallbackHome != null:
return fallbackHome(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  home,TResult Function()?  history,TResult Function()?  settings,TResult Function( String taskId)?  taskEditor,TResult Function()?  fallbackHome,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Home() when home != null:
return home();case _History() when history != null:
return history();case _Settings() when settings != null:
return settings();case _TaskEditor() when taskEditor != null:
return taskEditor(_that.taskId);case _FallbackHome() when fallbackHome != null:
return fallbackHome();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  home,required TResult Function()  history,required TResult Function()  settings,required TResult Function( String taskId)  taskEditor,required TResult Function()  fallbackHome,}) {final _that = this;
switch (_that) {
case _Home():
return home();case _History():
return history();case _Settings():
return settings();case _TaskEditor():
return taskEditor(_that.taskId);case _FallbackHome():
return fallbackHome();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  home,TResult? Function()?  history,TResult? Function()?  settings,TResult? Function( String taskId)?  taskEditor,TResult? Function()?  fallbackHome,}) {final _that = this;
switch (_that) {
case _Home() when home != null:
return home();case _History() when history != null:
return history();case _Settings() when settings != null:
return settings();case _TaskEditor() when taskEditor != null:
return taskEditor(_that.taskId);case _FallbackHome() when fallbackHome != null:
return fallbackHome();case _:
  return null;

}
}

}

/// @nodoc


class _Home implements AppShellLaunchIntent {
  const _Home();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Home);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppShellLaunchIntent.home()';
}


}




/// @nodoc


class _History implements AppShellLaunchIntent {
  const _History();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _History);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppShellLaunchIntent.history()';
}


}




/// @nodoc


class _Settings implements AppShellLaunchIntent {
  const _Settings();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Settings);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppShellLaunchIntent.settings()';
}


}




/// @nodoc


class _TaskEditor implements AppShellLaunchIntent {
  const _TaskEditor({required this.taskId});
  

 final  String taskId;

/// Create a copy of AppShellLaunchIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskEditorCopyWith<_TaskEditor> get copyWith => __$TaskEditorCopyWithImpl<_TaskEditor>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskEditor&&(identical(other.taskId, taskId) || other.taskId == taskId));
}


@override
int get hashCode => Object.hash(runtimeType,taskId);

@override
String toString() {
  return 'AppShellLaunchIntent.taskEditor(taskId: $taskId)';
}


}

/// @nodoc
abstract mixin class _$TaskEditorCopyWith<$Res> implements $AppShellLaunchIntentCopyWith<$Res> {
  factory _$TaskEditorCopyWith(_TaskEditor value, $Res Function(_TaskEditor) _then) = __$TaskEditorCopyWithImpl;
@useResult
$Res call({
 String taskId
});




}
/// @nodoc
class __$TaskEditorCopyWithImpl<$Res>
    implements _$TaskEditorCopyWith<$Res> {
  __$TaskEditorCopyWithImpl(this._self, this._then);

  final _TaskEditor _self;
  final $Res Function(_TaskEditor) _then;

/// Create a copy of AppShellLaunchIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? taskId = null,}) {
  return _then(_TaskEditor(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _FallbackHome implements AppShellLaunchIntent {
  const _FallbackHome();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FallbackHome);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppShellLaunchIntent.fallbackHome()';
}


}




// dart format on
