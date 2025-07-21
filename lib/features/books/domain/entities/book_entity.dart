/// Book entity representing a book in the domain layer
class BookEntity {
  final int? id;
  final String title;
  final String author;
  final String description;
  final String imageUrl;
  final double rating;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BookEntity({
    this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a copy of this book entity with the given fields replaced
  BookEntity copyWith({
    int? id,
    String? title,
    String? author,
    String? description,
    String? imageUrl,
    double? rating,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookEntity &&
        other.id == id &&
        other.title == title &&
        other.author == author &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.rating == rating &&
        other.isAvailable == isAvailable &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        author.hashCode ^
        description.hashCode ^
        imageUrl.hashCode ^
        rating.hashCode ^
        isAvailable.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'BookEntity(id: $id, title: $title, author: $author, description: $description, imageUrl: $imageUrl, rating: $rating, isAvailable: $isAvailable, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
