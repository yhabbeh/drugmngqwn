import 'package:home_pharmacy_manager/domain/entities/entity.dart';

/// Represents a user/profile in the home pharmacy system
/// Supports multiple family members
class UserEntity extends Entity {
  final String name;
  final DateTime? dateOfBirth;
  final String? avatarPath;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required String id,
    required this.name,
    this.dateOfBirth,
    this.avatarPath,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  }) : super(id: id);

  @override
  List<Object?> get props => [
        id,
        name,
        dateOfBirth,
        avatarPath,
        isActive,
        createdAt,
        updatedAt,
      ];

  /// Check if user is an adult (18+)
  bool get isAdult {
    if (dateOfBirth == null) return false;
    final now = DateTime.now();
    final age = now.year - dateOfBirth!.year;
    return age >= 18;
  }

  UserEntity copyWith({
    String? id,
    String? name,
    DateTime? dateOfBirth,
    String? avatarPath,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      avatarPath: avatarPath ?? this.avatarPath,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
