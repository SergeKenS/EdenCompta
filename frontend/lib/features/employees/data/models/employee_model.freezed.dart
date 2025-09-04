// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) {
  return _EmployeeModel.fromJson(json);
}

/// @nodoc
mixin _$EmployeeModel {
  String get id => throw _privateConstructorUsedError;
  String get employeeNumber => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String get position => throw _privateConstructorUsedError;
  String get department => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // ACTIVE, INACTIVE, ON_LEAVE, TERMINATED
  DateTime get hireDate => throw _privateConstructorUsedError;
  DateTime? get terminationDate => throw _privateConstructorUsedError;
  double? get salary => throw _privateConstructorUsedError;
  String? get managerId => throw _privateConstructorUsedError;
  String get storeId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;

  /// Serializes this EmployeeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeModelCopyWith<EmployeeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeModelCopyWith<$Res> {
  factory $EmployeeModelCopyWith(
          EmployeeModel value, $Res Function(EmployeeModel) then) =
      _$EmployeeModelCopyWithImpl<$Res, EmployeeModel>;
  @useResult
  $Res call(
      {String id,
      String employeeNumber,
      String firstName,
      String lastName,
      String? email,
      String? phone,
      String? address,
      String position,
      String department,
      String status,
      DateTime hireDate,
      DateTime? terminationDate,
      double? salary,
      String? managerId,
      String storeId,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});
}

/// @nodoc
class _$EmployeeModelCopyWithImpl<$Res, $Val extends EmployeeModel>
    implements $EmployeeModelCopyWith<$Res> {
  _$EmployeeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeNumber = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? position = null,
    Object? department = null,
    Object? status = null,
    Object? hireDate = null,
    Object? terminationDate = freezed,
    Object? salary = freezed,
    Object? managerId = freezed,
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
      employeeNumber: null == employeeNumber
          ? _value.employeeNumber
          : employeeNumber // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String,
      department: null == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      hireDate: null == hireDate
          ? _value.hireDate
          : hireDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      terminationDate: freezed == terminationDate
          ? _value.terminationDate
          : terminationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      salary: freezed == salary
          ? _value.salary
          : salary // ignore: cast_nullable_to_non_nullable
              as double?,
      managerId: freezed == managerId
          ? _value.managerId
          : managerId // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$EmployeeModelImplCopyWith<$Res>
    implements $EmployeeModelCopyWith<$Res> {
  factory _$$EmployeeModelImplCopyWith(
          _$EmployeeModelImpl value, $Res Function(_$EmployeeModelImpl) then) =
      __$$EmployeeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String employeeNumber,
      String firstName,
      String lastName,
      String? email,
      String? phone,
      String? address,
      String position,
      String department,
      String status,
      DateTime hireDate,
      DateTime? terminationDate,
      double? salary,
      String? managerId,
      String storeId,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});
}

/// @nodoc
class __$$EmployeeModelImplCopyWithImpl<$Res>
    extends _$EmployeeModelCopyWithImpl<$Res, _$EmployeeModelImpl>
    implements _$$EmployeeModelImplCopyWith<$Res> {
  __$$EmployeeModelImplCopyWithImpl(
      _$EmployeeModelImpl _value, $Res Function(_$EmployeeModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmployeeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeNumber = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? position = null,
    Object? department = null,
    Object? status = null,
    Object? hireDate = null,
    Object? terminationDate = freezed,
    Object? salary = freezed,
    Object? managerId = freezed,
    Object? storeId = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_$EmployeeModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employeeNumber: null == employeeNumber
          ? _value.employeeNumber
          : employeeNumber // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String,
      department: null == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      hireDate: null == hireDate
          ? _value.hireDate
          : hireDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      terminationDate: freezed == terminationDate
          ? _value.terminationDate
          : terminationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      salary: freezed == salary
          ? _value.salary
          : salary // ignore: cast_nullable_to_non_nullable
              as double?,
      managerId: freezed == managerId
          ? _value.managerId
          : managerId // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$EmployeeModelImpl implements _EmployeeModel {
  const _$EmployeeModelImpl(
      {required this.id,
      required this.employeeNumber,
      required this.firstName,
      required this.lastName,
      this.email,
      this.phone,
      this.address,
      required this.position,
      required this.department,
      required this.status,
      required this.hireDate,
      this.terminationDate,
      this.salary,
      this.managerId,
      required this.storeId,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy});

  factory _$EmployeeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeModelImplFromJson(json);

  @override
  final String id;
  @override
  final String employeeNumber;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? address;
  @override
  final String position;
  @override
  final String department;
  @override
  final String status;
// ACTIVE, INACTIVE, ON_LEAVE, TERMINATED
  @override
  final DateTime hireDate;
  @override
  final DateTime? terminationDate;
  @override
  final double? salary;
  @override
  final String? managerId;
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
    return 'EmployeeModel(id: $id, employeeNumber: $employeeNumber, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, address: $address, position: $position, department: $department, status: $status, hireDate: $hireDate, terminationDate: $terminationDate, salary: $salary, managerId: $managerId, storeId: $storeId, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeNumber, employeeNumber) ||
                other.employeeNumber == employeeNumber) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.hireDate, hireDate) ||
                other.hireDate == hireDate) &&
            (identical(other.terminationDate, terminationDate) ||
                other.terminationDate == terminationDate) &&
            (identical(other.salary, salary) || other.salary == salary) &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId) &&
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
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        employeeNumber,
        firstName,
        lastName,
        email,
        phone,
        address,
        position,
        department,
        status,
        hireDate,
        terminationDate,
        salary,
        managerId,
        storeId,
        createdAt,
        updatedAt,
        createdBy,
        updatedBy
      ]);

  /// Create a copy of EmployeeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeModelImplCopyWith<_$EmployeeModelImpl> get copyWith =>
      __$$EmployeeModelImplCopyWithImpl<_$EmployeeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeModelImplToJson(
      this,
    );
  }
}

abstract class _EmployeeModel implements EmployeeModel {
  const factory _EmployeeModel(
      {required final String id,
      required final String employeeNumber,
      required final String firstName,
      required final String lastName,
      final String? email,
      final String? phone,
      final String? address,
      required final String position,
      required final String department,
      required final String status,
      required final DateTime hireDate,
      final DateTime? terminationDate,
      final double? salary,
      final String? managerId,
      required final String storeId,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? createdBy,
      final String? updatedBy}) = _$EmployeeModelImpl;

  factory _EmployeeModel.fromJson(Map<String, dynamic> json) =
      _$EmployeeModelImpl.fromJson;

  @override
  String get id;
  @override
  String get employeeNumber;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get address;
  @override
  String get position;
  @override
  String get department;
  @override
  String get status; // ACTIVE, INACTIVE, ON_LEAVE, TERMINATED
  @override
  DateTime get hireDate;
  @override
  DateTime? get terminationDate;
  @override
  double? get salary;
  @override
  String? get managerId;
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

  /// Create a copy of EmployeeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeModelImplCopyWith<_$EmployeeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmployeeScheduleModel _$EmployeeScheduleModelFromJson(
    Map<String, dynamic> json) {
  return _EmployeeScheduleModel.fromJson(json);
}

/// @nodoc
mixin _$EmployeeScheduleModel {
  String get id => throw _privateConstructorUsedError;
  String get employeeId => throw _privateConstructorUsedError;
  String get dayOfWeek =>
      throw _privateConstructorUsedError; // MONDAY, TUESDAY, etc.
  TimeOfDay get startTime => throw _privateConstructorUsedError;
  TimeOfDay get endTime => throw _privateConstructorUsedError;
  bool get isWorkingDay => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this EmployeeScheduleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeScheduleModelCopyWith<EmployeeScheduleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeScheduleModelCopyWith<$Res> {
  factory $EmployeeScheduleModelCopyWith(EmployeeScheduleModel value,
          $Res Function(EmployeeScheduleModel) then) =
      _$EmployeeScheduleModelCopyWithImpl<$Res, EmployeeScheduleModel>;
  @useResult
  $Res call(
      {String id,
      String employeeId,
      String dayOfWeek,
      TimeOfDay startTime,
      TimeOfDay endTime,
      bool isWorkingDay,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt});

  $TimeOfDayCopyWith<$Res> get startTime;
  $TimeOfDayCopyWith<$Res> get endTime;
}

/// @nodoc
class _$EmployeeScheduleModelCopyWithImpl<$Res,
        $Val extends EmployeeScheduleModel>
    implements $EmployeeScheduleModelCopyWith<$Res> {
  _$EmployeeScheduleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? dayOfWeek = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isWorkingDay = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      isWorkingDay: null == isWorkingDay
          ? _value.isWorkingDay
          : isWorkingDay // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
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

  /// Create a copy of EmployeeScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimeOfDayCopyWith<$Res> get startTime {
    return $TimeOfDayCopyWith<$Res>(_value.startTime, (value) {
      return _then(_value.copyWith(startTime: value) as $Val);
    });
  }

  /// Create a copy of EmployeeScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimeOfDayCopyWith<$Res> get endTime {
    return $TimeOfDayCopyWith<$Res>(_value.endTime, (value) {
      return _then(_value.copyWith(endTime: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EmployeeScheduleModelImplCopyWith<$Res>
    implements $EmployeeScheduleModelCopyWith<$Res> {
  factory _$$EmployeeScheduleModelImplCopyWith(
          _$EmployeeScheduleModelImpl value,
          $Res Function(_$EmployeeScheduleModelImpl) then) =
      __$$EmployeeScheduleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String employeeId,
      String dayOfWeek,
      TimeOfDay startTime,
      TimeOfDay endTime,
      bool isWorkingDay,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $TimeOfDayCopyWith<$Res> get startTime;
  @override
  $TimeOfDayCopyWith<$Res> get endTime;
}

/// @nodoc
class __$$EmployeeScheduleModelImplCopyWithImpl<$Res>
    extends _$EmployeeScheduleModelCopyWithImpl<$Res,
        _$EmployeeScheduleModelImpl>
    implements _$$EmployeeScheduleModelImplCopyWith<$Res> {
  __$$EmployeeScheduleModelImplCopyWithImpl(_$EmployeeScheduleModelImpl _value,
      $Res Function(_$EmployeeScheduleModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmployeeScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? dayOfWeek = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isWorkingDay = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$EmployeeScheduleModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      isWorkingDay: null == isWorkingDay
          ? _value.isWorkingDay
          : isWorkingDay // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$EmployeeScheduleModelImpl implements _EmployeeScheduleModel {
  const _$EmployeeScheduleModelImpl(
      {required this.id,
      required this.employeeId,
      required this.dayOfWeek,
      required this.startTime,
      required this.endTime,
      required this.isWorkingDay,
      this.notes,
      this.createdAt,
      this.updatedAt});

  factory _$EmployeeScheduleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeScheduleModelImplFromJson(json);

  @override
  final String id;
  @override
  final String employeeId;
  @override
  final String dayOfWeek;
// MONDAY, TUESDAY, etc.
  @override
  final TimeOfDay startTime;
  @override
  final TimeOfDay endTime;
  @override
  final bool isWorkingDay;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'EmployeeScheduleModel(id: $id, employeeId: $employeeId, dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, isWorkingDay: $isWorkingDay, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeScheduleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.isWorkingDay, isWorkingDay) ||
                other.isWorkingDay == isWorkingDay) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, employeeId, dayOfWeek,
      startTime, endTime, isWorkingDay, notes, createdAt, updatedAt);

  /// Create a copy of EmployeeScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeScheduleModelImplCopyWith<_$EmployeeScheduleModelImpl>
      get copyWith => __$$EmployeeScheduleModelImplCopyWithImpl<
          _$EmployeeScheduleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeScheduleModelImplToJson(
      this,
    );
  }
}

abstract class _EmployeeScheduleModel implements EmployeeScheduleModel {
  const factory _EmployeeScheduleModel(
      {required final String id,
      required final String employeeId,
      required final String dayOfWeek,
      required final TimeOfDay startTime,
      required final TimeOfDay endTime,
      required final bool isWorkingDay,
      final String? notes,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$EmployeeScheduleModelImpl;

  factory _EmployeeScheduleModel.fromJson(Map<String, dynamic> json) =
      _$EmployeeScheduleModelImpl.fromJson;

  @override
  String get id;
  @override
  String get employeeId;
  @override
  String get dayOfWeek; // MONDAY, TUESDAY, etc.
  @override
  TimeOfDay get startTime;
  @override
  TimeOfDay get endTime;
  @override
  bool get isWorkingDay;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of EmployeeScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeScheduleModelImplCopyWith<_$EmployeeScheduleModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TimeOfDay _$TimeOfDayFromJson(Map<String, dynamic> json) {
  return _TimeOfDay.fromJson(json);
}

/// @nodoc
mixin _$TimeOfDay {
  int get hour => throw _privateConstructorUsedError;
  int get minute => throw _privateConstructorUsedError;

  /// Serializes this TimeOfDay to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeOfDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeOfDayCopyWith<TimeOfDay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeOfDayCopyWith<$Res> {
  factory $TimeOfDayCopyWith(TimeOfDay value, $Res Function(TimeOfDay) then) =
      _$TimeOfDayCopyWithImpl<$Res, TimeOfDay>;
  @useResult
  $Res call({int hour, int minute});
}

/// @nodoc
class _$TimeOfDayCopyWithImpl<$Res, $Val extends TimeOfDay>
    implements $TimeOfDayCopyWith<$Res> {
  _$TimeOfDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeOfDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? minute = null,
  }) {
    return _then(_value.copyWith(
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minute: null == minute
          ? _value.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimeOfDayImplCopyWith<$Res>
    implements $TimeOfDayCopyWith<$Res> {
  factory _$$TimeOfDayImplCopyWith(
          _$TimeOfDayImpl value, $Res Function(_$TimeOfDayImpl) then) =
      __$$TimeOfDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int hour, int minute});
}

/// @nodoc
class __$$TimeOfDayImplCopyWithImpl<$Res>
    extends _$TimeOfDayCopyWithImpl<$Res, _$TimeOfDayImpl>
    implements _$$TimeOfDayImplCopyWith<$Res> {
  __$$TimeOfDayImplCopyWithImpl(
      _$TimeOfDayImpl _value, $Res Function(_$TimeOfDayImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimeOfDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? minute = null,
  }) {
    return _then(_$TimeOfDayImpl(
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minute: null == minute
          ? _value.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeOfDayImpl implements _TimeOfDay {
  const _$TimeOfDayImpl({required this.hour, required this.minute});

  factory _$TimeOfDayImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeOfDayImplFromJson(json);

  @override
  final int hour;
  @override
  final int minute;

  @override
  String toString() {
    return 'TimeOfDay(hour: $hour, minute: $minute)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeOfDayImpl &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hour, minute);

  /// Create a copy of TimeOfDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeOfDayImplCopyWith<_$TimeOfDayImpl> get copyWith =>
      __$$TimeOfDayImplCopyWithImpl<_$TimeOfDayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeOfDayImplToJson(
      this,
    );
  }
}

abstract class _TimeOfDay implements TimeOfDay {
  const factory _TimeOfDay(
      {required final int hour, required final int minute}) = _$TimeOfDayImpl;

  factory _TimeOfDay.fromJson(Map<String, dynamic> json) =
      _$TimeOfDayImpl.fromJson;

  @override
  int get hour;
  @override
  int get minute;

  /// Create a copy of TimeOfDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeOfDayImplCopyWith<_$TimeOfDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
