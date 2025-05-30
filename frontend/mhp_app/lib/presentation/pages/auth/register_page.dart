import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_event.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_state.dart';
import 'package:mental_health_partner/presentation/widgets/auth/auth_layout.dart';
import 'package:mental_health_partner/presentation/widgets/common/app_text_field.dart';
import 'package:mental_health_partner/config/routes.dart';

class RegisterPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Create Account',
      footerText: 'Already have an account? ',
      footerActionText: 'Sign in',
      onFooterActionPressed: () {
        Navigator.pushReplacementNamed(context, AppRouter.loginRoute);
      },
      children: [
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state is RegistrationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 5),
                ),
              );
              // Show email verification dialog
              _showEmailVerificationDialog(context, state.email);
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextField(
                    label: 'Username',
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.email),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Confirm Password',
                    controller: _confirmPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                    RegisterRequested(userData: {
                                      'email': _emailController.text,
                                      'password': _passwordController.text,
                                      'password_confirm':
                                          _confirmPasswordController.text,
                                      'username': _usernameController.text,
                                    }),
                                  );
                            }
                          },
                    child: state is AuthLoading
                        ? const CircularProgressIndicator()
                        : const Text('Register'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _showEmailVerificationDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Check Your Email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.email,
                size: 64,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              const Text(
                'We\'ve sent a verification link to:',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Please check your email and click the verification link to activate your account.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, AppRouter.loginRoute);
              },
              child: const Text('Go to Login'),
            ),
          ],
        );
      },
    );
  }
}
