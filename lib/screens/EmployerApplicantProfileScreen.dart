import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/ExperiencesApi.dart';
import 'package:labor_link_mobile/apis/SkillsApi.dart';
import 'package:labor_link_mobile/apis/UsersApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/models/Applicant.dart';
import 'package:labor_link_mobile/screens/AddWorkExperienceScreen.dart';
import 'package:labor_link_mobile/screens/MainNavigationHandler.dart';
import 'package:labor_link_mobile/screens/UserProfileUpdateScreen.dart';
import 'package:random_avatar/random_avatar.dart';

class EmployerApplicantProfileScreen extends StatefulWidget {
  final String email;
  
  EmployerApplicantProfileScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<EmployerApplicantProfileScreen> createState() => _EmployerApplicantProfileScreenState();
}

class _EmployerApplicantProfileScreenState extends State<EmployerApplicantProfileScreen> {
  Applicant? applicant;

  TextEditingController skillController = TextEditingController();

  String skillCount = "0";

   @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchSkillsCount();
  }

  _fetchUserData() async{
    UsersApi.getApplicantData(widget.email).then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.length > 0){
        setState(() {
           applicant = Applicant(
            querySnapshot.docs.first.get("full_name"), 
            querySnapshot.docs.first.get("address"), 
            querySnapshot.docs.first.get("email_address"), 
            querySnapshot.docs.first.get("job_role"),
            querySnapshot.docs.first.get("profile_url"), 
            querySnapshot.docs.first.get("minimum_expected_salary"), 
            querySnapshot.docs.first.get("maximum_expected_salary"),
            querySnapshot.docs.first.get("years_of_experience")
          );
        });
      }
    });
  }

  _fetchSkillsCount() async{
    SkillsApi.getSkillsData(widget.email).then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.length > 0){
        setState(() {
          skillCount = querySnapshot.docs.length.toString();
        });
      }else{
        setState(() {
          skillCount = "0";
        });
      }
    });
  }

  _acceptApplicant(){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Alert!',
      desc: 'Successfully accepted this applicant!',
      btnOkOnPress: () {
      },
    )..show();
  }

  _rejectApplicant(){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Alert!',
      desc: 'Successfully rejected this applicant!',
      btnOkOnPress: () {
      },
    )..show();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
                 
              ],)),
              SizedBox(height: 40),
              Center(child: Image.network(applicant?.profileUrl ?? "https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fpngwing.com.png?alt=media&token=ab84abf3-f915-4422-a711-00314197b9ae", height: 100)),
              SizedBox(height:10),
              Center(child: Text(applicant?.fullName ?? "",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff000000),fontSize: 25,fontWeight: FontWeight.w700),)), 
              SizedBox(height:5),
              Center(child: Text(applicant?.jobRole == "" ? "There is no job role yet" : applicant?.jobRole ?? "",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D),fontSize: 16),)), 
              SizedBox(height:10),
              applicant?.minimumExpectedSalary != ""
              ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text('Expected salary is ',textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D),fontSize: 16),),
                Text('₱',textAlign: TextAlign.center, style: TextStyle(color: Color(0xff95969D),fontSize: 16),),  
                Text('${applicant?.minimumExpectedSalary ?? "" } to ',textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D),fontSize: 16),), 
                Text(' ₱',textAlign: TextAlign.center, style: TextStyle(color: Color(0xff95969D),fontSize: 16),),  
                Text('${applicant?.maximumExpectedSalary ?? ""}',textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D),fontSize: 16),),
              ]) : 
              Center(child: Text("There is no expected salary yet", style: GoogleFonts.poppins(color: Color(0xff95969D),fontSize: 16),),),
              SizedBox(height:30),
              Padding(
                padding: EdgeInsets.only(left:20,right:20),
                child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Text(applicant?.yearsOfExperience == "" ? '0' : applicant?.yearsOfExperience ?? "", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),),
                    Text("Experience", style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 16),)
                  ],),
                  Column(children: [
                    Text(skillCount, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),),
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
                
               
              ])),
              SizedBox(height:20),
              StreamBuilder(
                    stream:  ExperiencesApi.getExperiences(widget.email),
                    builder: (context, snapshot) {
                      var streamDataLength = snapshot.data?.docs.length ?? 0;

                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        case ConnectionState.active:
                        case ConnectionState.done: 
                        if(streamDataLength > 0)
                          return ListView.separated(
                                    shrinkWrap: true,
                                    separatorBuilder: (_, index) => SizedBox(
                                      height: 20,
                                    ),
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data?.docs.length ?? 0,
                                    itemBuilder: (ctx, index) =>
                                      GestureDetector(
                                        onTap: () {
                                           AwesomeDialog(
                                              context: context,
                                              animType: AnimType.scale,
                                              dialogType: DialogType.info,
                                              body: Center(child: Text(
                                                      'Are you sure you want to delete this experience?',
                                                      style: GoogleFonts.poppins(),
                                                    ),),
                                              title: 'Alert',
                                              btnOkText: "Yes",
                                              btnCancelOnPress: (){},
                                              btnOkOnPress: () {
                                                ExperiencesApi.deleteExperience(snapshot.data?.docs[index].get("id") );
                                              },
                                            )..show();
                                        },
                                        child: Container(
                                        margin: EdgeInsets.only(left: 20, right:20),
                                        padding: EdgeInsets.only(left: 10, right:10),
                                        height: 80,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(color: Colors.white),
                                                borderRadius: BorderRadius.circular(20.0)
                                        ),
                                        child: Padding(
                                        padding: EdgeInsets.only(left:10),
                                        child:  Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                          Row(
                                              children: [
                                            Image.network(snapshot.data?.docs[index].get("company_logo_url"), height: 40,),
                                            SizedBox(width:10),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                              SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * 0.65) ,child: Text(snapshot.data?.docs[index].get("job_position"), overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500))),
                                              SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * 0.65) ,child: Text(snapshot.data?.docs[index].get("company_name"), overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 16)))
                                            ],)
                                            ],
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(right:10),
                                              child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                              Text(snapshot.data?.docs[index].get("company_city_location"), style: GoogleFonts.poppins(fontSize: 16)),
                                              Text("${snapshot.data?.docs[index].get("year_started")} - ${snapshot.data?.docs[index].get("year_ended")}", style: GoogleFonts.poppins(fontSize: 16))
                                            ],)
                                          )
                                        ])
                                    )))
                        );
                        return Center(child: Padding(padding: EdgeInsets.only(left:30, right: 30), child: Text("You have no experiences yet",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 18),)));
                      }
              }),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left:20,right:20),
                child: Row(children: [
                Text('Skills',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 22, fontWeight: FontWeight.w600),),
                SizedBox(width: 10,),
                
              ])),
              SizedBox(height:20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                Container(
                  margin: EdgeInsets.only(left:20,right:20),
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0)
                ),
                child: StreamBuilder(
                    stream:  SkillsApi.getSkills(widget.email),
                    builder: (context, snapshot) {
                      var streamDataLength = snapshot.data?.docs.length ?? 0;

                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        case ConnectionState.active:
                        case ConnectionState.done: 
                        if(streamDataLength > 0)
                          return ListView.separated(
                                    shrinkWrap: true,
                                    separatorBuilder: (_, index) => SizedBox(
                                      width: 0,
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: streamDataLength,
                                    itemBuilder: (ctx, index) =>
                                        Container(
                                          margin: EdgeInsets.only(left:10,right:10, top:15, bottom:15),
                                          height: 47,
                                            decoration: BoxDecoration(
                                              color: Color(0xff356899),
                                              border: Border.all(color: Color.fromARGB(255, 190, 224, 255)),
                                              borderRadius: BorderRadius.circular(20.0)
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 25, right: 25, top:10, bottom: 10),
                                              child: 
                                              Row(children: [
                                                Text(snapshot.data?.docs[index].get("skill_name"), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white)),
                                               
                                              ])
                                            )
                                        ),
                          );
                        return Padding(padding: EdgeInsets.only(left:30, right: 30,top:25,bottom:25), child: Text("You have no skills yet",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 18),));
                      }
                }),
               
              ),
              SizedBox(height: 40,),
              Padding(
                padding: EdgeInsets.only(left:30, right:30),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Expanded(child: GestureDetector(
                  onTap: (){
                    _acceptApplicant();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10, top:15, bottom: 15),
                    decoration: BoxDecoration(
                      color: Color(0xff1EAF47),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "Accept Applicant",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )),
                SizedBox(width: 30,),
                Expanded(child: GestureDetector(
                  onTap: (){
                    _rejectApplicant();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10, top:15, bottom: 15),
                    decoration: BoxDecoration(
                      color: Color(0xffDF4F4F),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "Reject Applicant",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )),
              ],)),
              SizedBox(height: 60,)])
            ]
          )
      )
    );
  }
}
