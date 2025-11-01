import '../model/post.dart';
import '../service/api_service.dart';
import 'auth_repository.dart';

class PostRepository {
  final ApiService apiService;
  final AuthRepository authRepository;

  PostRepository({required this.apiService, required this.authRepository});

  Future<String> _getAuthToken() async {
    final token = await authRepository.getToken();
    if (token == null) {
      throw Exception('Not authenticated. Please login again.');
    }
    return token;
  }

  Future<List<Post>> getPosts() async {
    final token = await _getAuthToken();
    final postList = await apiService.getPosts(token);
    return postList.map((postJson) => Post.fromJson(postJson)).toList();
  }

  Future<Post> addPost(String title, String body) async {
    // final token = await _getAuthToken();
    final postJson = await apiService.addPost(title, body);
    return Post.fromJson(postJson);
  }

  Future<Post> updatePost(int postId, String title, String body) async {
    // final token = await _getAuthToken();
    final postJson = await apiService.updatePost(postId, title, body);
    return Post.fromJson(postJson);
  }

  Future<void> deletePost(int postId) async {
    // final token = await _getAuthToken();
    await apiService.deletePost(postId);
  }
}
