// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingModelImpl _$$SettingModelImplFromJson(Map<String, dynamic> json) =>
    _$SettingModelImpl(
      id: json['id'] as String,
      key: json['key'] as String,
      value: json['value'] as String,
      category: json['category'] as String,
      description: json['description'] as String?,
      dataType: json['dataType'] as String,
      isEditable: json['isEditable'] as bool,
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

Map<String, dynamic> _$$SettingModelImplToJson(_$SettingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'value': instance.value,
      'category': instance.category,
      'description': instance.description,
      'dataType': instance.dataType,
      'isEditable': instance.isEditable,
      'storeId': instance.storeId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
    };
