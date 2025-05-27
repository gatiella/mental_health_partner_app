import 'package:equatable/equatable.dart';
import 'package:mental_health_partner/data/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserData extends AuthEvent {
  final UserModel user;

  const UpdateUserData(this.user);

  @override
  List<Object> get props => [user];
}

class CheckAuthStatus extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final Map<String, dynamic> userData;

  const RegisterRequested({required this.userData});

  @override
  List<Object> get props => [userData];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class GetUserRequested extends AuthEvent {}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested(this.email);

  @override
  List<Object> get props => [email];
}
