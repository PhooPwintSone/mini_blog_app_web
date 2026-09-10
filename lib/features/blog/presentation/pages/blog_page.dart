import 'dart:developer';

import 'package:blog_app/bloc/auth_bloc.dart';
import 'package:blog_app/core/common/responsive/constrained_scaffold.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/pages/signin_page.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_drawer.dart';
import 'package:blog_app/features/blog/presentation/widgets/custom_appbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() =>
      MaterialPageRoute(builder: (context) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  //for scroll controller
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<BlogBloc>().add((BlogGetAllBlogs()));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      log('--- TRAP 1 (UI): Reached the bottom! Dispatching Load More... ---');
      context.read<BlogBloc>().add((BlogLoadMoreBlogs()));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      backgroundColor: AppPallete.backgroundColor,
      drawer: BlogDrawer(),
      appBar: CustomAppBar(title: "📚 Feed"),

      //new feed body
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // Listen for Auth states here!
          if (state is AuthInitial) {
            Navigator.pushAndRemoveUntil(
              context,
              SigninPage.route(),
              (route) => false,
            );
          }
        },
        child: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            if (state is BlogFailure) {
              showSnackBar(context, state.errorMessage);
            }

            if (state is BlogUploadSuccess) {
              showSnackBar(context, "Success");
              context.read<BlogBloc>().add(BlogGetAllBlogs());
            }
          },

          builder: (context, state) {
            // loading state
            if (state is BlogLoading) {
              return const Loader();
            }

            // success state
            if (state is BlogDisplaySuccess) {
              final blogs = state.blogs;

              if (blogs.isEmpty) {
                return const Center(
                  child: Text(
                    'No blogs yet. Be the first to post!',
                    style: TextStyle(color: AppPallete.textColor, fontSize: 16),
                  ),
                );
              } else {
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: blogs.length,
                  itemBuilder: (context, index) {
                    final blog = blogs[index];
                    return BlogCard(blog: blog);
                  },
                );
              }
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
