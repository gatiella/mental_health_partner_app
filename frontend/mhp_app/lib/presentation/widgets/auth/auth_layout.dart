import 'package:flutter/material.dart';
import 'package:mental_health_partner/core/constants/asset_paths.dart';

class AuthLayout extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final String? footerText;
  final String? footerActionText;
  final VoidCallback? onFooterActionPressed;

  const AuthLayout({
    super.key,
    required this.title,
    required this.children,
    this.footerText,
    this.footerActionText,
    this.onFooterActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Image.asset(
                    AssetPaths.logo,
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: children,
                    ),
                  ),
                  if (footerText != null || footerActionText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (footerText != null)
                            Text(
                              footerText!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          if (footerActionText != null)
                            TextButton(
                              onPressed: onFooterActionPressed,
                              child: Text(
                                footerActionText!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
