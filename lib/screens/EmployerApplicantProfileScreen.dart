import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/CertificationApi.dart';
import 'package:labor_link_mobile/apis/ExperiencesApi.dart';
import 'package:labor_link_mobile/apis/FeedbackApis.dart';
import 'package:labor_link_mobile/apis/JobApi.dart';
import 'package:labor_link_mobile/apis/JobApplicationApi.dart';
import 'package:labor_link_mobile/apis/ResumeApi.dart';
import 'package:labor_link_mobile/apis/SkillsApi.dart';
import 'package:labor_link_mobile/apis/UsersApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/helper/NotificationHelper.dart';
import 'package:labor_link_mobile/models/Applicant.dart';
import 'package:labor_link_mobile/screens/AddWorkExperienceScreen.dart';
import 'package:labor_link_mobile/screens/JobApplicantFeedbackScreen.dart';
import 'package:labor_link_mobile/screens/MainNavigationHandler.dart';
import 'package:labor_link_mobile/screens/UserProfileUpdateScreen.dart';
import 'package:labor_link_mobile/screens/widgets/PDFViewerScreen.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class EmployerApplicantProfileScreen extends StatefulWidget {
  final String email;
  final String jobId;
  final String applicationStatus;
  final String companyName;

  EmployerApplicantProfileScreen(
      {Key? key,
      required this.jobId,
      required this.email,
      required this.applicationStatus,
      required this.companyName})
      : super(key: key);

  @override
  State<EmployerApplicantProfileScreen> createState() =>
      _EmployerApplicantProfileScreenState();
}

class _EmployerApplicantProfileScreenState
    extends State<EmployerApplicantProfileScreen> {
  Applicant? applicant;

  TextEditingController skillController = TextEditingController();

  String skillCount = "0";
  String certificationCount = "0";
  String resumeLink = "";
  String resumeName = "";
  int requiredEmployeeCount = 0;

  @override
  void initState() {
    _fetchUserData();
    _fetchSkillsCount();
    _fetchCertificationsCount();
    _fetchResumeLink();
    _fetchJobDescription();
    super.initState();
  }

  _fetchUserData() async {
    UsersApi.getApplicantData(widget.email).then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        setState(() {
          applicant = Applicant(
              querySnapshot.docs.first.get("full_name"),
              querySnapshot.docs.first.get("address"),
              querySnapshot.docs.first.get("email_address"),
              querySnapshot.docs.first.get("job_role"),
              querySnapshot.docs.first.get("profile_url"),
              querySnapshot.docs.first.get("minimum_expected_salary"),
              querySnapshot.docs.first.get("maximum_expected_salary"),
              querySnapshot.docs.first.get("years_of_experience"));
        });
      }
    });
  }

  _fetchJobDescription() async {
    setState(() async {
      requiredEmployeeCount =
          await JobApi.getRequiredApplicantCountByJobId(widget.jobId ?? "");
      print("EMPLOYEE COUNT: $requiredEmployeeCount");
    });
  }

  _fetchSkillsCount() async {
    SkillsApi.getSkillsData(widget.email).then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        setState(() {
          skillCount = querySnapshot.docs.length.toString();
        });
      } else {
        setState(() {
          skillCount = "0";
        });
      }
    });
  }

  _fetchCertificationsCount() async {
    CertificationApi.getCertificationData(widget.email)
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        setState(() {
          certificationCount = querySnapshot.docs.length.toString();
        });
      } else {
        setState(() {
          certificationCount = "0";
        });
      }
    });
  }

  _fetchResumeLink() async {
    ResumeApi.getResumeByEmail(widget.email)
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        setState(() {
          resumeLink = querySnapshot.docs[0].get("link");
          resumeName = querySnapshot.docs[0].get("file_name");
        });
      } else {
        setState(() {
          resumeLink = "No available resume";
        });
      }
    });
  }

  _acceptApplicant() {
    if (widget.applicationStatus == "Reviewing") {
      JobApplicationApi.updateApplicantStatus(
          widget.jobId, applicant?.emailAddress ?? "", "Screening Interview");
      createNotification(applicant?.emailAddress ?? "", "New Activity",
          "Congratulations! ${widget.companyName} wants to take a screening interview with you.");
    } else if (widget.applicationStatus == "Screening Interview") {
      JobApplicationApi.updateApplicantStatus(
          widget.jobId, applicant?.emailAddress ?? "", "Technical Interview");
      createNotification(applicant?.emailAddress ?? "", "New Activity",
          "Congratulations! ${widget.companyName} wants to take a technical interview with you.");
    } else if (widget.applicationStatus == "Technical Interview") {
      JobApplicationApi.updateApplicantStatus(
          widget.jobId, applicant?.emailAddress ?? "", "Final Interview");
      createNotification(applicant?.emailAddress ?? "", "New Activity",
          "Congratulations! ${widget.companyName} wants to take a final interview with you.");
    } else if (widget.applicationStatus == "Final Interview") {
      JobApplicationApi.updateApplicantStatus(
          widget.jobId, applicant?.emailAddress ?? "", "Job Offer");
      createNotification(applicant?.emailAddress ?? "", "New Activity",
          "Congratulations! You passed all of the interviews and ${widget.companyName} will send you a job offer to your email within 2 to 3 days.");
    } else if (widget.applicationStatus == "Job Offer") {
      JobApplicationApi.updateApplicantStatus(
          widget.jobId, applicant?.emailAddress ?? "", "Hired");
      createNotification(applicant?.emailAddress ?? "", "New Activity",
          "Congratulations! You are now hired by the ${widget.companyName}!");
      checkOtherApplications();
    }

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Alert!',
      desc: 'Successfully accepted this applicant!',
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    )..show();
  }

  checkOtherApplications() {
    int numberOfHired = 1;
    var emailAddressListToOptOut = [];

    JobApplicationApi.getApplicationsByJobId(
            widget.jobId, applicant?.emailAddress ?? "")
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          if (querySnapshot.docs[i].get("status") == "Hired") {
            numberOfHired++;
          } else {
            print("GET APPLICANT EMAIL: " +
                querySnapshot.docs[i].get("applicant_email"));
            emailAddressListToOptOut
                .add(querySnapshot.docs[i].get("applicant_email"));
          }
        }

        if (requiredEmployeeCount == numberOfHired) {
          print("THIS FUCKING WORKS HERE MAN WHAT A JOB WELL DONE!");
          for (int j = 0; j < emailAddressListToOptOut.length; j++) {
            JobApplicationApi.updateApplicantStatus(
                widget.jobId, emailAddressListToOptOut[j], "Rejected");
            createNotification(
                emailAddressListToOptOut[j] ?? "",
                "New Activity",
                "The ${widget.companyName} has already proceeded with the other applicant who is the better fit for this job. Thank you for taking your time in applying to us!");
          }
        }
      }
    });
  }

  _rejectApplicant() {
    JobApplicationApi.updateApplicantStatus(
        widget.jobId, applicant?.emailAddress ?? "", "Rejected");
    createNotification(applicant?.emailAddress ?? "", "New Activity",
        "The ${widget.companyName} has already proceeded with the other applicant who is the better fit for this job. Thank you for taking your time in applying to us!");
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Alert!',
      desc: 'Successfully rejected this applicant!',
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    )..show();
  }

  _getApplicantFeedbacks() {
    return StreamBuilder(
        stream: FeedbacksApi.getApplicantFeedbackByEmployer(widget.email),
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
                                  stream: UsersApi.streamEmployerDataByEmail(
                                      snapshot.data?.docs[index]
                                          .get("employer_email_address")),
                                  builder: (context, employerSnapshot) {
                                    var streamDataLength =
                                        employerSnapshot.data?.docs.length ?? 0;

                                    switch (employerSnapshot.connectionState) {
                                      case ConnectionState.waiting:
                                      case ConnectionState.none:
                                      case ConnectionState.active:
                                      case ConnectionState.done:
                                        if (streamDataLength > 0)
                                          return Text(
                                            employerSnapshot.data?.docs[index]
                                                .get("employer_name"),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                          );
                                        return Text(
                                          snapshot.data?.docs[index]
                                              .get("employer_email_address"),
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
                  GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => JobApplicantFeedbackScreen(
                                  jobId: widget.jobId,
                                  applicantEmailAddress:
                                      applicant?.emailAddress))),
                      child: Image.asset("assets/icons/feedback-icon.png",
                          height: 40)),
                ],
              )),
          SizedBox(height: 40),
          Center(
              child: Image.network(
                  applicant?.profileUrl ??
                      "https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fpngwing.com.png?alt=media&token=ab84abf3-f915-4422-a711-00314197b9ae",
                  height: 100)),
          SizedBox(height: 10),
          Center(
              child: Text(
            applicant?.fullName ?? "",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: Color(0xff000000),
                fontSize: 25,
                fontWeight: FontWeight.w700),
          )),
          SizedBox(height: 5),
          Center(
              child: Text(
            applicant?.jobRole == ""
                ? "There is no job role yet"
                : applicant?.jobRole ?? "",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 16),
          )),
          SizedBox(height: 10),
          applicant?.minimumExpectedSalary != ""
              ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Expected salary is ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: Color(0xff95969D), fontSize: 16),
                  ),
                  Text(
                    '₱',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xff95969D), fontSize: 16),
                  ),
                  Text(
                    '${applicant?.minimumExpectedSalary ?? ""} to ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: Color(0xff95969D), fontSize: 16),
                  ),
                  Text(
                    ' ₱',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xff95969D), fontSize: 16),
                  ),
                  Text(
                    '${applicant?.maximumExpectedSalary ?? ""}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: Color(0xff95969D), fontSize: 16),
                  ),
                ])
              : Center(
                  child: Text(
                    "There is no expected salary yet",
                    style: GoogleFonts.poppins(
                        color: Color(0xff95969D), fontSize: 16),
                  ),
                ),
          SizedBox(height: 30),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        applicant?.yearsOfExperience == ""
                            ? '0'
                            : applicant?.yearsOfExperience ?? "",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      Text(
                        "Experience",
                        style: GoogleFonts.poppins(
                            color: Color(0xff95969D), fontSize: 16),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        skillCount,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      Text(
                        "Skills",
                        style: GoogleFonts.poppins(
                            color: Color(0xff95969D), fontSize: 16),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        certificationCount,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      Text(
                        "Certifications",
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
              child: Row(children: [
                Text(
                  'Experiences',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                      color: Color(0xff0D0D26),
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
              ])),
          SizedBox(height: 20),
          StreamBuilder(
              stream: ExperiencesApi.getExperiences(widget.email),
              builder: (context, snapshot) {
                var streamDataLength = snapshot.data?.docs.length ?? 0;

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (streamDataLength > 0)
                      return ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (_, index) => SizedBox(
                                height: 20,
                              ),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data?.docs.length ?? 0,
                          itemBuilder: (ctx, index) => Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              padding: EdgeInsets.only(left: 10, right: 10),
                              height: 80,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.network(
                                              snapshot.data?.docs[index]
                                                  .get("company_logo_url"),
                                              height: 40,
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width -
                                                        (MediaQuery.sizeOf(
                                                                    context)
                                                                .width *
                                                            0.65),
                                                    child: Text(
                                                        snapshot
                                                            .data?.docs[index]
                                                            .get(
                                                                "job_position"),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500))),
                                                SizedBox(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width -
                                                        (MediaQuery.sizeOf(
                                                                    context)
                                                                .width *
                                                            0.65),
                                                    child: Text(
                                                        snapshot
                                                            .data?.docs[index]
                                                            .get(
                                                                "company_name"),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 16)))
                                              ],
                                            )
                                          ],
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    snapshot.data?.docs[index].get(
                                                        "company_city_location"),
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 16)),
                                                Text(
                                                    "${snapshot.data?.docs[index].get("year_started")} - ${snapshot.data?.docs[index].get("year_ended")}",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 16))
                                              ],
                                            ))
                                      ]))));
                    return Center(
                        child: Padding(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: Text(
                              "You have no experiences yet",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  color: Color(0xff95969D), fontSize: 18),
                            )));
                }
              }),
          SizedBox(height: 30),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(children: [
                Text(
                  'Skills',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                      color: Color(0xff0D0D26),
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 10,
                ),
              ])),
          SizedBox(height: 20),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: StreamBuilder(
                      stream: SkillsApi.getSkills(widget.email),
                      builder: (context, snapshot) {
                        var streamDataLength = snapshot.data?.docs.length ?? 0;

                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                          case ConnectionState.active:
                          case ConnectionState.done:
                            if (streamDataLength > 0)
                              return ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder: (_, index) => SizedBox(
                                  width: 0,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: streamDataLength,
                                itemBuilder: (ctx, index) => Container(
                                    margin: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 15,
                                        bottom: 15),
                                    height: 47,
                                    decoration: BoxDecoration(
                                        color: Color(0xff356899),
                                        border: Border.all(
                                            color: Color.fromARGB(
                                                255, 190, 224, 255)),
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 25,
                                            right: 25,
                                            top: 10,
                                            bottom: 10),
                                        child: Row(children: [
                                          Text(
                                              snapshot.data?.docs[index]
                                                  .get("skill_name"),
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ]))),
                              );
                            return Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, top: 25, bottom: 25),
                                child: Text(
                                  "You have no skills yet",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      color: Color(0xff95969D), fontSize: 18),
                                ));
                        }
                      }),
                ),
                SizedBox(height: 30),
                Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(children: [
                      Text(
                        'Resume',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                            color: Color(0xff0D0D26),
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ),
                    ])),
                SizedBox(height: 30),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PDFViewerScreen(
                                    resumeLink: resumeLink,
                                  )));
                    },
                    child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(resumeName,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                                color: Color(0xff0D0D26),
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.underline)))),
                SizedBox(
                  height: 40,
                ),
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Column(children: [
                      widget.applicationStatus != "Hired" &&
                              widget.applicationStatus != "Rejected"
                          ? Padding(
                              padding: EdgeInsets.only(
                                  top: 20, bottom: 20, left: 20, right: 20),
                              child: Text(
                                  "The application process is now at ${widget.applicationStatus == "Reviewing" ? "HR Interview" : widget.applicationStatus}",
                                  style: GoogleFonts.poppins(
                                      color: Color(0xff0D0D26),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)))
                          : Padding(
                              padding: EdgeInsets.only(
                                  top: 20, bottom: 20, left: 20, right: 20),
                              child: Text(
                                  "This applicant ${widget.applicationStatus == "Rejected" ? "has been rejected" : "now hired"}!",
                                  style: GoogleFonts.poppins(
                                      color: Color(0xff0D0D26),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600))),
                      SizedBox(height: 20),
                      widget.applicationStatus != "Hired" &&
                              widget.applicationStatus != "Rejected"
                          ? Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () {
                                      _acceptApplicant();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 15,
                                          bottom: 15),
                                      decoration: BoxDecoration(
                                        color: Color(0xff1EAF47),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Accept",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () {
                                      _rejectApplicant();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 15,
                                          bottom: 15),
                                      decoration: BoxDecoration(
                                        color: Color(0xffDF4F4F),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Reject",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                                ],
                              ))
                          : Container(),
                      widget.applicationStatus != "Hired" &&
                              widget.applicationStatus != "Rejected"
                          ? SizedBox(
                              height: 20,
                            )
                          : Container(),
                    ])),
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
                _getApplicantFeedbacks(),
                SizedBox(
                  height: 60,
                )
              ])
        ])));
  }
}
