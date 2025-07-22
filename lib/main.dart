import 'package:bookify_book_rental/core/routes/app_routes.dart';
import 'package:bookify_book_rental/core/theme/cubit/theme_cubit.dart';
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
  runApp(
    BlocProvider(
      create: (context) => di.sl<ThemeCubit>()..getSaveTheme(),
      child: MyApp(),
    ),
  );
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
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,

                  title: 'Bookify',
                  themeMode: state.themeMode,
                  theme: AppTheme.themeDataSelect(state.themeMode),
                  darkTheme: AppTheme.darkThemeData,
                  routerConfig: _router,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
