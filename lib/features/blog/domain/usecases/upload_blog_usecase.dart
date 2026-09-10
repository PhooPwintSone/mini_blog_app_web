import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repo.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

class UploadBlog implements Usecase<Blog, UploadBlogParamas> {
  final BlogRepo blogRepo;

  UploadBlog({required this.blogRepo});

  @override
  Future<Either<Failures, Blog>> call(UploadBlogParamas param) async {
    return await blogRepo.uploadBlog(
      image: param.image,
      title: param.title,
      content: param.content,
      userId: param.userId,
      categories: param.categories,
    );
  }
}

class UploadBlogParamas {
  final String userId;
  final String title;
  final String content;
  final XFile image;
  final List<String> categories;

  UploadBlogParamas({
    required this.userId,
    required this.title,
    required this.content,
    required this.image,
    required this.categories,
  });
}
