import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/screens/MainNavigationHandler.dart';
import 'package:random_avatar/random_avatar.dart';

class UserProfileScreen extends StatefulWidget {
  final String userName;
  
  UserProfileScreen({Key? key, required this.userName}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height:30),
              Padding(
                padding: EdgeInsets.only(left:20, right: 20),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, size: 30,)),
                Text("Edit", style: GoogleFonts.poppins(fontSize: 20),)
              ],)),
              SizedBox(height: 40),
              Image.network("https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fpngwing.com.png?alt=media&token=ab84abf3-f915-4422-a711-00314197b9ae", height: 100),
              SizedBox(height:10),
              Text(widget.userName,textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff000000),fontSize: 25,fontWeight: FontWeight.w700),), 
              SizedBox(height:5),
              Text('No profession yet',textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D),fontSize: 16),), 
              SizedBox(height:10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text('Expected salary is ',textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D),fontSize: 16),),
                Text('₱',textAlign: TextAlign.center, style: TextStyle(color: Color(0xff95969D),fontSize: 16),),  
                Text('25,000 to ',textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D),fontSize: 16),), 
                Text('₱',textAlign: TextAlign.center, style: TextStyle(color: Color(0xff95969D),fontSize: 16),),  
                Text('30,000',textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D),fontSize: 16),),
              ]),
              SizedBox(height:30),
              Padding(
                padding: EdgeInsets.only(left:20,right:20),
                child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Text("25", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),),
                    Text("Experience", style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 16),)
                  ],),
                  Column(children: [
                    Text("4", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),),
                    Text("Skills", style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 16),)
                  ],),
                  Column(children: [
                    Text("0", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),),
                    Text("Certifications", style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 16),)
                  ],)
              ],)),
              SizedBox(height:30),
              Padding(
                padding: EdgeInsets.only(left:20,right:20),
                child: Row(children: [
                Text('Experiences',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 22, fontWeight: FontWeight.w600),),
                SizedBox(width: 10,),
                Image.asset("assets/icons/add_icon.png")
              ])),
              SizedBox(height:20),
              Container(
                margin: EdgeInsets.only(left: 20, right:20),
                padding: EdgeInsets.only(left: 10, right:10),
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0)
                ),
                child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                   Image.asset("assets/images/company1_icon.png"),
                   SizedBox(width:10),
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text("Electrician"),
                    Text("7-eleven")
                   ],)
                  ],),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text("Manila"),
                    Text("Dec 20 - Feb 21")
                  ],)
              ])),

              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left:20,right:20),
                child: Row(children: [
                Text('Skills',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 22, fontWeight: FontWeight.w600),),
                SizedBox(width: 10,),
                Image.asset("assets/icons/add_icon.png")
              ])),
              SizedBox(height:20),
              Container(
                margin: EdgeInsets.only(left: 20, right:20),
                padding: EdgeInsets.only(left: 10, right:10),
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0)
                ),
                child: 
              Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: Color(0xff356899),
                        border: Border.all(color: Color(0xff356899)),
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 25, right: 25, top:10, bottom: 10),
                        child: Text("Electrician", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white))
                      )
                  ),
                  SizedBox(width: 10,),
                  Container(
                      decoration: BoxDecoration(
                        color: Color(0xff356899),
                        border: Border.all(color: Color(0xff356899)),
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 25, right: 25, top:10, bottom: 10),
                        child: Text("Electrician", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white))
                      )
                  ),
                  
            
              ],)
              )
            ]
          )
      )
    );
  }
}
