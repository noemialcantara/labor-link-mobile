import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:labor_link_mobile/screens/LoginScreen.dart';
import 'package:labor_link_mobile/screens/MainNavigationHandler.dart';

class AuthRedirector extends StatelessWidget {
  const AuthRedirector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainNavigationHandler();
          } else {
            return LoginScreen(isApplicantFirstMode: true,);
          }
        },
      ),
    );
  }
}