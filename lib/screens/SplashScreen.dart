import 'dart:async';
import 'package:flutter/material.dart';
import 'package:labor_link_mobile/screens/AuthRedirector.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
        const Duration(seconds: 4),
        () => Navigator.push(
        context,
        fadeTransitionBuilder(child:  const AuthRedirector())
      ));
  }

  PageRouteBuilder fadeTransitionBuilder({required Widget child}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final _scale = animation.drive(Tween<double>(begin: 0, end: 1));

          return ScaleTransition(scale: _scale, child: child);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff356899),
                Color(0xff1A334C),
              ],
            )
          ),
          child: Center(
            child:  Image.asset("assets/icons/splash-icon.png",height: 250, width:250,),
          ),
        ),
      ),
    
    );
  }
}