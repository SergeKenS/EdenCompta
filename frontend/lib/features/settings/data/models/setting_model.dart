import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_model.freezed.dart';
part 'setting_model.g.dart';

@freezed
class SettingModel with _$SettingModel {
  const factory SettingModel({
    required String id,
    required String key,
    required String value,
    required String category, // GENERAL, INVOICE, TAX, NOTIFICATION, etc.
    String? description,
    required String dataType, // STRING, NUMBER, BOOLEAN, JSON
    required bool isEditable,
    required String storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _SettingModel;

  factory SettingModel.fromJson(Map<String, dynamic> json) =>
      _$SettingModelFromJson(json);
}
