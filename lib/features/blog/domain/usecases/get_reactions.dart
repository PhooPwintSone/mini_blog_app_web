import 'package:fpdart/fpdart.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/reaction.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repo.dart';

class GetReactions implements Usecase<List<Reaction>, String> {
  final BlogRepo blogRepo;
  GetReactions(this.blogRepo);

  @override
  Future<Either<Failures, List<Reaction>>> call(String blogId) async {
    return await blogRepo.getReactions(blogId);
  }
}
