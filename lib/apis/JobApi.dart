import 'package:cloud_firestore/cloud_firestore.dart';

class JobApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getJobDetails() {

    return firestore
        .collection('jobs')
        .snapshots();
  }

}