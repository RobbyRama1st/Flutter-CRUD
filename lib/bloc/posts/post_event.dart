import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();
  @override
  List<Object> get props => [];
}

class PostsFetched extends PostEvent {}

class PostAdded extends PostEvent {
  final String title;
  final String body;

  const PostAdded({required this.title, required this.body});

  @override
  List<Object> get props => [title, body];
}

class PostUpdated extends PostEvent {
  final int id;
  final String title;
  final String body;

  const PostUpdated({
    required this.id,
    required this.title,
    required this.body,
  });

  @override
  List<Object> get props => [id, title, body];
}

class PostDeleted extends PostEvent {
  final int id;

  const PostDeleted({required this.id});

  @override
  List<Object> get props => [id];
}
