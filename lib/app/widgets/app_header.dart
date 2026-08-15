import 'package:flutter/material.dart';

import '../router/navigation_helper.dart';
import '../theme/app_colors.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final bool showBack;

  final List<Widget>? actions;

  const AppHeader({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      ),
      leading: showBack
          ? IconButton(
              onPressed: () {
                NavigationHelper.back(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
              ),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
