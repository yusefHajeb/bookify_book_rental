import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/register_use_case.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC for managing authentication state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final AuthRepository _authRepository;
  final formKey = GlobalKey<FormState>();
  final formRegisterKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required AuthRepository authRepository,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _authRepository = authRepository,
       super(AuthInitial()) {
    // Register event handlers
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  /// Handles authentication check event
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final isLoggedIn = await _authRepository.isLoggedIn();

      if (isLoggedIn) {
        final user = await _authRepository.getCurrentUser();
        user != null
            ? emit(AuthAuthenticated(user: user))
            : emit(AuthUnauthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: 'Auth check failed: ${e.toString()}'));
    }
  }

  /// Handles login event
  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    if (formKey.currentState?.validate() ?? false) {
      emit(AuthLoading());
      log(emailController.text);

      try {
        final user = await _loginUseCase.execute(
          emailController.text,
          passwordController.text,
        );
        log(user.toString());
        emit(AuthAuthenticated(user: user));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    }
  }

  /// Handles registration event
  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    if (formRegisterKey.currentState?.validate() ?? false) {
      try {
        final user = await _registerUseCase.execute(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          role: 'user',
        );
        log(user.toString());
        emit(AuthAuthenticated(user: user));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    }
  }

  /// Handles logout event
  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Failed to logout: ${e.toString()}'));
    }
  }
}
