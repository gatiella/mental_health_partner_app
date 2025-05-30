import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/domain/usecases/auth/forgot_password_use_case.dart';
import 'package:mental_health_partner/domain/usecases/auth/reset_password_use_case.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import '../../../domain/usecases/auth/logout_usecase.dart';
import '../../../domain/usecases/auth/get_user_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetUserUseCase getUserUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getUserUseCase,
    required this.forgotPasswordUseCase,
    required this.resetPasswordUseCase,
  }) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<GetUserRequested>(_onGetUserRequested);
    on<UpdateUserData>(_onUpdateUserData);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested); // Add this
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final userResult = await getUserUseCase();
    userResult.fold(
      (failure) => emit(Unauthenticated()),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUseCase(event.email, event.password);
    if (emit.isDone) return;

    if (result.isLeft()) {
      final failure = result.swap().getOrElse(() => throw Exception());
      if (failure.message.contains('verify your email')) {
        emit(EmailVerificationRequired(message: failure.message));
      } else {
        emit(AuthError(message: failure.message));
      }
    } else {
      final userResult = await getUserUseCase();
      if (emit.isDone) return;
      userResult.fold(
        (failure) => emit(AuthError(message: failure.message)),
        (user) => emit(Authenticated(user: user)),
      );
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await registerUseCase(event.userData);
    if (emit.isDone) return;

    if (result.isLeft()) {
      emit(AuthError(
          message: result.swap().getOrElse(() => throw Exception()).message));
    } else {
      // Registration successful, show verification message
      emit(RegistrationSuccess(
        message:
            'Account created successfully. Please check your email to verify your account.',
        email: event.userData['email'],
      ));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await logoutUseCase();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onGetUserRequested(
    GetUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await getUserUseCase();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onUpdateUserData(
    UpdateUserData event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is Authenticated) {
      emit(Authenticated(user: event.user));
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await forgotPasswordUseCase(event.email);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (message) => emit(ForgotPasswordSuccess(message: message)),
    );
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await resetPasswordUseCase(event.token, event.password);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (message) => emit(ResetPasswordSuccess(message: message)),
    );
  }
}
