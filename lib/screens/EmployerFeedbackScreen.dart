import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/CompanyApi.dart';
import 'package:labor_link_mobile/apis/FeedbackApis.dart';
import 'package:labor_link_mobile/apis/JobApplicationApi.dart';
import 'package:labor_link_mobile/apis/ResumeApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/models/Feedback.dart' as LLFeedback;
import 'dart:math' as math;

class EmployerFeedbackScreen extends StatefulWidget {
  late String jobId;
  late String? companyEmailAddress;
  EmployerFeedbackScreen(
      {Key? key, required this.jobId, required this.companyEmailAddress})
      : super(key: key);

  @override
  State<EmployerFeedbackScreen> createState() => _EmployerFeedbackScreenState();
}

class _EmployerFeedbackScreenState extends State<EmployerFeedbackScreen> {
  Options options = Options(format: Format.rgb, luminosity: Luminosity.dark);
  TextEditingController commentsTextEditingController = TextEditingController();
  String selectedRating = "";
  bool hasExistingData = false;

  @override
  void initState() {
    super.initState();
    fetchFeedbackDetails();
  }

  fetchFeedbackDetails() {
    FeedbacksApi.fetchFeedbackDetails(
            FirebaseAuth.instance.currentUser?.email ?? "",
            widget.companyEmailAddress.toString(),
            "applicant",
            widget.jobId.toString())
        .then((value) {
      setState(() {
        if (value.docs.length > 0) {
          selectedRating = value.docs.first.get("rating");
          commentsTextEditingController.text = value.docs.first.get("comments");
          hasExistingData = true;
        }
      });
    });
  }

  saveFeedback() {
    if (selectedRating == "") {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Alert!',
        desc: 'Please select a rating first',
        btnOkOnPress: () {},
      )..show();
    } else {
      LLFeedback.Feedback feedbackPayload = LLFeedback.Feedback(
          FirebaseAuth.instance.currentUser?.email ?? "",
          widget.companyEmailAddress.toString(),
          commentsTextEditingController.text,
          selectedRating,
          widget.jobId);
      if (hasExistingData) {
        FeedbacksApi.updateFeedback(feedbackPayload.toJson(), "applicant",
            FirebaseAuth.instance.currentUser?.email ?? "");
      } else {
        FeedbacksApi.addFeedback(feedbackPayload.toJson(), "applicant");
      }

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Alert!',
        desc:
            'You have successfully ${hasExistingData ? "updated" : "added"} a feedback!',
        btnOkOnPress: () {
          Navigator.pop(context);
        },
      )..show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              color: const Color.fromRGBO(255, 255, 255, 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.arrow_back, size: 30),
                          ),
                          Text("Feedback",
                              style: GoogleFonts.poppins(
                                  fontSize: 22, fontWeight: FontWeight.w600)),
                          Container()
                        ],
                      )),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Text(
                      "Rate Your Experience",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildRatingSmiley("Excellent",
                            "https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fexcellent_5.png?alt=media&token=3c9a9f21-6fe7-47a9-a2cc-17bbb23d02a1"),
                        _buildRatingSmiley("Good",
                            "https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fgood_4.png?alt=media&token=d7fa22a6-bc4c-41e8-9086-1930c9af93f3"),
                        _buildRatingSmiley("Medium",
                            "https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fmedium_3.png?alt=media&token=aa1f32ae-3540-4881-b30b-eb0cbe17a1d9"),
                        _buildRatingSmiley("Poor",
                            "https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fpoor_2.png?alt=media&token=6a24fcac-b746-41ea-939f-5fd640e4f500"),
                        _buildRatingSmiley("Very Bad",
                            "https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fverybad_1.png?alt=media&token=05ec229b-7af2-43d1-bec9-d1c393036c85"),
                      ],
                    ),
                  ),
                  SizedBox(height: 28),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              color: const Color.fromRGBO(255, 255, 255, 1),
              child: Column(
                children: [
                  Center(
                    child: Image.network(
                      "https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Ffeedback.png?alt=media&token=197da427-5c5b-4ae4-8a41-5bafecd98d97",
                      height: 270,
                      width: 270,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Additional Comments",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFF4F5F4),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          padding: EdgeInsets.all(20),
                          child: TextFormField(
                            controller: commentsTextEditingController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: "Write your comments here...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        CustomButton(
                          text:
                              "${hasExistingData ? "Update" : "Submit"} Feedback",
                          onTap: () {
                            saveFeedback();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSmiley(String label, String imageUrl) {
    double screenWidth = MediaQuery.of(context).size.width;
    double smileyWidth = screenWidth - screenWidth * 0.90;

    Color textColor = Colors.black;
    double fontSize = 14;

    if (label == "Excellent") {
      textColor = Color(0xFF40AC74);
      fontSize = 14;
    } else if (label == "Good") {
      textColor = Color(0xFF75C763);
      fontSize = 14;
    } else if (label == "Medium") {
      textColor = Color(0xFFEAA740);
      fontSize = 14;
    } else if (label == "Poor") {
      textColor = Color(0xFFEC5346);
      fontSize = 14;
    } else if (label == "Very Bad") {
      textColor = Color(0xFFED1F25);
      fontSize = 14;
    }

    return GestureDetector(
        onTap: () {
          setState(() {
            selectedRating = label;
          });
        },
        child: Container(
            padding: EdgeInsets.all(10),
            decoration: selectedRating == label
                ? BoxDecoration(border: Border.all(color: Color(0xff356899)))
                : BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(imageUrl, height: 50, width: smileyWidth),
                SizedBox(height: 4),
                Text(label,
                    style: TextStyle(fontSize: fontSize, color: textColor)),
              ],
            )));
  }
}
