import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/screens/JobDetailsScreen.dart';
import 'package:labor_link_mobile/screens/widgets/JobItem.dart';

class JobList extends StatelessWidget {
  JobList({Key? key}) : super(key: key);

  final jobList = Job.generateJobs();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      height: 160,
      child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 0),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Stack(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: JobDetailsScreen(
                        jobList[index],
                      ),
                    ),
                  );
                },
                child: JobItem(
                  job: jobList[index],
                ),
              ),
            ],
          ),
          separatorBuilder: (_, index) => SizedBox(
            width: 15,
          ),
          itemCount: jobList.length),
    );
  }
}