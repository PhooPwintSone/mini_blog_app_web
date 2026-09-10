// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repo.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements Usecase<User, UserSignUpParam> {
  //
  final AuthRepo authRepo;
  UserSignUp({required this.authRepo});

  @override
  Future<Either<Failures, User>> call(UserSignUpParam param) async {
    try {
      return await authRepo.signUpwithEmailPassword(
        name: param.name,
        email: param.email,
        password: param.password,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}

//
class UserSignUpParam {
  final String email;
  final String password;
  final String name;
  UserSignUpParam({
    required this.email,
    required this.password,
    required this.name,
  });
}
