import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReactionButton extends StatelessWidget {
  final Blog blog;
  final String type;
  final String emoji;
  const ReactionButton({
    super.key,
    required this.blog,
    required this.type,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    final userState = context.read<AppUserCubit>().state;
    final userId = userState is AppUserLoggedIn ? userState.user.id : '';

    final reactions = blog.reactions ?? [];

    final count = reactions.where((react) => react.reactionType == type).length;

    // 4. Check if the CURRENT user clicked this exact reaction
    final isActive = reactions.any(
      (r) => r.userId == userId && r.reactionType == type,
    );

    return GestureDetector(
      onTap: () {
        if (userId.isEmpty) {
          return;
        }

        context.read<BlogBloc>().add(
          BlogUpdateReaction(
            blogId: blog.id,
            userId: userId,
            reactionType: type,
          ),
        );
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

        decoration: BoxDecoration(
          color: isActive
              ? AppPallete.gradient2.withValues(alpha: 0.15)
              : AppPallete.transparentColor,
          borderRadius: BorderRadius.circular(15),

          border: Border.all(
            color: isActive
                ? AppPallete.gradient2
                : AppPallete.transparentColor,
          ),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),

            if (count > 0) ...[
              const SizedBox(width: 3),

              Text(
                '$count',
                style: TextStyle(
                  fontSize: 14,
                  color: isActive ? AppPallete.gradient2 : AppPallete.greyColor,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
