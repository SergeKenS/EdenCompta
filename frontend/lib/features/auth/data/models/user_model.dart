import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
@HiveType(typeId: 0)
class UserModel with _$UserModel {
  const factory UserModel({
    @HiveField(0) required String id,
    @HiveField(1) required String username,
    @HiveField(2) required String email,
    @HiveField(3) required String firstName,
    @HiveField(4) required String lastName,
    @HiveField(5) required String role,
    @HiveField(6) required String storeId,
    @HiveField(7) required String status,
    @HiveField(8) DateTime? createdAt,
    @HiveField(9) DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
