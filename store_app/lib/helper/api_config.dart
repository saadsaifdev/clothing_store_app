/// Temporary backend while Fake Store API is unavailable.
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'https://dummyjson.com';

  static const String productsBase = '$baseUrl/products';

  /// Clothing-related category slugs on DummyJSON (mens / womens catalog).
  static const List<String> clothingCategorySlugs = [
    'mens-shirts',
    'mens-shoes',
    'mens-watches',
    'womens-dresses',
    'womens-shoes',
    'womens-watches',
    'womens-bags',
    'womens-jewellery',
    'tops',
  ];

  static String productById(int id) => '$productsBase/$id';

  static String categoryProducts(String categorySlug) =>
      '$productsBase/category/${Uri.encodeComponent(categorySlug)}';

  static String get categories => '$productsBase/categories';
}
