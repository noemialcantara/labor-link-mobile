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
import 'package:labor_link_mobile/apis/ExperiencesApi.dart';
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
import 'package:labor_link_mobile/models/Experience.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/models/Resume.dart';
import 'package:labor_link_mobile/screens/JobApplicationTrackingScreen.dart';
import 'package:labor_link_mobile/screens/MainNavigationHandler.dart';
import 'package:labor_link_mobile/screens/widgets/DynamicTextField.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:random_avatar/random_avatar.dart';
import 'dart:math' show min;
import 'package:uuid/uuid.dart';

class AddWorkExperience extends StatefulWidget {
  AddWorkExperience({Key? key}) : super(key: key);

  @override
  State<AddWorkExperience> createState() => _AddWorkExperienceState();
}

class _AddWorkExperienceState extends State<AddWorkExperience> {
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController yearStartedController = TextEditingController();
  TextEditingController yearEndedController = TextEditingController();
  TextEditingController companyCityLocationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void addWorkingExperience(){
    String id  = Uuid().v4();
    Experience experiencePayload = Experience(
      id,
      companyNameController.text,
      companyCityLocationController.text,
      "https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/company_images%2Fdefault-company-avatar-removebg-preview.png?alt=media&token=a3649b8b-5034-406c-95b0-2d289e558be2",
      FirebaseAuth.instance.currentUser!.email,
      jobTitleController.text,
      yearStartedController.text,
      yearEndedController.text == "" ? "Present" : yearEndedController.text
    );

    ExperiencesApi.addExperience(experiencePayload.toJson());
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Alert!',
      desc: 'Successfully added your work experience',
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
                iconTheme: IconThemeData( color: Colors. black, ), title: Text("Add Work Experience", style: GoogleFonts.poppins(color:Color(0xff0D0D26), fontSize: 22,fontWeight: FontWeight.w600),),centerTitle: true,backgroundColor: Colors.transparent),
                  body: SingleChildScrollView(
                      child: Padding(
                            padding: EdgeInsets.only(left:30,right:30),
                            child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height:30),
                          Text('Job Title',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: jobTitleController,
                            hintText: 'Enter job title',
                            obscureText: false,
                          ),
                          SizedBox(height: 20),
                          Text('Company',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: companyNameController,
                            hintText: 'Enter company name',
                            obscureText: false
                          ),
                          SizedBox(height: 20),
                          Text('Company City Location',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: companyCityLocationController,
                            hintText: 'Enter company city location',
                            obscureText: false
                          ),
                          SizedBox(height: 20),
                          Text('Year Started',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: yearStartedController,
                            hintText: 'Enter year started',
                            obscureText: false,
                            textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                            textInputType: TextInputType.number,
                          ),
                          SizedBox(height: 20),
                          Text('Year Ended',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: yearEndedController,
                            hintText: 'Enter year ended (Leave blank if present)',
                            obscureText: false,
                            textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                            textInputType: TextInputType.number,
                          ),
                          SizedBox(height: 30),
                          CustomButton(
                            text: "Save",
                            onTap: () {
                              addWorkingExperience();
                            },
                          ),
                          SizedBox(height: 50),
                         
                        ]
                      )),
                  )
    );
  }
}
