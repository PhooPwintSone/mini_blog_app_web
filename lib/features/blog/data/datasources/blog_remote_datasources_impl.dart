import 'dart:developer';
import 'dart:io';

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_datasources.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlogRemoteDatasourcesImpl implements BlogRemoteDatasources {
  final SupabaseClient supabaseClient;

  BlogRemoteDatasourcesImpl({required this.supabaseClient});

  //Upload whole Blog
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .insert(blog.toJson())
          .select();

      return BlogModel.fromJson(blogData.first);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  //Upload Image
  @override
  Future<String> uploadBlogImage({
    required XFile image,
    required BlogModel blog,
  }) async {
    try {
      // ✅ Add the platform-safe check here too!
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        await supabaseClient.storage
            .from('blog_images')
            .uploadBinary(blog.id, bytes);
      } else {
        final file = File(image.path);
        await supabaseClient.storage.from('blog_images').upload(blog.id, file);
      }

      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  //Calling all of the blogs
  @override
  Future<List<BlogModel>> getAllBlogs({int? page}) async {
    try {
      final int limit = 10;
      final int from = (page ?? 0) * limit;
      final int to = from + limit - 1;

      final blogs = await supabaseClient
          .from('blogs')
          .select('*,profiles(name)')
          .order('updated_at', ascending: false)
          .range(from, to);

      return blogs
          .map(
            (e) =>
                BlogModel.fromJson(e).copyWith(userName: e['profiles']['name']),
          )
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  //Delete feature
  @override
  Future<void> deleteBlog({
    required String blogId,
    required String imageUrl,
  }) async {
    try {
      log('--- 2. DATA SOURCE: Reached Remote Data Source ---');
      final imagePath = imageUrl.split('/').last;

      log('--- 3A. DATA SOURCE: Deleting from Storage... ---');
      await supabaseClient.storage.from('blog_images').remove([imagePath]);

      log('--- 3B. DATA SOURCE: Deleting from Database... ---');
      await supabaseClient.from('blogs').delete().eq('id', blogId);

      log('--- 3C. DATA SOURCE: Remote Deletion Complete ---');
    } catch (e) {
      log('--- ERROR IN DATA SOURCE: $e ---');
      throw ServerException(message: e.toString());
    }
  }

  //Edit Feature
  @override
  Future<BlogModel> editBlog(BlogModel blog) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .update({
            'title': blog.title,
            'content': blog.content,
            'image_url': blog.imageUrl,
            'topics': blog.categories,
            'updated_at': blog.updatedAt.toIso8601String(),
          })
          .eq('id', blog.id)
          .select('*, profiles(name)');

      return BlogModel.fromJson(blogData.first);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> uploadEditBlogImage({
    required XFile image,
    required String blogId,
  }) async {
    try {
      log('--- TRAP 3 (DATASOURCE): Starting Supabase upload... ---');
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        await supabaseClient.storage
            .from('blog_images')
            .uploadBinary(
              blogId,
              bytes,
              fileOptions: const FileOptions(upsert: true),
            );
      } else {
        final file = File(image.path);
        await supabaseClient.storage
            .from('blog_images')
            .upload(blogId, file, fileOptions: const FileOptions(upsert: true));
      }

      // Return the public URL
      return supabaseClient.storage.from('blog_images').getPublicUrl(blogId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
