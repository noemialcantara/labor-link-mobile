import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getNotifications(String emailAddress) {

    return firestore
        .collection('notifications')
        .orderBy("date_sent", descending: true)
        .where("email_address",isEqualTo: emailAddress)
        .snapshots();
  }

  static createNotification(Map<String, dynamic> notificationPayload) {

    return firestore
        .collection('notifications')
        .add(notificationPayload);
  }


  static deleteNotification(String notificationId){
    firestore.collection('notifications').where("id", isEqualTo: notificationId).snapshots().first.then((value) {
      String id = value.docs.first.id.toString();
      firestore
          .collection('notifications').doc(id).update({"is_seen": false});
    });
  }

}