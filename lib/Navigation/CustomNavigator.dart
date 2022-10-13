
import 'package:firbase_auth/ui/forget_password_page.dart';
import 'package:firbase_auth/ui/home_page.dart';
import 'package:firbase_auth/ui/login_page.dart';
import 'package:firbase_auth/ui/signup_page.dart';
import 'package:flutter/material.dart';

class CustomNavigator {

  void navigateToSignup(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUpPage()));
  }

  void navigateToForgetPassword(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const ForgetPasswordPage()));
  }

  void navigateToHome(BuildContext context){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const HomePage()), (route) => false);
  }

  void navigateToLogin(BuildContext context){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const LoginPage()), (route) => false);
  }


}