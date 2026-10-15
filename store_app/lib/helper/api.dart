import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  Map<String, String> _headers({String? token, bool jsonBody = false}) {
    final headers = <String, String>{};

    if (jsonBody) {
      headers['Content-Type'] = 'application/json; charset=UTF-8';
    }

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<dynamic> get({
    required String url,
    String? token,
  }) async {
    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: _headers(token: token),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      throw Exception(
        'There is a problem with status code ${response.statusCode}',
      );
    } on Exception catch (e) {
      throw Exception('Failed to communicate with server: $e');
    }
  }

  Future<dynamic> post({
    required String url,
    required dynamic body,
    String? token,
  }) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: _headers(token: token, jsonBody: true),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }

      throw Exception(
        'There is a problem with status code ${response.statusCode}',
      );
    } on Exception catch (e) {
      throw Exception('Failed to communicate with server: $e');
    }
  }

  Future<dynamic> put({
    required String url,
    required dynamic body,
    String? token,
  }) async {
    try {
      final http.Response response = await http.put(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: _headers(token: token, jsonBody: true),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }

      throw Exception(
        'There is a problem with status code ${response.statusCode}',
      );
    } on Exception catch (e) {
      throw Exception('Failed to communicate with server: $e');
    }
  }
}
