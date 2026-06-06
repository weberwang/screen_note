// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'widget_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WidgetSnapshot {

 String get snapshotId; DateTime get generatedAt; WidgetDisplayMode get displayMode; String get headerTitle; String get emptyTitle; String get emptyBody; String get fallbackHint; List<WidgetSnapshotItem> get items; bool get hasPrivateContent; bool get hasFallbackContent; int get version;
/// Create a copy of WidgetSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WidgetSnapshotCopyWith<WidgetSnapshot> get copyWith => _$WidgetSnapshotCopyWithImpl<WidgetSnapshot>(this as WidgetSnapshot, _$identity);

  /// Serializes this WidgetSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WidgetSnapshot&&(identical(other.snapshotId, snapshotId) || other.snapshotId == snapshotId)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.displayMode, displayMode) || other.displayMode == displayMode)&&(identical(other.headerTitle, headerTitle) || other.headerTitle == headerTitle)&&(identical(other.emptyTitle, emptyTitle) || other.emptyTitle == emptyTitle)&&(identical(other.emptyBody, emptyBody) || other.emptyBody == emptyBody)&&(identical(other.fallbackHint, fallbackHint) || other.fallbackHint == fallbackHint)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.hasPrivateContent, hasPrivateContent) || other.hasPrivateContent == hasPrivateContent)&&(identical(other.hasFallbackContent, hasFallbackContent) || other.hasFallbackContent == hasFallbackContent)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,snapshotId,generatedAt,displayMode,headerTitle,emptyTitle,emptyBody,fallbackHint,const DeepCollectionEquality().hash(items),hasPrivateContent,hasFallbackContent,version);

@override
String toString() {
  return 'WidgetSnapshot(snapshotId: $snapshotId, generatedAt: $generatedAt, displayMode: $displayMode, headerTitle: $headerTitle, emptyTitle: $emptyTitle, emptyBody: $emptyBody, fallbackHint: $fallbackHint, items: $items, hasPrivateContent: $hasPrivateContent, hasFallbackContent: $hasFallbackContent, version: $version)';
}


}

/// @nodoc
abstract mixin class $WidgetSnapshotCopyWith<$Res>  {
  factory $WidgetSnapshotCopyWith(WidgetSnapshot value, $Res Function(WidgetSnapshot) _then) = _$WidgetSnapshotCopyWithImpl;
@useResult
$Res call({
 String snapshotId, DateTime generatedAt, WidgetDisplayMode displayMode, String headerTitle, String emptyTitle, String emptyBody, String fallbackHint, List<WidgetSnapshotItem> items, bool hasPrivateContent, bool hasFallbackContent, int version
});




}
/// @nodoc
class _$WidgetSnapshotCopyWithImpl<$Res>
    implements $WidgetSnapshotCopyWith<$Res> {
  _$WidgetSnapshotCopyWithImpl(this._self, this._then);

  final WidgetSnapshot _self;
  final $Res Function(WidgetSnapshot) _then;

/// Create a copy of WidgetSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? snapshotId = null,Object? generatedAt = null,Object? displayMode = null,Object? headerTitle = null,Object? emptyTitle = null,Object? emptyBody = null,Object? fallbackHint = null,Object? items = null,Object? hasPrivateContent = null,Object? hasFallbackContent = null,Object? version = null,}) {
  return _then(_self.copyWith(
snapshotId: null == snapshotId ? _self.snapshotId : snapshotId // ignore: cast_nullable_to_non_nullable
as String,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,displayMode: null == displayMode ? _self.displayMode : displayMode // ignore: cast_nullable_to_non_nullable
as WidgetDisplayMode,headerTitle: null == headerTitle ? _self.headerTitle : headerTitle // ignore: cast_nullable_to_non_nullable
as String,emptyTitle: null == emptyTitle ? _self.emptyTitle : emptyTitle // ignore: cast_nullable_to_non_nullable
as String,emptyBody: null == emptyBody ? _self.emptyBody : emptyBody // ignore: cast_nullable_to_non_nullable
as String,fallbackHint: null == fallbackHint ? _self.fallbackHint : fallbackHint // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<WidgetSnapshotItem>,hasPrivateContent: null == hasPrivateContent ? _self.hasPrivateContent : hasPrivateContent // ignore: cast_nullable_to_non_nullable
as bool,hasFallbackContent: null == hasFallbackContent ? _self.hasFallbackContent : hasFallbackContent // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WidgetSnapshot].
extension WidgetSnapshotPatterns on WidgetSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WidgetSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WidgetSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WidgetSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _WidgetSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WidgetSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _WidgetSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String snapshotId,  DateTime generatedAt,  WidgetDisplayMode displayMode,  String headerTitle,  String emptyTitle,  String emptyBody,  String fallbackHint,  List<WidgetSnapshotItem> items,  bool hasPrivateContent,  bool hasFallbackContent,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WidgetSnapshot() when $default != null:
return $default(_that.snapshotId,_that.generatedAt,_that.displayMode,_that.headerTitle,_that.emptyTitle,_that.emptyBody,_that.fallbackHint,_that.items,_that.hasPrivateContent,_that.hasFallbackContent,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String snapshotId,  DateTime generatedAt,  WidgetDisplayMode displayMode,  String headerTitle,  String emptyTitle,  String emptyBody,  String fallbackHint,  List<WidgetSnapshotItem> items,  bool hasPrivateContent,  bool hasFallbackContent,  int version)  $default,) {final _that = this;
switch (_that) {
case _WidgetSnapshot():
return $default(_that.snapshotId,_that.generatedAt,_that.displayMode,_that.headerTitle,_that.emptyTitle,_that.emptyBody,_that.fallbackHint,_that.items,_that.hasPrivateContent,_that.hasFallbackContent,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String snapshotId,  DateTime generatedAt,  WidgetDisplayMode displayMode,  String headerTitle,  String emptyTitle,  String emptyBody,  String fallbackHint,  List<WidgetSnapshotItem> items,  bool hasPrivateContent,  bool hasFallbackContent,  int version)?  $default,) {final _that = this;
switch (_that) {
case _WidgetSnapshot() when $default != null:
return $default(_that.snapshotId,_that.generatedAt,_that.displayMode,_that.headerTitle,_that.emptyTitle,_that.emptyBody,_that.fallbackHint,_that.items,_that.hasPrivateContent,_that.hasFallbackContent,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WidgetSnapshot implements WidgetSnapshot {
  const _WidgetSnapshot({required this.snapshotId, required this.generatedAt, required this.displayMode, required this.headerTitle, required this.emptyTitle, required this.emptyBody, required this.fallbackHint, required final  List<WidgetSnapshotItem> items, required this.hasPrivateContent, required this.hasFallbackContent, required this.version}): _items = items;
  factory _WidgetSnapshot.fromJson(Map<String, dynamic> json) => _$WidgetSnapshotFromJson(json);

@override final  String snapshotId;
@override final  DateTime generatedAt;
@override final  WidgetDisplayMode displayMode;
@override final  String headerTitle;
@override final  String emptyTitle;
@override final  String emptyBody;
@override final  String fallbackHint;
 final  List<WidgetSnapshotItem> _items;
@override List<WidgetSnapshotItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  bool hasPrivateContent;
@override final  bool hasFallbackContent;
@override final  int version;

/// Create a copy of WidgetSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WidgetSnapshotCopyWith<_WidgetSnapshot> get copyWith => __$WidgetSnapshotCopyWithImpl<_WidgetSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WidgetSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WidgetSnapshot&&(identical(other.snapshotId, snapshotId) || other.snapshotId == snapshotId)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.displayMode, displayMode) || other.displayMode == displayMode)&&(identical(other.headerTitle, headerTitle) || other.headerTitle == headerTitle)&&(identical(other.emptyTitle, emptyTitle) || other.emptyTitle == emptyTitle)&&(identical(other.emptyBody, emptyBody) || other.emptyBody == emptyBody)&&(identical(other.fallbackHint, fallbackHint) || other.fallbackHint == fallbackHint)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasPrivateContent, hasPrivateContent) || other.hasPrivateContent == hasPrivateContent)&&(identical(other.hasFallbackContent, hasFallbackContent) || other.hasFallbackContent == hasFallbackContent)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,snapshotId,generatedAt,displayMode,headerTitle,emptyTitle,emptyBody,fallbackHint,const DeepCollectionEquality().hash(_items),hasPrivateContent,hasFallbackContent,version);

@override
String toString() {
  return 'WidgetSnapshot(snapshotId: $snapshotId, generatedAt: $generatedAt, displayMode: $displayMode, headerTitle: $headerTitle, emptyTitle: $emptyTitle, emptyBody: $emptyBody, fallbackHint: $fallbackHint, items: $items, hasPrivateContent: $hasPrivateContent, hasFallbackContent: $hasFallbackContent, version: $version)';
}


}

/// @nodoc
abstract mixin class _$WidgetSnapshotCopyWith<$Res> implements $WidgetSnapshotCopyWith<$Res> {
  factory _$WidgetSnapshotCopyWith(_WidgetSnapshot value, $Res Function(_WidgetSnapshot) _then) = __$WidgetSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String snapshotId, DateTime generatedAt, WidgetDisplayMode displayMode, String headerTitle, String emptyTitle, String emptyBody, String fallbackHint, List<WidgetSnapshotItem> items, bool hasPrivateContent, bool hasFallbackContent, int version
});




}
/// @nodoc
class __$WidgetSnapshotCopyWithImpl<$Res>
    implements _$WidgetSnapshotCopyWith<$Res> {
  __$WidgetSnapshotCopyWithImpl(this._self, this._then);

  final _WidgetSnapshot _self;
  final $Res Function(_WidgetSnapshot) _then;

/// Create a copy of WidgetSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? snapshotId = null,Object? generatedAt = null,Object? displayMode = null,Object? headerTitle = null,Object? emptyTitle = null,Object? emptyBody = null,Object? fallbackHint = null,Object? items = null,Object? hasPrivateContent = null,Object? hasFallbackContent = null,Object? version = null,}) {
  return _then(_WidgetSnapshot(
snapshotId: null == snapshotId ? _self.snapshotId : snapshotId // ignore: cast_nullable_to_non_nullable
as String,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,displayMode: null == displayMode ? _self.displayMode : displayMode // ignore: cast_nullable_to_non_nullable
as WidgetDisplayMode,headerTitle: null == headerTitle ? _self.headerTitle : headerTitle // ignore: cast_nullable_to_non_nullable
as String,emptyTitle: null == emptyTitle ? _self.emptyTitle : emptyTitle // ignore: cast_nullable_to_non_nullable
as String,emptyBody: null == emptyBody ? _self.emptyBody : emptyBody // ignore: cast_nullable_to_non_nullable
as String,fallbackHint: null == fallbackHint ? _self.fallbackHint : fallbackHint // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<WidgetSnapshotItem>,hasPrivateContent: null == hasPrivateContent ? _self.hasPrivateContent : hasPrivateContent // ignore: cast_nullable_to_non_nullable
as bool,hasFallbackContent: null == hasFallbackContent ? _self.hasFallbackContent : hasFallbackContent // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
