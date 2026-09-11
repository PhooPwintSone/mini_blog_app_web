import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/responsive/constrained_scaffold.dart';
import 'package:blog_app/core/common/widgets/responsive_image_sizer.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calaulate_real_reading_time.dart';
import 'package:blog_app/core/utils/datetime_format_helper.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/reaction_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogViewerPage extends StatelessWidget {
  static MaterialPageRoute<dynamic> route(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog));
  final Blog blog;

  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    //Get the current user ID
    final userState = context.read<AppUserCubit>().state;
    final currentUserId = (userState is AppUserLoggedIn)
        ? userState.user.id
        : null;

    //check if the current user is the author of this blog
    final isAuthor = currentUserId == blog.userId;

    return ConstrainedScaffold(
      appBar: AppBar(
        title: Text("📚 Feed"),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppPallete.textColor),

        actions: [
          //only show the delete btn if they are author
          if (isAuthor)
            IconButton(
              onPressed: () {
                context.read<BlogBloc>().add(
                  BlogDeletEvent(blogId: blog.id, imageUrl: blog.imageUrl),
                );

                Navigator.pop(context);
              },
              icon: Icon(Icons.delete, color: AppPallete.errorColor),
            ),

          //edit if they are author
          if (isAuthor)
            IconButton(
              onPressed: () {
                Navigator.push(context, AddNewBlogPage.route(blogToEdit: blog));
              },
              icon: const Icon(Icons.edit, color: AppPallete.gradient1),
            ),
        ],
      ),

      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                //Title
                Text(
                  blog.title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.textColor,
                  ),
                ),

                const SizedBox(height: 20),

                //User Name and MetaData
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppPallete.gradient2,
                            radius: 20,
                            child: Text(
                              blog.userName.isNotEmpty
                                  ? blog.userName[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          Text(
                            "By ${blog.userName}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppPallete.textColor,
                            ),
                          ),
                        ],
                      ),

                      Text(
                        "${formatDate(blog.updatedAt)}  ${calculateReadingTime(blog.content)} mins read",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppPallete.greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                //Blog Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),

                  child: ResponsiveImageSizer(
                    mobileHeight: 250,
                    child: Image.network(
                      '${blog.imageUrl}?v=${blog.updatedAt.millisecondsSinceEpoch}',
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,

                      //Error Icon
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 250,
                          width: double.infinity,
                          color: AppPallete.borderColor,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: AppPallete.greyColor,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                //blog Content
                Text(
                  blog.content,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.8,
                    color: AppPallete.textColor,
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<BlogBloc, BlogState>(
                  builder: (context, state) {
                    Blog updatedBlog = blog;

                    if (state is BlogDisplaySuccess) {
                      final matchingBlogs = state.blogs.where(
                        (b) => b.id == blog.id,
                      );

                      if (matchingBlogs.isNotEmpty) {
                        updatedBlog = matchingBlogs.first;
                      }
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ReactionButton(
                          blog: updatedBlog,
                          type: 'love',
                          emoji: '💖',
                        ),
                        ReactionButton(
                          blog: updatedBlog,
                          type: 'haha',
                          emoji: '😆',
                        ),
                        ReactionButton(
                          blog: updatedBlog,
                          type: 'sad',
                          emoji: '🥲',
                        ),
                        ReactionButton(
                          blog: updatedBlog,
                          type: 'wow',
                          emoji: '🙄',
                        ),
                        ReactionButton(
                          blog: updatedBlog,
                          type: 'angry',
                          emoji: '🤬',
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
