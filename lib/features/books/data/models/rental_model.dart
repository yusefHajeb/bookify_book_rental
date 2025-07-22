import '../../domain/entities/rental_entity.dart';

class RentalModel extends RentalEntity {
  const RentalModel({
    super.id,
    required super.userId,
    required super.bookId,
    required super.rentalDate,
    super.returnDate,
    required super.dueDate,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory RentalModel.fromJson(Map<String, dynamic> json) {
    return RentalModel(
      id: json['id'],
      userId: json['userId'],
      bookId: json['bookId'],
      rentalDate: DateTime.parse(json['rentalDate']),
      returnDate: json['returnDate'] != null
          ? DateTime.parse(json['returnDate'])
          : null,
      dueDate: DateTime.parse(json['dueDate']),
      status: RentalStatus.values.firstWhere((e) => e.name == json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'bookId': bookId,
      'rentalDate': rentalDate.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory RentalModel.fromEntity(RentalEntity entity) {
    return RentalModel(
      id: entity.id,
      userId: entity.userId,
      bookId: entity.bookId,
      rentalDate: entity.rentalDate,
      returnDate: entity.returnDate,
      dueDate: entity.dueDate,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  RentalModel copyWith({
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
    return RentalModel(
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
}
