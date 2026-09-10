import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_out.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final UserSignOut _userSignOut;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required this._userSignUp,
    required this._userSignIn,
    required this._currentUser,
    required this._appUserCubit,
    required this._userSignOut,
  }) : super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    //For sign up
    on<AuthSignUp>(_onAuthSignUp);

    //For Sign In
    on<AuthSignIn>(_onAuthSignIn);

    //For Sign Out
    on<AuthSignOut>(_onAuthSignOut);

    //for isUserLoggedIn ??
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  //function for Sign up
  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final response = await _userSignUp(
      UserSignUpParam(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    response.fold(
      // Inside AuthBloc
      (failure) => emit(AuthFailure(message: failure.message)),

      (user) => _emitAuthSuccess(user, emit),
    );
  }

  //function for Sign in
  void _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    final response = await _userSignIn(
      UserSignInParam(email: event.email, password: event.password),
    );

    response.fold(
      // Inside AuthBloc
      (failure) => emit(AuthFailure(message: failure.message)),

      (user) => _emitAuthSuccess(user, emit),
    );
  }

  //function for sign out
  void _onAuthSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    final response = await _userSignOut(NoParam());

    response.fold((failure) => emit(AuthFailure(message: failure.message)), (
      _,
    ) {
      _appUserCubit.updateUser(null);
      emit(AuthInitial());
    });
  }

  //function for checking user is logged in or not ?
  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _currentUser(NoParam());

    response.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);

    emit(AuthSuccess(user: user));
  }
}
