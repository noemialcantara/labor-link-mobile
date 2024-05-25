import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labor_link_mobile/apis/JobApi.dart';
import 'package:labor_link_mobile/apis/JobApplicationApi.dart';
import 'package:labor_link_mobile/apis/JobCategoryApi.dart';
import 'package:labor_link_mobile/apis/ResumeApi.dart';
import 'package:labor_link_mobile/apis/UsersApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/components/CustomTextField.dart';
import 'package:labor_link_mobile/constants/JobLevelsConstants.dart';
import 'package:labor_link_mobile/constants/JobScheduleConstants.dart';
import 'package:labor_link_mobile/constants/JobTypeConstants.dart';
import 'package:labor_link_mobile/models/Applicant.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/models/Resume.dart';
import 'package:labor_link_mobile/screens/MainNavigationHandler.dart';
import 'package:labor_link_mobile/screens/widgets/DynamicTextField.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:random_avatar/random_avatar.dart';
import 'dart:math' show min;
import 'package:uuid/uuid.dart';

class UserProfileUpdateScreen extends StatefulWidget {
  final Applicant? applicantData;
  UserProfileUpdateScreen({Key? key, required this.applicantData})
      : super(key: key);

  @override
  State<UserProfileUpdateScreen> createState() =>
      _UserProfileUpdateScreenState();
}

class _UserProfileUpdateScreenState extends State<UserProfileUpdateScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController jobPositionController = TextEditingController();
  TextEditingController minimumExpectedSalary = TextEditingController();
  TextEditingController maximumExpectedSalary = TextEditingController();
  TextEditingController yearsOfExperienceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getProfileData();
  }

  _getProfileData() {
    setState(() {
      fullNameController.text = widget.applicantData!.fullName.toString();
      addressController.text = widget.applicantData!.address.toString();
      jobPositionController.text = widget.applicantData!.jobRole.toString();
      minimumExpectedSalary.text =
          widget.applicantData!.minimumExpectedSalary.toString();
      maximumExpectedSalary.text =
          widget.applicantData!.maximumExpectedSalary.toString();
      yearsOfExperienceController.text =
          widget.applicantData!.yearsOfExperience.toString();
    });
  }

  void updateProfile() {
    Applicant applicantPayload = Applicant(
        fullNameController.text,
        addressController.text,
        widget.applicantData!.emailAddress,
        jobPositionController.text,
        widget.applicantData!.profileUrl,
        minimumExpectedSalary.text,
        maximumExpectedSalary.text,
        yearsOfExperienceController.text);

    UsersApi.updateUserProfile(applicantPayload.toJson());
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Alert!',
      desc: 'Successfully updated your profile',
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 80,
            bottomOpacity: 0.0,
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            title: Text(
              "Update User Profile",
              style: GoogleFonts.poppins(
                  color: Color(0xff0D0D26),
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Text(
                      'Full Name',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                          color: Color(0xff0D0D26),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: fullNameController,
                      hintText: 'Enter full name',
                      obscureText: false,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Address',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                          color: Color(0xff0D0D26),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                        controller: addressController,
                        hintText: 'Enter complete address',
                        obscureText: false),
                    SizedBox(height: 20),
                    Text(
                      'Job Position',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                          color: Color(0xff0D0D26),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                        controller: jobPositionController,
                        hintText: 'Enter job position',
                        obscureText: false),
                    SizedBox(height: 20),
                    Text(
                      'Minimum Expected Salary',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                          color: Color(0xff0D0D26),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: minimumExpectedSalary,
                      hintText: 'Enter minimum expected salary per month',
                      obscureText: false,
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textInputType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Maximum Expected Salary',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                          color: Color(0xff0D0D26),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: maximumExpectedSalary,
                      hintText: 'Enter maximum expected salary per month',
                      obscureText: false,
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textInputType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Years of Experience',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                          color: Color(0xff0D0D26),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: yearsOfExperienceController,
                      hintText: 'Enter years of experience',
                      obscureText: false,
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: 30),
                    CustomButton(
                      text: "Update",
                      onTap: () {
                        updateProfile();
                      },
                    ),
                    SizedBox(height: 50),
                  ])),
        ));
  }
}
