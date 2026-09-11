import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/entities/reaction.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

abstract interface class BlogRepo {
  //--- Blog Section --- //
  Future<Either<Failures, Blog>> uploadBlog({
    required XFile image,
    required String title,
    required String content,
    required String userId,
    required List<String> categories,
  });

  Future<Either<Failures, List<Blog>>> getAllBlogs({required int page});

  //delete feature
  Future<Either<Failures, void>> deleteBlog({
    required String blogId,
    required String imageUrl,
  });

  //edit feature
  Future<Either<Failures, Blog>> editBlog({
    required XFile? image,
    required String blogId,
    required String title,
    required String content,
    required List<String> categories,
    required String existingImageUrl,
  });

  //--- Reactions Section --- //

  //update reaction
  Future<Either<Failures, void>> updateReaction({
    required String blogId,
    required String userId,
    required String reactionType,
  });

  //get reaction
  Future<Either<Failures, List<Reaction>>> getReactions(String blogId);
}
