import 'package:store_app/helper/api.dart';

class GetAllCategoriesServices {
  final String baseUrl = 'https://fakestoreapi.com/products/categories';

  Future<List<dynamic>> getAllCategories() async {
    List<dynamic> data = await Api().get(url: baseUrl);

    return data;
  }
}