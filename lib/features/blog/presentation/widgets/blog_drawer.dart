import 'package:blog_app/bloc/auth_bloc.dart';
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/pages/user_own_blog_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogDrawer extends StatelessWidget {
  const BlogDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Grab the current user's state
    final userState = context.read<AppUserCubit>().state;

    // 2. If they somehow aren't logged in, return an empty box
    if (userState is! AppUserLoggedIn) {
      return const SizedBox();
    }

    final user = userState.user;

    return Drawer(
      backgroundColor: AppPallete.backgroundColor,
      child: Column(
        children: [
          // 3. Flutter's built-in beautiful profile header!
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppPallete.gradient2),
            accountName: Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(user.email),

            currentAccountPicture: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppPallete.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.person, size: 40, color: AppPallete.gradient2),
            ),
          ),

          // 4. You can add more menu items here later!
          ListTile(
            leading: const Icon(
              CupertinoIcons.add_circled_solid,
              color: AppPallete.gradient2,
              size: 26,
            ),
            title: const Text('Create New Blog'),
            onTap: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.feed,
              color: AppPallete.gradient2,
              size: 26,
            ),
            title: const Text('My Blogs'),
            onTap: () {
              Navigator.pop(context);

              final blogBloc = context.read<BlogBloc>();
              Navigator.push(context, UserOwnBlogPage.route()).then((_) {
                // When the user presses the back button to return here, refresh the feed!
                blogBloc.add(BlogGetAllBlogs());
              });
            },
          ),

          // const Spacer(),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Loader();
              }
              return ListTile(
                leading: const Icon(
                  Icons.door_back_door_outlined,
                  color: AppPallete.gradient2,
                  size: 26,
                ),
                title: const Text('Log Out'),
                onTap: () {
                  context.read<AuthBloc>().add(AuthSignOut());
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
