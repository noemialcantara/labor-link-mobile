import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/FirebaseChatApi.dart';
import 'package:labor_link_mobile/screens/EmployerNavigationScreen.dart';
import 'package:labor_link_mobile/screens/IDVerificationScreen.dart';
import 'package:labor_link_mobile/screens/JobApplicationsListScreen.dart';
import 'package:labor_link_mobile/screens/JobPostingsScreen.dart';
import 'package:labor_link_mobile/screens/NavigationScreen.dart';
import 'package:labor_link_mobile/screens/ResumesCertificationsScreen.dart';
import 'package:labor_link_mobile/screens/UploadIDScreen.dart';
import 'package:labor_link_mobile/screens/UserProfileScreen.dart';
import 'package:random_avatar/random_avatar.dart';

class MainNavigationHandler extends StatefulWidget {
  const MainNavigationHandler({Key? key}) : super(key: key);

  @override
  _MainNavigationHandlerState createState() => _MainNavigationHandlerState();
}

class _MainNavigationHandlerState extends State<MainNavigationHandler> with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;
  final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0;
  String userName = "user";
  String userType = "";

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;

  final iconList = <IconData>[
    Icons.home,
    Icons.email,
    Icons.bookmark_sharp,
    Icons.dashboard,
  ];

  final employerIconList = <IconData>[
    Icons.home,
    Icons.edit_document,
    Icons.email,
    Icons.dashboard,
  ];

  @override
  void initState() {
    super.initState();

    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
    borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
      borderRadiusCurve,
    );

    _hideBottomBarAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

   _fetchUserData();
   
    Future.delayed(
      Duration(seconds: 1),
      () => _fabAnimationController.forward(),
    );
    Future.delayed(
      Duration(seconds: 1),
      () => _borderRadiusAnimationController.forward(),
    );
  }

  @override
  void dispose() {
    _hideBottomBarAnimationController.dispose();
    _fabAnimationController.dispose();
    _borderRadiusAnimationController.dispose();
    borderRadiusCurve.dispose();
    fabCurve.dispose();
    
    super.dispose();
  }

  void _fetchUserData() async{
    userName =   await FirebaseChatApi.getCurrentUserData(FirebaseAuth.instance.currentUser!.email ?? "");
    userType =   await FirebaseChatApi.getCurrentUserType(FirebaseAuth.instance.currentUser!.email ?? "");
    print("USER TYPE IS $userType");
    setState(() {});
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification &&
        notification.metrics.axis == Axis.vertical) {
      switch (notification.direction) {
        case ScrollDirection.forward:
          _hideBottomBarAnimationController.reverse();
          _fabAnimationController.forward(from: 0);
          break;
        case ScrollDirection.reverse:
          _hideBottomBarAnimationController.forward();
          _fabAnimationController.reverse(from: 1);
          break;
        case ScrollDirection.idle:
          break;
      }
    }
    return false;
  }

  void signOut() async{
    await FirebaseChatApi.updateActiveStatus(false);
    await FirebaseChatApi.auth.signOut();
  }

  Widget _drawer() {
    return Drawer(
      backgroundColor: Colors.white,
        child: Column(
          children: [ 
            SizedBox(height:50),
            RandomAvatar(userName , trBackground: true, height: 130, width: 130),
            SizedBox(height:10),
            Text(userName,textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff000000),fontSize: 25,fontWeight: FontWeight.w700),), 
            SizedBox(height:5),
            Text('No profession yet',textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D),fontSize: 16),), 
            SizedBox(height:10),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UserProfileScreen(userName: userName,))),
              },
              child: Text('View Profile',textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff356899),fontSize: 18),), 
            ),
            SizedBox(height:40),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UserProfileScreen(userName: userName,))),
              },
              child: Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
               Image.asset("assets/icons/personal_info_icon.png"),
               SizedBox(width: 20,),
               Text('Personal Info', style: GoogleFonts.poppins(fontSize: 18),), 

            ],))),
            SizedBox(height:30),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> JobApplicationsListScreen(userName: userName,))),
              },
              child:  Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
               Image.asset("assets/icons/applications_icon.png"),
               SizedBox(width: 20,),
               Text('Applications', style: GoogleFonts.poppins(fontSize: 18),), 

            ],))),
             SizedBox(height:30),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ResumesCertificationsScreen(userName: userName,))),
              },
              child:  Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
               Image.asset("assets/icons/resumes_certifications_icon.png"),
               SizedBox(width: 20,),
               Expanded(child: Text('Resumes & Certifications', style: GoogleFonts.poppins(fontSize: 18),)), 

            ],))),
            SizedBox(height:30),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> IDVerificationScreen())),
              },
              child: Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
               Image.asset("assets/icons/id_verifications_icon.png"),
               SizedBox(width: 20,),
               Text('ID Verifications', style: GoogleFonts.poppins(fontSize: 18),), 

            ],))),
            SizedBox(height:30),
            Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
               Image.asset("assets/icons/chat_support_icon.png"),
               SizedBox(width: 20,),
               Text('Chat Support', style: GoogleFonts.poppins(fontSize: 18),), 

            ],)),
             SizedBox(height:30),
            GestureDetector(
              onTap: signOut,
              child: Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
               Image.asset("assets/icons/logout_icon.png"),
               SizedBox(width: 20,),
               Text('Logout', style: GoogleFonts.poppins(fontSize: 18,color: Color(0xffE30000)),), 

            ],)))
          ], 
        ));
  }

  Widget _employerDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
        child: Column(
          children: [ 
            SizedBox(height:50),
            RandomAvatar(userName , trBackground: true, height: 130, width: 130),
            SizedBox(height:10),
            Text(userName,textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff000000),fontSize: 25,fontWeight: FontWeight.w700),), 
            SizedBox(height:5),
            Text('No industry input yet',textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D),fontSize: 16),), 
            SizedBox(height:10),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UserProfileScreen(userName: userName,))),
              },
              child: Text('View Profile',textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff356899),fontSize: 18),), 
            ),
            SizedBox(height:40),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UserProfileScreen(userName: userName,))),
              },
              child: Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
               Image.asset("assets/icons/personal_info_icon.png"),
               SizedBox(width: 20,),
               Text('Company Info', style: GoogleFonts.poppins(fontSize: 18),), 

            ],))),
            SizedBox(height:30),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> JobPostingsScreen(userName: userName,))),
              },
              child:  Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
               Image.asset("assets/icons/applications_icon.png"),
               SizedBox(width: 20,),
               Text('Job Posting', style: GoogleFonts.poppins(fontSize: 18),), 

            ],))),
            SizedBox(height:30),
            Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
               Image.asset("assets/icons/chat_support_icon.png"),
               SizedBox(width: 20,),
               Text('Chat Support', style: GoogleFonts.poppins(fontSize: 18),), 

            ],)),
             SizedBox(height:30),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ResumesCertificationsScreen(userName: userName,))),
              },
              child:  Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
               Image.asset("assets/icons/resumes_certifications_icon.png"),
               SizedBox(width: 20,),
               Expanded(child: Text('Subscription', style: GoogleFonts.poppins(fontSize: 18),)), 

            ],))),
            SizedBox(height:30),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> IDVerificationScreen())),
              },
              child: Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
               Image.asset("assets/icons/id_verifications_icon.png"),
               SizedBox(width: 20,),
               Text('ID Verifications', style: GoogleFonts.poppins(fontSize: 18),), 

            ],))),
            
             SizedBox(height:30),
            GestureDetector(
              onTap: signOut,
              child: Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
               Image.asset("assets/icons/logout_icon.png"),
               SizedBox(width: 20,),
               Text('Logout', style: GoogleFonts.poppins(fontSize: 18,color: Color(0xffE30000)),), 

            ],)))
          ], 
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: NotificationListener<ScrollNotification>(
        onNotification: onScrollNotification,
        child: userType == "Employer" ? EmployerNavigationScreen(_bottomNavIndex) : NavigationScreen(_bottomNavIndex)
      ),
      drawer: userType == "Employer" ? _employerDrawer() : _drawer(),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive
              ? Color(0xff356899)
              : Color(0xffCACBCE);
          return userType != "Employer" ? 
             Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconList[index],
                  size: 24,
                  color: color,
                ),
              ],
            ):  Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  employerIconList[index],
                  size: 24,
                  color: color,
                ),
              ],
            );
        },
        gapLocation: GapLocation.none,
        backgroundColor: Color(0xffffffff),
        activeIndex: _bottomNavIndex,
        splashColor: Color(0xff356899),
        notchAndCornersAnimation: borderRadiusAnimation,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.defaultEdge,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
