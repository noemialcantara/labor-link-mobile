import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/CompanyApi.dart';
import 'package:labor_link_mobile/apis/JobApplicationApi.dart';
import 'package:labor_link_mobile/apis/ResumeApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/models/JobApplication.dart';
import 'package:labor_link_mobile/screens/AuthRedirector.dart';
import 'package:labor_link_mobile/screens/JobApplicationTrackingScreen.dart';
import 'package:labor_link_mobile/screens/MainNavigationHandler.dart';
import 'dart:math' as math;

class JobApplicationSuccessScreen extends StatefulWidget {
  final Job jobDetails;
  final String employerEmail;

  JobApplicationSuccessScreen(
      {Key? key, required this.jobDetails, required this.employerEmail})
      : super(key: key);

  @override
  State<JobApplicationSuccessScreen> createState() =>
      _JobApplicationSuccessScreenState();
}

class _JobApplicationSuccessScreenState
    extends State<JobApplicationSuccessScreen> {
  Options options = Options(format: Format.rgb, luminosity: Luminosity.dark);
  TextEditingController coverLetterTextEditingController =
      TextEditingController();
  String userEmail = "test@gmail.com";
  String selectedResume = "";
  String selectedResumeProfileName = "";
  List<bool> isResumeCheckedList = [];

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  void _getUserEmail() async {
    setState(() async {
      userEmail = FirebaseAuth.instance.currentUser!.email ?? "test@gmail.com";
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
          SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                SizedBox(width: 20),
                Image.network(widget.jobDetails.companyLogo,
                    height: 60, width: 60, alignment: Alignment.center),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: MediaQuery.sizeOf(context).width -
                            (MediaQuery.sizeOf(context).width * .70),
                        child: Text(
                          widget.jobDetails.jobName,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff0D0D26)),
                        )),
                    SizedBox(
                        width: MediaQuery.sizeOf(context).width -
                            (MediaQuery.sizeOf(context).width * .70),
                        child: Text(
                          widget.jobDetails.companyName,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 14.0, color: Color(0xff0D0D26)),
                        ))
                  ],
                )
              ],
            ),
            Padding(
                padding: EdgeInsets.only(right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                        width: MediaQuery.sizeOf(context).width -
                            (MediaQuery.sizeOf(context).width * .73),
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          text: TextSpan(
                              text: "₱",
                              style: TextStyle(
                                  fontSize: 15.0, color: Color(0xff0D0D26)),
                              children: [
                                TextSpan(
                                    text: widget.jobDetails.minimumSalary
                                            .toString()
                                            .replaceAllMapped(
                                                RegExp(
                                                    r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                (Match m) => '${m[1]},') +
                                        "/mo",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff0D0D26))),
                              ]),
                        )),
                    SizedBox(
                        width: MediaQuery.sizeOf(context).width -
                            (MediaQuery.sizeOf(context).width * .73),
                        child: Text(widget.jobDetails.jobCityLocation,
                            maxLines: 1,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontSize: 14.0, color: Color(0xff0D0D26)))),
                  ],
                ))
          ]),
          SizedBox(height: 10),
          Center(
              child: Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2FDone-rafiki%201%20(1).png?alt=media&token=f6f58e4a-e7d5-4013-8db3-b6552daca3e3",
                  height: 300,
                  width: 300)),
          Center(
              child: Text(
            "Job Application Successful!",
            style:
                GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.bold),
          )),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 15),
              child: Center(
                  child: Text(
                "You've successfully applied to ${widget.jobDetails.companyName} as ${widget.jobDetails.jobName}. You can see the job status from Application Tracking",
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.poppins(fontSize: 18, color: Color(0xff95969D)),
              ))),
          SizedBox(height: 30),
          Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: CustomButton(
                text: "Track Job",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => JobApplicationTrackingScreen(
                                companyLogo: widget.jobDetails.companyLogo,
                                jobName: widget.jobDetails.jobName,
                                minimumSalary:
                                    widget.jobDetails.minimumSalary.toString(),
                                companyName: widget.jobDetails.companyName,
                                jobCityLocation:
                                    widget.jobDetails.jobCityLocation,
                                status: "Reviewing",
                                companyEmail: widget.employerEmail,
                                jobId: widget.jobDetails.jobId,
                              )));
                },
              )),
          Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 30),
              child: GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AuthRedirector())),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xff356899))),
                  child: Center(
                    child: Text(
                      "Browse Jobs",
                      style: GoogleFonts.poppins(
                        color: Color(0xff356899),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              )),
        ])));
  }
}

class SampleData {
  String id;
  String title;

  SampleData({required this.id, required this.title});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
