import 'package:flutter/material.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/screens/JobDetailsScreen.dart';
import 'package:labor_link_mobile/screens/widgets/JobItem.dart';



class SearchList extends StatelessWidget {
  final List<Job> jobDetails;
  SearchList({Key? key, required this.jobDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return jobDetails.length > 0 ? Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: 
       ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 25),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => GestureDetector(
            onTap: (){
               Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => JobDetailsScreen(jobDetails: jobDetails[index])));
            },
            child:
          JobItem(
            job: jobDetails[index],
            width: double.infinity,
          )),
          separatorBuilder: (_, index) => SizedBox(
            height: 15,
          ),
          itemCount: jobDetails.length),
    ): Container();
  }
}