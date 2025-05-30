import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;

  const Authenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

class RegistrationSuccess extends AuthState {
  final String message;
  final String email;

  const RegistrationSuccess({required this.message, required this.email});

  @override
  List<Object> get props => [message, email];
}

class EmailVerificationRequired extends AuthState {
  final String message;

  const EmailVerificationRequired({required this.message});

  @override
  List<Object> get props => [message];
}
