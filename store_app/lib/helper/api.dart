import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  Future<dynamic> get({
    required String url,
    String? token,
  }) async {
    final Map<String, String> headers = {};

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
 
    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
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
    final Map<String, String> headers = {};

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        body: body,
        headers: headers,
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
    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    try {
      final http.Response response = await http.put(
        Uri.parse(url),
        body: body,
        headers: headers,
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