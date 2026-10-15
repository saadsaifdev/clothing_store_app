import 'package:store_app/helper/api.dart';
import 'package:store_app/helper/api_config.dart';
import 'package:store_app/models/product_model.dart';

class AddProductService {
  AddProductService({Api? api}) : _api = api ?? Api();

  final Api _api;

  Future<ProductModel> addProduct({
    required String title,
    required String price,
    required String desc,
    required String image,
    required String category,
  }) async {
    final parsedPrice = double.tryParse(price.trim());

    if (parsedPrice == null || parsedPrice <= 0) {
      throw const FormatException('Invalid product price');
    }

    final Map<String, dynamic> data = await _api.post(
      url: ApiConfig.productsBase,
      token: null,
      body: {
        'title': title.trim(),
        'price': parsedPrice,
        'description': desc.trim(),
        'thumbnail': image.trim(),
        'images': [image.trim()],
        'category': category.trim(),
      },
    );

    return ProductModel.fromJson(data);
  }
}
