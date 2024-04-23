// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:labor_link_mobile/screens/LoginScreen.dart';
import 'package:labor_link_mobile/screens/RegistrationScreen.dart';

class LoginOrRegistration extends StatefulWidget {
  const LoginOrRegistration({Key? key}) : super(key: key);

  @override
  State<LoginOrRegistration> createState() => _LoginOrRegistrationState();
}

class _LoginOrRegistrationState extends State<LoginOrRegistration> {
  bool showLoginPage = true;

  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreen(
        onTap: togglePage,
      );
    } else {
      return RegistrationScreen(
        onTap: togglePage,
      );
    }
  }
}