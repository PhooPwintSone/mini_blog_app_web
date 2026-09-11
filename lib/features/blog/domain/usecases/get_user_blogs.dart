import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repo.dart';
import 'package:fpdart/fpdart.dart';

class GetUserBlogs implements Usecase<List<Blog>, GetUserBlogsParams> {
  final BlogRepo blogRepo;

  GetUserBlogs({required this.blogRepo});
  @override
  Future<Either<Failures, List<Blog>>> call(GetUserBlogsParams param) async {
    return await blogRepo.getUserBlogs(userId: param.userId);
  }
}

class GetUserBlogsParams {
  final String userId;

  GetUserBlogsParams({required this.userId});
}
