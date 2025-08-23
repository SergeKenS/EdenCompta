import 'package:json_annotation/json_annotation.dart';
import 'package:decimal/decimal.dart';

part 'sales.g.dart';

@JsonSerializable()
class Receipt {
  final String id;
  final String storeId;
  final String receiptNumber;
  final String createdBy;
  final String? finalizedBy;
  final DateTime createdAt;
  final DateTime? finalizedAt;
  final ReceiptStatus status;
  final List<ReceiptLine> lines;
  final List<Payment> payments;
  final String? sourceOfflineId;
  final DateTime updatedAt;

  const Receipt({
    required this.id,
    required this.storeId,
    required this.receiptNumber,
    required this.createdBy,
    this.finalizedBy,
    required this.createdAt,
    this.finalizedAt,
    required this.status,
    required this.lines,
    required this.payments,
    this.sourceOfflineId,
    required this.updatedAt,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) => _$ReceiptFromJson(json);
  Map<String, dynamic> toJson() => _$ReceiptToJson(this);

  Decimal get subtotal => lines.fold(
    Decimal.zero,
    (sum, line) => sum + line.total
  );

  Decimal get totalTax => lines.fold(
    Decimal.zero,
    (sum, line) => sum + line.tax
  );

  Decimal get total => subtotal + totalTax;

  Decimal get totalPaid => payments.fold(
    Decimal.zero,
    (sum, payment) => sum + payment.amount
  );

  Decimal get balance => total - totalPaid;

  bool get isFullyPaid => balance <= Decimal.zero;
  bool get isFinalized => status == ReceiptStatus.finalized;

  Receipt copyWith({
    String? id,
    String? storeId,
    String? receiptNumber,
    String? createdBy,
    String? finalizedBy,
    DateTime? createdAt,
    DateTime? finalizedAt,
    ReceiptStatus? status,
    List<ReceiptLine>? lines,
    List<Payment>? payments,
    String? sourceOfflineId,
    DateTime? updatedAt,
  }) {
    return Receipt(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      createdBy: createdBy ?? this.createdBy,
      finalizedBy: finalizedBy ?? this.finalizedBy,
      createdAt: createdAt ?? this.createdAt,
      finalizedAt: finalizedAt ?? this.finalizedAt,
      status: status ?? this.status,
      lines: lines ?? this.lines,
      payments: payments ?? this.payments,
      sourceOfflineId: sourceOfflineId ?? this.sourceOfflineId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class ReceiptLine {
  final String id;
  final String receiptId;
  final String variantId;
  final String productName;
  final String variantName;
  final Decimal quantity;
  final Decimal unitPrice;
  final Decimal taxRate;
  final DateTime createdAt;

  const ReceiptLine({
    required this.id,
    required this.receiptId,
    required this.variantId,
    required this.productName,
    required this.variantName,
    required this.quantity,
    required this.unitPrice,
    required this.taxRate,
    required this.createdAt,
  });

  factory ReceiptLine.fromJson(Map<String, dynamic> json) => _$ReceiptLineFromJson(json);
  Map<String, dynamic> toJson() => _$ReceiptLineToJson(this);

  Decimal get subtotal => quantity * unitPrice;
  Decimal get tax => subtotal * taxRate;
  Decimal get total => subtotal + tax;

  ReceiptLine copyWith({
    String? id,
    String? receiptId,
    String? variantId,
    String? productName,
    String? variantName,
    Decimal? quantity,
    Decimal? unitPrice,
    Decimal? taxRate,
    DateTime? createdAt,
  }) {
    return ReceiptLine(
      id: id ?? this.id,
      receiptId: receiptId ?? this.receiptId,
      variantId: variantId ?? this.variantId,
      productName: productName ?? this.productName,
      variantName: variantName ?? this.variantName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      taxRate: taxRate ?? this.taxRate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@JsonSerializable()
class Payment {
  final String id;
  final String receiptId;
  final PaymentMethod method;
  final Decimal amount;
  final String? reference;
  final DateTime createdAt;

  const Payment({
    required this.id,
    required this.receiptId,
    required this.method,
    required this.amount,
    this.reference,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);

  Payment copyWith({
    String? id,
    String? receiptId,
    PaymentMethod? method,
    Decimal? amount,
    String? reference,
    DateTime? createdAt,
  }) {
    return Payment(
      id: id ?? this.id,
      receiptId: receiptId ?? this.receiptId,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      reference: reference ?? this.reference,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum ReceiptStatus {
  @JsonValue('DRAFT')
  draft,
  @JsonValue('FINALIZED')
  finalized,
  @JsonValue('CANCELLED')
  cancelled,
}

enum PaymentMethod {
  @JsonValue('CASH')
  cash,
  @JsonValue('CARD')
  card,
  @JsonValue('MOBILE_MONEY')
  mobileMoney,
  @JsonValue('BANK_TRANSFER')
  bankTransfer,
  @JsonValue('CHECK')
  check,
}
