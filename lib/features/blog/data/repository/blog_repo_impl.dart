import 'package:blog_app/core/common/network/connection_checker.dart';
import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_datasource.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_datasources.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/entities/reaction.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repo.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class BlogRepoImpl implements BlogRepo {
  final BlogRemoteDatasources blogRemoteDatasources;
  final BlogLocalDatasource blogLoaclDatasource;
  final ConnectionChecker connectionChecker;
  BlogRepoImpl({
    required this.blogRemoteDatasources,
    required this.blogLoaclDatasource,
    required this.connectionChecker,
  });

  //--- Blog Section --- //

  @override
  Future<Either<Failures, Blog>> uploadBlog({
    required XFile image,
    required String title,
    required String content,
    required String userId,
    required List<String> categories,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failures("No internet connection ...!"));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        userId: userId,
        title: title,
        content: content,
        imageUrl: '',
        categories: categories,
        updatedAt: DateTime.now(),
        userName: '',
      );

      final imageUrl = await blogRemoteDatasources.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final uploadedBlog = await blogRemoteDatasources.uploadBlog(blogModel);

      return right(uploadedBlog);
    } on ServerException catch (e) {
      return Left(Failures(e.message));
    } catch (e) {
      return Left(Failures(e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<Blog>>> getAllBlogs({int page = 0}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final blogs = blogLoaclDatasource.loadBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDatasources.getAllBlogs(page: page);
      blogLoaclDatasource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return Left(Failures(e.message));
    } catch (e) {
      return Left(Failures(e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> deleteBlog({
    required String blogId,
    required String imageUrl,
  }) async {
    try {
      await blogRemoteDatasources.deleteBlog(
        blogId: blogId,
        imageUrl: imageUrl,
      );
      return right(null);
    } on ServerException catch (e) {
      return Left(Failures(e.message));
    } catch (e) {
      return Left(Failures(e.toString()));
    }
  }

  @override
  Future<Either<Failures, Blog>> editBlog({
    required XFile? image,
    required String blogId,
    required String title,
    required String content,
    required List<String> categories,
    required String existingImageUrl,
  }) async {
    try {
      String imageUrl = existingImageUrl;

      if (image != null) {
        imageUrl = await blogRemoteDatasources.uploadEditBlogImage(
          image: image,
          blogId: blogId,
        );
      }
      final updatedBlog = BlogModel(
        id: blogId,
        userId: '',
        title: title,
        content: content,
        imageUrl: imageUrl,

        updatedAt: DateTime.now(),
        categories: categories,
        userName: '',
      );

      final res = await blogRemoteDatasources.editBlog(updatedBlog);
      return right(res);
    } on ServerException catch (e) {
      return Left(Failures(e.message));
    } catch (e) {
      return Left(Failures(e.toString()));
    }
  }

  //get user blogs
  @override
  Future<Either<Failures, List<Blog>>> getUserBlogs({
    required String userId,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failures("No internet connection ...!"));
      }

      final blogs = await blogRemoteDatasources.getUserBlogs(userId: userId);

      return right(blogs);
    } on ServerException catch (e) {
      return Left(Failures(e.message));
    } catch (e) {
      return Left(Failures(e.toString()));
    }
  }

  //--- Reactions Section --- //

  //get reaction

  @override
  Future<Either<Failures, List<Reaction>>> getReactions(String blogId) async {
    try {
      final reactions = await blogRemoteDatasources.getReactions(blogId);

      return right(reactions);
    } on ServerException catch (e) {
      return Left(Failures(e.message));
    } catch (e) {
      return Left(Failures(e.toString()));
    }
  }

  //update reaction

  @override
  Future<Either<Failures, void>> updateReaction({
    required String blogId,
    required String userId,
    required String reactionType,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failures("No internet connection ...!"));
      }

      await blogRemoteDatasources.updateReaction(
        blogId: blogId,
        userId: userId,
        reactionType: reactionType,
      );

      return right(null);
    } on ServerException catch (e) {
      return Left(Failures(e.message));
    } catch (e) {
      return Left(Failures(e.toString()));
    }
  }
}
