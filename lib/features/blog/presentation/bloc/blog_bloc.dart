import 'dart:developer';

import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/delete_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/edit_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  final DeleteBlog _deleteBlog;
  final EditBlog _editBlog;

  int _currentPage = 0;
  bool _isFetching = false;

  BlogBloc({
    required this._uploadBlog,
    required this._getAllBlogs,
    required this._deleteBlog,
    required this._editBlog,
  }) : super(BlogInitial()) {
    // //loading state
    // on<BlogEvent>((event, emit) => emit(BlogLoading()));

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
  }

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
    emit(BlogLoading());
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
    final response = await _deleteBlog(
      DeleteBlogParams(blogId: event.blogId, imageUrl: event.imageUrl),
    );

    response.fold(
      (left) {
        emit(BlogFailure(errorMessage: left.message));
      },
      (right) {
        emit(BlogUploadSuccess());
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
      log('--- TRAP 2 (BLoC): Ignored because hasReachedMax is TRUE ---');
      return;
    }

    _isFetching = true;

    emit(BlogDisplaySuccess(blogs: currentState.blogs, isLoadingMore: true));

    _currentPage++;
    log('--- TRAP 3 (BLoC): Fetching Page $_currentPage from Supabase... ---');

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
}
