import 'package:bookify_book_rental/core/routes/routes.dart';
import 'package:bookify_book_rental/core/widgets/app_test_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  String _selectedRole = 'user';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeText = theme.textTheme;
    final _authBloc = context.read<AuthBloc>();

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

          if (state is AuthAuthenticated) {
            context.pushReplacementNamed(Routes.homePage);
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _authBloc.formRegisterKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.book, size: 64, color: theme.primaryColor),
                        const SizedBox(height: 16),
                        Text(
                          'Bookify',
                          style: themeText.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'إنشاء حساب جديد',
                          style: themeText.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Name Field
                        AppTextFormField(
                          controller: _authBloc.nameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          labelText: 'الاسم',
                          hintText: 'ادخل الإسم كاملا',
                          prefixIcon: const Icon(Icons.person_outline),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى ادخال الإسم';
                            }
                            if (value.length < 2) {
                              return 'ادخل اسم صحيح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Email Field
                        AppTextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _authBloc.emailController,
                          keyboardType: TextInputType.emailAddress,
                          labelText: 'الإيميل',
                          hintText: 'أدخل البريد الإلكتروني',
                          prefixIcon: const Icon(Icons.email_outlined),

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
                        const SizedBox(height: 16),

                        AppTextFormField(
                          controller: _authBloc.passwordController,
                          isObscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          labelText: 'كلمة المرور',
                          hintText: 'ادخل كلمة المرور',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إنشاء كلمة المرور';
                            }
                            if (value.length < 8) {
                              return 'يجب ان تحتوي كلمة المرور على 8 احرف على الأقل';
                            }
                            if (!RegExp(r'(?=.*[0-9])').hasMatch(value)) {
                              return 'يجب ان تحتوي كلمة المرور على رقم واحد على الأقل';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: InputDecoration(
                            labelText: 'الصلاحية',
                            prefixIcon: const Icon(Icons.person_pin),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'user',
                              child: Text('مستخدم'),
                            ),
                            DropdownMenuItem(
                              value: 'admin',
                              child: Text('أدمن'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedRole = value);
                            }
                          },
                        ),
                        const SizedBox(height: 24),

                        // Register Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'إنشاء حساب',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 16),

                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'هل لديك حساب ?',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            TextButton(
                              onPressed: () {
                                context.pushReplacement(Routes.loginPage);
                              },
                              child: Text(
                                'إنشاء الحساب',
                                style: TextStyle(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Handles registration form submission
  void _handleRegister() {
    // if (_formKey.currentState?.validate() ?? false) {
    context.read<AuthBloc>().add(
      AuthRegisterRequested(
        name: 'name',
        email: 'email',
        password: 'password',
        role: _selectedRole,
      ),
    );
  }

  // }
}
