import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/post_repository.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(PostsInitial()) {
    on<PostsFetched>(_onPostsFetched);
    on<PostAdded>(_onPostAdded);
    on<PostUpdated>(_onPostUpdated);
    on<PostDeleted>(_onPostDeleted);
  }

  Future<void> _onPostsFetched(
    PostsFetched event,
    Emitter<PostState> emit,
  ) async {
    emit(PostsLoadInProgress());
    try {
      final posts = await postRepository.getPosts();
      emit(PostsLoadSuccess(posts: posts));
    } catch (e) {
      emit(PostOperationFailure(error: e.toString()));
    }
  }

  Future<void> _onPostAdded(PostAdded event, Emitter<PostState> emit) async {
    emit(PostOperationInProgress());
    try {
      await postRepository.addPost(event.title, event.body);
      emit(const PostOperationSuccess(message: 'Post berhasil ditambahkan'));
    } catch (e) {
      emit(PostOperationFailure(error: e.toString()));
    }
  }

  Future<void> _onPostUpdated(
    PostUpdated event,
    Emitter<PostState> emit,
  ) async {
    emit(PostOperationInProgress());
    try {
      await postRepository.updatePost(event.id, event.title, event.body);
      emit(const PostOperationSuccess(message: 'Post berhasil di perbarui'));
    } catch (e) {
      emit(PostOperationFailure(error: e.toString()));
    }
  }

  Future<void> _onPostDeleted(
    PostDeleted event,
    Emitter<PostState> emit,
  ) async {
    emit(PostOperationInProgress());
    try {
      await postRepository.deletePost(event.id);
      emit(const PostOperationSuccess(message: 'Post berhasil dihapus'));
    } catch (e) {
      emit(PostOperationFailure(error: e.toString()));
    }
  }
}
