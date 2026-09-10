import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repo.dart';
import 'package:fpdart/fpdart.dart';

class UserSignOut implements Usecase<void, NoParam> {
  final AuthRepo authRepo;

  UserSignOut({required this.authRepo});

  @override
  Future<Either<Failures, void>> call(NoParam param) async {
    return await authRepo.signOut();
  }
}
