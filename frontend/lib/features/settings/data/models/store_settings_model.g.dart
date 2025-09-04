// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoreSettingsModelImpl _$$StoreSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$StoreSettingsModelImpl(
      id: json['id'] as String,
      storeName: json['storeName'] as String,
      storeAddress: json['storeAddress'] as String,
      storePhone: json['storePhone'] as String?,
      storeEmail: json['storeEmail'] as String?,
      currency: json['currency'] as String,
      taxRate: json['taxRate'] as String,
      invoiceFormat: json['invoiceFormat'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$StoreSettingsModelImplToJson(
        _$StoreSettingsModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeName': instance.storeName,
      'storeAddress': instance.storeAddress,
      'storePhone': instance.storePhone,
      'storeEmail': instance.storeEmail,
      'currency': instance.currency,
      'taxRate': instance.taxRate,
      'invoiceFormat': instance.invoiceFormat,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
