import 'package:json_annotation/json_annotation.dart';
// import 'package:uuid/uuid.dart'; // Commenté car non utilisé pour l'instant

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final UserRole role;
  final UserStatus status;
  final String storeId;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final int loginAttempts;
  final DateTime? lockedUntil;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.role,
    required this.status,
    required this.storeId,
    required this.createdAt,
    this.lastLoginAt,
    required this.loginAttempts,
    this.lockedUntil,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    UserRole? role,
    UserStatus? status,
    String? storeId,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    int? loginAttempts,
    DateTime? lockedUntil,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      status: status ?? this.status,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      loginAttempts: loginAttempts ?? this.loginAttempts,
      lockedUntil: lockedUntil ?? this.lockedUntil,
    );
  }

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();
  
  bool get isActive => status == UserStatus.active;
  bool get isLocked => lockedUntil != null && lockedUntil!.isAfter(DateTime.now());
}

enum UserRole {
  @JsonValue('ADMIN')
  admin,
  @JsonValue('MANAGER')
  manager,
  @JsonValue('CASHIER')
  cashier,
  @JsonValue('STOCK_MANAGER')
  stockManager,
}

enum UserStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('INACTIVE')
  inactive,
  @JsonValue('SUSPENDED')
  suspended,
  @JsonValue('LOCKED')
  locked,
}
