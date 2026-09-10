import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repo.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

class EditBlog implements Usecase<Blog, EditBlogParams> {
  final BlogRepo blogRepo;

  EditBlog({required this.blogRepo});
  @override
  Future<Either<Failures, Blog>> call(EditBlogParams param) async {
    return await blogRepo.editBlog(
      image: param.image,
      blogId: param.blogId,
      title: param.title,
      content: param.content,
      categories: param.categories,
      existingImageUrl: param.existingImageUrl,
    );
  }
}

class EditBlogParams {
  final XFile? image;
  final String blogId;
  final String userId;
  final String userName;
  final String title;
  final String content;
  final List<String> categories;
  final String existingImageUrl;

  EditBlogParams({
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
