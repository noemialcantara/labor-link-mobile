import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/FirebaseChatApi.dart';
import 'package:labor_link_mobile/screens/NavigationScreen.dart';

class MainNavigationHandler extends StatefulWidget {
  const MainNavigationHandler({Key? key}) : super(key: key);

  @override
  _MainNavigationHandlerState createState() => _MainNavigationHandlerState();
}

class _MainNavigationHandlerState extends State<MainNavigationHandler> with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;
  final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0;

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

  void signOut() {
    FirebaseChatApi.auth.signOut().then((value) async {
      FirebaseAuth.instance.signOut();
    });
  }

  Widget _drawer() {
    return Drawer(
      backgroundColor: Colors.white,
        child: ListView( 
          padding: EdgeInsets.zero, 
          children: [ 
            const DrawerHeader( 
              decoration: BoxDecoration( 
                color: Colors.white, 
              ), 
              child: Text( 
                '', 
                style: TextStyle(fontSize: 20), 
              ), 
            ), 
            ClipRRect(
                  borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).height * .25),
                  child: CachedNetworkImage(
                    width: 30,
                    height: 50,
                    fit: BoxFit.cover,
                    imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR__2IIAULCR-xberpmuxf-9Jx3cJZLJgLm4tSb9cDwRQ&s",
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
              
            Text('John Doe',textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff000000),fontSize: 25,fontWeight: FontWeight.w700),), 
            SizedBox(height:5),
            Text('Electrician',textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D),fontSize: 16),), 
            SizedBox(height:10),
            Text('View Profile',textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff356899),fontSize: 18),), 
            SizedBox(height:40),
            Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
               Icon(Icons.person),
               SizedBox(width: 20,),
               Text('Personal Info', style: GoogleFonts.poppins(fontSize: 18),), 

            ],)),
            SizedBox(height:30),
            Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
               Icon(Icons.person),
               SizedBox(width: 20,),
               Text('Applications', style: GoogleFonts.poppins(fontSize: 18),), 

            ],)),
             SizedBox(height:30),
            Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
               Icon(Icons.person),
               SizedBox(width: 20,),
               Expanded(child: Text('Resumes & Certifications', style: GoogleFonts.poppins(fontSize: 18),)), 

            ],)),
            SizedBox(height:30),
            Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
               Icon(Icons.person),
               SizedBox(width: 20,),
               Text('ID Verifications', style: GoogleFonts.poppins(fontSize: 18),), 

            ],)),
            SizedBox(height:30),
            Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
               Icon(Icons.person),
               SizedBox(width: 20,),
               Text('Chat Support', style: GoogleFonts.poppins(fontSize: 18),), 

            ],)),
             SizedBox(height:30),
            Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
               Icon(Icons.person),
               SizedBox(width: 20,),
               Text('Logout', style: GoogleFonts.poppins(fontSize: 18),), 

            ],)),
          ], 
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: NotificationListener<ScrollNotification>(
        onNotification: onScrollNotification,
        child: NavigationScreen(_bottomNavIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: signOut,
        child: Icon(Icons.logout),
      ),
      drawer: _drawer(),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive
              ? Color(0xff356899)
              : Color(0xffCACBCE);
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconList[index],
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
