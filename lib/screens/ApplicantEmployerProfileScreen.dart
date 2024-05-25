import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/ExperiencesApi.dart';
import 'package:labor_link_mobile/apis/FeedbackApis.dart';
import 'package:labor_link_mobile/apis/JobApplicationApi.dart';
import 'package:labor_link_mobile/apis/SkillsApi.dart';
import 'package:labor_link_mobile/apis/UsersApi.dart';
import 'package:labor_link_mobile/models/Applicant.dart';
import 'package:labor_link_mobile/models/Employer.dart';
import 'package:labor_link_mobile/screens/AddWorkExperienceScreen.dart';
import 'package:labor_link_mobile/screens/EmployerProfileUpdateScreen.dart';
import 'package:labor_link_mobile/screens/MainNavigationHandler.dart';
import 'package:labor_link_mobile/screens/UserProfileUpdateScreen.dart';
import 'package:random_avatar/random_avatar.dart';

class ApplicantEmployerProfileScreen extends StatefulWidget {
  final String email;

  ApplicantEmployerProfileScreen({Key? key, required this.email})
      : super(key: key);

  @override
  State<ApplicantEmployerProfileScreen> createState() =>
      _ApplicantEmployerProfileScreenState();
}

class _ApplicantEmployerProfileScreenState
    extends State<ApplicantEmployerProfileScreen> {
  Employer? employer;

  TextEditingController skillController = TextEditingController();

  String jobPostingCount = "0";
  String hiredCount = "0";
  String rejectedCount = "0";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  _fetchUserData() async {
    print("FETCH SHIT ${widget.email}");
    UsersApi.getCompanyNameByEmail(widget.email)
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        setState(() {
          employer = Employer(
              querySnapshot.docs.first.get("employer_name"),
              querySnapshot.docs.first.get("employer_address"),
              querySnapshot.docs.first.get("email_address"),
              querySnapshot.docs.first.get("employer_about"),
              querySnapshot.docs.first.get("logo_url"),
              querySnapshot.docs.first.get("industry"),
              querySnapshot.docs.first.get("owner"),
              querySnapshot.docs.first.get("year_founded"),
              querySnapshot.docs.first.get("company_size"),
              querySnapshot.docs.first.get("phone"));

          _fetchJobPostings();
          _fetchStatistics(employer!.employerName.toString());
        });
      }
    });
  }

  _fetchJobPostings() async {
    SkillsApi.getSkillsData(widget.email).then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        setState(() {
          jobPostingCount = querySnapshot.docs.length.toString();
        });
      } else {
        setState(() {
          jobPostingCount = "0";
        });
      }
    });
  }

  _fetchStatistics(String companyName) async {
    JobApplicationApi.getHiredCountByCompanyName(companyName)
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        setState(() {
          hiredCount = querySnapshot.docs.length.toString();
        });
      } else {
        setState(() {
          hiredCount = "0";
        });
      }
    });

    JobApplicationApi.getRejectedCountByCompanyName(companyName)
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        setState(() {
          rejectedCount = querySnapshot.docs.length.toString();
        });
      } else {
        setState(() {
          rejectedCount = "0";
        });
      }
    });
  }

  _getEmployerFeedbacks() {
    return StreamBuilder(
        stream: FeedbacksApi.getEmployerFeedbackByApplicant(widget.email),
        builder: (context, snapshot) {
          var streamDataLength = snapshot.data?.docs.length ?? 0;

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.done:
              if (streamDataLength > 0)
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (ctx, index) => Container(
                    margin: EdgeInsets.only(left: 30, right: 30, bottom: 15),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            spreadRadius: 2,
                          )
                        ]),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder(
                                  stream: UsersApi.streamApplicantDataByEmail(
                                      snapshot.data?.docs[index]
                                          .get("applicant_email_address")),
                                  builder: (context, applicantSnapshot) {
                                    var streamDataLength =
                                        applicantSnapshot.data?.docs.length ??
                                            0;

                                    switch (applicantSnapshot.connectionState) {
                                      case ConnectionState.waiting:
                                      case ConnectionState.none:
                                      case ConnectionState.active:
                                      case ConnectionState.done:
                                        if (streamDataLength > 0)
                                          return Text(
                                            applicantSnapshot.data?.docs[index]
                                                .get("full_name"),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                          );
                                        return Text(
                                          snapshot.data?.docs[index]
                                              .get("applicant_email_address"),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700),
                                        );
                                    }
                                  }),
                              SizedBox(height: 10),
                              Row(children: [
                                Text(
                                  "Rating:",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "${snapshot.data?.docs[index].get("rating")}",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ]),
                              SizedBox(height: 10),
                              Text(
                                "Comments:",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "${snapshot.data?.docs[index].get("comments")}",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                );

              return Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    "There are no ratings and comments yet to this applicant",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: Color(0xff95969D), fontSize: 16),
                  ));
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
          SizedBox(height: 30),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        size: 30,
                      )),
                ],
              )),
          SizedBox(height: 40),
          Center(
              child: Image.network(
                  employer?.logoUrl ??
                      "https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/company_images%2Fdefault-company-avatar-removebg-preview.png?alt=media&token=a3649b8b-5034-406c-95b0-2d289e558be2",
                  height: 100)),
          SizedBox(height: 10),
          Center(
              child: Text(
            employer?.employerName ?? "",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: Color(0xff000000),
                fontSize: 25,
                fontWeight: FontWeight.w700),
          )),
          SizedBox(height: 5),
          Center(
              child: Text(
            employer?.industry == ""
                ? "There is no industry data yet"
                : employer?.industry ?? "",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 16),
          )),
          SizedBox(height: 30),
          Padding(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        employer?.companySize == ""
                            ? '0'
                            : employer?.companySize ?? "",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      Text(
                        "No. of Employees",
                        style: GoogleFonts.poppins(
                            color: Color(0xff95969D), fontSize: 16),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        hiredCount,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      Text(
                        "Hired",
                        style: GoogleFonts.poppins(
                            color: Color(0xff95969D), fontSize: 16),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        rejectedCount,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      Text(
                        "Rejected",
                        style: GoogleFonts.poppins(
                            color: Color(0xff95969D), fontSize: 16),
                      )
                    ],
                  )
                ],
              )),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              'Description',
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                  color: Color(0xff0D0D26),
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 15),
          Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              padding: EdgeInsets.only(left: 10, right: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                  child: Text(
                    employer?.employerAbout == ""
                        ? "No data yet"
                        : employer?.employerAbout ?? "",
                    style: GoogleFonts.poppins(),
                  ))),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              'Contact Information',
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                  color: Color(0xff0D0D26),
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 15),
          Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              padding: EdgeInsets.only(left: 10, right: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email: ${employer?.emailAddress}",
                        style: GoogleFonts.poppins(),
                      ),
                      Text(
                        "Phone: ${employer?.phone == "" ? "No data yet" : employer?.phone}",
                        style: GoogleFonts.poppins(),
                      ),
                      Text(
                        "Address: ${employer?.employerAddress == "" ? "No data yet" : employer?.employerAddress}",
                        style: GoogleFonts.poppins(),
                      )
                    ],
                  ))),
          SizedBox(height: 30),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(children: [
                Text(
                  'Ratings & Reviews',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                      color: Color(0xff0D0D26),
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
              ])),
          SizedBox(height: 30),
          _getEmployerFeedbacks(),
          SizedBox(height: 60),
        ])));
  }
}
