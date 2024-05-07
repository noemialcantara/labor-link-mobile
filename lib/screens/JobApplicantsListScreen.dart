import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labor_link_mobile/apis/JobApi.dart';
import 'package:labor_link_mobile/apis/JobApplicantsApi.dart';
import 'package:labor_link_mobile/apis/JobApplicationApi.dart';
import 'package:labor_link_mobile/apis/ResumeApi.dart';
import 'package:labor_link_mobile/apis/UsersApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/models/Resume.dart';
import 'package:labor_link_mobile/screens/EmployerApplicantProfileScreen.dart';
import 'package:labor_link_mobile/screens/JobApplicationTrackingScreen.dart';
import 'package:labor_link_mobile/screens/MainNavigationHandler.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:random_avatar/random_avatar.dart';
import 'dart:math' show min;

class JobApplicantsListScreen extends StatefulWidget {
  
  JobApplicantsListScreen({Key? key}) : super(key: key);

  @override
  State<JobApplicantsListScreen> createState() => _JobApplicantsListScreenState();
}

class _JobApplicantsListScreenState extends State<JobApplicantsListScreen> {
  TextEditingController profileJobEditingController  = TextEditingController();
  TextEditingController profileNameEditingController  = TextEditingController();
  final List<XFile> _certificationsList = [];
  String userEmail = "test@gmail.com";
  String companyName = "";

  bool _dragging = false;
  int applicantsCount = 0;

  Offset? offset;

  uploadResume(PlatformFile file, String profileJob, String profileName){
    ResumeApi.uploadResume(file, profileJob, profileName, userEmail);
  }

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  void _getUserEmail(){
    setState(() {
       userEmail =  FirebaseAuth.instance.currentUser!.email ?? "test@gmail.com";
       UsersApi.getCompanyNameByEmail(userEmail).then((value) {
          setState(() {
            companyName  = value.docs.first.get("employer_name");
            print("COMPANY NAME IS ${companyName}");
            _getApplicantsCount();
          });
        });
    });
  }

  _getApplicantsCount(){
    JobApplicantsApi.getApplicationCount(companyName).then((value) {
      int dataLength = value.docs.length;
      setState(() {
        applicantsCount = dataLength;
      });
    });
  }


  Widget fetchApplications() {
    return StreamBuilder(
          stream:  JobApplicantsApi.getJobApplicantsByCompany(companyName),
          builder: (context, snapshot) {
            var streamDataLength = snapshot.data?.docs.length ?? 0;

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.done: 
              if(streamDataLength > 0)
                return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (ctx, index) =>
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => EmployerApplicantProfileScreen(jobId: snapshot.data?.docs[index].get("job_id"), email: snapshot.data?.docs[index].get("applicant_email"), applicationStatus:  snapshot.data?.docs[index].get("status"), companyName: companyName
                                         )));
                              },
                              child: Container(
                              margin: EdgeInsets.only(left:30,right:30,bottom:15),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: Offset(0, 1),
                                    blurRadius: 3,
                                    spreadRadius: 2,
                                  )
                                ]
                              ),
                              child: 
                                Column(children: [
                                  SizedBox(height:10),
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 20),
                                     Image.network("https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fpngwing.com.png?alt=media&token=ab84abf3-f915-4422-a711-00314197b9ae", height: 60),
                                    //Image.network(snapshot.data?.docs[index].get("profile_logo_url"), height: 90, width: 90, alignment: Alignment.center),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                      SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .60), child: Text(snapshot.data?.docs[index].get("applicant_name"), maxLines: 1,softWrap: false, overflow:TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 18.0,fontWeight: FontWeight.w600, color: Color(0xff0D0D26)),)),
                                      SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .60), child: Text("Applying for "+snapshot.data?.docs[index].get("job_name"), overflow:TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 16.0, color: Color(0xff0D0D26)),))
                                    ],)
                                    ],),
                                ]),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                     Container(
                                        margin: EdgeInsets.only(left:20,bottom:20),
                                        decoration: BoxDecoration(
                                          color: snapshot.data?.docs[index].get("status") == "Rejected" ? Color(0xffFFEDED) : snapshot.data?.docs[index].get("status") == "Hired" ? Color(0xffE8FDF2)  :  Color(0xffEDF3FC),
                                          border: Border.all(color: Color(0xffEDF3FC)),
                                          borderRadius: BorderRadius.circular(20.0)
                                        ),
                                        child: SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width  * .60), child: Padding(
                                          padding: EdgeInsets.only(left: 25, right: 25, top:10, bottom: 10),
                                          child: Text(snapshot.data?.docs[index].get("status"), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w600, color: snapshot.data?.docs[index].get("status") == "Rejected" ? Color(0xffDC312D) : snapshot.data?.docs[index].get("status") == "Hired" ? Color(0xff0E9D57)  : Color(0xff5386E4)))
                                        ))
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(bottom:20),
                                        decoration: BoxDecoration(
                                          color: Color(0xffffffff),
                                          border: Border.all(color: Color(0xffffffff)),
                                          borderRadius: BorderRadius.circular(20.0)
                                        ),
                                        child: SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width  * .70), child: Padding(
                                          padding: EdgeInsets.only(left: 25, right: 25, top:10, bottom: 10),
                                          child: Text(snapshot.data?.docs[index].get("employment_type"), maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 16.0,  color: Color(0xff0D0D26))))
                                        )
                                    ),
                                ],)
                                ]
                              )
                            )),
                    ) ;
        
              return Padding(padding: EdgeInsets.only(left:30, right: 30), child: Text("You have no applicants yet",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 18),));
             }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height:50),
                          Padding(
                            padding: EdgeInsets.only(left:30,right:30),
                            child: Text('Applications',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 25, fontWeight: FontWeight.w600),),
                          ),
                          SizedBox(height:20),
                          Padding(
                            padding: EdgeInsets.only(left:30,right:30),
                            child: Text('You have $applicantsCount Applicant(s)',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 25, fontWeight: FontWeight.w600),),
                          ),
                          SizedBox(height: 30),
                          fetchApplications(),
                          SizedBox(height: 30),
                        ]
                      )
                  )
    );
  }
}
