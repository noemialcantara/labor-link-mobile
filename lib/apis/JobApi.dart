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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getJobListByCategory(String category) {

    return firestore
        .collection('jobs')
        .where("job_categories", isEqualTo: [category])
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getJobListByEmployer(String companyName) {

    return firestore
        .collection('jobs')
        .where("company_name", isEqualTo: companyName)
        .snapshots();
  }

  static Future<QuerySnapshot> getQueryJobListByEmployer(String companyName) {

    return firestore
        .collection('jobs')
        .where("company_name", isEqualTo: companyName)
        .get();
  }

  static Future<QuerySnapshot> getJobPostingsCount(String companyName){
    return firestore
      .collection('jobs')
      .where("company_name", isEqualTo: companyName)
      .get();
  }

  static deleteJobById(String jobId){
    firestore.collection('jobs').where("job_id", isEqualTo: jobId).snapshots().first.then((value) {
      String id = value.docs.first.id.toString();
      firestore
          .collection('jobs').doc(id).delete();
    });
  }
}