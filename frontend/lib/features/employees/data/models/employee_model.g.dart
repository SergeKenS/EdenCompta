// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmployeeModelImpl _$$EmployeeModelImplFromJson(Map<String, dynamic> json) =>
    _$EmployeeModelImpl(
      id: json['id'] as String,
      employeeNumber: json['employeeNumber'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      position: json['position'] as String,
      department: json['department'] as String,
      status: json['status'] as String,
      hireDate: DateTime.parse(json['hireDate'] as String),
      terminationDate: json['terminationDate'] == null
          ? null
          : DateTime.parse(json['terminationDate'] as String),
      salary: (json['salary'] as num?)?.toDouble(),
      managerId: json['managerId'] as String?,
      storeId: json['storeId'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$$EmployeeModelImplToJson(_$EmployeeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeNumber': instance.employeeNumber,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'position': instance.position,
      'department': instance.department,
      'status': instance.status,
      'hireDate': instance.hireDate.toIso8601String(),
      'terminationDate': instance.terminationDate?.toIso8601String(),
      'salary': instance.salary,
      'managerId': instance.managerId,
      'storeId': instance.storeId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
    };

_$EmployeeScheduleModelImpl _$$EmployeeScheduleModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EmployeeScheduleModelImpl(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      dayOfWeek: json['dayOfWeek'] as String,
      startTime: TimeOfDay.fromJson(json['startTime'] as Map<String, dynamic>),
      endTime: TimeOfDay.fromJson(json['endTime'] as Map<String, dynamic>),
      isWorkingDay: json['isWorkingDay'] as bool,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$EmployeeScheduleModelImplToJson(
        _$EmployeeScheduleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'dayOfWeek': instance.dayOfWeek,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isWorkingDay': instance.isWorkingDay,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$TimeOfDayImpl _$$TimeOfDayImplFromJson(Map<String, dynamic> json) =>
    _$TimeOfDayImpl(
      hour: (json['hour'] as num).toInt(),
      minute: (json['minute'] as num).toInt(),
    );

Map<String, dynamic> _$$TimeOfDayImplToJson(_$TimeOfDayImpl instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'minute': instance.minute,
    };
