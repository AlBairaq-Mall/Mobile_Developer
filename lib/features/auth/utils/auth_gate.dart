import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/widgets/app_dialog.dart';
import '../providers/auth_provider.dart';

class AuthGate {
  AuthGate._();

  /// Checks if the user is logged in.
  /// If logged in, it executes [onAuthenticated].
  /// If not logged in, it asks the user to login.
  /// If [destination] is provided, it stores it as pending redirect, 
  /// so after successful login the user is redirected there.
  static void check(
    BuildContext context, {
    required VoidCallback onAuthenticated,
    String? destination,
    String loginMessage = 'يجب تسجيل الدخول لإتمام هذه العملية.',
  }) {
    final auth = context.read<AuthProvider>();

    if (auth.isLoggedIn) {
      onAuthenticated();
      return;
    }

    AppDialog.loginRequired(
      context,
      message: loginMessage,
    ).then((confirmed) {
      if (confirmed == true && context.mounted) {
        if (destination != null) {
          auth.setPendingRedirect(destination);
        }
        context.push(AppRoutes.login);
      }
    });
  }
}
