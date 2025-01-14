import 'package:dio/dio.dart';

class DioService {
  static final DioService _instance = DioService._internal();
  late Dio _dio;

  factory DioService() {
    return _instance;
  }

  DioService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "http://192.168.44.173:8080", // Replace with your API base URL
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    // Optionally add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Log requests or modify headers if needed
          print("Request: ${options.method} ${options.path}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log responses
          print("Response: ${response.statusCode} ${response.data}");
          return handler.next(response);
        },
        onError: (error, handler) {
          // Handle errors globally
          print("Error: ${error.response?.statusCode} ${error.message}");
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
