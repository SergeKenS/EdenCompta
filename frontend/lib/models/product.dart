import 'package:json_annotation/json_annotation.dart';
import 'package:decimal/decimal.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final String id;
  final String storeId;
  final String name;
  final String? description;
  final String? category;
  final bool isActive;
  final List<ProductVariant> variants;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.storeId,
    required this.name,
    this.description,
    this.category,
    required this.isActive,
    required this.variants,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  Product copyWith({
    String? id,
    String? storeId,
    String? name,
    String? description,
    String? category,
    bool? isActive,
    List<ProductVariant>? variants,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      variants: variants ?? this.variants,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  List<ProductVariant> get activeVariants => 
      variants.where((v) => v.isActive).toList();
}

@JsonSerializable()
class ProductVariant {
  final String id;
  final String productId;
  final String sku;
  final String name;
  final String? barcode;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductVariant({
    required this.id,
    required this.productId,
    required this.sku,
    required this.name,
    this.barcode,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) => _$ProductVariantFromJson(json);
  Map<String, dynamic> toJson() => _$ProductVariantToJson(this);

  ProductVariant copyWith({
    String? id,
    String? productId,
    String? sku,
    String? name,
    String? barcode,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductVariant(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class InventoryLevel {
  final String id;
  final String storeId;
  final String variantId;
  final Decimal quantityOnHand;
  final Decimal averageCost;
  final DateTime lastUpdated;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InventoryLevel({
    required this.id,
    required this.storeId,
    required this.variantId,
    required this.quantityOnHand,
    required this.averageCost,
    required this.lastUpdated,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InventoryLevel.fromJson(Map<String, dynamic> json) => _$InventoryLevelFromJson(json);
  Map<String, dynamic> toJson() => _$InventoryLevelToJson(this);

  bool get isInStock => quantityOnHand > Decimal.zero;
  bool get isLowStock => quantityOnHand <= Decimal.fromInt(10);
  bool get isOutOfStock => quantityOnHand <= Decimal.zero;

  InventoryLevel copyWith({
    String? id,
    String? storeId,
    String? variantId,
    Decimal? quantityOnHand,
    Decimal? averageCost,
    DateTime? lastUpdated,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryLevel(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      variantId: variantId ?? this.variantId,
      quantityOnHand: quantityOnHand ?? this.quantityOnHand,
      averageCost: averageCost ?? this.averageCost,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
