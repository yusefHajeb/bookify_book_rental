import 'dart:async';
import 'dart:developer';

import 'package:bookify_book_rental/core/routes/routes.dart';
import 'package:bookify_book_rental/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bookify_book_rental/features/auth/presentation/screens/admin_panel_screen.dart';
import 'package:bookify_book_rental/features/auth/presentation/screens/login_screen.dart';
import 'package:bookify_book_rental/features/auth/presentation/screens/register_screen.dart';
import 'package:bookify_book_rental/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  static List<GoRoute> get routes {
    return [
      GoRoute(
        path: Routes.loginPage,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.registerPage,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.homePage,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.adminPage,
        builder: (context, state) => const AdminPanelScreen(),
      ),
    ];
  }

  static GoRouter router(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: Routes.loginPage,
      routes: routes,
      redirect: (context, state) {
        final authState = context.read<AuthBloc>().state;

        if (authState is AuthUnauthenticated) {
          if (state.uri.path == Routes.adminPage) {
            return Routes.adminPage;
          }
          log('state.uri.path llsdllsd');
          log(state.uri.path);
          if (state.uri.path == Routes.loginPage) {
            return Routes.loginPage;
          }
          if (state.uri.path == Routes.registerPage) {
            return Routes.registerPage;
          }

          log('User is unauthenticated, redirecting to login page');
          return state.uri.path == Routes.loginPage ? null : Routes.loginPage;
        }

        if (authState is AuthAuthenticated) {
          log('Authenticated user: ${authState.user.email}');
          if (authState.user.role == 'admin') {
            return state.uri.path != Routes.adminPage ? Routes.adminPage : null;
          } else {
            return state.uri.path == Routes.loginPage ? Routes.homePage : null;
          }
        }

        return null;
      },
      refreshListenable: _RefreshStream(authBloc),
    );
  }
}

class _RefreshStream extends ChangeNotifier {
  _RefreshStream(AuthBloc authBloc) {
    _subscription = authBloc.stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
