// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setting_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SettingModel _$SettingModelFromJson(Map<String, dynamic> json) {
  return _SettingModel.fromJson(json);
}

/// @nodoc
mixin _$SettingModel {
  String get id => throw _privateConstructorUsedError;
  String get key => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  String get category =>
      throw _privateConstructorUsedError; // GENERAL, INVOICE, TAX, NOTIFICATION, etc.
  String? get description => throw _privateConstructorUsedError;
  String get dataType =>
      throw _privateConstructorUsedError; // STRING, NUMBER, BOOLEAN, JSON
  bool get isEditable => throw _privateConstructorUsedError;
  String get storeId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;

  /// Serializes this SettingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SettingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingModelCopyWith<SettingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingModelCopyWith<$Res> {
  factory $SettingModelCopyWith(
          SettingModel value, $Res Function(SettingModel) then) =
      _$SettingModelCopyWithImpl<$Res, SettingModel>;
  @useResult
  $Res call(
      {String id,
      String key,
      String value,
      String category,
      String? description,
      String dataType,
      bool isEditable,
      String storeId,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});
}

/// @nodoc
class _$SettingModelCopyWithImpl<$Res, $Val extends SettingModel>
    implements $SettingModelCopyWith<$Res> {
  _$SettingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? value = null,
    Object? category = null,
    Object? description = freezed,
    Object? dataType = null,
    Object? isEditable = null,
    Object? storeId = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      dataType: null == dataType
          ? _value.dataType
          : dataType // ignore: cast_nullable_to_non_nullable
              as String,
      isEditable: null == isEditable
          ? _value.isEditable
          : isEditable // ignore: cast_nullable_to_non_nullable
              as bool,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettingModelImplCopyWith<$Res>
    implements $SettingModelCopyWith<$Res> {
  factory _$$SettingModelImplCopyWith(
          _$SettingModelImpl value, $Res Function(_$SettingModelImpl) then) =
      __$$SettingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String key,
      String value,
      String category,
      String? description,
      String dataType,
      bool isEditable,
      String storeId,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});
}

/// @nodoc
class __$$SettingModelImplCopyWithImpl<$Res>
    extends _$SettingModelCopyWithImpl<$Res, _$SettingModelImpl>
    implements _$$SettingModelImplCopyWith<$Res> {
  __$$SettingModelImplCopyWithImpl(
      _$SettingModelImpl _value, $Res Function(_$SettingModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SettingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? value = null,
    Object? category = null,
    Object? description = freezed,
    Object? dataType = null,
    Object? isEditable = null,
    Object? storeId = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_$SettingModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      dataType: null == dataType
          ? _value.dataType
          : dataType // ignore: cast_nullable_to_non_nullable
              as String,
      isEditable: null == isEditable
          ? _value.isEditable
          : isEditable // ignore: cast_nullable_to_non_nullable
              as bool,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SettingModelImpl implements _SettingModel {
  const _$SettingModelImpl(
      {required this.id,
      required this.key,
      required this.value,
      required this.category,
      this.description,
      required this.dataType,
      required this.isEditable,
      required this.storeId,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy});

  factory _$SettingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingModelImplFromJson(json);

  @override
  final String id;
  @override
  final String key;
  @override
  final String value;
  @override
  final String category;
// GENERAL, INVOICE, TAX, NOTIFICATION, etc.
  @override
  final String? description;
  @override
  final String dataType;
// STRING, NUMBER, BOOLEAN, JSON
  @override
  final bool isEditable;
  @override
  final String storeId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? createdBy;
  @override
  final String? updatedBy;

  @override
  String toString() {
    return 'SettingModel(id: $id, key: $key, value: $value, category: $category, description: $description, dataType: $dataType, isEditable: $isEditable, storeId: $storeId, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.dataType, dataType) ||
                other.dataType == dataType) &&
            (identical(other.isEditable, isEditable) ||
                other.isEditable == isEditable) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      key,
      value,
      category,
      description,
      dataType,
      isEditable,
      storeId,
      createdAt,
      updatedAt,
      createdBy,
      updatedBy);

  /// Create a copy of SettingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingModelImplCopyWith<_$SettingModelImpl> get copyWith =>
      __$$SettingModelImplCopyWithImpl<_$SettingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingModelImplToJson(
      this,
    );
  }
}

abstract class _SettingModel implements SettingModel {
  const factory _SettingModel(
      {required final String id,
      required final String key,
      required final String value,
      required final String category,
      final String? description,
      required final String dataType,
      required final bool isEditable,
      required final String storeId,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? createdBy,
      final String? updatedBy}) = _$SettingModelImpl;

  factory _SettingModel.fromJson(Map<String, dynamic> json) =
      _$SettingModelImpl.fromJson;

  @override
  String get id;
  @override
  String get key;
  @override
  String get value;
  @override
  String get category; // GENERAL, INVOICE, TAX, NOTIFICATION, etc.
  @override
  String? get description;
  @override
  String get dataType; // STRING, NUMBER, BOOLEAN, JSON
  @override
  bool get isEditable;
  @override
  String get storeId;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get createdBy;
  @override
  String? get updatedBy;

  /// Create a copy of SettingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingModelImplCopyWith<_$SettingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
