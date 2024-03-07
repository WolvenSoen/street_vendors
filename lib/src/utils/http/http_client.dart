import 'dart:convert';

import 'package:http/http.dart' as http;

class HTTPClient{
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  // GET request
  static Future<Map<String, dynamic>> get(String endpoint) async{
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));
    return _handleResponse(response);
  }

  // POST request
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async{
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'}
    );
    return _handleResponse(response);
  }

  // PUT request
  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async{
    final response = await http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'}
    );
    return _handleResponse(response);
  }

  // DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint) async{
    final response = await http.delete(Uri.parse('$_baseUrl/$endpoint'));
    return _handleResponse(response);
  }

  // PATCH request
  static Future<Map<String, dynamic>> patch(String endpoint, Map<String, dynamic> body) async{
    final response = await http.patch(
      Uri.parse('$_baseUrl/$endpoint'),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'}
    );
    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response){
    if(response.statusCode >= 200 && response.statusCode < 300){
      return json.decode(response.body);
    }else{
      throw Exception('Failed to load data');
    }
  }
}