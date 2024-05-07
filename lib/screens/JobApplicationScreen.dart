import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/FirebaseChatApi.dart';
import 'package:labor_link_mobile/apis/JobApplicationApi.dart';
import 'package:labor_link_mobile/apis/ResumeApi.dart';
import 'package:labor_link_mobile/apis/UsersApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/helper/NotificationHelper.dart';
import 'package:labor_link_mobile/models/ChatUser.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/models/JobApplication.dart';
import 'package:labor_link_mobile/models/Message.dart';
import 'package:labor_link_mobile/screens/JobApplicationSuccessScreen.dart';

class JobApplicationScreen extends StatefulWidget {
  final Job jobDetails;
  
  JobApplicationScreen({Key? key, required this.jobDetails}) : super(key: key);

  @override
  State<JobApplicationScreen> createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {
  Options options = Options(format: Format.rgb, luminosity: Luminosity.dark);
  TextEditingController coverLetterTextEditingController = TextEditingController();
  String userEmail = "test@gmail.com";
  String employerEmailAddress = "";
  String selectedResume = "";
  String selectedResumeProfileName = "";
  List<bool> isResumeCheckedList = [] ;
  
  @override
  void initState() {
    super.initState();
    _getUserEmail();
    _getEmployerEmailAddress();
  }

  void _getUserEmail(){
    setState(() {
       userEmail =  FirebaseAuth.instance.currentUser!.email ?? "test@gmail.com";
    });
  }

  void _getEmployerEmailAddress(){
     UsersApi.getEmployerDataByName(widget.jobDetails.companyName).then((value) {
          setState(() {
            employerEmailAddress =  value.docs.first.get("email_address");
            print("EMLOYER EMAIL: $employerEmailAddress");
          });
     });
  }

  void submitApplication() async{
    String coverLetter = coverLetterTextEditingController.text;
    if(selectedResume != ""){
      JobApplication payload = JobApplication(selectedResumeProfileName, selectedResume, coverLetter, widget.jobDetails.jobId, userEmail, widget.jobDetails.companyLogo,
       widget.jobDetails.jobName,widget.jobDetails.companyName,widget.jobDetails.minimumSalary.toString(), widget.jobDetails.jobCityLocation, "Reviewing", widget.jobDetails.employmentType);
      JobApplicationApi.submitApplication(payload.toJson());


      await FirebaseChatApi.addChatUserWithFrom(employerEmailAddress, userEmail).then((value) {
        FirebaseChatApi.sendFirstMessageCustom(value["from_id"],value["to_id"], "Hello ${selectedResumeProfileName},\n\nThis is to inform you that we have already received your application regarding ${widget.jobDetails.jobName} position. We are now currently reviewing your resume. Rest assured that we will send you a message regarding the interview schedule.\n\nThank you.", Type.text);
      });

      createNotification(userEmail,"New Activity", "${widget.jobDetails.companyName} has already received your application for ${ widget.jobDetails.jobName} position.");
      createNotification(employerEmailAddress, "New Activity", "$selectedResumeProfileName has submitted his/her application for ${ widget.jobDetails.jobName} position.");
     
      Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => JobApplicationSuccessScreen(jobDetails: widget.jobDetails)));
    }else{
      showAlertDialog(context);
    }
   
  }
                                                                                                                                                                                                                                              
  showAlertDialog(BuildContext context) {
        Widget okButton = TextButton(
          child: Text("Okay", style: GoogleFonts.poppins(color: Colors.black),),
          onPressed: () { 
            Navigator.pop(context);
          },
        );
        AlertDialog alert = AlertDialog(
          title: Text("Alert!",style: GoogleFonts.poppins()),
          content: Text("Please select a resume first", style: GoogleFonts.poppins()),
          actions: [
            okButton,
          ],
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }

  Widget resumeList(){
      return 
          StreamBuilder(
          stream:  ResumeApi.getResumeByUser( userEmail),
          builder: (context, snapshot) {
            var streamDataLength = snapshot.data?.docs.length ?? 0;
            
            if(streamDataLength > 0){
             for(int i = 0; i < snapshot.data!.docs.length;i++){
              isResumeCheckedList.add(false);
             }
            }

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.done: 
              if(streamDataLength > 0)
                return 
                  Padding(
                padding: EdgeInsets.only(left:20, right: 20),
                child: SizedBox( height:100, child: ListView.builder(scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (ctx, index) =>
                    Container(
                      margin: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0)
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 15, right: 15, top:10, bottom: 10),
                            child: Row(children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Color(0xffCACBCE),
                                  ), child : Checkbox(

                                checkColor: Colors.white,
                                fillColor: MaterialStateProperty.resolveWith((states) {
                                
                                  if(states.contains(MaterialState.selected))
                                    return Color(0xff356899);
                                  return Colors.white;
                                }),
                                value: isResumeCheckedList[index],
                                shape: CircleBorder(),
                                onChanged: (bool? value) {

                                  print("THE SELECTED RESUME IS ${snapshot.data?.docs[index].get("link")}");
                                  setState(() {
                                    selectedResume = snapshot.data?.docs[index].get("link").toString() ?? "";
                                    selectedResumeProfileName = snapshot.data?.docs[index].get("profile_name").toString() ?? "";
                                    isResumeCheckedList = [];
                                    for(int i = 0; i < snapshot.data!.docs.length;i++){
                                      isResumeCheckedList.add(false);
                                    }
                                    isResumeCheckedList[index] = value!;
                                  });
                                },
                              ))),
                              SizedBox(width:15),
                              Column(children: [
                                SizedBox(height:8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xff356899),
                                          border: Border.all(color:Color(0xff356899)),
                                          borderRadius: BorderRadius.circular(15.0)
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(left:10, right:10,top:5,bottom:5),
                                          child: 
                                            Text(snapshot.data?.docs[index].get("profile_job") ?? "", style: GoogleFonts.poppins(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.w600)))),
                                        SizedBox(height:10),
                                      Text(snapshot.data?.docs[index].get("profile_name") ?? "", style: GoogleFonts.poppins(fontSize: 16, color: Color(0xff0D0D26)),)
                            ])])))
                )));
              
              return Padding(padding: EdgeInsets.only(left:20,right:20),  child: Text("There is no resume yet. Please upload a resume first.", style: GoogleFonts.poppins(fontSize: 16, color: Color(0xff95969D)),));
             }
          });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height:30),
              Padding(
                padding: EdgeInsets.only(left:20, right: 20),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, size: 30,)),
                Text("Apply", style: GoogleFonts.poppins(color: Color(0xff000000),fontSize: 20,fontWeight: FontWeight.w600)),
                Container()
              
              ],)),
              SizedBox(height:20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                    Padding(padding: EdgeInsets.only(left:20), child: Image.network(widget.jobDetails.companyLogo, height: 50, width: 50, alignment: Alignment.center)),
                    SizedBox(width:10),
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .60), child: Text(widget.jobDetails.jobName, maxLines: 1,softWrap: false, overflow:TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 16.0,fontWeight: FontWeight.w600, color: Color(0xff0D0D26)),)),
                    SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .60), child: Text(widget.jobDetails.companyName, overflow:TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 14.0, color: Color(0xff0D0D26)),))
                   ],)
                  ],),
                  Padding(
                    padding: EdgeInsets.only(right:25),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                     mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                     SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .73), child: RichText(
                       overflow:TextOverflow.ellipsis,
                       maxLines: 1,
                          text: TextSpan( text: 
                                "₱", style: TextStyle(fontSize: 15.0, color: Color(0xff0D0D26)),
                                  children: [
                                    TextSpan(text:  widget.jobDetails.minimumSalary.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')+"/mo", style: GoogleFonts.poppins(fontSize: 14.0,
                                      fontWeight: FontWeight.w600, color: Color(0xff0D0D26))),
                                  ]
                          ),
                        )),
                    SizedBox(width: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * .73), child: Text(widget.jobDetails.jobCityLocation,maxLines: 1,textAlign: TextAlign.right,  overflow:TextOverflow.ellipsis,style: GoogleFonts.poppins(fontSize: 14.0,color: Color(0xff0D0D26)))),
                  ],))
              ]),
              SizedBox(height:30),
              Padding(
                padding: EdgeInsets.only(left:20, right: 20),
                child: Text("Select a resume", textAlign: TextAlign.left,  style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w500, color: Color(0xff0D0D26)))),
              SizedBox(height:20),
              resumeList(),
              SizedBox(height:30),
              Padding(
                padding: EdgeInsets.only(left:20, right: 20),
                child: Row(children: [
                Text("Cover letter", textAlign: TextAlign.left,  style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w500, color: Color(0xff0D0D26))),
                Text(" (Optional)", textAlign: TextAlign.left,  style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w500, color: Color(0xff95969D)))
              ])),
              SizedBox(height:20),
              Padding(
                padding: EdgeInsets.only(left:20, right: 20),
                child: TextFormField(
                  controller: coverLetterTextEditingController,
                   style:  GoogleFonts.poppins(color: Colors.black, fontSize: 18),
                  minLines: 6,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    filled: true,
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20),)),
                  labelText: 'Write a cover letter...',
                  labelStyle: GoogleFonts.poppins(color: Colors.black),
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  
)
                ),
              )),
              SizedBox(height:30),
              Padding(
                padding: EdgeInsets.only(left:20,right:20,bottom: 30),
                child: CustomButton(
                text: "Apply Now",
                onTap: () async  =>  submitApplication(),
              )),
            ]
          )
      )
    );
  }
}

class SampleData {
  String id;
  String title;

  SampleData({required this.id, required this.title});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
