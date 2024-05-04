import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/CompanyApi.dart';
import 'package:labor_link_mobile/apis/JobApplicationApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/screens/JobApplicationScreen.dart';
import 'package:labor_link_mobile/screens/MainNavigationHandler.dart';
import 'package:random_avatar/random_avatar.dart';

class JobDetailsScreen extends StatefulWidget {
  final Job jobDetails;
  
  JobDetailsScreen({Key? key, required this.jobDetails}) : super(key: key);

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  bool isAlreadyApplied = false;
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyApplied();
  }

  _checkIfAlreadyApplied() async{
    userEmail =  FirebaseAuth.instance.currentUser!.email ?? "test@gmail.com";
    print("USER EMAIL IS ${userEmail}");
    JobApplicationApi.checkIfUserAlreadyApplied(widget.jobDetails.jobId, userEmail).then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.length > 0){
        setState(() {
            isAlreadyApplied = true;
        });
      }
    });
  }

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
                  child: Icon(Icons.arrow_back, size: 30,),
                  ),
              Icon(
                  Icons.bookmark_add_outlined,
                  color: Color(0xff000000),
                  size: 30,
               )
              ],)),
              Image.network(widget.jobDetails.companyLogo, height: 125, width: 125, alignment: Alignment.center),
              Text(widget.jobDetails.jobName,textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff000000),fontSize: 26,fontWeight: FontWeight.w700),), 
              SizedBox(height:5),
              Text(widget.jobDetails.companyName,textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D),fontSize: 18),), 
              SizedBox(height:25),
              Padding(
                padding: EdgeInsets.only(left:30,right:30),
                child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Container(
                      decoration: BoxDecoration(
                        color: Color(0xffE4E5E7),
                        border: Border.all(color: Color(0xffE4E5E7)),
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .75),child: Padding(
                        padding: EdgeInsets.only(left: 25, right: 25, top:10, bottom: 10),
                        child: Text(widget.jobDetails.jobCategories[0], maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 14.0, color: Color(0xff0D0D26))))
                      )
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Color(0xffE4E5E7),
                        border: Border.all(color: Color(0xffE4E5E7)),
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .75),child: Padding(
                        padding: EdgeInsets.only(left: 25, right: 25, top:10, bottom: 10),
                        child: Text(widget.jobDetails.employmentType, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 14.0, color: Color(0xff0D0D26))))
                      )
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Color(0xffE4E5E7),
                        border: Border.all(color: Color(0xffE4E5E7)),
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      child:SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .75),child:  Padding(
                        padding: EdgeInsets.only(left: 25, right: 25, top:10, bottom: 10),
                        child: Text(widget.jobDetails.jobLevels, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 14.0, color: Color(0xff0D0D26))))
                      )
                  ),
                  
              ],)),
              SizedBox(height:25),
              Padding(
                padding: EdgeInsets.only(left:30,right:30),
                child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan( text: 
                           "₱", style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold, color: Color(0xff0D0D26)),
                            children: [
                              TextSpan(text:  widget.jobDetails.minimumSalary.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')+"/month", style: GoogleFonts.poppins(fontSize: 17.0,
                                fontWeight: FontWeight.w600, color: Color(0xff0D0D26))),
                            ]
                    ),
                  ),
                  Text(widget.jobDetails.jobCityLocation, style: GoogleFonts.poppins(fontSize: 17.0,fontWeight:FontWeight.w600,color: Color(0xff0D0D26))),
                ])
              ),
              SizedBox(height:25),
              Container(
                height: MediaQuery.sizeOf(context).height - (MediaQuery.sizeOf(context).height * .60),
                child: DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar:  PreferredSize(
                      preferredSize: Size.fromHeight(70),
                      child:  Container(
                        color: Color(0xffFAFAFD),
                        child: SafeArea(
                          child: Column(
                            children: <Widget>[
                               SizedBox(height: 15,),
                               Expanded(child: TabBar(
                                indicatorColor: Color(0xffFAFAFD),
                                labelColor: Color(0xff000000),
                                unselectedLabelColor: Color(0xff95969D),
                                tabs: [
                                  Padding(padding: EdgeInsets.only(left:5,right: 5),  child: AutoSizeText("Description", style: GoogleFonts.poppins( fontSize: 15, fontWeight: FontWeight.w600))), 
                                  Padding(padding: EdgeInsets.only(left:5,right: 5),  child: AutoSizeText("Requirements",  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600))),
                                  Padding(padding: EdgeInsets.only(left:5,right: 5),  child: AutoSizeText("About",  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)))
                                ],
                              )),
                            ],
                          ),
                        ),
                      ),),
                    body: TabBarView(
                      children: [
                        SingleChildScrollView(child: Padding(
                          padding: EdgeInsets.only(left:25,right:25,top:15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.jobDetails.jobDescription , style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 15)),
                            SizedBox(height:30),
                            Text("Responsibilities" , style: GoogleFonts.poppins(color: Color(0xff494A50), fontSize: 15, fontWeight: FontWeight.w600)),
                            SizedBox(height:10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.jobDetails.jobResponsibilities.map((e) => Text("- "+e ,softWrap: true, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 15))).toList()
                            )
                          ],
                        ))),
                        SingleChildScrollView(child: Padding(
                          padding: EdgeInsets.only(left:25,right:25,top:15),
                          child:  Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.jobDetails.jobRequirements.map((e) => Text("- "+e ,softWrap: true, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 15))).toList()
                            ))),
                        SingleChildScrollView(child: Padding(
                          padding: EdgeInsets.only(left:25,right:25,top:15),
                          child:  Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder(
                                    stream: CompanyApi.getCompanyDetailsByName(widget.jobDetails.companyName),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                        case ConnectionState.none:
                                        case ConnectionState.active:
                                        case ConnectionState.done:
                                          
                                          return Text(snapshot.data?.docs[0]["employer_about"].toString() ?? "About Us",softWrap: true, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 15));
                                      }
                                    })
                              ]))),
                       
                      ],
                    ),
                  ),
                )),
              SizedBox(height:30),
              isAlreadyApplied ? 
               Padding(
                padding: EdgeInsets.only(left:10,right:10,bottom: 30),
                child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey)
                    ),
                    child: Center(
                      child: Text(
                        "You already applied to this job",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ): 
              Padding(
                padding: EdgeInsets.only(left:20,right:20,bottom: 30),
                child: CustomButton(
                text: "Apply Now",
                onTap: () => 
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => JobApplicationScreen(jobDetails: widget.jobDetails)))
                
              ))
              
            ]
          )
      )
    );
  }
}
