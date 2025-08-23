// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Receipt _$ReceiptFromJson(Map<String, dynamic> json) => Receipt(
      id: json['id'] as String,
      storeId: json['storeId'] as String,
      receiptNumber: json['receiptNumber'] as String,
      createdBy: json['createdBy'] as String,
      finalizedBy: json['finalizedBy'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      finalizedAt: json['finalizedAt'] == null
          ? null
          : DateTime.parse(json['finalizedAt'] as String),
      status: $enumDecode(_$ReceiptStatusEnumMap, json['status']),
      lines: (json['lines'] as List<dynamic>)
          .map((e) => ReceiptLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      payments: (json['payments'] as List<dynamic>)
          .map((e) => Payment.fromJson(e as Map<String, dynamic>))
          .toList(),
      sourceOfflineId: json['sourceOfflineId'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ReceiptToJson(Receipt instance) => <String, dynamic>{
      'id': instance.id,
      'storeId': instance.storeId,
      'receiptNumber': instance.receiptNumber,
      'createdBy': instance.createdBy,
      'finalizedBy': instance.finalizedBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'finalizedAt': instance.finalizedAt?.toIso8601String(),
      'status': _$ReceiptStatusEnumMap[instance.status]!,
      'lines': instance.lines,
      'payments': instance.payments,
      'sourceOfflineId': instance.sourceOfflineId,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ReceiptStatusEnumMap = {
  ReceiptStatus.draft: 'DRAFT',
  ReceiptStatus.finalized: 'FINALIZED',
  ReceiptStatus.cancelled: 'CANCELLED',
};

ReceiptLine _$ReceiptLineFromJson(Map<String, dynamic> json) => ReceiptLine(
      id: json['id'] as String,
      receiptId: json['receiptId'] as String,
      variantId: json['variantId'] as String,
      productName: json['productName'] as String,
      variantName: json['variantName'] as String,
      quantity: Decimal.fromJson(json['quantity'] as String),
      unitPrice: Decimal.fromJson(json['unitPrice'] as String),
      taxRate: Decimal.fromJson(json['taxRate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ReceiptLineToJson(ReceiptLine instance) =>
    <String, dynamic>{
      'id': instance.id,
      'receiptId': instance.receiptId,
      'variantId': instance.variantId,
      'productName': instance.productName,
      'variantName': instance.variantName,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'taxRate': instance.taxRate,
      'createdAt': instance.createdAt.toIso8601String(),
    };

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      id: json['id'] as String,
      receiptId: json['receiptId'] as String,
      method: $enumDecode(_$PaymentMethodEnumMap, json['method']),
      amount: Decimal.fromJson(json['amount'] as String),
      reference: json['reference'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'id': instance.id,
      'receiptId': instance.receiptId,
      'method': _$PaymentMethodEnumMap[instance.method]!,
      'amount': instance.amount,
      'reference': instance.reference,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'CASH',
  PaymentMethod.card: 'CARD',
  PaymentMethod.mobileMoney: 'MOBILE_MONEY',
  PaymentMethod.bankTransfer: 'BANK_TRANSFER',
  PaymentMethod.check: 'CHECK',
};
