import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/responsive/constrained_scaffold.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:blog_app/features/blog/presentation/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserOwnBlogPage extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (context) => const UserOwnBlogPage());
  const UserOwnBlogPage({super.key});

  @override
  State<UserOwnBlogPage> createState() => _UserOwnBlogPageState();
}

class _UserOwnBlogPageState extends State<UserOwnBlogPage> {
  @override
  void initState() {
    super.initState();

    final userState = context.read<AppUserCubit>().state;

    if (userState is AppUserLoggedIn) {
      context.read<BlogBloc>().add(BlogGetUserBlogs(userId: userState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: CustomAppBar(title: '📑 My Blogs'),

      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }

          if (state is BlogDisplaySuccess) {
            if (state.blogs.isEmpty) {
              return const Center(
                child: Text(
                  'You haven\t posted any blogs yet!',
                  style: TextStyle(fontSize: 18, color: AppPallete.greyColor),
                ),
              );
            }

            return ListView.builder(
              itemCount: state.blogs.length,

              itemBuilder: (context, index) {
                final blog = state.blogs[index];

                return BlogCard(blog: blog);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
