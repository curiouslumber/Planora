import 'package:dio/dio.dart';
import 'package:planora/apis/api_client.dart';
import 'package:planora/apis/models/auth/login_request.dart';
import 'package:planora/apis/models/auth/login_response.dart';
import 'package:planora/constants/api_endpoints.dart';

class AuthService {
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await ApiClient.dio.post(
        ApiEndpoint.login,
        data: request.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _handleError(DioException error) {
    switch (error.response?.statusCode) {
      case 401:
        throw 'Invalid credentials';
      case 500:
        throw 'Server error';
      default:
        throw 'Network error';
    }
  }
}
