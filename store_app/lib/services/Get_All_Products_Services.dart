import 'package:store_app/helper/api.dart';
import 'package:store_app/models/product_model.dart';

class GetAllProductsServices {
  GetAllProductsServices({Api? api}) : _api = api ?? Api();

  static const String _baseUrl = 'https://fakestoreapi.com/products';

  final Api _api;

  Future<List<ProductModel>> getAllProducts() async {
    final response = await _api.get(url: _baseUrl);

    if (response is! List) {
      throw const FormatException('Invalid products response format.');
    }

    final products = <ProductModel>[];

    for (final item in response) {
      if (item is! Map) {
        throw const FormatException('Invalid product item format.');
      }

      final product = ProductModel.fromJson(
        Map<String, dynamic>.from(item),
      );

      if (_isSupportedProduct(product)) {
        products.add(product);
      }
    }

    return List<ProductModel>.unmodifiable(products);
  }

  bool _isSupportedProduct(ProductModel product) {
    final category = product.category.toLowerCase();
    final title = product.title.toLowerCase();

    final isClothing =
        category == "men's clothing" || category == "women's clothing";

    final isNotBackpack = !title.contains('fjallraven');

    return isClothing && isNotBackpack;
  }
}