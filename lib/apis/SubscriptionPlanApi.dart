import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionPlanApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getPlanList() {

    return firestore
        .collection('subscription_plans')
        .snapshots();
  }

}