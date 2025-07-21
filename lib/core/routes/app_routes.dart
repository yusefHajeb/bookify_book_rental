import 'dart:async';
import 'dart:developer';

import 'package:bookify_book_rental/core/di/injection.dart';
import 'package:bookify_book_rental/core/routes/routes.dart';
import 'package:bookify_book_rental/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bookify_book_rental/features/auth/presentation/screens/admin_panel_screen.dart';
import 'package:bookify_book_rental/features/auth/presentation/screens/login_screen.dart';
import 'package:bookify_book_rental/features/auth/presentation/screens/register_screen.dart';
import 'package:bookify_book_rental/features/books/data/models/book_model.dart';
import 'package:bookify_book_rental/features/books/presentation/screens/book_details_screen.dart';
import 'package:bookify_book_rental/features/books/presentation/screens/booking_flow_screen.dart';
import 'package:bookify_book_rental/features/books/presentation/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/books/presentation/bloc/book_bloc.dart';

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
        builder: (context, state) => BlocProvider(
          create: (context) => sl<BookBloc>()..add(const LoadBooksEvent()),
        ),
      ),
      GoRoute(
        path: Routes.bookDetailsPage,

        builder: (context, state) {
          final book = state.extra as BookModel; // استقبال البيانات

          return BlocProvider(
            create: (context) => sl<BookBloc>()..add(const LoadBooksEvent()),
            child: BookDetailsScreen(book: book),
          );
        },
      ),
      GoRoute(
        path: Routes.bookingFlowPage,

        builder: (context, state) {
          final book = state.extra as BookModel; // استقبال البيانات

          return BlocProvider(
            create: (context) => sl<BookBloc>()..add(const LoadBooksEvent()),
            child: BookingFlowScreen(book: book),
          );
        },
      ),
      GoRoute(
        path: Routes.profilePage,

        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<BookBloc>()..add(const LoadBooksEvent()),
            child: UserProfileScreen(),
          );
        },
      ),
      GoRoute(
        path: Routes.adminPage,

        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<BookBloc>()..add(const LoadBooksEvent()),
            child: AdminPanelScreen(),
          );
        },
      ),
      GoRoute(
        path: Routes.adminPage,

        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<BookBloc>()..add(const LoadBooksEvent()),
            child: AdminPanelScreen(),
          );
        },
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
        final authState = authBloc.state;

        if (authState is AuthUnauthenticated) {
          if (state.uri.path == Routes.loginPage ||
              state.uri.path == Routes.registerPage) {
            return null;
          }
          return Routes.loginPage;
        }

        if (authState is AuthAuthenticated) {
          log(
            'Authenticated user: ${authState.user.email}, role: ${authState.user.role} , path: ${state.uri.path}',
          );
          final isLoginOrRegister =
              state.uri.path == Routes.loginPage ||
              state.uri.path == Routes.registerPage;
          final isAdminPath = state.uri.path == Routes.adminPage;
          final isAdmin = authState.user.role == 'admin';

          if (isLoginOrRegister || isAdminPath) {
            print('Redirecting authenticated user to home page');
            return isAdmin ? Routes.adminPage : Routes.homePage;
          }

          if (isAdminPath && !isAdmin) {
            return Routes.homePage;
          }

          return null;
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
