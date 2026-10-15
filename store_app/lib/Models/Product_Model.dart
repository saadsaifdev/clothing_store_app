class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;
  final String category;
  final RatingModel rating;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> jsonData) {
    return ProductModel(
      id: int.tryParse(jsonData['id'].toString()) ?? 0,
      title: jsonData['title']?.toString() ?? 'No Title',
      price: (jsonData['price'] as num?)?.toDouble() ?? 0.0,
      description:
          jsonData['description']?.toString() ?? 'No description available',
      image: _resolveImageUrl(jsonData),
      category: jsonData['category']?.toString() ?? '',
      rating: _parseRating(jsonData),
    );
  }

  static String _resolveImageUrl(Map<String, dynamic> jsonData) {
    final directImage = jsonData['image']?.toString();
    if (directImage != null && directImage.isNotEmpty) {
      return directImage;
    }

    final thumbnail = jsonData['thumbnail']?.toString();
    if (thumbnail != null && thumbnail.isNotEmpty) {
      return thumbnail;
    }

    final images = jsonData['images'];
    if (images is List && images.isNotEmpty) {
      final first = images.first?.toString() ?? '';
      if (first.isNotEmpty) {
        return first;
      }
    }

    return 'https://placehold.co/600x400/png?text=No+Image';
  }

  static RatingModel _parseRating(Map<String, dynamic> jsonData) {
    final ratingValue = jsonData['rating'];
    if (ratingValue is Map<String, dynamic>) {
      return RatingModel.fromJson(ratingValue);
    }

    if (ratingValue is num) {
      final reviews = jsonData['reviews'];
      final reviewCount = reviews is List ? reviews.length : 0;
      return RatingModel(rate: ratingValue.toDouble(), count: reviewCount);
    }

    return RatingModel(rate: 0.0, count: 0);
  }
}

class RatingModel {
  final double rate;
  final int count;

  RatingModel({required this.rate, required this.count});

  factory RatingModel.fromJson(Map<String, dynamic> jsonData) {
    return RatingModel(
      rate: (jsonData['rate'] as num?)?.toDouble() ?? 0.0,
      count: int.tryParse(jsonData['count']?.toString() ?? '') ?? 0,
    );
  }
}
