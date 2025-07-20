import 'package:bookify_book_rental/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection.dart' as di;
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await ScreenUtil.ensureScreenSize();
  await AppTheme.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _authBloc = di.sl<AuthBloc>();

  late final GoRouter _router = AppRoutes.router(_authBloc);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,

      designSize: const Size(360, 690),

      child: Builder(
        builder: (context) {
          return BlocProvider.value(
            value: _authBloc..add(const AuthCheckRequested()),
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,

              title: 'Bookify',
              themeMode: ThemeMode.dark,
              theme: AppTheme.darkThemeData,
              darkTheme: AppTheme.darkThemeData,
              routerConfig: _router,
            ),
          );
        },
      ),
    );
  }
}

/// Simple home screen after successful authentication
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookify Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Bookify!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return Text('Logged in as: ${state.user.email}');
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
