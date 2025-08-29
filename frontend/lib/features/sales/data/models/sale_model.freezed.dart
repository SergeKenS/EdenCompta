// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SaleModel _$SaleModelFromJson(Map<String, dynamic> json) {
  return _SaleModel.fromJson(json);
}

/// @nodoc
mixin _$SaleModel {
  String get id => throw _privateConstructorUsedError;
  String get storeId => throw _privateConstructorUsedError;
  String get cashierId => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  double get taxAmount => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  List<SaleItemModel> get items => throw _privateConstructorUsedError;

  /// Serializes this SaleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleModelCopyWith<SaleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleModelCopyWith<$Res> {
  factory $SaleModelCopyWith(SaleModel value, $Res Function(SaleModel) then) =
      _$SaleModelCopyWithImpl<$Res, SaleModel>;
  @useResult
  $Res call(
      {String id,
      String storeId,
      String cashierId,
      String sessionId,
      double totalAmount,
      double taxAmount,
      double discountAmount,
      String paymentMethod,
      String status,
      String? customerName,
      String? customerPhone,
      String? notes,
      DateTime createdAt,
      DateTime? updatedAt,
      List<SaleItemModel> items});
}

/// @nodoc
class _$SaleModelCopyWithImpl<$Res, $Val extends SaleModel>
    implements $SaleModelCopyWith<$Res> {
  _$SaleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? cashierId = null,
    Object? sessionId = null,
    Object? totalAmount = null,
    Object? taxAmount = null,
    Object? discountAmount = null,
    Object? paymentMethod = null,
    Object? status = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      cashierId: null == cashierId
          ? _value.cashierId
          : cashierId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SaleItemModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SaleModelImplCopyWith<$Res>
    implements $SaleModelCopyWith<$Res> {
  factory _$$SaleModelImplCopyWith(
          _$SaleModelImpl value, $Res Function(_$SaleModelImpl) then) =
      __$$SaleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String storeId,
      String cashierId,
      String sessionId,
      double totalAmount,
      double taxAmount,
      double discountAmount,
      String paymentMethod,
      String status,
      String? customerName,
      String? customerPhone,
      String? notes,
      DateTime createdAt,
      DateTime? updatedAt,
      List<SaleItemModel> items});
}

/// @nodoc
class __$$SaleModelImplCopyWithImpl<$Res>
    extends _$SaleModelCopyWithImpl<$Res, _$SaleModelImpl>
    implements _$$SaleModelImplCopyWith<$Res> {
  __$$SaleModelImplCopyWithImpl(
      _$SaleModelImpl _value, $Res Function(_$SaleModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SaleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? cashierId = null,
    Object? sessionId = null,
    Object? totalAmount = null,
    Object? taxAmount = null,
    Object? discountAmount = null,
    Object? paymentMethod = null,
    Object? status = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? items = null,
  }) {
    return _then(_$SaleModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      cashierId: null == cashierId
          ? _value.cashierId
          : cashierId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SaleItemModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleModelImpl implements _SaleModel {
  const _$SaleModelImpl(
      {required this.id,
      required this.storeId,
      required this.cashierId,
      required this.sessionId,
      required this.totalAmount,
      required this.taxAmount,
      required this.discountAmount,
      required this.paymentMethod,
      required this.status,
      this.customerName,
      this.customerPhone,
      this.notes,
      required this.createdAt,
      this.updatedAt,
      required final List<SaleItemModel> items})
      : _items = items;

  factory _$SaleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleModelImplFromJson(json);

  @override
  final String id;
  @override
  final String storeId;
  @override
  final String cashierId;
  @override
  final String sessionId;
  @override
  final double totalAmount;
  @override
  final double taxAmount;
  @override
  final double discountAmount;
  @override
  final String paymentMethod;
  @override
  final String status;
  @override
  final String? customerName;
  @override
  final String? customerPhone;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  final List<SaleItemModel> _items;
  @override
  List<SaleItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'SaleModel(id: $id, storeId: $storeId, cashierId: $cashierId, sessionId: $sessionId, totalAmount: $totalAmount, taxAmount: $taxAmount, discountAmount: $discountAmount, paymentMethod: $paymentMethod, status: $status, customerName: $customerName, customerPhone: $customerPhone, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.cashierId, cashierId) ||
                other.cashierId == cashierId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      storeId,
      cashierId,
      sessionId,
      totalAmount,
      taxAmount,
      discountAmount,
      paymentMethod,
      status,
      customerName,
      customerPhone,
      notes,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_items));

  /// Create a copy of SaleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleModelImplCopyWith<_$SaleModelImpl> get copyWith =>
      __$$SaleModelImplCopyWithImpl<_$SaleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleModelImplToJson(
      this,
    );
  }
}

abstract class _SaleModel implements SaleModel {
  const factory _SaleModel(
      {required final String id,
      required final String storeId,
      required final String cashierId,
      required final String sessionId,
      required final double totalAmount,
      required final double taxAmount,
      required final double discountAmount,
      required final String paymentMethod,
      required final String status,
      final String? customerName,
      final String? customerPhone,
      final String? notes,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      required final List<SaleItemModel> items}) = _$SaleModelImpl;

  factory _SaleModel.fromJson(Map<String, dynamic> json) =
      _$SaleModelImpl.fromJson;

  @override
  String get id;
  @override
  String get storeId;
  @override
  String get cashierId;
  @override
  String get sessionId;
  @override
  double get totalAmount;
  @override
  double get taxAmount;
  @override
  double get discountAmount;
  @override
  String get paymentMethod;
  @override
  String get status;
  @override
  String? get customerName;
  @override
  String? get customerPhone;
  @override
  String? get notes;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  List<SaleItemModel> get items;

  /// Create a copy of SaleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleModelImplCopyWith<_$SaleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SaleItemModel _$SaleItemModelFromJson(Map<String, dynamic> json) {
  return _SaleItemModel.fromJson(json);
}

/// @nodoc
mixin _$SaleItemModel {
  String get id => throw _privateConstructorUsedError;
  String get saleId => throw _privateConstructorUsedError;
  String get variantId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String get variantName => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  double? get discountAmount => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this SaleItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaleItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleItemModelCopyWith<SaleItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleItemModelCopyWith<$Res> {
  factory $SaleItemModelCopyWith(
          SaleItemModel value, $Res Function(SaleItemModel) then) =
      _$SaleItemModelCopyWithImpl<$Res, SaleItemModel>;
  @useResult
  $Res call(
      {String id,
      String saleId,
      String variantId,
      String productName,
      String variantName,
      double unitPrice,
      int quantity,
      double totalPrice,
      double? discountAmount,
      String? notes});
}

/// @nodoc
class _$SaleItemModelCopyWithImpl<$Res, $Val extends SaleItemModel>
    implements $SaleItemModelCopyWith<$Res> {
  _$SaleItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? saleId = null,
    Object? variantId = null,
    Object? productName = null,
    Object? variantName = null,
    Object? unitPrice = null,
    Object? quantity = null,
    Object? totalPrice = null,
    Object? discountAmount = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      saleId: null == saleId
          ? _value.saleId
          : saleId // ignore: cast_nullable_to_non_nullable
              as String,
      variantId: null == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      variantName: null == variantName
          ? _value.variantName
          : variantName // ignore: cast_nullable_to_non_nullable
              as String,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SaleItemModelImplCopyWith<$Res>
    implements $SaleItemModelCopyWith<$Res> {
  factory _$$SaleItemModelImplCopyWith(
          _$SaleItemModelImpl value, $Res Function(_$SaleItemModelImpl) then) =
      __$$SaleItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String saleId,
      String variantId,
      String productName,
      String variantName,
      double unitPrice,
      int quantity,
      double totalPrice,
      double? discountAmount,
      String? notes});
}

/// @nodoc
class __$$SaleItemModelImplCopyWithImpl<$Res>
    extends _$SaleItemModelCopyWithImpl<$Res, _$SaleItemModelImpl>
    implements _$$SaleItemModelImplCopyWith<$Res> {
  __$$SaleItemModelImplCopyWithImpl(
      _$SaleItemModelImpl _value, $Res Function(_$SaleItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SaleItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? saleId = null,
    Object? variantId = null,
    Object? productName = null,
    Object? variantName = null,
    Object? unitPrice = null,
    Object? quantity = null,
    Object? totalPrice = null,
    Object? discountAmount = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$SaleItemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      saleId: null == saleId
          ? _value.saleId
          : saleId // ignore: cast_nullable_to_non_nullable
              as String,
      variantId: null == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      variantName: null == variantName
          ? _value.variantName
          : variantName // ignore: cast_nullable_to_non_nullable
              as String,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleItemModelImpl implements _SaleItemModel {
  const _$SaleItemModelImpl(
      {required this.id,
      required this.saleId,
      required this.variantId,
      required this.productName,
      required this.variantName,
      required this.unitPrice,
      required this.quantity,
      required this.totalPrice,
      this.discountAmount,
      this.notes});

  factory _$SaleItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleItemModelImplFromJson(json);

  @override
  final String id;
  @override
  final String saleId;
  @override
  final String variantId;
  @override
  final String productName;
  @override
  final String variantName;
  @override
  final double unitPrice;
  @override
  final int quantity;
  @override
  final double totalPrice;
  @override
  final double? discountAmount;
  @override
  final String? notes;

  @override
  String toString() {
    return 'SaleItemModel(id: $id, saleId: $saleId, variantId: $variantId, productName: $productName, variantName: $variantName, unitPrice: $unitPrice, quantity: $quantity, totalPrice: $totalPrice, discountAmount: $discountAmount, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.saleId, saleId) || other.saleId == saleId) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.variantName, variantName) ||
                other.variantName == variantName) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      saleId,
      variantId,
      productName,
      variantName,
      unitPrice,
      quantity,
      totalPrice,
      discountAmount,
      notes);

  /// Create a copy of SaleItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleItemModelImplCopyWith<_$SaleItemModelImpl> get copyWith =>
      __$$SaleItemModelImplCopyWithImpl<_$SaleItemModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleItemModelImplToJson(
      this,
    );
  }
}

abstract class _SaleItemModel implements SaleItemModel {
  const factory _SaleItemModel(
      {required final String id,
      required final String saleId,
      required final String variantId,
      required final String productName,
      required final String variantName,
      required final double unitPrice,
      required final int quantity,
      required final double totalPrice,
      final double? discountAmount,
      final String? notes}) = _$SaleItemModelImpl;

  factory _SaleItemModel.fromJson(Map<String, dynamic> json) =
      _$SaleItemModelImpl.fromJson;

  @override
  String get id;
  @override
  String get saleId;
  @override
  String get variantId;
  @override
  String get productName;
  @override
  String get variantName;
  @override
  double get unitPrice;
  @override
  int get quantity;
  @override
  double get totalPrice;
  @override
  double? get discountAmount;
  @override
  String? get notes;

  /// Create a copy of SaleItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleItemModelImplCopyWith<_$SaleItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateSaleRequest _$CreateSaleRequestFromJson(Map<String, dynamic> json) {
  return _CreateSaleRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateSaleRequest {
  String get storeId => throw _privateConstructorUsedError;
  String get cashierId => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<CreateSaleItemRequest> get items => throw _privateConstructorUsedError;

  /// Serializes this CreateSaleRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateSaleRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateSaleRequestCopyWith<CreateSaleRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateSaleRequestCopyWith<$Res> {
  factory $CreateSaleRequestCopyWith(
          CreateSaleRequest value, $Res Function(CreateSaleRequest) then) =
      _$CreateSaleRequestCopyWithImpl<$Res, CreateSaleRequest>;
  @useResult
  $Res call(
      {String storeId,
      String cashierId,
      String sessionId,
      String paymentMethod,
      String? customerName,
      String? customerPhone,
      String? notes,
      List<CreateSaleItemRequest> items});
}

/// @nodoc
class _$CreateSaleRequestCopyWithImpl<$Res, $Val extends CreateSaleRequest>
    implements $CreateSaleRequestCopyWith<$Res> {
  _$CreateSaleRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateSaleRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? cashierId = null,
    Object? sessionId = null,
    Object? paymentMethod = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? notes = freezed,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      cashierId: null == cashierId
          ? _value.cashierId
          : cashierId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CreateSaleItemRequest>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateSaleRequestImplCopyWith<$Res>
    implements $CreateSaleRequestCopyWith<$Res> {
  factory _$$CreateSaleRequestImplCopyWith(_$CreateSaleRequestImpl value,
          $Res Function(_$CreateSaleRequestImpl) then) =
      __$$CreateSaleRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String storeId,
      String cashierId,
      String sessionId,
      String paymentMethod,
      String? customerName,
      String? customerPhone,
      String? notes,
      List<CreateSaleItemRequest> items});
}

/// @nodoc
class __$$CreateSaleRequestImplCopyWithImpl<$Res>
    extends _$CreateSaleRequestCopyWithImpl<$Res, _$CreateSaleRequestImpl>
    implements _$$CreateSaleRequestImplCopyWith<$Res> {
  __$$CreateSaleRequestImplCopyWithImpl(_$CreateSaleRequestImpl _value,
      $Res Function(_$CreateSaleRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateSaleRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? cashierId = null,
    Object? sessionId = null,
    Object? paymentMethod = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? notes = freezed,
    Object? items = null,
  }) {
    return _then(_$CreateSaleRequestImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      cashierId: null == cashierId
          ? _value.cashierId
          : cashierId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CreateSaleItemRequest>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateSaleRequestImpl implements _CreateSaleRequest {
  const _$CreateSaleRequestImpl(
      {required this.storeId,
      required this.cashierId,
      required this.sessionId,
      required this.paymentMethod,
      this.customerName,
      this.customerPhone,
      this.notes,
      required final List<CreateSaleItemRequest> items})
      : _items = items;

  factory _$CreateSaleRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateSaleRequestImplFromJson(json);

  @override
  final String storeId;
  @override
  final String cashierId;
  @override
  final String sessionId;
  @override
  final String paymentMethod;
  @override
  final String? customerName;
  @override
  final String? customerPhone;
  @override
  final String? notes;
  final List<CreateSaleItemRequest> _items;
  @override
  List<CreateSaleItemRequest> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'CreateSaleRequest(storeId: $storeId, cashierId: $cashierId, sessionId: $sessionId, paymentMethod: $paymentMethod, customerName: $customerName, customerPhone: $customerPhone, notes: $notes, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateSaleRequestImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.cashierId, cashierId) ||
                other.cashierId == cashierId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      storeId,
      cashierId,
      sessionId,
      paymentMethod,
      customerName,
      customerPhone,
      notes,
      const DeepCollectionEquality().hash(_items));

  /// Create a copy of CreateSaleRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateSaleRequestImplCopyWith<_$CreateSaleRequestImpl> get copyWith =>
      __$$CreateSaleRequestImplCopyWithImpl<_$CreateSaleRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateSaleRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateSaleRequest implements CreateSaleRequest {
  const factory _CreateSaleRequest(
          {required final String storeId,
          required final String cashierId,
          required final String sessionId,
          required final String paymentMethod,
          final String? customerName,
          final String? customerPhone,
          final String? notes,
          required final List<CreateSaleItemRequest> items}) =
      _$CreateSaleRequestImpl;

  factory _CreateSaleRequest.fromJson(Map<String, dynamic> json) =
      _$CreateSaleRequestImpl.fromJson;

  @override
  String get storeId;
  @override
  String get cashierId;
  @override
  String get sessionId;
  @override
  String get paymentMethod;
  @override
  String? get customerName;
  @override
  String? get customerPhone;
  @override
  String? get notes;
  @override
  List<CreateSaleItemRequest> get items;

  /// Create a copy of CreateSaleRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateSaleRequestImplCopyWith<_$CreateSaleRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateSaleItemRequest _$CreateSaleItemRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateSaleItemRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateSaleItemRequest {
  String get variantId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double? get discountAmount => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this CreateSaleItemRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateSaleItemRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateSaleItemRequestCopyWith<CreateSaleItemRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateSaleItemRequestCopyWith<$Res> {
  factory $CreateSaleItemRequestCopyWith(CreateSaleItemRequest value,
          $Res Function(CreateSaleItemRequest) then) =
      _$CreateSaleItemRequestCopyWithImpl<$Res, CreateSaleItemRequest>;
  @useResult
  $Res call(
      {String variantId, int quantity, double? discountAmount, String? notes});
}

/// @nodoc
class _$CreateSaleItemRequestCopyWithImpl<$Res,
        $Val extends CreateSaleItemRequest>
    implements $CreateSaleItemRequestCopyWith<$Res> {
  _$CreateSaleItemRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateSaleItemRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? variantId = null,
    Object? quantity = null,
    Object? discountAmount = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      variantId: null == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateSaleItemRequestImplCopyWith<$Res>
    implements $CreateSaleItemRequestCopyWith<$Res> {
  factory _$$CreateSaleItemRequestImplCopyWith(
          _$CreateSaleItemRequestImpl value,
          $Res Function(_$CreateSaleItemRequestImpl) then) =
      __$$CreateSaleItemRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String variantId, int quantity, double? discountAmount, String? notes});
}

/// @nodoc
class __$$CreateSaleItemRequestImplCopyWithImpl<$Res>
    extends _$CreateSaleItemRequestCopyWithImpl<$Res,
        _$CreateSaleItemRequestImpl>
    implements _$$CreateSaleItemRequestImplCopyWith<$Res> {
  __$$CreateSaleItemRequestImplCopyWithImpl(_$CreateSaleItemRequestImpl _value,
      $Res Function(_$CreateSaleItemRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateSaleItemRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? variantId = null,
    Object? quantity = null,
    Object? discountAmount = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$CreateSaleItemRequestImpl(
      variantId: null == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateSaleItemRequestImpl implements _CreateSaleItemRequest {
  const _$CreateSaleItemRequestImpl(
      {required this.variantId,
      required this.quantity,
      this.discountAmount,
      this.notes});

  factory _$CreateSaleItemRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateSaleItemRequestImplFromJson(json);

  @override
  final String variantId;
  @override
  final int quantity;
  @override
  final double? discountAmount;
  @override
  final String? notes;

  @override
  String toString() {
    return 'CreateSaleItemRequest(variantId: $variantId, quantity: $quantity, discountAmount: $discountAmount, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateSaleItemRequestImpl &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, variantId, quantity, discountAmount, notes);

  /// Create a copy of CreateSaleItemRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateSaleItemRequestImplCopyWith<_$CreateSaleItemRequestImpl>
      get copyWith => __$$CreateSaleItemRequestImplCopyWithImpl<
          _$CreateSaleItemRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateSaleItemRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateSaleItemRequest implements CreateSaleItemRequest {
  const factory _CreateSaleItemRequest(
      {required final String variantId,
      required final int quantity,
      final double? discountAmount,
      final String? notes}) = _$CreateSaleItemRequestImpl;

  factory _CreateSaleItemRequest.fromJson(Map<String, dynamic> json) =
      _$CreateSaleItemRequestImpl.fromJson;

  @override
  String get variantId;
  @override
  int get quantity;
  @override
  double? get discountAmount;
  @override
  String? get notes;

  /// Create a copy of CreateSaleItemRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateSaleItemRequestImplCopyWith<_$CreateSaleItemRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
