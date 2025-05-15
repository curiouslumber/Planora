import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:planora/apis/interceptors/auth_interceptor.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_URL']!,
      connectTimeout: const Duration(seconds: 5),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static Dio get dio {
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
    _dio.interceptors.add(AuthInterceptor());
    return _dio;
  }
}
