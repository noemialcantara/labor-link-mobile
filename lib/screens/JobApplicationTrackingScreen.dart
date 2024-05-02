import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/constants/JobApplicationConstants.dart';
import 'dart:math' as math;

import 'package:labor_link_mobile/models/JobApplicationProcess.dart';

class JobApplicationTrackingScreen extends StatefulWidget {
  final String companyLogo;
  final String jobName;
  final String companyName;
  final String minimumSalary;
  final String jobCityLocation;
  final String status;
  JobApplicationTrackingScreen({Key? key, required this.companyLogo, required this.jobName, required this.minimumSalary, required this.companyName, required this.jobCityLocation, required this.status}) : super(key: key);

  @override
  State<JobApplicationTrackingScreen> createState() => _JobApplicationTrackingScreenState();
}

class _JobApplicationTrackingScreenState extends State<JobApplicationTrackingScreen> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                toolbarHeight: 80,
                bottomOpacity: 0.0,
                elevation: 0.0,
                iconTheme: IconThemeData( color: Colors. black, ), title: Text("Applied Job Details", style: GoogleFonts.poppins(color:Color(0xff0D0D26), fontSize: 22,fontWeight: FontWeight.w600),),centerTitle: true,backgroundColor: Colors.transparent),
                  
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height:10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                   Image.network(widget.companyLogo, height: 100, width: 100, alignment: Alignment.center),
                  
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .70), child: Text(widget.jobName, maxLines: 1,softWrap: false, overflow:TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 16.0,fontWeight: FontWeight.w600, color: Color(0xff0D0D26)),)),
                    SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .70), child: Text(widget.companyName, overflow:TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 14.0, color: Color(0xff0D0D26)),))
                   ],)
                  ],),
                  Padding(
                    padding: EdgeInsets.only(right:25),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                     mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                     SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .73), child: RichText(
                       overflow:TextOverflow.ellipsis,
                       maxLines: 1,
                          text: TextSpan( text: 
                                "₱", style: TextStyle(fontSize: 15.0, color: Color(0xff0D0D26)),
                                  children: [
                                    TextSpan(text:  widget.minimumSalary.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')+"/mo", style: GoogleFonts.poppins(fontSize: 14.0,
                                      fontWeight: FontWeight.w600, color: Color(0xff0D0D26))),
                                  ]
                          ),
                        )),
                    SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .73), child: Text(widget.jobCityLocation,maxLines: 1,textAlign: TextAlign.right,  overflow:TextOverflow.ellipsis,style: GoogleFonts.poppins(fontSize: 14.0,color: Color(0xff0D0D26)))),
                  ],))
              ]),
              SizedBox(height:10),
              
             TimelineComponent(status: widget.status)
             
            ]
          )
      )
    );
  }
}

class TimelineComponent extends StatelessWidget {
  TimelineComponent({Key? key, required this.status}) : super(key: key);

  final String status;

  final List<JobApplicationProcess> listOfEvents = [
    JobApplicationProcess(statusName: "Application Submitted", statusDescription: DateTime.now().toString()),
    JobApplicationProcess(statusName: "Reviewed By HR", statusDescription: "Not yet"),
    JobApplicationProcess(statusName: "Screening Interview", statusDescription: "Not yet"),
    JobApplicationProcess(statusName: "Technical Interview", statusDescription: "Not yet"),
    JobApplicationProcess(statusName: "Final Interview", statusDescription: "Not yet"),
    JobApplicationProcess(statusName: "Job Offer", statusDescription: "Not yet"),
  ];

  Widget getJobApplicationStatusDecoration(int index, String? status, String process){
    if(status == "Rejected"){
      if(index == 0){
        return Image.network("https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fteenyicons_tick-circle-solid.png?alt=media&token=c0989ce4-3dc5-425b-86fd-1af1019277c9", height: 30);
      }else{
        return Image.network("https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Frejected_icon-removebg-preview.png?alt=media&token=54c148a0-47db-461f-9365-d70eb6b81e3d", height: 30);
      }
    }

    if(status == "Reviewing" ){
       if(index < REVIEWING)
          return Image.network("https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fteenyicons_tick-circle-solid.png?alt=media&token=c0989ce4-3dc5-425b-86fd-1af1019277c9", height: 30);
       else if(index == REVIEWING)
          return Image.network("https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2FGroup%20232.png?alt=media&token=3d0e0b40-4bdf-446f-a6e8-c019b9f656e5", height: 30);
    }

    if(status == "Screening Interview" ){
       if(index < SCREENING)
          return Image.network("https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fteenyicons_tick-circle-solid.png?alt=media&token=c0989ce4-3dc5-425b-86fd-1af1019277c9", height: 30);
       else if(index == SCREENING)
          return Image.network("https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2FGroup%20232.png?alt=media&token=3d0e0b40-4bdf-446f-a6e8-c019b9f656e5", height: 30);
    }

    if(status == "Technical Interview" ){
       if(index < TECHNICAL)
          return Image.network("https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fteenyicons_tick-circle-solid.png?alt=media&token=c0989ce4-3dc5-425b-86fd-1af1019277c9", height: 30);
       else if(index == TECHNICAL)
          return Image.network("https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2FGroup%20232.png?alt=media&token=3d0e0b40-4bdf-446f-a6e8-c019b9f656e5", height: 30);
    }

    if(status == "Final Interview" ){
       if(index < FINAL)
          return Image.network("https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fteenyicons_tick-circle-solid.png?alt=media&token=c0989ce4-3dc5-425b-86fd-1af1019277c9", height: 30);
       else if(index == FINAL)
          return Image.network("https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2FGroup%20232.png?alt=media&token=3d0e0b40-4bdf-446f-a6e8-c019b9f656e5", height: 30);
    }

    if(status == "Job Offer" ){
       if(index < JOB_OFFER)
          return Image.network("https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fteenyicons_tick-circle-solid.png?alt=media&token=c0989ce4-3dc5-425b-86fd-1af1019277c9", height: 30);
       else if(index == JOB_OFFER)
          return Image.network("https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2FGroup%20232.png?alt=media&token=3d0e0b40-4bdf-446f-a6e8-c019b9f656e5", height: 30);
    }

    if(status == "Hired"){
      return Image.network("https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fteenyicons_tick-circle-solid.png?alt=media&token=c0989ce4-3dc5-425b-86fd-1af1019277c9", height: 30); 
    }

    return Image.network("https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2FEllipse%20787.png?alt=media&token=157f3257-312a-419a-80fa-353e0f457a2c", height: 30);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(left:30,right:30),
            child: Text('Track Application',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 20, fontWeight: FontWeight.w600),),
          ),
          SizedBox(height:30),
          ListView.builder(
                shrinkWrap: true,
                reverse: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: listOfEvents.length,
                itemBuilder: (context, i) {
                  return Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 48, bottom: 48, left:30, right: 30),
                        child: Row(
                          children: [
                            SizedBox(width: size.width * 0.15,),
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(listOfEvents[i].statusName, style: GoogleFonts.poppins(fontSize: 18, color: Colors.black),),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        left: 54,
                        child:  Container(
                          height: size.height * 0.7,
                          width: 1.0,
                          
                          color: Colors.grey.shade400,
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: getJobApplicationStatusDecoration(i, status,listOfEvents[i].statusDescription) 
                        ),
                      ),
                    ],
                  );
                }
          ),
          SizedBox(height:30),
        ],
      );
  }
}
