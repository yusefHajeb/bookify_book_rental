class RentalEntity {
  final int? id;
  final int userId;
  final int bookId;
  final DateTime rentalDate;
  final DateTime? returnDate;
  final DateTime dueDate;
  final RentalStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RentalEntity({
    this.id,
    required this.userId,
    required this.bookId,
    required this.rentalDate,
    this.returnDate,
    required this.dueDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  RentalEntity copyWith({
    int? id,
    int? userId,
    int? bookId,
    DateTime? rentalDate,
    DateTime? returnDate,
    DateTime? dueDate,
    RentalStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RentalEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bookId: bookId ?? this.bookId,
      rentalDate: rentalDate ?? this.rentalDate,
      returnDate: returnDate ?? this.returnDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RentalEntity &&
        other.id == id &&
        other.userId == userId &&
        other.bookId == bookId &&
        other.rentalDate == rentalDate &&
        other.returnDate == returnDate &&
        other.dueDate == dueDate &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        bookId.hashCode ^
        rentalDate.hashCode ^
        returnDate.hashCode ^
        dueDate.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'RentalEntity(id: $id, userId: $userId, bookId: $bookId, rentalDate: $rentalDate, returnDate: $returnDate, dueDate: $dueDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

enum RentalStatus {
  pending,
  approved,
  returned,
  overdue,
  cancelled;

  String get displayName {
    switch (this) {
      case RentalStatus.pending:
        return 'Pending';
      case RentalStatus.approved:
        return 'Approved';
      case RentalStatus.returned:
        return 'Returned';
      case RentalStatus.overdue:
        return 'Overdue';
      case RentalStatus.cancelled:
        return 'Cancelled';
    }
  }
}
