// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return _ProductModel.fromJson(json);
}

/// @nodoc
mixin _$ProductModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get storeId => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductModelCopyWith<ProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
          ProductModel value, $Res Function(ProductModel) then) =
      _$ProductModelCopyWithImpl<$Res, ProductModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String? barcode,
      String category,
      String storeId,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res, $Val extends ProductModel>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? barcode = freezed,
    Object? category = null,
    Object? storeId = null,
    Object? isActive = null,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$ProductModelImplCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$$ProductModelImplCopyWith(
          _$ProductModelImpl value, $Res Function(_$ProductModelImpl) then) =
      __$$ProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String? barcode,
      String category,
      String storeId,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});
}

/// @nodoc
class __$$ProductModelImplCopyWithImpl<$Res>
    extends _$ProductModelCopyWithImpl<$Res, _$ProductModelImpl>
    implements _$$ProductModelImplCopyWith<$Res> {
  __$$ProductModelImplCopyWithImpl(
      _$ProductModelImpl _value, $Res Function(_$ProductModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? barcode = freezed,
    Object? category = null,
    Object? storeId = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_$ProductModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$ProductModelImpl implements _ProductModel {
  const _$ProductModelImpl(
      {required this.id,
      required this.name,
      this.description,
      this.barcode,
      required this.category,
      required this.storeId,
      required this.isActive,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy});

  factory _$ProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? barcode;
  @override
  final String category;
  @override
  final String storeId;
  @override
  final bool isActive;
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
    return 'ProductModel(id: $id, name: $name, description: $description, barcode: $barcode, category: $category, storeId: $storeId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
  int get hashCode => Object.hash(runtimeType, id, name, description, barcode,
      category, storeId, isActive, createdAt, updatedAt, createdBy, updatedBy);

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      __$$ProductModelImplCopyWithImpl<_$ProductModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductModelImplToJson(
      this,
    );
  }
}

abstract class _ProductModel implements ProductModel {
  const factory _ProductModel(
      {required final String id,
      required final String name,
      final String? description,
      final String? barcode,
      required final String category,
      required final String storeId,
      required final bool isActive,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? createdBy,
      final String? updatedBy}) = _$ProductModelImpl;

  factory _ProductModel.fromJson(Map<String, dynamic> json) =
      _$ProductModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get barcode;
  @override
  String get category;
  @override
  String get storeId;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get createdBy;
  @override
  String? get updatedBy;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductVariantModel _$ProductVariantModelFromJson(Map<String, dynamic> json) {
  return _ProductVariantModel.fromJson(json);
}

/// @nodoc
mixin _$ProductVariantModel {
  String get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get cost => throw _privateConstructorUsedError;
  int get stock => throw _privateConstructorUsedError;
  int? get minimumStock => throw _privateConstructorUsedError;
  int? get maximumStock => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get size => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ProductVariantModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductVariantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductVariantModelCopyWith<ProductVariantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductVariantModelCopyWith<$Res> {
  factory $ProductVariantModelCopyWith(
          ProductVariantModel value, $Res Function(ProductVariantModel) then) =
      _$ProductVariantModelCopyWithImpl<$Res, ProductVariantModel>;
  @useResult
  $Res call(
      {String id,
      String productId,
      String sku,
      String name,
      String? description,
      double price,
      double cost,
      int stock,
      int? minimumStock,
      int? maximumStock,
      String? unit,
      double? weight,
      String? color,
      String? size,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ProductVariantModelCopyWithImpl<$Res, $Val extends ProductVariantModel>
    implements $ProductVariantModelCopyWith<$Res> {
  _$ProductVariantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductVariantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? sku = null,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? cost = null,
    Object? stock = null,
    Object? minimumStock = freezed,
    Object? maximumStock = freezed,
    Object? unit = freezed,
    Object? weight = freezed,
    Object? color = freezed,
    Object? size = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      minimumStock: freezed == minimumStock
          ? _value.minimumStock
          : minimumStock // ignore: cast_nullable_to_non_nullable
              as int?,
      maximumStock: freezed == maximumStock
          ? _value.maximumStock
          : maximumStock // ignore: cast_nullable_to_non_nullable
              as int?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$ProductVariantModelImplCopyWith<$Res>
    implements $ProductVariantModelCopyWith<$Res> {
  factory _$$ProductVariantModelImplCopyWith(_$ProductVariantModelImpl value,
          $Res Function(_$ProductVariantModelImpl) then) =
      __$$ProductVariantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String productId,
      String sku,
      String name,
      String? description,
      double price,
      double cost,
      int stock,
      int? minimumStock,
      int? maximumStock,
      String? unit,
      double? weight,
      String? color,
      String? size,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ProductVariantModelImplCopyWithImpl<$Res>
    extends _$ProductVariantModelCopyWithImpl<$Res, _$ProductVariantModelImpl>
    implements _$$ProductVariantModelImplCopyWith<$Res> {
  __$$ProductVariantModelImplCopyWithImpl(_$ProductVariantModelImpl _value,
      $Res Function(_$ProductVariantModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductVariantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? sku = null,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? cost = null,
    Object? stock = null,
    Object? minimumStock = freezed,
    Object? maximumStock = freezed,
    Object? unit = freezed,
    Object? weight = freezed,
    Object? color = freezed,
    Object? size = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ProductVariantModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      minimumStock: freezed == minimumStock
          ? _value.minimumStock
          : minimumStock // ignore: cast_nullable_to_non_nullable
              as int?,
      maximumStock: freezed == maximumStock
          ? _value.maximumStock
          : maximumStock // ignore: cast_nullable_to_non_nullable
              as int?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$ProductVariantModelImpl implements _ProductVariantModel {
  const _$ProductVariantModelImpl(
      {required this.id,
      required this.productId,
      required this.sku,
      required this.name,
      this.description,
      required this.price,
      required this.cost,
      required this.stock,
      this.minimumStock,
      this.maximumStock,
      this.unit,
      this.weight,
      this.color,
      this.size,
      required this.isActive,
      this.createdAt,
      this.updatedAt});

  factory _$ProductVariantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductVariantModelImplFromJson(json);

  @override
  final String id;
  @override
  final String productId;
  @override
  final String sku;
  @override
  final String name;
  @override
  final String? description;
  @override
  final double price;
  @override
  final double cost;
  @override
  final int stock;
  @override
  final int? minimumStock;
  @override
  final int? maximumStock;
  @override
  final String? unit;
  @override
  final double? weight;
  @override
  final String? color;
  @override
  final String? size;
  @override
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ProductVariantModel(id: $id, productId: $productId, sku: $sku, name: $name, description: $description, price: $price, cost: $cost, stock: $stock, minimumStock: $minimumStock, maximumStock: $maximumStock, unit: $unit, weight: $weight, color: $color, size: $size, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductVariantModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.minimumStock, minimumStock) ||
                other.minimumStock == minimumStock) &&
            (identical(other.maximumStock, maximumStock) ||
                other.maximumStock == maximumStock) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
      productId,
      sku,
      name,
      description,
      price,
      cost,
      stock,
      minimumStock,
      maximumStock,
      unit,
      weight,
      color,
      size,
      isActive,
      createdAt,
      updatedAt);

  /// Create a copy of ProductVariantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductVariantModelImplCopyWith<_$ProductVariantModelImpl> get copyWith =>
      __$$ProductVariantModelImplCopyWithImpl<_$ProductVariantModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductVariantModelImplToJson(
      this,
    );
  }
}

abstract class _ProductVariantModel implements ProductVariantModel {
  const factory _ProductVariantModel(
      {required final String id,
      required final String productId,
      required final String sku,
      required final String name,
      final String? description,
      required final double price,
      required final double cost,
      required final int stock,
      final int? minimumStock,
      final int? maximumStock,
      final String? unit,
      final double? weight,
      final String? color,
      final String? size,
      required final bool isActive,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ProductVariantModelImpl;

  factory _ProductVariantModel.fromJson(Map<String, dynamic> json) =
      _$ProductVariantModelImpl.fromJson;

  @override
  String get id;
  @override
  String get productId;
  @override
  String get sku;
  @override
  String get name;
  @override
  String? get description;
  @override
  double get price;
  @override
  double get cost;
  @override
  int get stock;
  @override
  int? get minimumStock;
  @override
  int? get maximumStock;
  @override
  String? get unit;
  @override
  double? get weight;
  @override
  String? get color;
  @override
  String? get size;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ProductVariantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductVariantModelImplCopyWith<_$ProductVariantModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
