import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepo {
  //

  //Sign Up
  Future<Either<Failures, User>> signUpwithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  //Sign In
  Future<Either<Failures, User>> signInwithPassword({
    required String email,
    required String password,
  });

  Future<Either<Failures, User>> currentUser();
  //
  Future<Either<Failures, void>> signOut();
}
