// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SaleModelImpl _$$SaleModelImplFromJson(Map<String, dynamic> json) =>
    _$SaleModelImpl(
      id: json['id'] as String,
      storeId: json['storeId'] as String,
      cashierId: json['cashierId'] as String,
      sessionId: json['sessionId'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => SaleItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SaleModelImplToJson(_$SaleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeId': instance.storeId,
      'cashierId': instance.cashierId,
      'sessionId': instance.sessionId,
      'totalAmount': instance.totalAmount,
      'taxAmount': instance.taxAmount,
      'discountAmount': instance.discountAmount,
      'paymentMethod': instance.paymentMethod,
      'status': instance.status,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'items': instance.items,
    };

_$SaleItemModelImpl _$$SaleItemModelImplFromJson(Map<String, dynamic> json) =>
    _$SaleItemModelImpl(
      id: json['id'] as String,
      saleId: json['saleId'] as String,
      variantId: json['variantId'] as String,
      productName: json['productName'] as String,
      variantName: json['variantName'] as String,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$SaleItemModelImplToJson(_$SaleItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'saleId': instance.saleId,
      'variantId': instance.variantId,
      'productName': instance.productName,
      'variantName': instance.variantName,
      'unitPrice': instance.unitPrice,
      'quantity': instance.quantity,
      'totalPrice': instance.totalPrice,
      'discountAmount': instance.discountAmount,
      'notes': instance.notes,
    };

_$CreateSaleRequestImpl _$$CreateSaleRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateSaleRequestImpl(
      storeId: json['storeId'] as String,
      cashierId: json['cashierId'] as String,
      sessionId: json['sessionId'] as String,
      paymentMethod: json['paymentMethod'] as String,
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      notes: json['notes'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => CreateSaleItemRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CreateSaleRequestImplToJson(
        _$CreateSaleRequestImpl instance) =>
    <String, dynamic>{
      'storeId': instance.storeId,
      'cashierId': instance.cashierId,
      'sessionId': instance.sessionId,
      'paymentMethod': instance.paymentMethod,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'notes': instance.notes,
      'items': instance.items,
    };

_$CreateSaleItemRequestImpl _$$CreateSaleItemRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateSaleItemRequestImpl(
      variantId: json['variantId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$CreateSaleItemRequestImplToJson(
        _$CreateSaleItemRequestImpl instance) =>
    <String, dynamic>{
      'variantId': instance.variantId,
      'quantity': instance.quantity,
      'discountAmount': instance.discountAmount,
      'notes': instance.notes,
    };
