import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:labor_link_mobile/screens/EmployerHomeDashboardScreen.dart';
import 'package:labor_link_mobile/screens/HomeDashboardScreen.dart';
import 'package:labor_link_mobile/screens/JobApplicantsListScreen.dart';
import 'package:labor_link_mobile/screens/MessagesScreen.dart';
import 'package:labor_link_mobile/screens/NotificationsScreen.dart';
import 'package:labor_link_mobile/screens/SavedJobsScreen.dart';
import 'package:labor_link_mobile/screens/UploadIDScreen.dart';


class EmployerNavigationScreen extends StatefulWidget {
  final int bottomNavIndex;

  EmployerNavigationScreen(this.bottomNavIndex) : super();

  @override
  _EmployerNavigationScreenState createState() => _EmployerNavigationScreenState();
}

class _EmployerNavigationScreenState extends State<EmployerNavigationScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void didUpdateWidget(EmployerNavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bottomNavIndex != widget.bottomNavIndex) {
      _startAnimation();
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    super.initState();
  }

  _startAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.bottomNavIndex == 1){
      return JobApplicantsListScreen();
    }else if(widget.bottomNavIndex == 2){
      return MessagesScreen();
    }else if(widget.bottomNavIndex == 3){
      return NotificationsScreen();
    }
    return EmployerHomeDashboardScreen();
  }
}