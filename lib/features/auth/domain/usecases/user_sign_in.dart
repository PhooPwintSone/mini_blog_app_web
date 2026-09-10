import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repo.dart';
import 'package:fpdart/fpdart.dart';

class UserSignIn implements Usecase<User, UserSignInParam> {
  final AuthRepo authRepo;

  const UserSignIn({required this.authRepo});

  @override
  Future<Either<Failures, User>> call(UserSignInParam param) {
    return authRepo.signInwithPassword(
      email: param.email,
      password: param.password,
    );
  }
}

class UserSignInParam {
  final String email;
  final String password;

  UserSignInParam({required this.email, required this.password});
}
