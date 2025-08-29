import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String name,
    String? description,
    String? barcode,
    required String category,
    required String storeId,
    required bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}

@freezed
class ProductVariantModel with _$ProductVariantModel {
  const factory ProductVariantModel({
    required String id,
    required String productId,
    required String sku,
    required String name,
    String? description,
    required double price,
    required double cost,
    required int stock,
    int? minimumStock,
    int? maximumStock,
    String? unit,
    double? weight,
    String? color,
    String? size,
    required bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProductVariantModel;

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantModelFromJson(json);
}
