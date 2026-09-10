import 'package:blog_app/core/common/network/connection_checker.dart';
import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repo.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDatasource remoteDatasource;
  final ConnectionChecker connectionChecker;
  AuthRepoImpl({
    required this.remoteDatasource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failures, User>> signInwithPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDatasource.singninWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failures, User>> signUpwithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDatasource.singUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failures, User>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDatasource.currentUserSession;

        if (session == null) {
          return left(Failures("User doesn't logged in"));
        }
        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email.toString(),
            name: '',
          ),
        );
      }
      final user = await remoteDatasource.getCurrentUserData();

      if (user == null) {
        return left(Failures("User doesn't logged in"));
      }

      return right(user);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }

  //Funtion to have clean code
  Future<Either<Failures, User>> _getUser(Future<User> Function() fn) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failures("No Internet Connection ...!"));
      }
      final user = await fn();
      //right means Success state ..!
      return right(user);
    } on AuthException catch (e) {
      return left(Failures(e.message));
    } on ServerException catch (e) {
      //left means fail state. -> e.message can't assign directly , so wrap with Failure
      return left(Failures(e.message));
    }
  }

  @override
  Future<Either<Failures, void>> signOut() async {
    try {
      await remoteDatasource.signOut();
      return right(null);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }
}
