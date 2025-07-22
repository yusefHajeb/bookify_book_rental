import 'package:bookify_book_rental/core/routes/routes.dart';
import 'package:bookify_book_rental/core/theme/theme_card.dart';
import 'package:bookify_book_rental/core/utils/animated_fade_in.dart'; // <-- Import AnimatedFadeIn
import 'package:bookify_book_rental/core/widgets/app_test_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';

/// Login screen for user authentication
/// Provides UI for email/password login with form validation
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _checkUserStatus();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }

          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state is AuthAuthenticated) {}
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ThemeCard(),
                AnimatedFadeIn(
                  // <-- Use AnimatedFadeIn here
                  delay: Duration(milliseconds: 400),
                  child: Center(
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(32.0.r),
                            child: Form(
                              key: authBloc.formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // App Logo/TitAnimatedFadeInle
                                  AnimatedFadeIn(
                                    delay: Duration(milliseconds: 400),
                                    child: Icon(
                                      Icons.book,
                                      size: 64,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  AnimatedFadeIn(
                                    delay: Duration(milliseconds: 440),
                                    child: Text(
                                      'Bookify',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedFadeIn(
                                    delay: Duration(milliseconds: 470),
                                    child: Text(
                                      'مرحبا بعودتك ! يرجى تسجيل الدخول اولا.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.grey[400]),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 32),

                                  // Email Field
                                  AnimatedFadeIn(
                                    delay: Duration(milliseconds: 550),
                                    child: AppTextFormField(
                                      controller: authBloc.emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      labelText: 'الايميل',
                                      hintText: 'أدخل البريد الإلكتروني',
                                      prefixIcon: const Icon(
                                        Icons.email_outlined,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2,
                                        ),
                                      ),

                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'يرجى ادخال البريد الالكتروني';
                                        }
                                        if (!RegExp(
                                          r'^[^@]+@[^@]+\.[^@]+',
                                        ).hasMatch(value)) {
                                          return 'يرجى ادخال بريد الكتروني صالح';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Password Field
                                  AnimatedFadeIn(
                                    delay: Duration(milliseconds: 600),
                                    child: AppTextFormField(
                                      controller: authBloc.passwordController,
                                      isObscureText: _obscurePassword,
                                      textInputAction: TextInputAction.done,
                                      labelText: 'كلمة المرور ',
                                      hintText: 'ادخل كلمة المرور الخاصه بك ',
                                      prefixIcon: const Icon(
                                        Icons.lock_outlined,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      ),

                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2,
                                        ),
                                      ),

                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'يرجى إدخال كلمة المرور';
                                        }
                                        if (value.length < 6) {
                                          return 'يجب أن تحتوي كلمة المرور على 8 احرف ';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  AnimatedFadeIn(
                                    delay: Duration(milliseconds: 650),
                                    child: ElevatedButton(
                                      onPressed: _isLoading
                                          ? null
                                          : _handleLogin,
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                            )
                                          : Text(
                                              'تسجيل الدخول',
                                              style:
                                                  theme.textTheme.labelMedium,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Forgot Password Link
                                  TextButton(
                                    onPressed: () {
                                      // TODO: Implement forgot password functionality
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'تم اضافتها لمحاكاة تجربة المستخدم ',
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    child: Text('نسيت كلمة المرور؟'),
                                  ),
                                  const SizedBox(height: 24),

                                  // Divider
                                  AnimatedFadeIn(
                                    delay: Duration(milliseconds: 700),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Divider(
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Text('أو'),
                                        ),
                                        Expanded(
                                          child: Divider(
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Register Link
                                  AnimatedFadeIn(
                                    delay: Duration(milliseconds: 750),
                                    child: OutlinedButton(
                                      onPressed: () => context.go(
                                        Routes.registerPage,
                                        // extra: 'replace',
                                      ),

                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.h,
                                        ),

                                        side: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      child: Text(
                                        'إنشاء حساب جديد',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Handles login form submission
  void _handleLogin() {
    context.read<AuthBloc>().add(
      AuthLoginRequested(email: 'email', password: 'password'),
    );
    // }
  }
}
