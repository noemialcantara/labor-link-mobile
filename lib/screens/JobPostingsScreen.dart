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
import 'package:labor_link_mobile/apis/UsersApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/models/Resume.dart';
import 'package:labor_link_mobile/screens/JobApplicationTrackingScreen.dart';
import 'package:labor_link_mobile/screens/JobPostingManagementScreen.dart';
import 'package:labor_link_mobile/screens/MainNavigationHandler.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:random_avatar/random_avatar.dart';
import 'dart:math' show min;

class JobPostingsScreen extends StatefulWidget {
  final String userName;
  
  JobPostingsScreen({Key? key, required this.userName}) : super(key: key);

  @override
  State<JobPostingsScreen> createState() => _JobPostingsScreenState();
}

class _JobPostingsScreenState extends State<JobPostingsScreen> {
  TextEditingController profileJobEditingController  = TextEditingController();
  TextEditingController profileNameEditingController  = TextEditingController();
  final List<XFile> _certificationsList = [];
  String userEmail = "test@gmail.com";
  String companyName = "";

  bool _dragging = false;
  int jobPostingsCount = 0;

  Offset? offset;

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
            _getJobPostingsCount();
          });
        });
    });
  }

  _getJobPostingsCount(){
    JobApi.getJobPostingsCount(companyName).then((value) {
      int dataLength = value.docs.length;
      setState(() {
        jobPostingsCount = dataLength;
        
      });
    });
  }


  Widget fetchJobPostings() {
    return StreamBuilder(
          stream:  JobApi.getJobListByEmployer(companyName),
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
                               
                              },
                              child: Container(
                              margin: EdgeInsets.only(left:30,right:30,bottom:15),
                              padding: EdgeInsets.only(left: 10, right: 10,  top: 20),
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
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                      SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .70), child: Padding( padding: EdgeInsets.only(left:10),child: Text(snapshot.data?.docs[index].get("job_name"), maxLines: 1,softWrap: false, overflow:TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 16.0,fontWeight: FontWeight.w600, color: Color(0xff0D0D26)),))),
                                       SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .70), child: Padding( padding: EdgeInsets.only(left:10),child: Text("${snapshot.data?.docs[index].get("required_applicant_count")} applicants", maxLines: 1,softWrap: false, overflow:TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 14.0,fontWeight: FontWeight.w500, color: Color(0xff82828e)),))),
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
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                     Container(
                                        margin: EdgeInsets.only(left:10,bottom:10),
                                        decoration: BoxDecoration(
                                          color: snapshot.data?.docs[index].get("employment_type") == "Freelance" ? Color(0xfffcf5ed) : snapshot.data?.docs[index].get("employment_type") == "Full-time" ? Color(0xffe3edf9)  :  Color(0XFFdaffe3),
                                          border: Border.all(color: snapshot.data?.docs[index].get("employment_type") == "Freelance" ? Color(0xfffcf5ed) : snapshot.data?.docs[index].get("employment_type") == "Full-time" ? Color(0xffe3edf9)  :  Color(0XFFdaffe3)),
                                          borderRadius: BorderRadius.circular(20.0)
                                        ),
                                        child: SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width  * .73), child: Padding(
                                          padding: EdgeInsets.only(left: 5, right: 5, top:5, bottom: 5),
                                          child: Text(snapshot.data?.docs[index].get("employment_type"), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: snapshot.data?.docs[index].get("employment_type") == "Freelance" ? Color(0xffC86C38) : snapshot.data?.docs[index].get("employment_type") == "Full-time" ? Color(0xff5386E4)  : Color(0xff2BC155)))
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
                                          padding: EdgeInsets.only(left: 25, right: 25, top:20, bottom: 10),
                                          child: Text("8 hours shift", style: GoogleFonts.poppins(fontSize: 14.0,  color: Color(0xff0D0D26)))
                                        )
                                    ),
                                ],)
                                ]
                              )
                            )),
                    ) ;
        
              return Padding(padding: EdgeInsets.only(left:30, right: 30), child: Text("You have no job postings yet",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 18),));
             }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => JobPostingManagementScreen(companyName: companyName)));
        },
        backgroundColor: Color(0xff356899),
        child: const Icon(Icons.add, size: 30,),
      ),
      appBar: AppBar(
                toolbarHeight: 80,
                bottomOpacity: 0.0,
                elevation: 0.0,
                iconTheme: IconThemeData( color: Colors. black, ), title: Text("Job Postings", style: GoogleFonts.poppins(color:Color(0xff0D0D26), fontSize: 22,fontWeight: FontWeight.w600),),centerTitle: true,backgroundColor: Colors.transparent),
                  body: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height:30),
                          Padding(
                            padding: EdgeInsets.only(left:30,right:30),
                            child: Text('You have $jobPostingsCount Job Posting(s)',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 25, fontWeight: FontWeight.w600),),
                          ),
                          SizedBox(height: 30),
                          fetchJobPostings(),
                          SizedBox(height: 30),
                        ]
                      )
                  )
    );
  }
}
