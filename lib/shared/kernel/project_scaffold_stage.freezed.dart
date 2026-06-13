// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_scaffold_stage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectScaffoldStage {

 String get stageName; bool get bootstrapCodeReady; bool get featureCodeReady;
/// Create a copy of ProjectScaffoldStage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectScaffoldStageCopyWith<ProjectScaffoldStage> get copyWith => _$ProjectScaffoldStageCopyWithImpl<ProjectScaffoldStage>(this as ProjectScaffoldStage, _$identity);

  /// Serializes this ProjectScaffoldStage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectScaffoldStage&&(identical(other.stageName, stageName) || other.stageName == stageName)&&(identical(other.bootstrapCodeReady, bootstrapCodeReady) || other.bootstrapCodeReady == bootstrapCodeReady)&&(identical(other.featureCodeReady, featureCodeReady) || other.featureCodeReady == featureCodeReady));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stageName,bootstrapCodeReady,featureCodeReady);

@override
String toString() {
  return 'ProjectScaffoldStage(stageName: $stageName, bootstrapCodeReady: $bootstrapCodeReady, featureCodeReady: $featureCodeReady)';
}


}

/// @nodoc
abstract mixin class $ProjectScaffoldStageCopyWith<$Res>  {
  factory $ProjectScaffoldStageCopyWith(ProjectScaffoldStage value, $Res Function(ProjectScaffoldStage) _then) = _$ProjectScaffoldStageCopyWithImpl;
@useResult
$Res call({
 String stageName, bool bootstrapCodeReady, bool featureCodeReady
});




}
/// @nodoc
class _$ProjectScaffoldStageCopyWithImpl<$Res>
    implements $ProjectScaffoldStageCopyWith<$Res> {
  _$ProjectScaffoldStageCopyWithImpl(this._self, this._then);

  final ProjectScaffoldStage _self;
  final $Res Function(ProjectScaffoldStage) _then;

/// Create a copy of ProjectScaffoldStage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stageName = null,Object? bootstrapCodeReady = null,Object? featureCodeReady = null,}) {
  return _then(_self.copyWith(
stageName: null == stageName ? _self.stageName : stageName // ignore: cast_nullable_to_non_nullable
as String,bootstrapCodeReady: null == bootstrapCodeReady ? _self.bootstrapCodeReady : bootstrapCodeReady // ignore: cast_nullable_to_non_nullable
as bool,featureCodeReady: null == featureCodeReady ? _self.featureCodeReady : featureCodeReady // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectScaffoldStage].
extension ProjectScaffoldStagePatterns on ProjectScaffoldStage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectScaffoldStage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectScaffoldStage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectScaffoldStage value)  $default,){
final _that = this;
switch (_that) {
case _ProjectScaffoldStage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectScaffoldStage value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectScaffoldStage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String stageName,  bool bootstrapCodeReady,  bool featureCodeReady)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectScaffoldStage() when $default != null:
return $default(_that.stageName,_that.bootstrapCodeReady,_that.featureCodeReady);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String stageName,  bool bootstrapCodeReady,  bool featureCodeReady)  $default,) {final _that = this;
switch (_that) {
case _ProjectScaffoldStage():
return $default(_that.stageName,_that.bootstrapCodeReady,_that.featureCodeReady);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String stageName,  bool bootstrapCodeReady,  bool featureCodeReady)?  $default,) {final _that = this;
switch (_that) {
case _ProjectScaffoldStage() when $default != null:
return $default(_that.stageName,_that.bootstrapCodeReady,_that.featureCodeReady);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectScaffoldStage implements ProjectScaffoldStage {
  const _ProjectScaffoldStage({required this.stageName, required this.bootstrapCodeReady, required this.featureCodeReady});
  factory _ProjectScaffoldStage.fromJson(Map<String, dynamic> json) => _$ProjectScaffoldStageFromJson(json);

@override final  String stageName;
@override final  bool bootstrapCodeReady;
@override final  bool featureCodeReady;

/// Create a copy of ProjectScaffoldStage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectScaffoldStageCopyWith<_ProjectScaffoldStage> get copyWith => __$ProjectScaffoldStageCopyWithImpl<_ProjectScaffoldStage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectScaffoldStageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectScaffoldStage&&(identical(other.stageName, stageName) || other.stageName == stageName)&&(identical(other.bootstrapCodeReady, bootstrapCodeReady) || other.bootstrapCodeReady == bootstrapCodeReady)&&(identical(other.featureCodeReady, featureCodeReady) || other.featureCodeReady == featureCodeReady));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stageName,bootstrapCodeReady,featureCodeReady);

@override
String toString() {
  return 'ProjectScaffoldStage(stageName: $stageName, bootstrapCodeReady: $bootstrapCodeReady, featureCodeReady: $featureCodeReady)';
}


}

/// @nodoc
abstract mixin class _$ProjectScaffoldStageCopyWith<$Res> implements $ProjectScaffoldStageCopyWith<$Res> {
  factory _$ProjectScaffoldStageCopyWith(_ProjectScaffoldStage value, $Res Function(_ProjectScaffoldStage) _then) = __$ProjectScaffoldStageCopyWithImpl;
@override @useResult
$Res call({
 String stageName, bool bootstrapCodeReady, bool featureCodeReady
});




}
/// @nodoc
class __$ProjectScaffoldStageCopyWithImpl<$Res>
    implements _$ProjectScaffoldStageCopyWith<$Res> {
  __$ProjectScaffoldStageCopyWithImpl(this._self, this._then);

  final _ProjectScaffoldStage _self;
  final $Res Function(_ProjectScaffoldStage) _then;

/// Create a copy of ProjectScaffoldStage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stageName = null,Object? bootstrapCodeReady = null,Object? featureCodeReady = null,}) {
  return _then(_ProjectScaffoldStage(
stageName: null == stageName ? _self.stageName : stageName // ignore: cast_nullable_to_non_nullable
as String,bootstrapCodeReady: null == bootstrapCodeReady ? _self.bootstrapCodeReady : bootstrapCodeReady // ignore: cast_nullable_to_non_nullable
as bool,featureCodeReady: null == featureCodeReady ? _self.featureCodeReady : featureCodeReady // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
