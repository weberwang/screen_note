// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_add_flow_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuickAddFlowResult {

 QuickAddFlowStatus get status; QuickAddDraft? get draft; String? get taskId; String? get routePath;
/// Create a copy of QuickAddFlowResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickAddFlowResultCopyWith<QuickAddFlowResult> get copyWith => _$QuickAddFlowResultCopyWithImpl<QuickAddFlowResult>(this as QuickAddFlowResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickAddFlowResult&&(identical(other.status, status) || other.status == status)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.routePath, routePath) || other.routePath == routePath));
}


@override
int get hashCode => Object.hash(runtimeType,status,draft,taskId,routePath);

@override
String toString() {
  return 'QuickAddFlowResult(status: $status, draft: $draft, taskId: $taskId, routePath: $routePath)';
}


}

/// @nodoc
abstract mixin class $QuickAddFlowResultCopyWith<$Res>  {
  factory $QuickAddFlowResultCopyWith(QuickAddFlowResult value, $Res Function(QuickAddFlowResult) _then) = _$QuickAddFlowResultCopyWithImpl;
@useResult
$Res call({
 QuickAddFlowStatus status, QuickAddDraft? draft, String? taskId, String? routePath
});


$QuickAddDraftCopyWith<$Res>? get draft;

}
/// @nodoc
class _$QuickAddFlowResultCopyWithImpl<$Res>
    implements $QuickAddFlowResultCopyWith<$Res> {
  _$QuickAddFlowResultCopyWithImpl(this._self, this._then);

  final QuickAddFlowResult _self;
  final $Res Function(QuickAddFlowResult) _then;

/// Create a copy of QuickAddFlowResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? draft = freezed,Object? taskId = freezed,Object? routePath = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as QuickAddFlowStatus,draft: freezed == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as QuickAddDraft?,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,routePath: freezed == routePath ? _self.routePath : routePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of QuickAddFlowResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuickAddDraftCopyWith<$Res>? get draft {
    if (_self.draft == null) {
    return null;
  }

  return $QuickAddDraftCopyWith<$Res>(_self.draft!, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuickAddFlowResult].
extension QuickAddFlowResultPatterns on QuickAddFlowResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickAddFlowResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickAddFlowResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickAddFlowResult value)  $default,){
final _that = this;
switch (_that) {
case _QuickAddFlowResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickAddFlowResult value)?  $default,){
final _that = this;
switch (_that) {
case _QuickAddFlowResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( QuickAddFlowStatus status,  QuickAddDraft? draft,  String? taskId,  String? routePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickAddFlowResult() when $default != null:
return $default(_that.status,_that.draft,_that.taskId,_that.routePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( QuickAddFlowStatus status,  QuickAddDraft? draft,  String? taskId,  String? routePath)  $default,) {final _that = this;
switch (_that) {
case _QuickAddFlowResult():
return $default(_that.status,_that.draft,_that.taskId,_that.routePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( QuickAddFlowStatus status,  QuickAddDraft? draft,  String? taskId,  String? routePath)?  $default,) {final _that = this;
switch (_that) {
case _QuickAddFlowResult() when $default != null:
return $default(_that.status,_that.draft,_that.taskId,_that.routePath);case _:
  return null;

}
}

}

/// @nodoc


class _QuickAddFlowResult implements QuickAddFlowResult {
  const _QuickAddFlowResult({required this.status, this.draft, this.taskId, this.routePath});
  

@override final  QuickAddFlowStatus status;
@override final  QuickAddDraft? draft;
@override final  String? taskId;
@override final  String? routePath;

/// Create a copy of QuickAddFlowResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickAddFlowResultCopyWith<_QuickAddFlowResult> get copyWith => __$QuickAddFlowResultCopyWithImpl<_QuickAddFlowResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickAddFlowResult&&(identical(other.status, status) || other.status == status)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.routePath, routePath) || other.routePath == routePath));
}


@override
int get hashCode => Object.hash(runtimeType,status,draft,taskId,routePath);

@override
String toString() {
  return 'QuickAddFlowResult(status: $status, draft: $draft, taskId: $taskId, routePath: $routePath)';
}


}

/// @nodoc
abstract mixin class _$QuickAddFlowResultCopyWith<$Res> implements $QuickAddFlowResultCopyWith<$Res> {
  factory _$QuickAddFlowResultCopyWith(_QuickAddFlowResult value, $Res Function(_QuickAddFlowResult) _then) = __$QuickAddFlowResultCopyWithImpl;
@override @useResult
$Res call({
 QuickAddFlowStatus status, QuickAddDraft? draft, String? taskId, String? routePath
});


@override $QuickAddDraftCopyWith<$Res>? get draft;

}
/// @nodoc
class __$QuickAddFlowResultCopyWithImpl<$Res>
    implements _$QuickAddFlowResultCopyWith<$Res> {
  __$QuickAddFlowResultCopyWithImpl(this._self, this._then);

  final _QuickAddFlowResult _self;
  final $Res Function(_QuickAddFlowResult) _then;

/// Create a copy of QuickAddFlowResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? draft = freezed,Object? taskId = freezed,Object? routePath = freezed,}) {
  return _then(_QuickAddFlowResult(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as QuickAddFlowStatus,draft: freezed == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as QuickAddDraft?,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,routePath: freezed == routePath ? _self.routePath : routePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of QuickAddFlowResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuickAddDraftCopyWith<$Res>? get draft {
    if (_self.draft == null) {
    return null;
  }

  return $QuickAddDraftCopyWith<$Res>(_self.draft!, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

// dart format on
