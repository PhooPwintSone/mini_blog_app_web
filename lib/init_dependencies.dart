import 'package:blog_app/bloc/auth_bloc.dart';
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/network/connection_checker.dart';
import 'package:blog_app/core/common/network/connection_checker_impl.dart';
import 'package:blog_app/core/secrets/supabase_secrets.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repo.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_out.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_datasource.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_datasource_impl.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_datasources.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_datasources_impl.dart';
import 'package:blog_app/features/blog/data/repository/blog_repo_impl.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repo.dart';
import 'package:blog_app/features/blog/domain/usecases/delete_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/edit_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/update_reaction.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog_usecase.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // 1. Initialize Supabase FIRST
  final supabase = await Supabase.initialize(
    url: SupabaseSecrets.supabaseUrl,
    publishableKey: SupabaseSecrets.supabasePublishedKey,
  );

  // 2. Initialize Hive
  // This automatically finds the correct document directory for Android/iOS
  await Hive.initFlutter();

  // 3. Open the Box
  // We await this so the box is fully ready before the app starts
  final blogBox = await Hive.openBox('blogs');

  // Register the opened box
  serviceLocator.registerLazySingleton<Box>(() => blogBox);

  // 4. Register core services
  serviceLocator.registerLazySingleton(() => supabase.client);

  // Checking connection
  serviceLocator.registerFactory(() => InternetConnection());

  // Connection checker
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(connection: serviceLocator()),
  );

  // 5. Register Feature Dependencies
  _initAuth();
  _initBlog();
}

// For Auth
void _initAuth() {
  // Data Source
  serviceLocator.registerFactory<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(supabaseClient: serviceLocator()),
  );

  // Repository
  serviceLocator.registerFactory<AuthRepo>(
    () => AuthRepoImpl(
      remoteDatasource: serviceLocator(),
      connectionChecker: serviceLocator(),
    ),
  );

  // Use Cases
  serviceLocator.registerFactory(() => UserSignUp(authRepo: serviceLocator()));
  serviceLocator.registerFactory(() => UserSignIn(authRepo: serviceLocator()));
  serviceLocator.registerFactory(() => UserSignOut(authRepo: serviceLocator()));
  serviceLocator.registerFactory(() => CurrentUser(authRepo: serviceLocator()));

  // Core State
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  // BLoC
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userSignIn: serviceLocator(),
      userSignOut: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}

// For Blog
void _initBlog() {
  serviceLocator
    // Data Source
    ..registerFactory<BlogRemoteDatasources>(
      () => BlogRemoteDatasourcesImpl(supabaseClient: serviceLocator()),
    )
    // Local datasource - it will automatically grab the Box we registered above!
    ..registerFactory<BlogLocalDatasource>(
      () => BlogLocalDatasourceImpl(box: serviceLocator()),
    )
    // Repository
    ..registerFactory<BlogRepo>(
      () => BlogRepoImpl(
        blogRemoteDatasources: serviceLocator(),
        blogLoaclDatasource: serviceLocator(),
        connectionChecker: serviceLocator(),
      ),
    )
    // Use Case
    ..registerFactory<UploadBlog>(
      () => UploadBlog(blogRepo: serviceLocator<BlogRepo>()),
    )
    ..registerFactory<GetAllBlogs>(
      () => GetAllBlogs(serviceLocator<BlogRepo>()),
    )
    ..registerFactory<DeleteBlog>(
      () => DeleteBlog(blogRepo: serviceLocator<BlogRepo>()),
    )
    ..registerFactory<EditBlog>(
      () => EditBlog(blogRepo: serviceLocator<BlogRepo>()),
    )
    //reactions
    ..registerFactory<UpdateReaction>(
      () => UpdateReaction(blogRepo: serviceLocator<BlogRepo>()),
    )
    // BLoC
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator<UploadBlog>(),
        getAllBlogs: serviceLocator<GetAllBlogs>(),
        deleteBlog: serviceLocator<DeleteBlog>(),
        editBlog: serviceLocator<EditBlog>(),

        updateReaction: serviceLocator<UpdateReaction>(),
      ),
    );
}
