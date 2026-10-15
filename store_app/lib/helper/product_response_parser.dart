/// Parses product list payloads from DummyJSON (`{ "products": [...] }`) or legacy list APIs.
List<Map<String, dynamic>> parseProductsResponse(dynamic response) {
  if (response is List) {
    return response
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  if (response is Map && response['products'] is List) {
    return (response['products'] as List)
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  throw const FormatException('Invalid products response format.');
}
