import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

@freezed
@HiveType(typeId: 1)
class ExpenseModel with _$ExpenseModel {
  const factory ExpenseModel({
    @HiveField(0) required String id,
    @HiveField(1) required String storeId,
    @HiveField(2) required String category,
    @HiveField(3) required String description,
    @HiveField(4) required String amount,
    @HiveField(5) required String paymentMethod,
    @HiveField(6) String? reference,
    @HiveField(7) String? notes,
    @HiveField(8) required DateTime expenseDate,
    @HiveField(9) String? approvedBy,
    @HiveField(10) DateTime? approvedAt,
    @HiveField(11) required String status,
    @HiveField(12) required DateTime createdAt,
    @HiveField(13) required String createdBy,
    @HiveField(14) required DateTime updatedAt,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);
}

// Énumérations pour les catégories et statuts
enum ExpenseCategory {
  SUPPLIES('Fournitures'),
  TRANSPORT('Transport'),
  UTILITIES('Services publics'),
  MAINTENANCE('Maintenance'),
  MARKETING('Marketing'),
  OTHER('Autre');

  const ExpenseCategory(this.displayName);
  final String displayName;
}

enum ExpenseStatus {
  PENDING('En attente'),
  APPROVED('Approuvé'),
  REJECTED('Rejeté'),
  CANCELLED('Annulé');

  const ExpenseStatus(this.displayName);
  final String displayName;
}

enum PaymentMethod {
  CASH('Espèces'),
  CARD('Carte'),
  MOBILE('Mobile'),
  OTHER('Autre');

  const PaymentMethod(this.displayName);
  final String displayName;
}
