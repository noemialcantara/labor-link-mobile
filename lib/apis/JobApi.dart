import 'package:cloud_firestore/cloud_firestore.dart';

class JobApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static postJob(Map<String, dynamic>  job) {

    return firestore
        .collection('jobs')
        .add(job);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getJobDetails() {

    return firestore
        .collection('jobs')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getJobListByEmployer(String companyName) {

    return firestore
        .collection('jobs')
        .where("company_name", isEqualTo: companyName)
        .snapshots();
  }

  static Future<QuerySnapshot> getJobPostingsCount(String companyName){
    return firestore
      .collection('jobs')
      .where("company_name", isEqualTo: companyName)
      .get();
  }
}