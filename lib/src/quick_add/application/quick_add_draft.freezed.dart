// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_add_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuickAddDraft {

 String get draftText; QuickAddEntrySource get source; DateTime? get dueAt; bool get isPinned; bool get isPrivate; bool get hasUnsavedChanges; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of QuickAddDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickAddDraftCopyWith<QuickAddDraft> get copyWith => _$QuickAddDraftCopyWithImpl<QuickAddDraft>(this as QuickAddDraft, _$identity);

  /// Serializes this QuickAddDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickAddDraft&&(identical(other.draftText, draftText) || other.draftText == draftText)&&(identical(other.source, source) || other.source == source)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.hasUnsavedChanges, hasUnsavedChanges) || other.hasUnsavedChanges == hasUnsavedChanges)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,draftText,source,dueAt,isPinned,isPrivate,hasUnsavedChanges,createdAt,updatedAt);

@override
String toString() {
  return 'QuickAddDraft(draftText: $draftText, source: $source, dueAt: $dueAt, isPinned: $isPinned, isPrivate: $isPrivate, hasUnsavedChanges: $hasUnsavedChanges, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $QuickAddDraftCopyWith<$Res>  {
  factory $QuickAddDraftCopyWith(QuickAddDraft value, $Res Function(QuickAddDraft) _then) = _$QuickAddDraftCopyWithImpl;
@useResult
$Res call({
 String draftText, QuickAddEntrySource source, DateTime? dueAt, bool isPinned, bool isPrivate, bool hasUnsavedChanges, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$QuickAddDraftCopyWithImpl<$Res>
    implements $QuickAddDraftCopyWith<$Res> {
  _$QuickAddDraftCopyWithImpl(this._self, this._then);

  final QuickAddDraft _self;
  final $Res Function(QuickAddDraft) _then;

/// Create a copy of QuickAddDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? draftText = null,Object? source = null,Object? dueAt = freezed,Object? isPinned = null,Object? isPrivate = null,Object? hasUnsavedChanges = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
draftText: null == draftText ? _self.draftText : draftText // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as QuickAddEntrySource,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,hasUnsavedChanges: null == hasUnsavedChanges ? _self.hasUnsavedChanges : hasUnsavedChanges // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickAddDraft].
extension QuickAddDraftPatterns on QuickAddDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickAddDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickAddDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickAddDraft value)  $default,){
final _that = this;
switch (_that) {
case _QuickAddDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickAddDraft value)?  $default,){
final _that = this;
switch (_that) {
case _QuickAddDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String draftText,  QuickAddEntrySource source,  DateTime? dueAt,  bool isPinned,  bool isPrivate,  bool hasUnsavedChanges,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickAddDraft() when $default != null:
return $default(_that.draftText,_that.source,_that.dueAt,_that.isPinned,_that.isPrivate,_that.hasUnsavedChanges,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String draftText,  QuickAddEntrySource source,  DateTime? dueAt,  bool isPinned,  bool isPrivate,  bool hasUnsavedChanges,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _QuickAddDraft():
return $default(_that.draftText,_that.source,_that.dueAt,_that.isPinned,_that.isPrivate,_that.hasUnsavedChanges,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String draftText,  QuickAddEntrySource source,  DateTime? dueAt,  bool isPinned,  bool isPrivate,  bool hasUnsavedChanges,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _QuickAddDraft() when $default != null:
return $default(_that.draftText,_that.source,_that.dueAt,_that.isPinned,_that.isPrivate,_that.hasUnsavedChanges,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuickAddDraft implements QuickAddDraft {
  const _QuickAddDraft({this.draftText = '', required this.source, this.dueAt, this.isPinned = false, this.isPrivate = false, this.hasUnsavedChanges = false, required this.createdAt, required this.updatedAt});
  factory _QuickAddDraft.fromJson(Map<String, dynamic> json) => _$QuickAddDraftFromJson(json);

@override@JsonKey() final  String draftText;
@override final  QuickAddEntrySource source;
@override final  DateTime? dueAt;
@override@JsonKey() final  bool isPinned;
@override@JsonKey() final  bool isPrivate;
@override@JsonKey() final  bool hasUnsavedChanges;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of QuickAddDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickAddDraftCopyWith<_QuickAddDraft> get copyWith => __$QuickAddDraftCopyWithImpl<_QuickAddDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuickAddDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickAddDraft&&(identical(other.draftText, draftText) || other.draftText == draftText)&&(identical(other.source, source) || other.source == source)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.hasUnsavedChanges, hasUnsavedChanges) || other.hasUnsavedChanges == hasUnsavedChanges)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,draftText,source,dueAt,isPinned,isPrivate,hasUnsavedChanges,createdAt,updatedAt);

@override
String toString() {
  return 'QuickAddDraft(draftText: $draftText, source: $source, dueAt: $dueAt, isPinned: $isPinned, isPrivate: $isPrivate, hasUnsavedChanges: $hasUnsavedChanges, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$QuickAddDraftCopyWith<$Res> implements $QuickAddDraftCopyWith<$Res> {
  factory _$QuickAddDraftCopyWith(_QuickAddDraft value, $Res Function(_QuickAddDraft) _then) = __$QuickAddDraftCopyWithImpl;
@override @useResult
$Res call({
 String draftText, QuickAddEntrySource source, DateTime? dueAt, bool isPinned, bool isPrivate, bool hasUnsavedChanges, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$QuickAddDraftCopyWithImpl<$Res>
    implements _$QuickAddDraftCopyWith<$Res> {
  __$QuickAddDraftCopyWithImpl(this._self, this._then);

  final _QuickAddDraft _self;
  final $Res Function(_QuickAddDraft) _then;

/// Create a copy of QuickAddDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? draftText = null,Object? source = null,Object? dueAt = freezed,Object? isPinned = null,Object? isPrivate = null,Object? hasUnsavedChanges = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_QuickAddDraft(
draftText: null == draftText ? _self.draftText : draftText // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as QuickAddEntrySource,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,hasUnsavedChanges: null == hasUnsavedChanges ? _self.hasUnsavedChanges : hasUnsavedChanges // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
