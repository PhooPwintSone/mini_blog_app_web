part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

//---- Blog Section ----//
final class BlogUpload extends BlogEvent {
  final String userId;
  final String title;
  final String content;
  final XFile image;
  final List<String> categories;

  BlogUpload({
    required this.userId,
    required this.title,
    required this.content,
    required this.image,
    required this.categories,
  });
}

final class BlogGetAllBlogs extends BlogEvent {}

final class BlogDeletEvent extends BlogEvent {
  final String blogId;
  final String imageUrl;

  BlogDeletEvent({required this.blogId, required this.imageUrl});
}

final class BlogEditEvent extends BlogEvent {
  final XFile? image;
  final String blogId;
  final String userId;
  final String userName;
  final String title;
  final String content;
  final List<String> categories;
  final String existingImageUrl;

  BlogEditEvent({
    this.image,
    required this.blogId,
    required this.userId,
    required this.userName,
    required this.title,
    required this.content,
    required this.categories,
    required this.existingImageUrl,
  });
}

class BlogLoadMoreBlogs extends BlogEvent {}

class BlogGetUserBlogs extends BlogEvent {
  final String userId;

  BlogGetUserBlogs({required this.userId});
}

//---- REactions Section ----//

class BlogUpdateReaction extends BlogEvent {
  final String blogId;
  final String userId;
  final String reactionType;

  BlogUpdateReaction({
    required this.blogId,
    required this.userId,
    required this.reactionType,
  });
}
