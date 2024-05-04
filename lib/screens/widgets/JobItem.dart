import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/screens/widgets/IconText.dart';

class JobItem extends StatefulWidget {
  JobItem({Key? key, required this.job, this.width = 280})
      : super(key: key);

  final Job job;
  final double width;

  @override
  State<JobItem> createState() => _JobItemState();
}

class _JobItemState extends State<JobItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Padding(
                padding: EdgeInsets.only(left:20,right:20),
                child:  Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: Image.network(widget.job.companyLogo),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width - ( MediaQuery.sizeOf(context).width * (widget.width == 280 ? .70 : .50)),
                    child:Text(
                    widget.job.companyName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  )),
                ],
              )),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
                padding: EdgeInsets.only(left:20,right:20),
                child: SizedBox(
                    width: MediaQuery.sizeOf(context).width - ( MediaQuery.sizeOf(context).width * (widget.width == 280 ? .40 : .50)),
                    child:Text(
                  widget.job.jobName,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
                )),
          ),
          SizedBox(height: 15),
          Padding(
              padding: EdgeInsets.only(left:15,right:15),
              child:
                  Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    SizedBox(width: 10,),
                     SizedBox(
                    width: MediaQuery.sizeOf(context).width - ( MediaQuery.sizeOf(context).width * (widget.width == 280 ? .70 : .50)),
                    child:Text(widget.job.jobCityLocation+ ", "+ widget.job.jobStateLocation,overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins( fontSize: 15),)
                     )
                  ],
                ),
          ),
        ],
      ),
    );
  }
}