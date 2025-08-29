import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'store_model.freezed.dart';
part 'store_model.g.dart';

@freezed
@HiveType(typeId: 1)
class StoreModel with _$StoreModel {
  const factory StoreModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) String? address,
    @HiveField(3) String? phone,
    @HiveField(4) DateTime? createdAt,
    @HiveField(5) DateTime? updatedAt,
  }) = _StoreModel;

  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);
}
