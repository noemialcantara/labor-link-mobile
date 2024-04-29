import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/CompanyApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/screens/MainNavigationHandler.dart';
import 'package:random_avatar/random_avatar.dart';

class JobApplicationScreen extends StatefulWidget {
  final Job jobDetails;
  
  JobApplicationScreen({Key? key, required this.jobDetails}) : super(key: key);

  @override
  State<JobApplicationScreen> createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height:30),
              Padding(
                padding: EdgeInsets.only(left:20, right: 20),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, size: 30,)),
              ],)),
              Image.network(widget.jobDetails.companyLogo, height: 125, width: 125, alignment: Alignment.center),
              Text(widget.jobDetails.jobName,textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff000000),fontSize: 26,fontWeight: FontWeight.w700),), 
              SizedBox(height:5),
              Text(widget.jobDetails.companyName,textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D),fontSize: 18),), 
              SizedBox(height:25),
              Padding(
                padding: EdgeInsets.only(left:40,right:40),
                child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Container(
                      decoration: BoxDecoration(
                        color: Color(0xffE4E5E7),
                        border: Border.all(color: Color(0xffE4E5E7)),
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 25, right: 25, top:10, bottom: 10),
                        child: Text(widget.jobDetails.jobCategories[0], style: GoogleFonts.poppins(fontSize: 14.0, color: Color(0xff0D0D26)))
                      )
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Color(0xffE4E5E7),
                        border: Border.all(color: Color(0xffE4E5E7)),
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 25, right: 25, top:10, bottom: 10),
                        child: Text(widget.jobDetails.employmentType, style: GoogleFonts.poppins(fontSize: 14.0, color: Color(0xff0D0D26)))
                      )
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Color(0xffE4E5E7),
                        border: Border.all(color: Color(0xffE4E5E7)),
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 25, right: 25, top:10, bottom: 10),
                        child: Text(widget.jobDetails.jobLevels, style: GoogleFonts.poppins(fontSize: 14.0, color: Color(0xff0D0D26)))
                      )
                  ),
                  
              ],)),
              SizedBox(height:25),
              Padding(
                padding: EdgeInsets.only(left:30,right:30),
                child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan( text: 
                           "₱", style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold, color: Color(0xff0D0D26)),
                            children: [
                              TextSpan(text:  widget.jobDetails.minimumSalary.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')+"/month", style: GoogleFonts.poppins(fontSize: 17.0,
                                fontWeight: FontWeight.w600, color: Color(0xff0D0D26))),
                            ]
                    ),
                  ),
                  Text(widget.jobDetails.jobCityLocation, style: GoogleFonts.poppins(fontSize: 17.0,fontWeight:FontWeight.w600,color: Color(0xff0D0D26))),
                ])
              ),
              SizedBox(height:25),
              Container(
                height: MediaQuery.sizeOf(context).height - (MediaQuery.sizeOf(context).height * .60),
                child: DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar:  PreferredSize(
                      preferredSize: Size.fromHeight(kToolbarHeight),
                      child:  Container(
                        color: Color(0xffFAFAFD),
                        child: SafeArea(
                          child: Column(
                            children: <Widget>[
                               SizedBox(height: 15,),
                               TabBar(
                                indicatorColor: Color(0xffFAFAFD),
                                labelColor: Color(0xff000000),
                                unselectedLabelColor: Color(0xff95969D),
                                tabs: [
                                  Text("Description", style: GoogleFonts.poppins( fontSize: 14, fontWeight: FontWeight.w600)), 
                                  Text("Requirements", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                                  Text("About", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),),
                    body: TabBarView(
                      children: [
                        SingleChildScrollView(child: Padding(
                          padding: EdgeInsets.only(left:25,right:25,top:15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.jobDetails.jobDescription , style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 15)),
                            SizedBox(height:30),
                            Text("Responsibilities" , style: GoogleFonts.poppins(color: Color(0xff494A50), fontSize: 15, fontWeight: FontWeight.w600)),
                            SizedBox(height:10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.jobDetails.jobResponsibilities.map((e) => Text("- "+e ,softWrap: true, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 15))).toList()
                            )
                          ],
                        ))),
                        SingleChildScrollView(child: Padding(
                          padding: EdgeInsets.only(left:25,right:25,top:15),
                          child:  Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.jobDetails.jobRequirements.map((e) => Text("- "+e ,softWrap: true, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 15))).toList()
                            ))),
                        SingleChildScrollView(child: Padding(
                          padding: EdgeInsets.only(left:25,right:25,top:15),
                          child:  Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder(
                                    stream: CompanyApi.getCompanyDetailsByName(widget.jobDetails.companyName),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                        case ConnectionState.none:
                                        case ConnectionState.active:
                                        case ConnectionState.done:
                                          
                                          return Text(snapshot.data?.docs[0]["employer_about"].toString() ?? "About Us",softWrap: true, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 15));
                                      }
                                    })
                              ]))),
                       
                      ],
                    ),
                  ),
                )),
              SizedBox(height:30),
              Padding(
                padding: EdgeInsets.only(left:20,right:20,bottom: 30),
                child: CustomButton(
                text: "Apply Now",
                onTap: () => (){},
              )),
            ]
          )
      )
    );
  }
}
