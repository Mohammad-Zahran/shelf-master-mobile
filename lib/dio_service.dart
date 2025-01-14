import 'package:dio/dio.dart';

class DioService {
  static final DioService _instance = DioService._iternal();
  late Dio _dio;

  factory DioService() {
    return _instance;
  }

  DioService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "http://192.168.1.2:8080",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Content-Type": "application/json",
        }
      )
    );
  }

}