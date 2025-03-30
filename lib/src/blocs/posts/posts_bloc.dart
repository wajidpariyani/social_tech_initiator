import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_tech_initiator/src/models/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../repositories/posts_repository.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostsRepository _postsRepository;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  PostBloc()
      : _postsRepository = PostsRepository(),
        super(PostInitialState()) {
    on<LoadPostsEvent>((event, emit) => _onLoadPosts(event, emit));
    on<LoadMorePostsEvent>(
        (event, emit) => _onLoadPosts(event, emit, isPaginating: true));
    on<CreatePostEvent>(_onCreatePost);
  }

  Future<void> _onLoadPosts(event, Emitter<PostState> emit,
      {bool isPaginating = false}) async {
    try {
      if (!isPaginating) emit(PostLoadingState());

      if (isPaginating && state is PostLoadedState) {
        emit(PostLoadedState(
          (state as PostLoadedState).posts,
          isPaginating: true,
        ));
      }

      await for (var newPosts
          in _postsRepository.getPosts(isPaginating: isPaginating)) {
        if (newPosts.isNotEmpty) {
          if (state is PostLoadedState && isPaginating) {
            final updatedPosts =
                List<Post>.from((state as PostLoadedState).posts)
                  ..addAll(newPosts);
            emit(PostLoadedState(updatedPosts, isPaginating: false));
          } else {
            emit(PostLoadedState(newPosts));
          }
        } else {
          if (state is PostLoadedState && isPaginating) {
            emit((state as PostLoadedState).copyWith(isPaginating: false));
          } else {
            emit(PostLoadedState([]));
          }
        }
      }
    } catch (e) {
      emit(PostErrorState('Failed to load posts: ${e.toString()}'));
    }
  }

  Future<void> _onCreatePost(
      CreatePostEvent event, Emitter<PostState> emit) async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        emit(PostErrorState('No user logged in'));
        return;
      }

      final post = Post(
        userId: currentUser.uid,
        username: currentUser.displayName ?? 'Unknown',
        message: event.message,
        createdAt: Timestamp.now(),
      );

      await _postsRepository.addPost(post);
    } catch (e) {
      emit(PostErrorState('Failed to create post: ${e.toString()}'));
    }
  }
}
