import 'package:blog_app/features/blog/data/models/reaction_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/entities/reaction.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.categories,
    required super.updatedAt,
    required super.userName,
    super.reactions,
  });

  // Convert from Supabase database map to Dart Object
  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      imageUrl: map['image_url'] as String,
      categories: List<String>.from(map['topics'] ?? []),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at'] as String).toLocal(),

      userName: map['profiles'] != null
          ? map['profiles']['name'] as String
          : 'Unknown',
      reactions: map['blog_reactions'] != null
          ? (map['blog_reactions'] as List<dynamic>)
                .map(
                  (reaction) =>
                      ReactionModel.fromJson(reaction as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }

  // Convert from Dart Object to Supabase database map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': categories,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  BlogModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? categories,
    DateTime? updatedAt,
    String? userName,
    List<Reaction>? reactions,
  }) {
    return BlogModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
      updatedAt: updatedAt ?? this.updatedAt,
      userName: userName ?? this.userName,
      reactions: reactions ?? this.reactions,
    );
  }
}
