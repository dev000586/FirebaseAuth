import 'package:firbase_auth/ui/forget_password_page.dart';
import 'package:firbase_auth/ui/home_page.dart';
import 'package:firbase_auth/ui/login_page.dart';
import 'package:firbase_auth/ui/signup_page.dart';
import 'package:flutter/material.dart';

class RoutesConst {
  // Routes Name
  static const login = '/login';
  static const signup = '/signup';
  static const forgetPassword = '/forgetPassword';
  static const home = '/home';

  //Router...
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map<dynamic, dynamic>? params = settings.arguments == null ? null : settings.arguments as Map;
    switch (settings.name) {
    // Login Route
      case login:
        return _GeneratePageRoute(
          widget: const LoginPage(),
          routeName: settings.name,
        );
    // SignUp Route
      case signup:
        return _GeneratePageRoute(
          widget: const SignUpPage(

          ),
          routeName: settings.name,
        );
    // Forget Password Route
      case forgetPassword:
        return _GeneratePageRoute(
          widget: const ForgetPasswordPage(),
          routeName: settings.name,
        );
    // SignUp Route
      case home:
        return _GeneratePageRoute(
          widget: const HomePage(),
          routeName: settings.name,
        );
    // Default route
      default:
        return _GeneratePageRoute(
          widget: const LoginPage(),
          routeName: settings.name,
        );
    }
  }
}

//! Widget for generating routes with screen and route name (For Animation)
class _GeneratePageRoute extends PageRouteBuilder {
  final Widget widget;
  final String? routeName;
  final bool isAction;
  _GeneratePageRoute({
    required this.widget,
    required this.routeName,
    this.isAction = false,
  }) : super(
    settings: RouteSettings(name: routeName),
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) {
      return widget;
    },
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) {
      Animation<Offset> offset = isAction
          ? Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(animation)
          : Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation);
      return SlideTransition(
        textDirection: TextDirection.ltr,
        position: offset,
        child: child,
      );
    },
  );
}
