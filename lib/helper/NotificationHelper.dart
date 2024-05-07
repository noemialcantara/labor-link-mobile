import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:labor_link_mobile/apis/NotificationsApi.dart';
import 'package:labor_link_mobile/models/Notification.dart' as NotificationModel;

Map<String, dynamic> notificationPayload = {};
late NotificationModel.Notification notificationModel;

void createNotification(String destinationEmail, String title, String description){
    final dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
    notificationModel = NotificationModel.Notification(
      id: "", 
      emailAddress: destinationEmail,
      notificationTitle: title,
      notificationDescription: description,
      dateSent: dateFormat.format(DateTime.now()),
      isSeen: false
    );
    notificationPayload = notificationModel.toJson();
    NotificationsApi.createNotification(notificationPayload);
  }