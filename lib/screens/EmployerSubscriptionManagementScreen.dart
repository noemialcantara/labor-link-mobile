import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:labor_link_mobile/apis/SubscribersApi.dart';
import 'package:labor_link_mobile/apis/TransactionsApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/models/Subscriber.dart';
import 'package:labor_link_mobile/models/SubscriptionPlan.dart';
import 'dart:math' as math;

class EmployerSubscriptionManagementScreen extends StatefulWidget {
  late Subscriber subscriber;
  EmployerSubscriptionManagementScreen({Key? key, required this.subscriber}) : super(key: key);

  @override
  State<EmployerSubscriptionManagementScreen> createState() => _EmployerSubscriptionManagementScreenState();
}

class _EmployerSubscriptionManagementScreenState extends State<EmployerSubscriptionManagementScreen> {
  SubscriptionPlan? subscriptionPlan;
  String beginsDate = "";
  String endsDate = "";
  String monthStarted = "";

  @override
  void initState() {
    super.initState();
    formatDates();
  }

  formatDates(){
    DateTime beginsDateTime = DateTime.parse(widget.subscriber.premiumPlanStartingDate.toString());
    DateTime endsDateTime = DateTime.parse(widget.subscriber.premiumPlanEndingDate.toString());
    setState(() {
      beginsDate = beginsDateTime.day.toString()+ " "+DateFormat.MMMM().format(beginsDateTime).toString()+ ", "+beginsDateTime.year.toString();
      monthStarted = DateFormat.MMMM().format(beginsDateTime).toString();
      endsDate = endsDateTime.day.toString()+ " "+DateFormat.MMMM().format(endsDateTime).toString()+ ", "+endsDateTime.year.toString();
    });
  }

  cancelSubscriptionPlan(){
    SubscribersApi.cancelSubscription(widget.subscriber.id.toString());
    TransactionsApi.cancelTransaction(widget.subscriber.id.toString());
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Success!',
      desc: 'You have cancelled your subscription successfully!',
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                toolbarHeight: 80,
                bottomOpacity: 0.0,
                elevation: 0.0,
                iconTheme: IconThemeData( color: Colors. black,size: 30 ), title: Text("Subscription", style: GoogleFonts.poppins(color:Color(0xff0D0D26), fontSize: 22,fontWeight: FontWeight.w600),),centerTitle: true,backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height:20),
              Center(child: Image.asset("assets/icons/subscription_icon.png",)),
               SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left:20,right:20,top:10),
                child: 
                Text("Unlimited Plan: the ultimate solution for employers seeking to expand their workforce without breaking the bank. With this plan, employers gain unlimited access to job postings, enabling them to cast a wider net and attract top talent from various fields.", textAlign: TextAlign.start,  style: GoogleFonts.poppins(fontSize: 18,color: Colors.black),)
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.only(left:20, right:20),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text("Month", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),),
                Flexible(child: Text(monthStarted, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),))
              ],),),
              SizedBox(height:20),
              Padding(
                padding: EdgeInsets.only(left:20, right:20),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text("Amount", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),),
                Flexible(child: Text("Php ${widget.subscriber.monthlyPayment} ${widget.subscriber.duration}", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),))
              ],),),
              SizedBox(height:20),
              Padding(
                padding: EdgeInsets.only(left:20, right:20),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text("Begins", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),),
                Flexible(child: Text("${beginsDate}", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),))
              ],),),
              SizedBox(height:20),
              Padding(
                padding: EdgeInsets.only(left:20, right:20),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text("Ends", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),),
                Flexible(child: Text("${endsDate}", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),))
              ],),),
              SizedBox(height:20),
              Padding(
                padding: EdgeInsets.only(left:20, right:20),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text("Type", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),),
                Flexible(child: Text(widget.subscriber.duration.toString()[0].toUpperCase()+widget.subscriber.duration.toString().substring(1), style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),))
              ],),),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.only(left:20,right:20,bottom:25),
                child: CustomButton(
                text: "Cancel Plan",
                onTap: () {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'Alert!',
                        desc: 'Are you sure you want to cancel the subscription. You can only add unlimited job posting until the end of your contract.',
                        btnOkOnPress: () {
                          cancelSubscriptionPlan();
                        },
                        btnCancelOnPress: (){

                        },
                        btnCancelText: "Cancel"
                      )..show();
                })),
                SizedBox(height:30),
            ]
          )
      )
    );
  }
}