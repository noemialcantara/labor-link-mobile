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
import 'dart:math' show min;

import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/screens/JobDetailsScreen.dart';
import 'package:labor_link_mobile/screens/widgets/JobItem.dart';

class JobListByCategoryScreen extends StatefulWidget {
  final String categoryTitle;
  
  JobListByCategoryScreen({Key? key, required this.categoryTitle}) : super(key: key);

  @override
  State<JobListByCategoryScreen> createState() => _JobListByCategoryScreenState();
}

class _JobListByCategoryScreenState extends State<JobListByCategoryScreen> {
  String userEmail = "";
  List<Job> _jobList = [];

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  void _getUserEmail(){
    setState(() {
       userEmail =  FirebaseAuth.instance.currentUser!.email ?? "test@gmail.com";
    });
  }

  Widget fetchJobs() {
    return StreamBuilder(
          stream:  JobApi.getJobListByCategory(widget.categoryTitle),
          builder: (context, snapshot) {
            var streamDataLength = snapshot.data?.docs.length ?? 0;

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.done: 
               if(streamDataLength > 0){

                final data = snapshot.data?.docs;
                  _jobList = data?.map((e) => Job.fromJson(e.data())).toList() ?? [];
                  return ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.vertical,
                        separatorBuilder: (_, index) => SizedBox(
                          height: 20,
                        ),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => JobDetailsScreen(jobDetails: _jobList[index])));
                              },
                              child: JobItem(
                                width: double.infinity,
                                job: _jobList[index],
                              ),
                            ),
                        itemCount: _jobList.length);
               }
        
              return Padding(padding: EdgeInsets.only(left:30, right: 30), child: Text("There is no job found with this category yet",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 18),));
             }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                toolbarHeight: 80,
                bottomOpacity: 0.0,
                elevation: 0.0,
                iconTheme: IconThemeData( color: Colors. black, ), title: Text(widget.categoryTitle, style: GoogleFonts.poppins(color:Color(0xff0D0D26), fontSize: 22,fontWeight: FontWeight.w600),),centerTitle: true,backgroundColor: Colors.transparent),
                  body: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height:30),
                          fetchJobs(),
                          SizedBox(height: 50),
                        ]
                      )
                  )
    );
  }
}
