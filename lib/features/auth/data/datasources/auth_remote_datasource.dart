import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDatasource {
  Session? get currentUserSession;

  Future<UserModel> singUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> singninWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();

  //sign out
  Future<void> signOut();
}
