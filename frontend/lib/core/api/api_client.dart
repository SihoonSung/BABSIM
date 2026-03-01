import 'package:dio/dio.dart';

class ApiClient {
  static const String _baseUrl = 'http://localhost:8000';

  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));
  }

  Dio get dio => _dio;
}
