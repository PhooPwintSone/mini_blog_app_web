import 'package:blog_app/features/blog/domain/entities/reaction.dart';

class ReactionModel extends Reaction {
  ReactionModel({
    required super.id,
    required super.blogId,
    required super.userId,
    required super.reactionType,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      id: json['id'] ?? '',
      blogId: json['blog_id'] ?? '',
      userId: json['user_id'] ?? '',
      reactionType: json['reaction_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blog_id': blogId,
      'user_id': userId,
      'reaction_type': reactionType,
    };
  }
}
