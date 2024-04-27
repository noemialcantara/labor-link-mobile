import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/screens/SearchListScreen.dart';
import 'package:labor_link_mobile/screens/widgets/JobCategoryList.dart';
import 'package:labor_link_mobile/screens/widgets/JobList.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);

  @override
  _HomeDashboardScreenState createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: 
      Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(height: 50),
        Text("Welcome ${user?.email}!", style: GoogleFonts.poppins(fontWeight: FontWeight.normal, color: Color(0xff95969D))),
        Text("Discover Jobs", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 25)),
        SizedBox(height:30),
        GestureDetector(
            onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchListScreen())),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorColor: Color(0xff000000),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      fillColor: Color(0xffF2F2F3),
                      filled: true,
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide.none),
                      hintText: 'Search a job or position',
                      hintStyle: GoogleFonts.poppins(fontSize: 15.0, color: Color(0xff95969D)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xffF2F2F3),
                            width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xffF2F2F3),
                            width: 2.0),
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
                SizedBox(width: 10,),
                Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(13),
                  decoration: BoxDecoration(
                      color: Color(0xffF2F2F3),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  // child: Icon(Icons.filter_b_and_w_outlined,color: Colors.white,),
                  child: Image.asset('assets/icons/filter.png'),
                )
              ],
            ),
        ),
        SizedBox(height: 20),
        Text("Categories", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20)),
        JobCategoryList(),
        SizedBox(height:20),
        Text("Recommended Jobs", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20)),
        JobList(),
        SizedBox(height:60),
      ],)));
    
  }
}
