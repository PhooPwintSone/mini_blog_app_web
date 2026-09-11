import 'dart:developer';
import 'dart:io';

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_datasources.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/data/models/reaction_model.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlogRemoteDatasourcesImpl implements BlogRemoteDatasources {
  final SupabaseClient supabaseClient;

  BlogRemoteDatasourcesImpl({required this.supabaseClient});

  // --- Blogs Section --- //
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
          .select('*,profiles(name), blog_reactions(*)')
          .order('updated_at', ascending: false)
          .range(from, to);
      log('🔴 SUPABASE RAW DATA: ${blogs[0]['blog_reactions']}');
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
      final imagePath = imageUrl.split('/').last;

      await supabaseClient.storage.from('blog_images').remove([imagePath]);

      await supabaseClient.from('blogs').delete().eq('id', blogId);
    } catch (e) {
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

  // edid photo at add new blog page
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

      return supabaseClient.storage.from('blog_images').getPublicUrl(blogId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // --- Reactions Section --- //

  //update reactions
  @override
  Future<void> updateReaction({
    required String blogId,
    required String userId,
    required String reactionType,
  }) async {
    try {
      // 1. Check if the user already reacted with this exact type
      final existingReaction = await supabaseClient
          .from('blog_reactions')
          .select()
          .eq('blog_id', blogId)
          .eq('user_id', userId)
          .maybeSingle();

      // If they clicked the same reaction again, remove it (toggle off)

      if (existingReaction != null &&
          existingReaction['reaction_type'] == reactionType) {
        await supabaseClient
            .from('blog_reactions')
            .delete()
            .eq('blog_id', blogId)
            .eq('user_id', userId);
      } else {
        // Otherwise, insert or update to the new reaction type (upsert)

        await supabaseClient.from('blog_reactions').upsert({
          'blog_id': blogId,
          'user_id': userId,
          'reaction_type': reactionType,
        }, onConflict: 'blog_id , user_id');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  //get all reactions
  @override
  Future<List<ReactionModel>> getReactions(String blogId) async {
    try {
      final response = await supabaseClient
          .from('blog_reactions')
          .select()
          .eq('blog_id', blogId);

      return response.map((json) => ReactionModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
