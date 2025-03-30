import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post_model.dart';

class PostsRepository {
  final CollectionReference _postsCollection =
  FirebaseFirestore.instance.collection('posts');

  DocumentSnapshot? _lastDocument;

  Stream<List<Post>> getPosts({bool isPaginating = false}) {
    Query query = _postsCollection.orderBy('createdAt', descending: true).limit(10);

    if (isPaginating && _lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    return query.snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      }

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Post.fromFirestore(data);
      }).toList();
    });
  }


  Future<DocumentReference> addPost(Post post) async {
    try {
      final docRef = await _postsCollection.add({
        'userId': post.userId,
        'username': post.username,
        'message': post.message,
        'createdAt': post.createdAt,
      });

      return docRef;
    } catch (e) {
      throw Exception('Failed to add post: $e');
    }
  }

}

