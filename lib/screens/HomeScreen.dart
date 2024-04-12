import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final user = FirebaseAuth.instance.currentUser;
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "You are logged in as: ${user?.email}",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: signOut,
        child: Icon(Icons.logout),
      ),
    );
  }
}