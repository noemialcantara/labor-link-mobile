import 'package:flutter/material.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/screens/widgets/JobItem.dart';



class SearchList extends StatelessWidget {
  SearchList({Key? key}) : super(key: key);
  // final jobList=Job.generateJobs();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text("test")
      //  ListView.separated(
      //     padding: EdgeInsets.symmetric(horizontal: 25),
      //     scrollDirection: Axis.vertical,
      //     itemBuilder: (context, index) => JobItem(
      //       job:,
      //       showTime: true,
      //     ),
      //     separatorBuilder: (_, index) => SizedBox(
      //       height: 15,
      //     ),
      //     itemCount: jobList.length),
    );
  }
}