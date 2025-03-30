abstract class PostEvent {}

class LoadPostsEvent extends PostEvent {}
class LoadMorePostsEvent extends PostEvent {}

class CreatePostEvent extends PostEvent {
  final String message;

  CreatePostEvent(this.message);
}
