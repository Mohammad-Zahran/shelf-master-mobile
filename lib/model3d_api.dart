import 'package:dio/dio.dart';
import 'dio_service.dart';

class Model3DApi {
  final Dio _dio = DioService().dio;

  Future<List<Map<String, dynamic>>> fetch3DModels() async {
    try {
      final response = await _dio.get("/3d"); // Adjust endpoint
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception("Failed to fetch 3D models.");
      }
    } catch (e) {
      rethrow;
    }
  }
}
