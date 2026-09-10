import 'dart:developer';
import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/responsive/constrained_scaffold.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/common/widgets/responsive_image_sizer.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/image_picker.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_edit_textfield.dart';
import 'package:blog_app/features/blog/presentation/widgets/custom_appbar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddNewBlogPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route({Blog? blogToEdit}) =>
      MaterialPageRoute(
        builder: (context) => AddNewBlogPage(blogToEdit: blogToEdit),
      );

  final Blog? blogToEdit;
  const AddNewBlogPage({super.key, this.blogToEdit});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  // Controllers for textfield
  final _blogTitleController = TextEditingController();
  final _blogContentController = TextEditingController();

  // Lists of categories
  List<String> selectedCategories = [];

  // form key
  final formKey = GlobalKey<FormState>();

  // for imagePicker
  XFile? image;
  @override
  void initState() {
    super.initState();
    if (widget.blogToEdit != null) {
      _blogTitleController.text = widget.blogToEdit!.title;
      _blogContentController.text = widget.blogToEdit!.content;
      selectedCategories = List.from(widget.blogToEdit!.categories);
    }
  }

  @override
  void dispose() {
    _blogTitleController.dispose();
    _blogContentController.dispose();
    super.dispose();
  }

  void selectImage() async {
    final pickImage = await pickerImage();

    if (pickImage != null) {
      setState(() {
        image = pickImage;
      });
    }
  }

  // Upload or Edit blog
  void _uploadBlog() {
    final hasImage = image != null || widget.blogToEdit != null;

    if (formKey.currentState!.validate() &&
        selectedCategories.isNotEmpty &&
        hasImage) {
      if (widget.blogToEdit != null) {
        // 💡 Dispatch Edit Event
        log('--- TRAP 1 (UI): Image picked is: ${image?.path} ---');
        context.read<BlogBloc>().add(
          BlogEditEvent(
            image: image,
            blogId: widget.blogToEdit!.id,
            userId: widget.blogToEdit!.userId,
            userName: widget.blogToEdit!.userName,
            title: _blogTitleController.text.trim(),
            content: _blogContentController.text.trim(),
            categories: selectedCategories,
            existingImageUrl: widget.blogToEdit!.imageUrl,
          ),
        );
      } else {
        // Dispatch Create Event
        final userState = context.read<AppUserCubit>().state;

        if (userState is AppUserLoggedIn) {
          final userId = userState.user.id;

          context.read<BlogBloc>().add(
            BlogUpload(
              userId: userId,
              title: _blogTitleController.text.trim(),
              content: _blogContentController.text.trim(),
              image: image!,
              categories: selectedCategories,
            ),
          );
        } else {
          showSnackBar(context, "User session not found. Please log in again.");
        }
      }
    } else {
      showSnackBar(
        context,
        "Please fill all fields, select an image, and choose a category.",
      );
    }
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    final isEditing = widget.blogToEdit != null;

    return ConstrainedScaffold(
      backgroundColor: AppPallete.backgroundColor,
      appBar: CustomAppBar(
        title: isEditing ? "✍️ Edit Blog" : "✍️ New Blog",
        actions: [
          IconButton(
            onPressed: () => _uploadBlog(),
            icon: const Icon(
              CupertinoIcons.check_mark_circled_solid,
              color: AppPallete.gradient1,
              size: 26,
            ),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.errorMessage);
            log(state.errorMessage);
          } else if (state is BlogUploadSuccess || state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    // const SizedBox(height: 20),

                    // Image picker container with support for local file, network image, or empty state
                    image != null
                        ? GestureDetector(
                            onTap: () => selectImage(),
                            // 💡 1. Used here for the newly picked image
                            child: ResponsiveImageSizer(
                              mobileHeight: 250,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: kIsWeb
                                    ? Image.network(
                                        height: 250,
                                        image!.path,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        height: 250,
                                        File(image!.path),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          )
                        : isEditing
                        ? GestureDetector(
                            onTap: () => selectImage(),
                            // 💡 2. Used here for the existing edited image
                            child: ResponsiveImageSizer(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  height: 250,
                                  '${widget.blogToEdit!.imageUrl}?v=${widget.blogToEdit!.updatedAt.millisecondsSinceEpoch}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => selectImage(),
                            // 💡 3. Used here for the empty dotted placeholder
                            child: ResponsiveImageSizer(
                              child: DottedBorder(
                                color: AppPallete.borderColor,
                                strokeWidth: 2,
                                dashPattern: const [10, 4],
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(12),
                                child: Container(
                                  width: double.infinity,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        CupertinoIcons.folder_open,
                                        color: AppPallete.gradient1,
                                        size: 44,
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        "Select your image",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppPallete.textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                    const SizedBox(height: 30),

                    // Categories Labels
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            const [
                                  'Technology',
                                  'Business',
                                  'Programming',
                                  'Entertainment',
                                  'Hobby',
                                  'Just For Fun',
                                  'Life Style',
                                ]
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (selectedCategories.contains(e)) {
                                          selectedCategories.remove(e);
                                        } else {
                                          selectedCategories.add(e);
                                        }
                                        setState(() {});
                                      },
                                      child: Chip(
                                        label: Text(e),
                                        color: selectedCategories.contains(e)
                                            ? const WidgetStatePropertyAll(
                                                AppPallete.gradient2,
                                              )
                                            : null,
                                        side: selectedCategories.contains(e)
                                            ? null
                                            : BorderSide(
                                                color: AppPallete.borderColor,
                                              ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Title Text Field
                    BlogEditTextfield(
                      controller: _blogTitleController,
                      hintText: "Title....",
                    ),

                    const SizedBox(height: 20),

                    // Content Text Field
                    BlogEditTextfield(
                      controller: _blogContentController,
                      hintText: "Blog Content....",
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
