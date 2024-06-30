import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class JobApi {
  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static postJob(Map<String, dynamic> job) {
    return firestore.collection('jobs').add(job);
  }

  static updateJob(Map<String, dynamic> job) async {
    String jobDocumentId = await getJobDocumentId(job["job_id"]);
    return firestore.collection('jobs').doc(jobDocumentId).set(job);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getJobDetails() {
    return firestore.collection('jobs').snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getJobListByCategory(
      String category) {
    return firestore
        .collection('jobs')
        .where("job_categories", isEqualTo: [category]).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getJobListByEmployer(
      String companyName) {
    return firestore
        .collection('jobs')
        .where("company_name", isEqualTo: companyName)
        .snapshots();
  }

  static Future<String> getJobDocumentId(String jobId) {
    var data =
        firestore.collection('jobs').where("job_id", isEqualTo: jobId).get();

    return data.then((value) {
      String id = value.docs[0].id;
      return id;
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllJobsById(
      List<String> jobIds) {
    return firestore
        .collection('jobs')
        .where('job_id', whereIn: jobIds.isEmpty ? [''] : jobIds)
        .snapshots();
  }

  static Future<int> getRequiredApplicantCountByJobId(String jobId) async {
    final data = await firestore
        .collection('jobs')
        .where('job_id', isEqualTo: jobId)
        .get();
    return data.docs.first.data()["required_applicant_count"];
  }

  static Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      searchJobByKeyword(String searchKeyword) {
    return firestore.collection('jobs').snapshots().map((querySnapshot) {
      var filteredSearch = querySnapshot.docs.where((doc) {
        return (doc['job_name'] as String)
            .toLowerCase()
            .contains(searchKeyword.toLowerCase());
      }).toList();
      return filteredSearch;
    });
  }

  static Future<QuerySnapshot> getQueryJobListByEmployer(String companyName) {
    return firestore
        .collection('jobs')
        .where("company_name", isEqualTo: companyName)
        .get();
  }

  static Future<QuerySnapshot> getJobPostingsCount(String companyName) {
    return firestore
        .collection('jobs')
        .where("company_name", isEqualTo: companyName)
        .get();
  }

  static deleteJobById(String jobId) {
    firestore
        .collection('jobs')
        .where("job_id", isEqualTo: jobId)
        .snapshots()
        .first
        .then((value) {
      String id = value.docs.first.id.toString();
      firestore.collection('jobs').doc(id).delete();
    });
  }
}
