import 'package:equatable/equatable.dart';

import '../../model/post.dart';

abstract class PostState extends Equatable {
  const PostState();
  @override
  List<Object> get props => [];
}

class PostsInitial extends PostState {}

// State untuk memuat daftar post (GET)
class PostsLoadInProgress extends PostState {}

// State untuk operasi CUD (Add, Update, Delete)
class PostOperationInProgress extends PostState {}

// State sukses untuk GET
class PostsLoadSuccess extends PostState {
  final List<Post> posts;

  const PostsLoadSuccess({required this.posts});

  @override
  List<Object> get props => [posts];
}

// State sukses untuk CUD
class PostOperationSuccess extends PostState {
  final String message;
  const PostOperationSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

// State gagal untuk semua operasi
class PostOperationFailure extends PostState {
  final String error;

  const PostOperationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
