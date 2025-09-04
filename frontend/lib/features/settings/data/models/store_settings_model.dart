import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_settings_model.freezed.dart';
part 'store_settings_model.g.dart';

@freezed
class StoreSettingsModel with _$StoreSettingsModel {
  const factory StoreSettingsModel({
    required String id,
    required String storeName,
    required String storeAddress,
    String? storePhone,
    String? storeEmail,
    required String currency,
    required String taxRate,
    required String invoiceFormat,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _StoreSettingsModel;

  factory StoreSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$StoreSettingsModelFromJson(json);
}
