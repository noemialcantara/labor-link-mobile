import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/JobApi.dart';
import 'package:labor_link_mobile/apis/SavedJobsApi.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/models/SavedJob.dart';
import 'package:labor_link_mobile/screens/JobDetailsScreen.dart';
import 'package:labor_link_mobile/screens/widgets/JobItem.dart';

class SavedJobsScreen extends StatefulWidget {
  const SavedJobsScreen({Key? key}) : super(key: key);

  @override
  _SavedJobsScreenState createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  List<dynamic> _jobList = [];

  Widget fetchSavedJobs() {
    return StreamBuilder(
            stream: SavedJobsApi.getSavedJobsByEmail(FirebaseAuth.instance.currentUser?.email ?? ""),
            builder: (context, firstSnapshot) {
              switch (firstSnapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                case ConnectionState.done: 
                  return StreamBuilder(
                    stream:  JobApi.getAllJobsById(firstSnapshot.data?.docs.map((e) => e.get("job_id").toString()).toList() ?? []),
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
                  
                        return Padding(padding: EdgeInsets.only(left:25, right: 25), child: Text("No saved jobs yet",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 18),));
                      }
              });

              }
            }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(height: 50),
              Padding(child: Text("Saved Jobs", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 25)), padding: EdgeInsets.only(left:25,right:25),),
        SizedBox(height: 20),
        fetchSavedJobs()
      
      ])
    );
  }
}
