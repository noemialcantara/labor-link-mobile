import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/UsersApi.dart';
import 'package:labor_link_mobile/screens/FullCategoriesListScreen.dart';
import 'package:labor_link_mobile/screens/SearchListScreen.dart';
import 'package:labor_link_mobile/screens/UserProfileScreen.dart';
import 'package:labor_link_mobile/screens/widgets/JobCategoryList.dart';
import 'package:labor_link_mobile/screens/widgets/JobList.dart';
import 'package:labor_link_mobile/apis/FirebaseChatApi.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);

  @override
  _HomeDashboardScreenState createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  final user = FirebaseAuth.instance.currentUser;
  String fullName = "";
  TextEditingController searchJobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  _fetchUserData() async {
    UsersApi.getApplicantData(user?.email ?? "")
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        setState(() {
          fullName = querySnapshot.docs.first.get("full_name");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.menu,
                      size: 30,
                      color: Color(0xff356899),
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome $fullName",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Color(0xff95969D))),
                          SizedBox(height: 5),
                          Text("Discover Jobs",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold, fontSize: 25)),
                        ],
                      )),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserProfileScreen(
                                email: user!.email.toString(),
                              ))),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fpngwing.com.png?alt=media&token=ab84abf3-f915-4422-a711-00314197b9ae"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchListScreen(
                      searchKeyword: searchJobController.text))),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: Color(0xff000000),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      controller: searchJobController,
                      decoration: InputDecoration(
                        fillColor: Color(0xffF2F2F3),
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Search a job or position',
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 15.0, color: Color(0xff95969D)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffF2F2F3),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffF2F2F3),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        prefixIcon: Container(
                          padding: EdgeInsets.all(15.0),
                          child: Image.asset(
                            'assets/icons/search.png',
                            width: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    padding: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: Color(0xffF2F2F3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // child: Icon(Icons.filter_b_and_w_outlined,color: Colors.white,),
                    child: Image.asset('assets/icons/filter.png'),
                  )
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Categories",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 20)),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FullCategoriesListScreen()));
                    },
                    child: Text("See all",
                        style: GoogleFonts.poppins(
                            color: Color(0xff356899),
                            fontWeight: FontWeight.w500,
                            fontSize: 16))),
              ],
            ),
            JobCategoryList(),
            SizedBox(height: 20),
            Text("Recommended Jobs",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 20)),
            JobList(),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
