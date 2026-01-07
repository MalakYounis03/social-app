import 'dart:convert';

import 'package:get/get.dart';
import 'package:social_app/app/constants/end_points.dart';
import 'package:social_app/app/constants/general_response.dart';
import 'package:social_app/app/services/auth_services.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final authService = Get.find<AuthServices>();

  Future<T> get<T>({
    required EndPoints endPoint,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await http.get(
      endPoint.url,
      headers: {
        'Authorization': "Bearer ${authService.token}",
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return fromJson(data);
    }
    throw handleError(data);
  }

  Future<T> post<T>({
    required EndPoints endPoint,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await http.post(
      endPoint.url,
      headers: {
        'Authorization': "Bearer ${authService.token}",
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return fromJson(data);
    }
    throw handleError(data);
  }

  Future<T> delete<T>({
    required EndPoints endPoint,
    required String postId,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await http.delete(
      endPoint.url.replace(queryParameters: {'post_id': postId}),
      headers: {'Authorization': "Bearer ${authService.token}"},
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return fromJson(data);
    }
    throw handleError(data);
  }

  String handleError(Map<String, dynamic> data) {
    final generalResponse = GeneralResponse.fromJson(data);

    return generalResponse.message;
  }
}
