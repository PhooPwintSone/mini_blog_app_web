part of 'app_user_cubit.dart';

// -- Notes -- //
// Core cannot depend on other features
// but other features can depend on core

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final User user;

  AppUserLoggedIn({required this.user});
}
