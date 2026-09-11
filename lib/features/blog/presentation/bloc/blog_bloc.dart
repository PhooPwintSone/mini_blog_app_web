import 'dart:developer';

import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/delete_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/edit_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/get_user_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/update_reaction.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  //---- Blog Section ----//
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  final DeleteBlog _deleteBlog;
  final EditBlog _editBlog;
  final GetUserBlogs _getUserBlogs;
  // Related to Pagination
  int _currentPage = 0;
  bool _isFetching = false;

  //---- Reactions Section ----//
  final UpdateReaction _updateReaction;

  BlogBloc({
    required this._uploadBlog,
    required this._getAllBlogs,
    required this._deleteBlog,
    required this._editBlog,
    required this._updateReaction,
    required this._getUserBlogs,
  }) : super(BlogInitial()) {
    // //loading state
    // on<BlogEvent>((event, emit) => emit(BlogLoading()) );

    //---- Blog Section ----//
    //upload Blog
    on<BlogUpload>(_onBlogUpload);

    //get all blogs
    on<BlogGetAllBlogs>(_ongetAllBlogs);

    //deletBlogs
    on<BlogDeletEvent>(_onDeleteBlog);

    //editBlogs
    on<BlogEditEvent>(_onEditBlog);

    //load more blogs
    on<BlogLoadMoreBlogs>(_onLoadMoreBlogs);

    //get user blogs
    on<BlogGetUserBlogs>(_onGetUserBlogs);

    //---- Reactions Section ----//
    on<BlogUpdateReaction>(_onUpdateReaction);
  }

  //---- Blog Section ----//
  //upload Blog
  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final response = await _uploadBlog(
      UploadBlogParamas(
        userId: event.userId,
        title: event.title,
        content: event.content,
        image: event.image,
        categories: event.categories,
      ),
    );

    response.fold(
      (left) => emit(BlogFailure(errorMessage: left.message)),
      (right) => emit(BlogUploadSuccess()),
    );
  }

  //get all blogs
  void _ongetAllBlogs(BlogGetAllBlogs event, Emitter<BlogState> emit) async {
    _currentPage = 0;
    // emit(BlogLoading());
    final response = await _getAllBlogs(GetAllBlogsParams(page: _currentPage));

    response.fold(
      (left) => emit(BlogFailure(errorMessage: left.message)),
      (right) => emit(
        BlogDisplaySuccess(blogs: right, hasReachedMax: right.length < 10),
      ),
    );
  }

  //deleteBlog
  void _onDeleteBlog(BlogDeletEvent event, Emitter<BlogState> emit) async {
    final currentState = state;
    final response = await _deleteBlog(
      DeleteBlogParams(blogId: event.blogId, imageUrl: event.imageUrl),
    );

    response.fold(
      (failure) => emit(BlogFailure(errorMessage: failure.message)),
      (_) {
        if (currentState is BlogDisplaySuccess) {
          final updatedBlogs = currentState.blogs
              .where((blog) => blog.id != event.blogId)
              .toList();

          emit(BlogDisplaySuccess(blogs: updatedBlogs));
        }
      },
    );
  }

  //edit blog
  void _onEditBlog(BlogEditEvent event, Emitter<BlogState> emit) async {
    final response = await _editBlog(
      EditBlogParams(
        blogId: event.blogId,
        title: event.title,
        content: event.content,
        categories: event.categories,
        existingImageUrl: event.existingImageUrl,
        userId: event.userId,
        userName: event.userName,
        image: event.image,
      ),
    );

    response.fold(
      (left) => emit(BlogFailure(errorMessage: left.message)),
      (right) => emit(BlogUploadSuccess()),
    );
  }

  //load more blogs
  void _onLoadMoreBlogs(
    BlogLoadMoreBlogs event,
    Emitter<BlogState> emit,
  ) async {
    if (_isFetching || state is! BlogDisplaySuccess) return;

    final currentState = state as BlogDisplaySuccess;

    if (currentState.hasReachedMax) {
      return;
    }

    _isFetching = true;

    emit(BlogDisplaySuccess(blogs: currentState.blogs, isLoadingMore: true));

    _currentPage++;

    final response = await _getAllBlogs(GetAllBlogsParams(page: _currentPage));

    response.fold(
      (left) {
        _isFetching = false;
        emit(BlogFailure(errorMessage: left.message));
      },
      (newBlogs) {
        _isFetching = false;
        // Combine the old blogs with the new chunk!
        emit(
          BlogDisplaySuccess(
            blogs: List.of(currentState.blogs)..addAll(newBlogs),
            hasReachedMax: newBlogs.length < 10,
          ),
        );
      },
    );
  }

  //get user blogs
  void _onGetUserBlogs(BlogGetUserBlogs event, Emitter<BlogState> emit) async {
    emit(BlogLoading());

    final res = await _getUserBlogs(GetUserBlogsParams(userId: event.userId));

    res.fold((failure) => emit(BlogFailure(errorMessage: failure.message)), (
      right,
    ) {
      log('Found ${right.length} blogs');
      emit(BlogDisplaySuccess(blogs: right));
    });
  }

  //---- Reactions Section ----//
  void _onUpdateReaction(
    BlogUpdateReaction event,
    Emitter<BlogState> emit,
  ) async {
    final response = await _updateReaction(
      UpdateReactionParams(
        blogId: event.blogId,
        userId: event.userId,
        reactionType: event.reactionType,
      ),
    );

    response.fold((left) => emit(BlogFailure(errorMessage: left.message)), (_) {
      // Trigger a refresh of your blogs so the counts update
      add(BlogGetAllBlogs());
    });
  }
}
