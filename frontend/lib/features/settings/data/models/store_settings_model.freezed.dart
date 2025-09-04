// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StoreSettingsModel _$StoreSettingsModelFromJson(Map<String, dynamic> json) {
  return _StoreSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$StoreSettingsModel {
  String get id => throw _privateConstructorUsedError;
  String get storeName => throw _privateConstructorUsedError;
  String get storeAddress => throw _privateConstructorUsedError;
  String? get storePhone => throw _privateConstructorUsedError;
  String? get storeEmail => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get taxRate => throw _privateConstructorUsedError;
  String get invoiceFormat => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this StoreSettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreSettingsModelCopyWith<StoreSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreSettingsModelCopyWith<$Res> {
  factory $StoreSettingsModelCopyWith(
          StoreSettingsModel value, $Res Function(StoreSettingsModel) then) =
      _$StoreSettingsModelCopyWithImpl<$Res, StoreSettingsModel>;
  @useResult
  $Res call(
      {String id,
      String storeName,
      String storeAddress,
      String? storePhone,
      String? storeEmail,
      String currency,
      String taxRate,
      String invoiceFormat,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$StoreSettingsModelCopyWithImpl<$Res, $Val extends StoreSettingsModel>
    implements $StoreSettingsModelCopyWith<$Res> {
  _$StoreSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeName = null,
    Object? storeAddress = null,
    Object? storePhone = freezed,
    Object? storeEmail = freezed,
    Object? currency = null,
    Object? taxRate = null,
    Object? invoiceFormat = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      storeAddress: null == storeAddress
          ? _value.storeAddress
          : storeAddress // ignore: cast_nullable_to_non_nullable
              as String,
      storePhone: freezed == storePhone
          ? _value.storePhone
          : storePhone // ignore: cast_nullable_to_non_nullable
              as String?,
      storeEmail: freezed == storeEmail
          ? _value.storeEmail
          : storeEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceFormat: null == invoiceFormat
          ? _value.invoiceFormat
          : invoiceFormat // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreSettingsModelImplCopyWith<$Res>
    implements $StoreSettingsModelCopyWith<$Res> {
  factory _$$StoreSettingsModelImplCopyWith(_$StoreSettingsModelImpl value,
          $Res Function(_$StoreSettingsModelImpl) then) =
      __$$StoreSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String storeName,
      String storeAddress,
      String? storePhone,
      String? storeEmail,
      String currency,
      String taxRate,
      String invoiceFormat,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$StoreSettingsModelImplCopyWithImpl<$Res>
    extends _$StoreSettingsModelCopyWithImpl<$Res, _$StoreSettingsModelImpl>
    implements _$$StoreSettingsModelImplCopyWith<$Res> {
  __$$StoreSettingsModelImplCopyWithImpl(_$StoreSettingsModelImpl _value,
      $Res Function(_$StoreSettingsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeName = null,
    Object? storeAddress = null,
    Object? storePhone = freezed,
    Object? storeEmail = freezed,
    Object? currency = null,
    Object? taxRate = null,
    Object? invoiceFormat = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$StoreSettingsModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      storeAddress: null == storeAddress
          ? _value.storeAddress
          : storeAddress // ignore: cast_nullable_to_non_nullable
              as String,
      storePhone: freezed == storePhone
          ? _value.storePhone
          : storePhone // ignore: cast_nullable_to_non_nullable
              as String?,
      storeEmail: freezed == storeEmail
          ? _value.storeEmail
          : storeEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceFormat: null == invoiceFormat
          ? _value.invoiceFormat
          : invoiceFormat // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreSettingsModelImpl implements _StoreSettingsModel {
  const _$StoreSettingsModelImpl(
      {required this.id,
      required this.storeName,
      required this.storeAddress,
      this.storePhone,
      this.storeEmail,
      required this.currency,
      required this.taxRate,
      required this.invoiceFormat,
      this.createdAt,
      this.updatedAt});

  factory _$StoreSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreSettingsModelImplFromJson(json);

  @override
  final String id;
  @override
  final String storeName;
  @override
  final String storeAddress;
  @override
  final String? storePhone;
  @override
  final String? storeEmail;
  @override
  final String currency;
  @override
  final String taxRate;
  @override
  final String invoiceFormat;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'StoreSettingsModel(id: $id, storeName: $storeName, storeAddress: $storeAddress, storePhone: $storePhone, storeEmail: $storeEmail, currency: $currency, taxRate: $taxRate, invoiceFormat: $invoiceFormat, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreSettingsModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.storeAddress, storeAddress) ||
                other.storeAddress == storeAddress) &&
            (identical(other.storePhone, storePhone) ||
                other.storePhone == storePhone) &&
            (identical(other.storeEmail, storeEmail) ||
                other.storeEmail == storeEmail) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.invoiceFormat, invoiceFormat) ||
                other.invoiceFormat == invoiceFormat) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      storeName,
      storeAddress,
      storePhone,
      storeEmail,
      currency,
      taxRate,
      invoiceFormat,
      createdAt,
      updatedAt);

  /// Create a copy of StoreSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreSettingsModelImplCopyWith<_$StoreSettingsModelImpl> get copyWith =>
      __$$StoreSettingsModelImplCopyWithImpl<_$StoreSettingsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _StoreSettingsModel implements StoreSettingsModel {
  const factory _StoreSettingsModel(
      {required final String id,
      required final String storeName,
      required final String storeAddress,
      final String? storePhone,
      final String? storeEmail,
      required final String currency,
      required final String taxRate,
      required final String invoiceFormat,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$StoreSettingsModelImpl;

  factory _StoreSettingsModel.fromJson(Map<String, dynamic> json) =
      _$StoreSettingsModelImpl.fromJson;

  @override
  String get id;
  @override
  String get storeName;
  @override
  String get storeAddress;
  @override
  String? get storePhone;
  @override
  String? get storeEmail;
  @override
  String get currency;
  @override
  String get taxRate;
  @override
  String get invoiceFormat;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of StoreSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreSettingsModelImplCopyWith<_$StoreSettingsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
