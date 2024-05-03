import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplicantsApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;


  static checkIfUserAlreadyApplied(String  jobId, String emailAddress){

    return firestore
        .collection('job_applications')
        .where("job_id", isEqualTo: jobId)
        .where("applicant_email", isEqualTo: emailAddress)
        .get();
  }


  static Stream<QuerySnapshot<Map<String, dynamic>>> getJobApplicantsByCompany(String companyName) {
    
    return firestore
      .collection('job_applications')
      .where("company_name", isEqualTo: companyName)
      .snapshots();
  }

  static Future<QuerySnapshot> getApplicationCount(String companyName){
    return firestore
      .collection('job_applications')
      .where("company_name", isEqualTo: companyName)
      .get();
  }

}