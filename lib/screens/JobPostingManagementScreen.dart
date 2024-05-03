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
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/models/Resume.dart';
import 'package:labor_link_mobile/screens/JobApplicationTrackingScreen.dart';
import 'package:labor_link_mobile/screens/MainNavigationHandler.dart';
import 'package:labor_link_mobile/screens/widgets/DynamicTextField.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:random_avatar/random_avatar.dart';
import 'dart:math' show min;
import 'package:uuid/uuid.dart';

class JobPostingManagementScreen extends StatefulWidget {
  final String companyName;
  JobPostingManagementScreen({Key? key, required this.companyName}) : super(key: key);

  @override
  State<JobPostingManagementScreen> createState() => _JobPostingManagementScreenState();
}

class _JobPostingManagementScreenState extends State<JobPostingManagementScreen> {
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController requiredHireCountController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  TextEditingController jobCityController = TextEditingController();
  TextEditingController jobStateController = TextEditingController();
  

  String selectedJobType = "Full-time";
  String selectedJobSchedule = "8 hours shift";
  String selectedJobCategory = "Electrician";
  String selectedJobLevel = "Junior";
  List<String> jobResponsbilitiesList = [""];
  List<String> jobRequirementsList = [""];

  String userEmail = "test@gmail.com";
  String companyLogoUrl = "";

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  void _getUserEmail(){
    setState(() {
       userEmail =  FirebaseAuth.instance.currentUser!.email ?? "test@gmail.com";
       UsersApi.getCompanyDetailsByName(widget.companyName).then((value) {
          setState(() {
            companyLogoUrl  = value.docs.first.get("logo_url");
            print("COMPANY LOGO URL: $companyLogoUrl");
          });
        });
    });
  }

  Widget _addJobResponsibilityField(int index) {
    bool isLast = index == jobResponsbilitiesList.length - 1;

    return InkWell(
      onTap: () => setState(
        () => isLast ? jobResponsbilitiesList.add('') : jobResponsbilitiesList.removeAt(index),
      ),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isLast ? Color(0xff356899) : Colors.redAccent,
        ),
        child: Icon(
          isLast ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _addJobRequirementsField(int index) {
    bool isLast = index == jobRequirementsList.length - 1;

    return InkWell(
      onTap: () => setState(
        () => isLast ? jobRequirementsList.add('') : jobRequirementsList.removeAt(index),
      ),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isLast ? Color(0xff356899) : Colors.redAccent,
        ),
        child: Icon(
          isLast ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  void postJob(){
    String jobId =  Uuid().v4();
    Job jobPayload = Job(
      jobId,
      jobTitleController.text,
      jobDescriptionController.text,
      jobRequirementsList,
      jobResponsbilitiesList,
      [selectedJobCategory],
      selectedJobLevel,
      selectedJobType,
      double.parse(salaryController.text),
      double.parse(salaryController.text),
      false,
      false,
      widget.companyName,
      companyLogoUrl,
      jobStateController.text,
      jobCityController.text,
      int.parse(requiredHireCountController.text)
    );

    JobApi.postJob(jobPayload.toJson());
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Alert!',
      desc: 'Successfully posted your job! Applicants may now apply to this job listing.',
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
                iconTheme: IconThemeData( color: Colors. black, ), title: Text("Create Job Posting", style: GoogleFonts.poppins(color:Color(0xff0D0D26), fontSize: 22,fontWeight: FontWeight.w600),),centerTitle: true,backgroundColor: Colors.transparent),
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
                          Text('Number of people to hire',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: requiredHireCountController,
                            hintText: 'Enter number of people',
                            obscureText: false,
                            textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                            textInputType: TextInputType.number,
                          ),
                          SizedBox(height: 20),
                          Text('Job Category',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          StreamBuilder<QuerySnapshot>(
                            stream: JobCategoryApi.getJobCategories(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return const Text("Loading.....");
                              else {
                                List<String> jobCategoriesList = [];
                                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                                  DocumentSnapshot snap = snapshot.data!.docs[i];
                                  jobCategoriesList.add(snap.get("name"));
                                }
                                return FormField<String>(
                                  builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          labelStyle: GoogleFonts.poppins(),
                                          errorStyle: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 16.0),
                                          hintText: 'Please select job category',
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                                      isEmpty: selectedJobCategory == '',
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: selectedJobCategory,
                                          isDense: true,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedJobCategory = newValue!;
                                              state.didChange(newValue);
                                            });
                                          },
                                          items: jobCategoriesList.map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                          }),
                          SizedBox(height: 20),
                          Text('Job Type',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    labelStyle: GoogleFonts.poppins(),
                                    errorStyle: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 16.0),
                                    hintText: 'Please select job type',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                                isEmpty: selectedJobType == '',
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedJobType,
                                    isDense: true,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedJobType = newValue!;
                                        state.didChange(newValue);
                                      });
                                    },
                                    items: JOB_TYPES.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          Text('Job Level',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    labelStyle: GoogleFonts.poppins(),
                                    errorStyle: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 16.0),
                                    hintText: 'Please select job level',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                                isEmpty: selectedJobLevel == '',
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedJobLevel,
                                    isDense: true,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedJobLevel = newValue!;
                                        state.didChange(newValue);
                                      });
                                    },
                                    items: JOB_LEVELS.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          Text('Schedule',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    labelStyle: GoogleFonts.poppins(),
                                    errorStyle: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 16.0),
                                    hintText: 'Please select schedule',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                                isEmpty: selectedJobSchedule == '',
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedJobSchedule,
                                    isDense: true,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedJobSchedule = newValue!;
                                        state.didChange(newValue);
                                      });
                                    },
                                    items: JOB_SCHEDULES.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          Text('Salary',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: salaryController,
                            hintText: 'Enter salary per month',
                            obscureText: false,
                            textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                            textInputType: TextInputType.number,
                          ),
                          SizedBox(height: 20),
                          Text('Job City Location',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: jobCityController,
                            hintText: 'Enter city location',
                            obscureText: false,
                          ),
                          SizedBox(height: 20),
                           Text('Job State Location',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: jobStateController,
                            hintText: 'Enter state location',
                            obscureText: false,
                          ),
                          SizedBox(height: 20),
                          Text('Job Description',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: jobDescriptionController,
                            hintText: 'Enter job description',
                            maxLines: 6,
                            obscureText: false,
                          ),
                          SizedBox(height: 20),
                          Text('Job Responsibilities',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: jobResponsbilitiesList.length,
                              itemBuilder: (context, index) => Row(
                                children: [
                                  Expanded(child: DynamicTextField(
                                      key: UniqueKey(),
                                      hintText: "Enter a job responsibility",
                                      initialValue: jobResponsbilitiesList[index],
                                      onChanged: (v) => jobResponsbilitiesList[index] = v,
                                    )),
                                  
                                  const SizedBox(width: 20),
                                  _addJobResponsibilityField(index),
                                ],
                              ),
                              separatorBuilder: (context, index) {
                                return SizedBox(height:20);
                              },
                            ),
                          
                          SizedBox(height: 20),
                          Text('Job Requirements',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 18, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10),
                          ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: jobRequirementsList.length,
                              itemBuilder: (context, index) => Row(
                                children: [
                                  Expanded(child: DynamicTextField(
                                      key: UniqueKey(),
                                      hintText: "Enter a job requirement",
                                      initialValue: jobRequirementsList[index],
                                      onChanged: (v) => jobRequirementsList[index] = v,
                                    )),
                                  
                                  const SizedBox(width: 20),
                                  _addJobRequirementsField(index),
                                ],
                              ),
                              separatorBuilder: (context, index) {
                                return SizedBox(height:20);
                              },
                            ),
                          
                          SizedBox(height: 30),
                          CustomButton(
                            text: "Post job",
                            onTap: () {
                              postJob();
                            },
                          ),
                          SizedBox(height: 50),
                         
                        ]
                      )),
                  )
    );
  }
}
