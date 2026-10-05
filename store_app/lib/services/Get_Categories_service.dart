import 'package:store_app/helper/api.dart';
import 'package:store_app/models/product_model.dart';

class GetCategoriesService {
  final String baseUrl = 'https://fakestoreapi.com/products/category';

  Future<List<ProductModel>> getCategoriesProducts({
    required String categoryName,
  }) async {
    final List<dynamic> data = await Api().get(
      url: '$baseUrl/${Uri.encodeComponent(categoryName)}',
    );

    final List<ProductModel> productsList = [];
    for (final product in data) {
      productsList.add(
        ProductModel.fromJson(product as Map<String, dynamic>),
      );
    }
    return productsList;
  }
}