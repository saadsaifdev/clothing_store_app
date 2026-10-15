import 'package:store_app/helper/api.dart';
import 'package:store_app/helper/api_config.dart';

class GetAllCategoriesServices {
  Future<List<String>> getAllCategories() async {
    final data = await Api().get(url: ApiConfig.categories);

    if (data is! List) {
      throw const FormatException('Invalid categories response format.');
    }

    final categories = <String>[];

    for (final item in data) {
      if (item is Map && item['slug'] != null) {
        categories.add(item['slug'].toString());
      } else if (item is String) {
        categories.add(item);
      }
    }

    return categories;
  }
}
