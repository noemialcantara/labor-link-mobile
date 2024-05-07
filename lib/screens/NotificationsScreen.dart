import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:labor_link_mobile/apis/NotificationsApi.dart';
import 'package:labor_link_mobile/models/Notification.dart' as NotificationModel;
import 'package:get_time_ago/get_time_ago.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> _notificationList = [];

  @override
  void initState() {
    super.initState();
  }

  Widget fetchNotifications() {
    return StreamBuilder(
      stream:  NotificationsApi.getNotifications(FirebaseAuth.instance.currentUser?.email ?? ""),
      builder: (context, snapshot) {
        var streamDataLength = snapshot.data?.docs.length ?? 0;

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.done: 
          if(streamDataLength > 0){

            final data = snapshot.data?.docs;
              _notificationList = data?.map((e) => NotificationModel.Notification.fromJson(e.data())).toList() ?? [];

              return Container(child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 10,),
                    itemCount: _notificationList.length,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, index) => SizedBox(
                      height: 20,
                    ),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => 
                        ListTile(
                          leading: Image.network("https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/company_images%2Fdefault-company-avatar-removebg-preview.png?alt=media&token=a3649b8b-5034-406c-95b0-2d289e558be2",height:40),
                          title: Text(_notificationList[index].notificationDescription,overflow: TextOverflow.ellipsis,  style: GoogleFonts.poppins(color: Colors.black, fontSize: 16), maxLines: 2,),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            SizedBox(height: 10),
                            Text(GetTimeAgo.parse(DateTime.parse(_notificationList[index].dateSent)), style: GoogleFonts.poppins(color: Colors.black,)),
                          ])
                        )
              ), margin: EdgeInsets.only(bottom:80),);
          }
          return Padding(padding: EdgeInsets.only(left:25, right: 25), child: Text("No notifications yet",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 18),));
        }
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(height: 50),
              Padding(child: Text("Notifications", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 25)), padding: EdgeInsets.only(left:25,right:25),),
        SizedBox(height: 20),
        fetchNotifications()
      ]))
    );
  }
}