import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repo.dart';
import 'package:fpdart/fpdart.dart';

class UpdateReaction implements Usecase<void, UpdateReactionParams> {
  final BlogRepo blogRepo;

  UpdateReaction({required this.blogRepo});
  @override
  Future<Either<Failures, void>> call(UpdateReactionParams param) async {
    return await blogRepo.updateReaction(
      blogId: param.blogId,
      userId: param.userId,
      reactionType: param.reactionType,
    );
  }
}

class UpdateReactionParams {
  final String blogId;
  final String userId;
  final String reactionType;

  UpdateReactionParams({
    required this.blogId,
    required this.userId,
    required this.reactionType,
  });
}
