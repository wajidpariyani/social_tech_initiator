import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String userId;
  final String username;
  final String message;
  final Timestamp createdAt;

  Post({
    required this.userId,
    required this.username,
    required this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'message': message,
      'createdAt': createdAt,
    };
  }

  factory Post.fromFirestore(Map<String, dynamic> data) {
    return Post(
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      message: data['message'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Post copyWith({
    String? userId,
    String? username,
    String? message,
    Timestamp? createdAt,
  }) {
    return Post(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
