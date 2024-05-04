import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/JobApi.dart';
import 'package:labor_link_mobile/apis/JobApplicantsApi.dart';
import 'package:labor_link_mobile/apis/JobApplicationApi.dart';
import 'package:labor_link_mobile/apis/UsersApi.dart';
import 'package:labor_link_mobile/screens/SearchListScreen.dart';
import 'package:labor_link_mobile/screens/widgets/JobCategoryList.dart';
import 'package:labor_link_mobile/screens/widgets/JobList.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EmployerHomeDashboardScreen extends StatefulWidget {
  const EmployerHomeDashboardScreen({Key? key}) : super(key: key);

  @override
  _EmployerHomeDashboardScreenState createState() => _EmployerHomeDashboardScreenState();
}

class _EmployerHomeDashboardScreenState extends State<EmployerHomeDashboardScreen> {
  final user = FirebaseAuth.instance.currentUser;
   List<ChartData>? chartData;
   int applicantsCount = 0;
   int jobPostingCount = 0;
   int hiredCount = 0;
   int rejectedCount = 0;

  @override
  void initState() {
    super.initState();
    fetchKPIs();
    chartData = <ChartData>[
      ChartData(
          x: 'Sun',
          y: 17.0,),
      ChartData(
          x: 'Mon',
          y: 30.0,),
      ChartData(
          x: 'Tue',
          y: 20.0,),
      ChartData(
          x: 'Wed', y: 32,),
      ChartData(
          x: 'Thu',
          y: 45.0,),
      ChartData(
          x: 'Fri',
          y: 10.0,),
      ChartData(
          x: 'Sat',
          y: 28.0,)
    ];
    
  }

  @override
  void dispose() {
    
    super.dispose();
    chartData!.clear();
  }

  fetchKPIs(){
    if(mounted){
      UsersApi.getCompanyNameByEmail(FirebaseAuth.instance.currentUser!.email!).then((value) {
        String companyName  = value.docs.first.get("employer_name");
        JobApplicantsApi.getApplicationCount(companyName).then((value) {
          int dataLength = value.docs.length;
          setState(() {
            applicantsCount = dataLength;
          });
        });

        JobApi.getQueryJobListByEmployer(companyName).then((value) {
          int dataLength = value.docs.length;
          setState(() {
            jobPostingCount = dataLength;
          });
        });

        JobApplicationApi.getQueryJobListByEmployerWithStatus(companyName,"Hired").then((value) {
          int dataLength = value.docs.length;
          setState(() {
            hiredCount = dataLength;
          });
        });

        JobApplicationApi.getQueryJobListByEmployerWithStatus(companyName,"Rejected").then((value) {
          int dataLength = value.docs.length;
          setState(() {
            rejectedCount = dataLength;
          });
        });

      });
    }
      
  }

  SfCartesianChart _buildDashedSplineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: ''),
      legend: Legend(isVisible:false),
      primaryXAxis:  CategoryAxis(
        labelStyle: GoogleFonts.poppins(),
        majorGridLines: MajorGridLines(width: 0),
        interval: 1,
      ),
      primaryYAxis:  NumericAxis(
        labelStyle: GoogleFonts.poppins(),
        minimum: 0,
        maximum: 50,
        interval: 4,
        labelFormat: '{value}',
        axisLine: AxisLine(width: 0),
      ),
      series: <CartesianSeries<ChartData, String>>[
            SplineSeries<ChartData, String>(
              dataSource: chartData!,
              xValueMapper: (ChartData data, _) => data.x ,
              yValueMapper: (ChartData data, _) => data.y,
            )
          ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: 
      Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(height: 40),
        Text("Welcome ${user?.email}!", style: GoogleFonts.poppins(fontWeight: FontWeight.normal, fontSize: 18, color: Color(0xff95969D))),
        Text("Dashboard", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 25)),
        SizedBox(height:30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Container(
              decoration: BoxDecoration(
                color: Color(0xffe3edf9),
                border: Border.all(color: Color(0xffe3edf9)),
                borderRadius: BorderRadius.circular(20.0)
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 22, right: 22, top:22, bottom: 22),
                child: Column(children: [
                    Row(children: [
                      Image.asset("assets/icons/multiple_users_icon.png",height: 20,),
                      SizedBox(width:10),
                      SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * 0.81) ,child:Text("Applicants",maxLines: 1,overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w500, color: Color(0xff197BD2)))),
                    ],),
                    
                    SizedBox(height:15),
                    SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * 0.7) ,child: Text(applicantsCount.toString(),maxLines: 1,overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 36.0, fontWeight: FontWeight.bold, color: Color(0xff197BD2))))
                ])
              )
          ),
          Container(
              decoration: BoxDecoration(
                color: Color(0xffede8f8),
                border: Border.all(color: Color(0xffede8f8)),
                borderRadius: BorderRadius.circular(20.0)
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 22, right: 22, top:22, bottom: 22),
                child: Column(children: [
                    Row(children: [
                      Image.asset("assets/icons/briefcase_icon.png",height: 20,),
                      SizedBox(width:10),
                      SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * 0.81) ,child:  Text("Job Posts",maxLines: 1,overflow: TextOverflow.ellipsis,  style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w500, color: Color(0xff7042C9)))),
                    ],),
                    SizedBox(height:15),
                    SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * 0.7) ,child: Text(jobPostingCount.toString(),maxLines: 1,overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 36.0, fontWeight: FontWeight.bold, color: Color(0xff7042C9))))
                ])
              )
          ),
        ],),
        SizedBox(height:22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Container(
              decoration: BoxDecoration(
                color: Color(0xffe1f3f5),
                border: Border.all(color: Color(0xffe1f3f5)),
                borderRadius: BorderRadius.circular(20.0)
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 22, right: 22, top:22, bottom: 22),
                child: Column(children: [
                    Row(children: [
                      Image.asset("assets/icons/hired_icon.png",height: 20,),
                      SizedBox(width:10),
                      SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * 0.81) ,child:Text("Hired",maxLines: 1,overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w500, color: Color(0xff0DB1AD)))),
                    ],),
                    
                    SizedBox(height:15),
                    SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * 0.7) ,child: Text(hiredCount.toString(),maxLines: 1,overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 36.0, fontWeight: FontWeight.bold, color: Color(0xff0DB1AD))))
                ])
              )
          ),
          Container(
              decoration: BoxDecoration(
                color: Color(0xfff6e7ef),
                border: Border.all(color: Color(0xfff6e7ef)),
                borderRadius: BorderRadius.circular(20.0)
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 22, right: 22, top:22, bottom: 22),
                child: Column(children: [
                    Row(children: [
                      Image.asset("assets/icons/rejected_icon.png",height: 20,),
                      SizedBox(width:10),
                      SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * 0.81) ,child:  Text("Rejected",maxLines: 1,overflow: TextOverflow.ellipsis,  style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w500, color: Color(0xffDF1F04)))),
                    ],),
                    SizedBox(height:15),
                    SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * 0.7) ,child: Text(rejectedCount.toString(),maxLines: 1,overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 36.0, fontWeight: FontWeight.bold, color: Color(0xffDF1F04))))
                ])
              )
          ),
        ],),
        SizedBox(height: 30),
        Container(
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                border: Border.all(color: Color(0xffffffff)),
                borderRadius: BorderRadius.circular(20.0)
              ),
              child:Padding(
                padding: EdgeInsets.only(top:20,left:20,right:10,bottom: 20),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text("Profile Visitor Trend", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff243465))),
                _buildDashedSplineChart(),
              ]))
        ),
        SizedBox(height:100),
      ],)));
    
  }

}

class ChartData {
  ChartData(
      {this.x,
      this.y,
      });
  final String? x;
  final num? y;
}