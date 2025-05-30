import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_links/app_links.dart';
import 'package:mental_health_partner/config/routes.dart';
import 'package:mental_health_partner/core/constants/asset_paths.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkStreamSubscription;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initializeDeepLinks();
  }

  void _initializeDeepLinks() {
    _appLinks = AppLinks();

    // Listen for incoming links when app is already running
    _linkStreamSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        _handleDeepLink(uri.toString());
      },
      onError: (err) {
        // Handle errors if needed
        debugPrint('Deep link error: $err');
      },
    );

    // Handle deep link when app is launched from terminated state
    _handleInitialLink();
  }

  Future<void> _handleInitialLink() async {
    try {
      final Uri? initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink.toString());
      }
    } catch (e) {
      debugPrint('Failed to get initial link: $e');
    }
  }

  void _handleDeepLink(String uri) {
    if (!mounted || _hasNavigated) return;

    if (uri.startsWith('mentalhealth://login')) {
      _hasNavigated = true;
      // Navigate to login screen
      Navigator.pushReplacementNamed(context, AppRouter.loginRoute);
    }
    // You can add more deep link handling here
    // else if (uri.startsWith('myapp://home')) {
    //   _hasNavigated = true;
    //   Navigator.pushReplacementNamed(context, AppRouter.homeRoute);
    // }
  }

  @override
  void dispose() {
    _linkStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (_hasNavigated) {
          return; // Prevent navigation if deep link already handled
        }

        if (state is Authenticated) {
          _hasNavigated = true;
          Navigator.pushReplacementNamed(context, AppRouter.homeRoute);
        } else if (state is Unauthenticated) {
          _hasNavigated = true;
          Navigator.pushReplacementNamed(context, AppRouter.loginRoute);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AssetPaths.logo, width: 150),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Made with ❤️',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
