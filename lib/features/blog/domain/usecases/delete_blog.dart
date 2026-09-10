import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repo.dart';
import 'package:fpdart/fpdart.dart';

class DeleteBlog implements Usecase<void, DeleteBlogParams> {
  final BlogRepo blogRepo;

  DeleteBlog({required this.blogRepo});

  @override
  Future<Either<Failures, void>> call(DeleteBlogParams param) async {
    return await blogRepo.deleteBlog(
      blogId: param.blogId,
      imageUrl: param.imageUrl,
    );
  }
}

class DeleteBlogParams {
  final String blogId;
  final String imageUrl;

  DeleteBlogParams({required this.blogId, required this.imageUrl});
}
