import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/CompanyApi.dart';
import 'package:labor_link_mobile/apis/JobApplicationApi.dart';
import 'package:labor_link_mobile/apis/ResumeApi.dart';
import 'package:labor_link_mobile/apis/SubscribersApi.dart';
import 'package:labor_link_mobile/apis/SubscriptionPlanApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/models/JobApplication.dart';
import 'package:labor_link_mobile/models/SubscriptionPlan.dart';
import 'package:labor_link_mobile/screens/AuthRedirector.dart';
import 'package:labor_link_mobile/screens/JobApplicationTrackingScreen.dart';
import 'package:labor_link_mobile/screens/MainNavigationHandler.dart';
import 'dart:math' as math;

import 'package:labor_link_mobile/screens/widgets/CreditCardPaymentScreen.dart';

class EmployerSubscriptionScreen extends StatefulWidget {
  EmployerSubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<EmployerSubscriptionScreen> createState() => _EmployerSubscriptionScreenState();
}

class _EmployerSubscriptionScreenState extends State<EmployerSubscriptionScreen> {
  SubscriptionPlan? subscriptionPlan;

  @override
  void initState() {
    super.initState();
  }

  Widget generateSubscriptionPlan(){
    return StreamBuilder(
        stream: SubscriptionPlanApi.getPlanList(),
        builder: (context, snapshot) {
          var streamDataLength = snapshot.data?.docs.length ?? 0;

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.done:
              if (streamDataLength > 0)
                return ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(height:20);
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: streamDataLength,
                  itemBuilder: (ctx, index) => 
                    GestureDetector(
                        onTap: (){
                          setState(() {
                             subscriptionPlan = SubscriptionPlan(snapshot.data?.docs[index].get("duration"), snapshot.data?.docs[index].get("plan_name"), snapshot.data?.docs[index].get("price"));  
                          });
                           
                        },
                        child: Container(
                        width: double.infinity,
                              margin: EdgeInsets.only(left: 20 ,right: 20),
                                  decoration: BoxDecoration(
                                    color: Color(0xffeeeff5),
                                    border: Border.all(color: snapshot.data?.docs[index].get("duration") == subscriptionPlan?.duration  ?  Color(0xff356899) :  Color(0xffeeeff5)),
                                    borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 15, right: 15, top:10, bottom: 10),
                                    child: 
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                            Text(snapshot.data?.docs[index].get("plan_name"), style: GoogleFonts.poppins(fontSize: 17, color: Color(0xff356899), fontWeight: FontWeight.w600),),
                                            Text("Payment is by ${snapshot.data?.docs[index].get("duration")} - PHP ${snapshot.data?.docs[index].get("price")}", style: GoogleFonts.poppins(fontSize: 15, color: Color(0xff356899)))
                                          ],)
                                  )
                      )),
                );
            return Container();
          }
        }
    );
  }

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
                  child: Icon(Icons.arrow_back, size: 30,),
                  ),
              ],)),
              SizedBox(height:20),
              Center(child: Text("Get Premium", style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xff356899)),)),
              Padding(
                padding: EdgeInsets.only(left:20,right:20,top:10),
                child: 
                Center(child: Text("Get unlimited job postings at your fingertips!", textAlign: TextAlign.center,  style: GoogleFonts.poppins(fontSize: 18,color: Color(0xff95969D)),))
              ),
              SizedBox(height: 20),
              Center(child: Image.asset("assets/icons/subscription_icon.png",)),
              Padding(
                padding: EdgeInsets.only(left:20,right:20,top:10),
                child: 
                Center(child: Text("You only have 10 free job postings in this free plan. Choose a plan from below to post unlimited jobs.", textAlign: TextAlign.center,  style: GoogleFonts.poppins(fontSize: 16,color: Color(0xff95969D)),))
              ),
              SizedBox(height:40),
              generateSubscriptionPlan(),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.only(left:20,right:20,bottom:25),
                child: CustomButton(
                text: "Subscribe to ${subscriptionPlan?.duration ?? "monthly"} offer",
                onTap: () {
                    if(subscriptionPlan == null){
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Alert!',
                          desc: 'Please select a subscription plan first from the list above.',
                          btnOkOnPress: () {
                          }
                        );
                    }else{
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CreditCardPaymentScreen(subscriptionPlan: subscriptionPlan!,)));
                    }
                   
                })),
              Padding(
                padding: EdgeInsets.only(left:20,right:20,bottom:40),
                child:Text("By placing this order, you agree to the Terms of Service and Privacy Policy. Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period.", style:GoogleFonts.poppins(color: Color(0xffAFB0B6), fontSize: 12),)
              )
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
