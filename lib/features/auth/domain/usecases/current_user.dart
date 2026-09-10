import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repo.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements Usecase<User, NoParam> {
  final AuthRepo authRepo;

  CurrentUser({required this.authRepo});

  @override
  Future<Either<Failures, User>> call(NoParam param) async {
    return await authRepo.currentUser();
  }
}
