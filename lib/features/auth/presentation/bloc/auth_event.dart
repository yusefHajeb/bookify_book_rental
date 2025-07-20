part of 'auth_bloc.dart';

/// Base class for all authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check current authentication status
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Event to request user login
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Event to request user registration
class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String role;

  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    this.role = 'user',
  });

  @override
  List<Object?> get props => [name, email, password, role];
}

/// Event to request user logout
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
