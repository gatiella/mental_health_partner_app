import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_event.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_state.dart';
import 'package:mental_health_partner/presentation/widgets/common/app_button.dart';
import 'package:mental_health_partner/presentation/widgets/common/app_text_field.dart';

class ResetPasswordPage extends StatelessWidget {
  final String token;
  const ResetPasswordPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AppTextField(
              label: 'New Password',
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Confirm Password',
              controller: confirmPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is ResetPasswordSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                }
              },
              builder: (context, state) {
                return AppButton(
                  text: 'Reset Password',
                  onPressed: state is AuthLoading
                      ? null
                      : () {
                          if (passwordController.text.isNotEmpty &&
                              passwordController.text ==
                                  confirmPasswordController.text) {
                            context.read<AuthBloc>().add(
                                  ResetPasswordRequested(
                                      token, passwordController.text),
                                );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Passwords do not match')),
                            );
                          }
                        },
                  isLoading: state is AuthLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
