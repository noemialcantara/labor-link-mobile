import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:labor_link_mobile/apis/JobApi.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/screens/JobApplicationScreen.dart';
import 'package:labor_link_mobile/screens/JobDetailsScreen.dart';
import 'package:labor_link_mobile/screens/widgets/JobItem.dart';

class JobList extends StatelessWidget {
  JobList({Key? key}) : super(key: key);
    List<Job> _jobList = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      height: 180,
      child: 
        StreamBuilder(
          stream: JobApi.getJobDetails(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                _jobList = data?.map((e) => Job.fromJson(e.data())).toList() ?? [];

                if (_jobList.isNotEmpty) {
                   return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // showModalBottomSheet(
                              //   isScrollControlled: true,
                              //   context: context,
                              //   backgroundColor: Colors.transparent,
                              //   builder: (context) => BackdropFilter(
                              //     filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              //     child: JobDetailsScreen(
                              //       _jobList[index],
                              //     ),
                              //   ),
                              // );
                               Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => JobApplicationScreen(jobDetails: _jobList[index])));
                            },
                            child: JobItem(
                              job: _jobList[index],
                            ),
                          ),
                        ],
                      ),
                      separatorBuilder: (_, index) => SizedBox(
                        width: 15,
                      ),
                      itemCount: _jobList.length);
                
                }else {
                  return const Center(
                    child: Text('No job list yet',
                        style: TextStyle(fontSize: 20)),
                  );
                }
            }
          }
        )
    );
  }
}