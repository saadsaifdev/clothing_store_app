import 'package:store_app/helper/api.dart';
import 'package:store_app/helper/api_config.dart';
import 'package:store_app/helper/product_response_parser.dart';
import 'package:store_app/models/product_model.dart';

class GetCategoriesService {
  Future<List<ProductModel>> getCategoriesProducts({
    required String categoryName,
  }) async {
    final response = await Api().get(
      url: ApiConfig.categoryProducts(categoryName),
    );

    final items = parseProductsResponse(response);
    final productsList = <ProductModel>[];

    for (final product in items) {
      productsList.add(ProductModel.fromJson(product));
    }

    return productsList;
  }
}
