import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_model.freezed.dart';
part 'sale_model.g.dart';

@freezed
class SaleModel with _$SaleModel {
  const factory SaleModel({
    required String id,
    required String storeId,
    required String cashierId,
    required String sessionId,
    required double totalAmount,
    required double taxAmount,
    required double discountAmount,
    required String paymentMethod,
    required String status,
    String? customerName,
    String? customerPhone,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required List<SaleItemModel> items,
  }) = _SaleModel;

  factory SaleModel.fromJson(Map<String, dynamic> json) =>
      _$SaleModelFromJson(json);
}

@freezed
class SaleItemModel with _$SaleItemModel {
  const factory SaleItemModel({
    required String id,
    required String saleId,
    required String variantId,
    required String productName,
    required String variantName,
    required double unitPrice,
    required int quantity,
    required double totalPrice,
    double? discountAmount,
    String? notes,
  }) = _SaleItemModel;

  factory SaleItemModel.fromJson(Map<String, dynamic> json) =>
      _$SaleItemModelFromJson(json);
}

@freezed
class CreateSaleRequest with _$CreateSaleRequest {
  const factory CreateSaleRequest({
    required String storeId,
    required String cashierId,
    required String sessionId,
    required String paymentMethod,
    String? customerName,
    String? customerPhone,
    String? notes,
    required List<CreateSaleItemRequest> items,
  }) = _CreateSaleRequest;

  factory CreateSaleRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateSaleRequestFromJson(json);
}

@freezed
class CreateSaleItemRequest with _$CreateSaleItemRequest {
  const factory CreateSaleItemRequest({
    required String variantId,
    required int quantity,
    double? discountAmount,
    String? notes,
  }) = _CreateSaleItemRequest;

  factory CreateSaleItemRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateSaleItemRequestFromJson(json);
}
