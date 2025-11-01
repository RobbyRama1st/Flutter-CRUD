import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  // Constructor
  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'https://dummyjson.com',
          contentType: 'application/json',
        ),
      ) {
    // INI DIA BAGIANNYA:
    _dio.interceptors.add(
      LogInterceptor(
        requestHeader: true, // Catat header request
        requestBody: true, // Catat body request (misal: data JSON saat login)
        responseHeader: true, // Catat header response
        responseBody:
            true, // Catat body response (misal: token atau daftar post)
        error: true, // Catat jika terjadi error
        logPrint: (object) {
          print(object.toString());
        },
      ),
    );
  }

  // 1. Auth Service
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(
        'Failed to login: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  // 2. Post Services (CRUD)
  String _getAuthHeader(String token) => 'Bearer $token';

  // GET Posts
  Future<List<dynamic>> getPosts(String token) async {
    try {
      final response = await _dio.get(
        '/posts',
        options: Options(headers: {'Authorization': _getAuthHeader(token)}),
      );
      return response.data['posts'] as List<dynamic>;
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch posts: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  // POST (Add) Post
  Future<Map<String, dynamic>> addPost(
    //String token,
    String title,
    String body,
  ) async {
    try {
      final response = await _dio.post(
        '/posts/add',
        data: {
          'title': title,
          'body': body,
          'userId': 1, // Dummy user ID
        },
        //options: Options(headers: {'Authorization': _getAuthHeader(token)}),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(
        'Failed to add post: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  // PUT (Update) Post
  Future<Map<String, dynamic>> updatePost(
    // String token,
    int postId,
    String title,
    String body,
  ) async {
    try {
      final response = await _dio.put(
        '/posts/$postId',
        data: {'title': title, 'body': body},
        // options: Options(headers: {'Authorization': _getAuthHeader(token)}),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(
        'Failed to update post: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  // DELETE Post
  Future<Map<String, dynamic>> deletePost(int postId) async {
    try {
      final response = await _dio.delete(
        '/posts/$postId',
        // options: Options(headers: {'Authorization': _getAuthHeader(token)}),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(
        'Failed to delete post: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }
}
