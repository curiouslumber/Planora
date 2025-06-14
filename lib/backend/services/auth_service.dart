import 'package:dio/dio.dart';
import 'package:planora/backend/api_client.dart';
import 'package:planora/backend/models/auth/login_request.dart';
import 'package:planora/backend/models/auth/login_response.dart';
import 'package:planora/backend/models/auth/register_request.dart';
import 'package:planora/backend/models/auth/register_response.dart';
import 'package:planora/constants/api_endpoints.dart';

class AuthService {
  // Login API
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

  // Register API
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await ApiClient.dio.post(
        ApiEndpoint.register,
        data: request.toJson(),
      );
      return RegisterResponse.fromJson(response.data);
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
