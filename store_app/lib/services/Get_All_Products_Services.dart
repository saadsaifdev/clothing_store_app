import 'package:store_app/helper/api.dart';
import 'package:store_app/helper/api_config.dart';
import 'package:store_app/helper/product_response_parser.dart';
import 'package:store_app/models/product_model.dart';

class GetAllProductsServices {
  GetAllProductsServices({Api? api}) : _api = api ?? Api();

  final Api _api;

  Future<List<ProductModel>> getAllProducts() async {
    final responses = await Future.wait(
      ApiConfig.clothingCategorySlugs.map(
        (slug) => _api.get(url: ApiConfig.categoryProducts(slug)),
      ),
    );

    final products = <ProductModel>[];
    final seenIds = <int>{};

    for (final response in responses) {
      final items = parseProductsResponse(response);

      for (final item in items) {
        final product = ProductModel.fromJson(item);

        if (!seenIds.add(product.id)) {
          continue;
        }

        if (_isSupportedProduct(product)) {
          products.add(product);
        }
      }
    }

    return List<ProductModel>.unmodifiable(products);
  }

  bool _isSupportedProduct(ProductModel product) {
    final category = product.category.toLowerCase();
    final title = product.title.toLowerCase();

    final isClothingCategory = ApiConfig.clothingCategorySlugs.contains(
      category,
    );

    final isNotBackpack = !title.contains('fjallraven');

    return isClothingCategory && isNotBackpack;
  }
}
