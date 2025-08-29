// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      barcode: json['barcode'] as String?,
      category: json['category'] as String,
      storeId: json['storeId'] as String,
      isActive: json['isActive'] as bool,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'barcode': instance.barcode,
      'category': instance.category,
      'storeId': instance.storeId,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
    };

_$ProductVariantModelImpl _$$ProductVariantModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductVariantModelImpl(
      id: json['id'] as String,
      productId: json['productId'] as String,
      sku: json['sku'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
      stock: (json['stock'] as num).toInt(),
      minimumStock: (json['minimumStock'] as num?)?.toInt(),
      maximumStock: (json['maximumStock'] as num?)?.toInt(),
      unit: json['unit'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      color: json['color'] as String?,
      size: json['size'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ProductVariantModelImplToJson(
        _$ProductVariantModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'sku': instance.sku,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'cost': instance.cost,
      'stock': instance.stock,
      'minimumStock': instance.minimumStock,
      'maximumStock': instance.maximumStock,
      'unit': instance.unit,
      'weight': instance.weight,
      'color': instance.color,
      'size': instance.size,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
