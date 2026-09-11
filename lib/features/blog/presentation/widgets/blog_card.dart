import 'package:blog_app/core/common/widgets/responsive_image_sizer.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calaulate_real_reading_time.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/reaction_button.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  const BlogCard({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, BlogViewerPage.route(blog));
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppPallete.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppPallete.borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          //
          child: Column(
            children: [
              //Cover Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: ResponsiveImageSizer(
                  child: Image.network(
                    '${blog.imageUrl}?v=${blog.updatedAt.millisecondsSinceEpoch}',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    //for error
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: AppPallete.borderColor,
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: AppPallete.greyColor,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              //Texts Card
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Scrollable Category Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: blog.categories
                            .map(
                              (category) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Chip(
                                  label: Text(category),
                                  color: WidgetStatePropertyAll(
                                    AppPallete.gradient2,
                                  ),
                                  side: BorderSide.none,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Blog Title
                    Center(
                      child: Text(
                        blog.title,
                        style: TextStyle(
                          fontSize: 20,
                          color: AppPallete.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 15),

                    //Blog Content
                    Text(
                      blog.content,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppPallete.textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.clip,
                    ),

                    const SizedBox(height: 15),

                    //User Name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "By ${blog.userName}",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppPallete.greyColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        // const SizedBox(width: 50),
                        Text(
                          "${calculateReadingTime(blog.content)} mins read",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppPallete.greyColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    //
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ReactionButton(blog: blog, type: 'love', emoji: '💖'),
                        ReactionButton(blog: blog, type: 'haha', emoji: '😆'),
                        ReactionButton(blog: blog, type: 'sad', emoji: '🥲'),
                        ReactionButton(blog: blog, type: 'wow', emoji: '🙄'),
                        ReactionButton(blog: blog, type: 'angry', emoji: '🤬'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
