class UserEntity {
  final int? id;
  final String name;
  final String email;
  final String role;
  final DateTime createdAt;

  const UserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  /// Creates a copy of this user entity with the given fields replaced
  UserEntity copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.role == role &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        role.hashCode ^
        createdAt.hashCode;
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, name: $name, email: $email, role: $role, createdAt: $createdAt)';
  }
}
