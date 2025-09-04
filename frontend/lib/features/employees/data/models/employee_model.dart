import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_model.freezed.dart';
part 'employee_model.g.dart';

@freezed
class EmployeeModel with _$EmployeeModel {
  const factory EmployeeModel({
    required String id,
    required String employeeNumber,
    required String firstName,
    required String lastName,
    String? email,
    String? phone,
    String? address,
    required String position,
    required String department,
    required String status, // ACTIVE, INACTIVE, ON_LEAVE, TERMINATED
    required DateTime hireDate,
    DateTime? terminationDate,
    double? salary,
    String? managerId,
    required String storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _EmployeeModel;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);
}

@freezed
class EmployeeScheduleModel with _$EmployeeScheduleModel {
  const factory EmployeeScheduleModel({
    required String id,
    required String employeeId,
    required String dayOfWeek, // MONDAY, TUESDAY, etc.
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required bool isWorkingDay,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _EmployeeScheduleModel;

  factory EmployeeScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeScheduleModelFromJson(json);
}

@freezed
class TimeOfDay with _$TimeOfDay {
  const factory TimeOfDay({
    required int hour,
    required int minute,
  }) = _TimeOfDay;

  factory TimeOfDay.fromJson(Map<String, dynamic> json) =>
      _$TimeOfDayFromJson(json);
}
