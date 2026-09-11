// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blog_app/features/blog/domain/entities/reaction.dart';

class Blog {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String imageUrl;
  final List<String> categories;
  final DateTime updatedAt;
  final String userName;
  final List<Reaction>? reactions;

  Blog({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.categories,
    required this.updatedAt,
    required this.userName,
    this.reactions = const [],
  });
}
