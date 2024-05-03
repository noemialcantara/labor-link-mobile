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
import 'package:labor_link_mobile/apis/JobApplicationApi.dart';
import 'package:labor_link_mobile/apis/ResumeApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/models/Resume.dart';
import 'package:labor_link_mobile/screens/JobApplicationTrackingScreen.dart';
import 'package:labor_link_mobile/screens/MainNavigationHandler.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:random_avatar/random_avatar.dart';
import 'dart:math' show min;

class JobApplicationsListScreen extends StatefulWidget {
  final String userName;
  
  JobApplicationsListScreen({Key? key, required this.userName}) : super(key: key);

  @override
  State<JobApplicationsListScreen> createState() => _JobApplicationsListScreenState();
}

class _JobApplicationsListScreenState extends State<JobApplicationsListScreen> {
  TextEditingController profileJobEditingController  = TextEditingController();
  TextEditingController profileNameEditingController  = TextEditingController();
  final List<XFile> _certificationsList = [];
  String userEmail = "test@gmail.com";

  bool _dragging = false;
  int applicationCount = 0;

  Offset? offset;

  uploadResume(PlatformFile file, String profileJob, String profileName){
    ResumeApi.uploadResume(file, profileJob, profileName, userEmail);
  }

  @override
  void initState() {
    super.initState();
    _getUserEmail();
    _getApplicationCount();
  }

  void _getUserEmail(){
    setState(() {
       userEmail =  FirebaseAuth.instance.currentUser!.email ?? "test@gmail.com";
    });
  }

  _getApplicationCount(){
    JobApplicationApi.getApplicationCount(userEmail).then((value) {
      int dataLength = value.docs.length;
      setState(() {
        applicationCount = dataLength;
      });
    });
  }


  Widget fetchApplications() {
    return StreamBuilder(
          stream:  JobApplicationApi.getJobDetailsByApplicantId(userEmail),
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
                                        builder: (_) => JobApplicationTrackingScreen(
                                          companyLogo:snapshot.data?.docs[index].get("company_logo_url"),
                                          jobCityLocation: snapshot.data?.docs[index].get("job_city_location"),
                                          companyName: snapshot.data?.docs[index].get("company_name"),
                                          jobName: snapshot.data?.docs[index].get("job_name"),
                                          minimumSalary: snapshot.data?.docs[index].get("min_salary"),
                                          status: snapshot.data?.docs[index].get("status"))));
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                      SizedBox(width: 10,),
                                    Image.network(snapshot.data?.docs[index].get("company_logo_url") ?? "", height: 55, width: 55, alignment: Alignment.center),
                                    SizedBox(width:10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                      SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .70), child: Text(snapshot.data?.docs[index].get("job_name"), maxLines: 1,softWrap: false, overflow:TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 16.0,fontWeight: FontWeight.w600, color: Color(0xff0D0D26)),)),
                                      SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .70), child: Text(snapshot.data?.docs[index].get("company_name"), overflow:TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 14.0, color: Color(0xff0D0D26)),))
                                    ],)
                                    ],),
                                    Padding(
                                      padding: EdgeInsets.only(right:25),
                                      child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                      SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .75), child: RichText(
                                        overflow:TextOverflow.ellipsis,
                                        maxLines: 1,
                                            text: TextSpan( text: 
                                                  "₱", style: TextStyle(fontSize: 15.0, color: Color(0xff0D0D26)),
                                                    children: [
                                                      TextSpan(text:  '${snapshot.data?.docs[index].get("min_salary").toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} /mo', style: GoogleFonts.poppins(fontSize: 14.0,
                                                        fontWeight: FontWeight.w600, color: Color(0xff0D0D26))),
                                                    ]
                                            ),
                                          )),
                                      SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .75), child: Text(snapshot.data?.docs[index].get("job_city_location"),maxLines: 1,textAlign: TextAlign.right,  overflow:TextOverflow.ellipsis,style: GoogleFonts.poppins(fontSize: 14.0,color: Color(0xff0D0D26)))),
                                    ],))
                                ]),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                     Container(
                                        margin: EdgeInsets.only(left:20,bottom:10),
                                        decoration: BoxDecoration(
                                          color: snapshot.data?.docs[index].get("status") == "Rejected" ? Color(0xffFFEDED) : snapshot.data?.docs[index].get("status") == "Hired" ? Color(0xffE8FDF2)  :  Color(0xffEDF3FC),
                                          border: Border.all(color: Color(0xffEDF3FC)),
                                          borderRadius: BorderRadius.circular(20.0)
                                        ),
                                        child: SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width  * .60), child: Padding(
                                          padding: EdgeInsets.only(left: 7, right: 7, top:7, bottom: 7),
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
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 25, right: 25, top:10, bottom: 10),
                                          child: Text(snapshot.data?.docs[index].get("employment_type"), style: GoogleFonts.poppins(fontSize: 16.0,  color: Color(0xff0D0D26)))
                                        )
                                    ),
                                ],)
                                ]
                              )
                            )),
                    ) ;
        
              return Padding(padding: EdgeInsets.only(left:30, right: 30), child: Text("You have no application yet",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 18),));
             }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                toolbarHeight: 80,
                bottomOpacity: 0.0,
                elevation: 0.0,
                iconTheme: IconThemeData( color: Colors. black, ), title: Text("Applications", style: GoogleFonts.poppins(color:Color(0xff0D0D26), fontSize: 22,fontWeight: FontWeight.w600),),centerTitle: true,backgroundColor: Colors.transparent),
                  body: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height:30),
                          Padding(
                            padding: EdgeInsets.only(left:30,right:30),
                            child: Text('You have $applicationCount Application(s)',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 25, fontWeight: FontWeight.w600),),
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
