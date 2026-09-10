import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repo.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlogsParams {
  final int page; // 👈 1. Is this missing?
  GetAllBlogsParams({required this.page});
}

class GetAllBlogs implements Usecase<List<Blog>, GetAllBlogsParams> {
  final BlogRepo blogRepo;
  GetAllBlogs(this.blogRepo);

  @override
  Future<Either<Failures, List<Blog>>> call(GetAllBlogsParams params) async {
    // 👈 2. Are you actually passing params.page to the repo?
    return await blogRepo.getAllBlogs(page: params.page);
  }
}
