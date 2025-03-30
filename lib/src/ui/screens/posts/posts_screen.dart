import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_tech_initiator/src/blocs/auth/auth_cubit.dart';
import 'package:social_tech_initiator/src/blocs/posts/posts_bloc.dart';
import 'package:social_tech_initiator/src/blocs/posts/posts_event.dart';
import 'package:social_tech_initiator/src/blocs/posts/posts_state.dart';
import 'package:social_tech_initiator/src/ui/components/common_scaffold.dart';
import 'package:social_tech_initiator/src/ui/components/custom_component.dart';
import '../../components/post_tile.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final TextEditingController _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(LoadPostsEvent());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<PostBloc>().add(LoadMorePostsEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: "Posts",
      body: buildPostsColumn(context),
      actions: [
        IconButton(
          onPressed: () => context.read<AuthCubit>().logout(context),
          icon: Icon(Icons.logout),
        ),
      ],
    );
  }

  Widget buildPostsColumn(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PostErrorState) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else if (state is PostLoadedState) {
          final posts = state.posts;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: 'Enter your post',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: CustomButton(
                    text: "Post",
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        context.read<PostBloc>().add(
                              CreatePostEvent(_messageController.text),
                            );
                        _messageController.clear();
                      }
                    }),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return PostTile(post: posts[index]);
                  },
                ),
              ),
              if (state.isPaginating) CircularProgressIndicator()
            ],
          );
        }
        return Center(child: Text('No posts available'));
      },
    );
  }
}
