import 'package:store_app/helper/api.dart';
import 'package:store_app/models/product_model.dart';

class PostAddProduct {
  Future<ProductModel> addProduct({
    required String title,
    required String price,
    required String desc,
    required String image,
    required String category,
  }) async {
    final Map<String, dynamic> data = await Api().post(
      url: 'https://fakestoreapi.com/products',
      token: null,
      body: {
        'title': title,
        'price': double.parse(price),
        'description': desc,
        'image': image,
        'category': category,
      },
    );

    return ProductModel.fromJson(data);
  }
}