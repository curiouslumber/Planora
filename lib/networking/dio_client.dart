import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  DioClient._internal();

  static final Dio dio = Dio();
}
