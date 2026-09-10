part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogFailure extends BlogState {
  final String errorMessage;

  BlogFailure({required this.errorMessage});
}

final class BlogUploadSuccess extends BlogState {}

final class BlogDisplaySuccess extends BlogState {
  final List<Blog> blogs;
  final bool hasReachedMax;
  final bool isLoadingMore;

  BlogDisplaySuccess({
    required this.blogs,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });
}
