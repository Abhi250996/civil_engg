import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';

class ApiService {
  /// =========================
  /// GET REQUEST
  /// =========================

  static Future<dynamic> getRequest(String endpoint) async {
    final url = Uri.parse("${ApiConstants.baseUrl}$endpoint");

    final response = await http.get(
      url,
      headers: {"Content-Type": ApiConstants.contentType},
    );

    return _handleResponse(response);
  }

  /// =========================
  /// POST REQUEST
  /// =========================

  static Future<dynamic> postRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse("${ApiConstants.baseUrl}$endpoint");

    final response = await http.post(
      url,
      headers: {"Content-Type": ApiConstants.contentType},
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  /// =========================
  /// PUT REQUEST
  /// =========================

  static Future<dynamic> putRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse("${ApiConstants.baseUrl}$endpoint");

    final response = await http.put(
      url,
      headers: {"Content-Type": ApiConstants.contentType},
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  /// =========================
  /// DELETE REQUEST
  /// =========================

  static Future<dynamic> deleteRequest(String endpoint) async {
    final url = Uri.parse("${ApiConstants.baseUrl}$endpoint");

    final response = await http.delete(
      url,
      headers: {"Content-Type": ApiConstants.contentType},
    );

    return _handleResponse(response);
  }

  /// =========================
  /// RESPONSE HANDLER
  /// =========================

  static dynamic _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data["message"] ?? "API Error");
    }
  }
}
