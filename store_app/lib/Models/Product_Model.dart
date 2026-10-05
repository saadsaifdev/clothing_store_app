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
          jsonData['description'] as String? ?? "No description available",
      image:
          (jsonData['image'] != null && jsonData['image'].toString().isNotEmpty)
          ? jsonData['image'].toString()
          : 'https://placehold.co/600x400/png?text=No+Image',
      category: jsonData['category']?.toString() ?? '',
      rating: jsonData['rating'] != null
          ? RatingModel.fromJson(jsonData['rating'] as Map<String, dynamic>)
          : RatingModel(rate: 0.0, count: 0),
    );
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
