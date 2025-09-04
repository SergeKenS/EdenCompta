// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) {
  return _ExpenseModel.fromJson(json);
}

/// @nodoc
mixin _$ExpenseModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get storeId => throw _privateConstructorUsedError;
  @HiveField(2)
  String get category => throw _privateConstructorUsedError;
  @HiveField(3)
  String get description => throw _privateConstructorUsedError;
  @HiveField(4)
  String get amount => throw _privateConstructorUsedError;
  @HiveField(5)
  String get paymentMethod => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get reference => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get notes => throw _privateConstructorUsedError;
  @HiveField(8)
  DateTime get expenseDate => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get approvedBy => throw _privateConstructorUsedError;
  @HiveField(10)
  DateTime? get approvedAt => throw _privateConstructorUsedError;
  @HiveField(11)
  String get status => throw _privateConstructorUsedError;
  @HiveField(12)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(13)
  String get createdBy => throw _privateConstructorUsedError;
  @HiveField(14)
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ExpenseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseModelCopyWith<ExpenseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseModelCopyWith<$Res> {
  factory $ExpenseModelCopyWith(
          ExpenseModel value, $Res Function(ExpenseModel) then) =
      _$ExpenseModelCopyWithImpl<$Res, ExpenseModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String storeId,
      @HiveField(2) String category,
      @HiveField(3) String description,
      @HiveField(4) String amount,
      @HiveField(5) String paymentMethod,
      @HiveField(6) String? reference,
      @HiveField(7) String? notes,
      @HiveField(8) DateTime expenseDate,
      @HiveField(9) String? approvedBy,
      @HiveField(10) DateTime? approvedAt,
      @HiveField(11) String status,
      @HiveField(12) DateTime createdAt,
      @HiveField(13) String createdBy,
      @HiveField(14) DateTime updatedAt});
}

/// @nodoc
class _$ExpenseModelCopyWithImpl<$Res, $Val extends ExpenseModel>
    implements $ExpenseModelCopyWith<$Res> {
  _$ExpenseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? category = null,
    Object? description = null,
    Object? amount = null,
    Object? paymentMethod = null,
    Object? reference = freezed,
    Object? notes = freezed,
    Object? expenseDate = null,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? createdBy = null,
    Object? updatedAt = null,
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      expenseDate: null == expenseDate
          ? _value.expenseDate
          : expenseDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseModelImplCopyWith<$Res>
    implements $ExpenseModelCopyWith<$Res> {
  factory _$$ExpenseModelImplCopyWith(
          _$ExpenseModelImpl value, $Res Function(_$ExpenseModelImpl) then) =
      __$$ExpenseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String storeId,
      @HiveField(2) String category,
      @HiveField(3) String description,
      @HiveField(4) String amount,
      @HiveField(5) String paymentMethod,
      @HiveField(6) String? reference,
      @HiveField(7) String? notes,
      @HiveField(8) DateTime expenseDate,
      @HiveField(9) String? approvedBy,
      @HiveField(10) DateTime? approvedAt,
      @HiveField(11) String status,
      @HiveField(12) DateTime createdAt,
      @HiveField(13) String createdBy,
      @HiveField(14) DateTime updatedAt});
}

/// @nodoc
class __$$ExpenseModelImplCopyWithImpl<$Res>
    extends _$ExpenseModelCopyWithImpl<$Res, _$ExpenseModelImpl>
    implements _$$ExpenseModelImplCopyWith<$Res> {
  __$$ExpenseModelImplCopyWithImpl(
      _$ExpenseModelImpl _value, $Res Function(_$ExpenseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? category = null,
    Object? description = null,
    Object? amount = null,
    Object? paymentMethod = null,
    Object? reference = freezed,
    Object? notes = freezed,
    Object? expenseDate = null,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? createdBy = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ExpenseModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      expenseDate: null == expenseDate
          ? _value.expenseDate
          : expenseDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseModelImpl implements _ExpenseModel {
  const _$ExpenseModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.storeId,
      @HiveField(2) required this.category,
      @HiveField(3) required this.description,
      @HiveField(4) required this.amount,
      @HiveField(5) required this.paymentMethod,
      @HiveField(6) this.reference,
      @HiveField(7) this.notes,
      @HiveField(8) required this.expenseDate,
      @HiveField(9) this.approvedBy,
      @HiveField(10) this.approvedAt,
      @HiveField(11) required this.status,
      @HiveField(12) required this.createdAt,
      @HiveField(13) required this.createdBy,
      @HiveField(14) required this.updatedAt});

  factory _$ExpenseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String storeId;
  @override
  @HiveField(2)
  final String category;
  @override
  @HiveField(3)
  final String description;
  @override
  @HiveField(4)
  final String amount;
  @override
  @HiveField(5)
  final String paymentMethod;
  @override
  @HiveField(6)
  final String? reference;
  @override
  @HiveField(7)
  final String? notes;
  @override
  @HiveField(8)
  final DateTime expenseDate;
  @override
  @HiveField(9)
  final String? approvedBy;
  @override
  @HiveField(10)
  final DateTime? approvedAt;
  @override
  @HiveField(11)
  final String status;
  @override
  @HiveField(12)
  final DateTime createdAt;
  @override
  @HiveField(13)
  final String createdBy;
  @override
  @HiveField(14)
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ExpenseModel(id: $id, storeId: $storeId, category: $category, description: $description, amount: $amount, paymentMethod: $paymentMethod, reference: $reference, notes: $notes, expenseDate: $expenseDate, approvedBy: $approvedBy, approvedAt: $approvedAt, status: $status, createdAt: $createdAt, createdBy: $createdBy, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.expenseDate, expenseDate) ||
                other.expenseDate == expenseDate) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      storeId,
      category,
      description,
      amount,
      paymentMethod,
      reference,
      notes,
      expenseDate,
      approvedBy,
      approvedAt,
      status,
      createdAt,
      createdBy,
      updatedAt);

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseModelImplCopyWith<_$ExpenseModelImpl> get copyWith =>
      __$$ExpenseModelImplCopyWithImpl<_$ExpenseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseModelImplToJson(
      this,
    );
  }
}

abstract class _ExpenseModel implements ExpenseModel {
  const factory _ExpenseModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String storeId,
      @HiveField(2) required final String category,
      @HiveField(3) required final String description,
      @HiveField(4) required final String amount,
      @HiveField(5) required final String paymentMethod,
      @HiveField(6) final String? reference,
      @HiveField(7) final String? notes,
      @HiveField(8) required final DateTime expenseDate,
      @HiveField(9) final String? approvedBy,
      @HiveField(10) final DateTime? approvedAt,
      @HiveField(11) required final String status,
      @HiveField(12) required final DateTime createdAt,
      @HiveField(13) required final String createdBy,
      @HiveField(14) required final DateTime updatedAt}) = _$ExpenseModelImpl;

  factory _ExpenseModel.fromJson(Map<String, dynamic> json) =
      _$ExpenseModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get storeId;
  @override
  @HiveField(2)
  String get category;
  @override
  @HiveField(3)
  String get description;
  @override
  @HiveField(4)
  String get amount;
  @override
  @HiveField(5)
  String get paymentMethod;
  @override
  @HiveField(6)
  String? get reference;
  @override
  @HiveField(7)
  String? get notes;
  @override
  @HiveField(8)
  DateTime get expenseDate;
  @override
  @HiveField(9)
  String? get approvedBy;
  @override
  @HiveField(10)
  DateTime? get approvedAt;
  @override
  @HiveField(11)
  String get status;
  @override
  @HiveField(12)
  DateTime get createdAt;
  @override
  @HiveField(13)
  String get createdBy;
  @override
  @HiveField(14)
  DateTime get updatedAt;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseModelImplCopyWith<_$ExpenseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
