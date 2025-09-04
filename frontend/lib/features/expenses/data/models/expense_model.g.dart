// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseModelAdapter extends TypeAdapter<ExpenseModel> {
  @override
  final int typeId = 1;

  @override
  ExpenseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseModel(
      id: fields[0] as String,
      storeId: fields[1] as String,
      category: fields[2] as String,
      description: fields[3] as String,
      amount: fields[4] as String,
      paymentMethod: fields[5] as String,
      reference: fields[6] as String?,
      notes: fields[7] as String?,
      expenseDate: fields[8] as DateTime,
      approvedBy: fields[9] as String?,
      approvedAt: fields[10] as DateTime?,
      status: fields[11] as String,
      createdAt: fields[12] as DateTime,
      createdBy: fields[13] as String,
      updatedAt: fields[14] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.storeId)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.paymentMethod)
      ..writeByte(6)
      ..write(obj.reference)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.expenseDate)
      ..writeByte(9)
      ..write(obj.approvedBy)
      ..writeByte(10)
      ..write(obj.approvedAt)
      ..writeByte(11)
      ..write(obj.status)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.createdBy)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseModelImpl _$$ExpenseModelImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseModelImpl(
      id: json['id'] as String,
      storeId: json['storeId'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      amount: json['amount'] as String,
      paymentMethod: json['paymentMethod'] as String,
      reference: json['reference'] as String?,
      notes: json['notes'] as String?,
      expenseDate: DateTime.parse(json['expenseDate'] as String),
      approvedBy: json['approvedBy'] as String?,
      approvedAt: json['approvedAt'] == null
          ? null
          : DateTime.parse(json['approvedAt'] as String),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ExpenseModelImplToJson(_$ExpenseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeId': instance.storeId,
      'category': instance.category,
      'description': instance.description,
      'amount': instance.amount,
      'paymentMethod': instance.paymentMethod,
      'reference': instance.reference,
      'notes': instance.notes,
      'expenseDate': instance.expenseDate.toIso8601String(),
      'approvedBy': instance.approvedBy,
      'approvedAt': instance.approvedAt?.toIso8601String(),
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
