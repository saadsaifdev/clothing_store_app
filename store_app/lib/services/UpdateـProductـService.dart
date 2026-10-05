import 'package:store_app/helper/api.dart';
import 'package:store_app/models/product_model.dart';

class UpdateProductService {
  UpdateProductService({Api? api}) : _api = api ?? Api();

  final Api _api;

  Future<ProductModel> updateProduct({
    required int id,
    required String title,
    required String price,
    required String description, // وحدناها لتصبح description بالكامل
    required String image,
    required String category,
  }) async {
    final cleanTitle = title.trim();
    final cleanPrice = price.trim();
    final cleanDescription = description.trim();
    final cleanImage = image.trim();
    final cleanCategory = category.trim();

    if (id <= 0) {
      throw const FormatException('Invalid product id');
    }

    if (cleanTitle.isEmpty) {
      throw const FormatException('Product title is required');
    }

    if (cleanDescription.isEmpty) {
      throw const FormatException('Product description is required');
    }

    if (cleanImage.isEmpty) {
      throw const FormatException('Product image is required');
    }

    if (cleanCategory.isEmpty) {
      throw const FormatException('Product category is required');
    }

    final parsedPrice = double.tryParse(cleanPrice);

    if (parsedPrice == null || parsedPrice <= 0) {
      throw const FormatException('Invalid product price');
    }

    final response = await _api.put(
      url: 'https://fakestoreapi.com/products/$id',
      token: null,
      body: {
        'title': cleanTitle,
        'price': parsedPrice.toString(),
        'description': cleanDescription,
        'image': cleanImage,
        'category': cleanCategory,
      },
    );

    if (response is! Map<String, dynamic>) {
      throw const FormatException('Invalid update response');
    }

    return ProductModel.fromJson(response);
  }
}