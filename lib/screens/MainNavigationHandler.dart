// Importing necessary packages
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/FirebaseChatApi.dart';
import 'package:labor_link_mobile/apis/SubscribersApi.dart';
import 'package:labor_link_mobile/apis/UsersApi.dart';
import 'package:labor_link_mobile/models/ChatUser.dart';
import 'package:labor_link_mobile/models/Message.dart';
import 'package:labor_link_mobile/models/Subscriber.dart';
import 'package:labor_link_mobile/screens/ChatScreen.dart';
import 'package:labor_link_mobile/screens/EmployerIDVerificationScreen.dart';
import 'package:labor_link_mobile/screens/EmployerNavigationScreen.dart';
import 'package:labor_link_mobile/screens/EmployerProfileScreen.dart';
import 'package:labor_link_mobile/screens/EmployerSubscriptionManagementScreen.dart';
import 'package:labor_link_mobile/screens/EmployerSubscriptionScreen.dart';
import 'package:labor_link_mobile/screens/IDVerificationScreen.dart';
import 'package:labor_link_mobile/screens/JobApplicationsListScreen.dart';
import 'package:labor_link_mobile/screens/JobPostingsScreen.dart';
import 'package:labor_link_mobile/screens/MessagesScreen.dart';
import 'package:labor_link_mobile/screens/NavigationScreen.dart';
import 'package:labor_link_mobile/screens/ResumesCertificationsScreen.dart';
import 'package:labor_link_mobile/screens/UploadIDScreen.dart';
import 'package:labor_link_mobile/screens/UserProfileScreen.dart';
import 'package:random_avatar/random_avatar.dart';

// Main class for handling the main navigation
class MainNavigationHandler extends StatefulWidget {
  const MainNavigationHandler({Key? key}) : super(key: key);

  @override
  _MainNavigationHandlerState createState() => _MainNavigationHandlerState();
}

class _MainNavigationHandlerState extends State<MainNavigationHandler> with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;
  final autoSizeGroup = AutoSizeGroup();
  bool isAlreadySubscribed = false;
  var _bottomNavIndex = 0;
  String userName = "user";
  String userType = "";
  String fullName = "";
  String profession = 'No profession yet';
  String industry = "No industry yet";
  String logoUrl = "";
  Subscriber? subscriber;

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
    _fetchUserData();

    // Initializing animation controllers and curves
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

   

    // Delayed animation controllers
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
    // Disposing animation controllers and curves
    _hideBottomBarAnimationController.dispose();
    _fabAnimationController.dispose();
    _borderRadiusAnimationController.dispose();
    borderRadiusCurve.dispose();
    fabCurve.dispose();

    super.dispose();
  }

  _fetchUserData() async{
    userName =   await FirebaseChatApi.getCurrentUserData(FirebaseAuth.instance.currentUser!.email ?? "");
    userType =   await FirebaseChatApi.getCurrentUserType(FirebaseAuth.instance.currentUser!.email ?? "");

    if(userType != "Employer")
      UsersApi.getApplicantData(user?.email ?? "").then((QuerySnapshot querySnapshot) {
        if(querySnapshot.docs.length > 0){
          setState(() {
            fullName = querySnapshot.docs.first.get("full_name");
            profession =  querySnapshot.docs.first.get("job_role");
            logoUrl =  querySnapshot.docs.first.get("profile_url");
          });
        }
      });
    else 
      UsersApi.getCompanyNameByEmail(user?.email ?? "").then((QuerySnapshot querySnapshot) {
        if(querySnapshot.docs.length > 0){
          setState(() {
            fullName = querySnapshot.docs.first.get("employer_name");
            industry =  querySnapshot.docs.first.get("industry");
            logoUrl =  querySnapshot.docs.first.get("logo_url");
          });
        }
      });
     

      SubscribersApi.getUserPlan(user?.email ?? "").then((QuerySnapshot querySnapshot) {
        if(querySnapshot.docs.length > 0){
          if(querySnapshot.docs.first.get("is_cancelled") == "false" && DateTime.parse( querySnapshot.docs.first.get("premium_plan_ending_date")).isAfter(DateTime.now())){
             setState(() {
              isAlreadySubscribed = true;
              subscriber = Subscriber(
                querySnapshot.docs.first.get("duration"), 
                user?.email ?? "", 
                querySnapshot.docs.first.get("monthly_payment"),
                querySnapshot.docs.first.get("plan"), 
                querySnapshot.docs.first.get("premium_plan_starting_date"), 
                querySnapshot.docs.first.get("premium_plan_ending_date"), 
                querySnapshot.docs.first.get("is_cancelled"),
                querySnapshot.docs.first.get("id"),
                querySnapshot.docs.first.get("created_on"),
                );
            });
          }else{
             setState(() {
              isAlreadySubscribed = false;

             });
          }
        }else{
          setState(() {
              isAlreadySubscribed = false;

          });
        }
      });
  }

  // Scroll notification handler
  bool onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification && notification.metrics.axis == Axis.vertical) {
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

  // Sign out function
  void signOut() async {
    await FirebaseChatApi.updateActiveStatus(false);
    await FirebaseChatApi.auth.signOut();
  }

  Widget _drawer() {
    // _fetchUserData();
    return Drawer(
      backgroundColor: Colors.white,
        child: Column(
          children: [ 
            SizedBox(height:50),
            Image.network(logoUrl, height: 130),
            SizedBox(height:10),
            Text(fullName,textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff000000),fontSize: 25,fontWeight: FontWeight.w700),), 
            SizedBox(height:5),
            Text(profession == "" ? "No profession yet" : profession,textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D),fontSize: 16),), 
            SizedBox(height:10),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UserProfileScreen(email: FirebaseAuth.instance.currentUser!.email.toString()))),
              },
              child: Text('View Profile',textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff356899),fontSize: 18),), 
            ),
            SizedBox(height:40),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UserProfileScreen(email: FirebaseAuth.instance.currentUser!.email.toString(),))),
              },
              child: Padding(
              padding: EdgeInsets.only(left:50),
              child: Row(
              children: [
                Image.asset("assets/icons/personal_info_icon.png"),
                SizedBox(width: 20),
                Text('Personal Info', style: GoogleFonts.poppins(fontSize: 18)),
              ],
            ),
          ),
        ),
        SizedBox(height: 30),
        GestureDetector(
          onTap: () => {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => JobApplicationsListScreen(userName: userName),
            )),
          },
          child: Padding(
            padding: EdgeInsets.only(left: 50),
            child: Row(
              children: [
                Image.asset("assets/icons/applications_icon.png"),
                SizedBox(width: 20),
                Text('Applications', style: GoogleFonts.poppins(fontSize: 18)),
              ],
            ),
          ),
        ),
        SizedBox(height: 30),
        GestureDetector(
          onTap: () => {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ResumesCertificationsScreen(userName: userName),
            )),
          },
          child: Padding(
            padding: EdgeInsets.only(left: 50),
            child: Row(
              children: [
                Image.asset("assets/icons/resumes_certifications_icon.png"),
                SizedBox(width: 20),
                Expanded(
                  child: Text('Resumes & Certifications', style: GoogleFonts.poppins(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 30),
        GestureDetector(
          onTap: () => {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => IDVerificationScreen(),
            )),
          },
          child: Padding(
            padding: EdgeInsets.only(left: 50),
            child: Row(
              children: [
                Image.asset("assets/icons/id_verifications_icon.png"),
                SizedBox(width: 20),
                Text('ID Verifications', style: GoogleFonts.poppins(fontSize: 18)),
              ],
            ),
          ),
        ),
        SizedBox(height: 30),
         GestureDetector(
              onTap: () async  {
                await FirebaseChatApi.addChatUserWithFrom("admin@laborlink.site", FirebaseAuth.instance.currentUser?.email ?? "").then((value) {
                  FirebaseChatApi.sendFirstMessageCustom(value["from_id"],value["to_id"], "Hello $userName and welcome to LaborLink Chat Support!\nHow can I assist you today?\nWhether you have questions, feedback, or need troubleshooting assistance, I'm here to help.\nFeel free to let me know how I can make your experience with our app smoother! ", Type.text);
                  FirebaseChatApi.getUserDataByEmail("admin@laborlink.site").then((chatUser) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> 
                      ChatScreen(user: chatUser,
                    )));
                  });
                });
               
              },
              child:  Padding(
          padding: EdgeInsets.only(left: 50),
          child: Row(
            children: [
              Image.asset("assets/icons/chat_support_icon.png"),
              SizedBox(width: 20),
              Text('Chat Support', style: GoogleFonts.poppins(fontSize: 18)),
            ],
          ),
        )),
        SizedBox(height: 30),
        GestureDetector(
          onTap: signOut,
          child: Padding(
            padding: EdgeInsets.only(left: 50),
            child: Row(
              children: [
                Image.asset("assets/icons/logout_icon.png"),
                SizedBox(width: 20),
                Text(
                  'Logout',
                  style: GoogleFonts.poppins(fontSize: 18, color: Color(0xffE30000)),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
  }

  Widget _employerDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
        child: Column(
          children: [ 
            SizedBox(height:50),
            Image.network(logoUrl, height: 130),
            SizedBox(height:10),
            Text(userName,textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff000000),fontSize: 25,fontWeight: FontWeight.w700),), 
            SizedBox(height:5),
            Text(industry == "" ? 'No industry input yet': industry ,textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D),fontSize: 16),), 
            SizedBox(height:10),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EmployerProfileScreen(email: FirebaseAuth.instance.currentUser!.email.toString(),))),
              },
              child: Text('View Profile',textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff356899),fontSize: 18),), 
            ),
            SizedBox(height:40),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EmployerProfileScreen(email: FirebaseAuth.instance.currentUser!.email.toString(),))),
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
            GestureDetector(
              onTap: () async  {
                await FirebaseChatApi.addChatUserWithFrom("admin@laborlink.site", FirebaseAuth.instance.currentUser?.email ?? "").then((value) {
                  FirebaseChatApi.sendFirstMessageCustom(value["from_id"],value["to_id"], "Hello $userName and welcome to LaborLink Chat Support!\nHow can I assist you today?\nWhether you have questions, feedback, or need troubleshooting assistance, I'm here to help.\nFeel free to let me know how I can make your experience with our app smoother! ", Type.text);
                  FirebaseChatApi.getUserDataByEmail("admin@laborlink.site").then((chatUser) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> 
                      ChatScreen(user: chatUser,
                    )));
                  });
                });
               
              },
              child:  Padding(
                padding: EdgeInsets.only(left:50),
                child: Row(
                children: [
                Image.asset("assets/icons/chat_support_icon.png"),
                SizedBox(width: 20,),
                Text('Chat Support', style: GoogleFonts.poppins(fontSize: 18),)
              ],)),
            ),
            SizedBox(height:30),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                if(isAlreadySubscribed){  
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EmployerSubscriptionManagementScreen(subscriber:subscriber!)));
                }else{
                   Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EmployerSubscriptionScreen()));
                }
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EmployerIDVerificationScreen())),
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
      onDrawerChanged: (isOpened) async{
       await _fetchUserData();
      },
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
