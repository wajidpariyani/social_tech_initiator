import '../../models/post_model.dart';

abstract class PostState {}

class PostInitialState extends PostState {}

class PostLoadingState extends PostState {}

class PostLoadedState extends PostState {
  final List<Post> posts;
  final bool isPaginating;

  PostLoadedState(this.posts, {this.isPaginating = false});

  PostLoadedState copyWith({
    List<Post>? posts,
    bool? isPaginating,
  }) {
    return PostLoadedState(
      posts ?? this.posts,
      isPaginating: isPaginating ?? this.isPaginating,
    );
  }
}


class PostErrorState extends PostState {
  final String errorMessage;

  PostErrorState(this.errorMessage);
}

