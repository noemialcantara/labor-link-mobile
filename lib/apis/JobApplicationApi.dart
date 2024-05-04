import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplicationApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static submitApplication(Map<String, dynamic>  jobApplication) {

    firestore
        .collection('job_applications')
        .add(jobApplication);
  }

  static checkIfUserAlreadyApplied(String  jobId, String emailAddress){

    return firestore
        .collection('job_applications')
        .where("job_id", isEqualTo: jobId)
        .where("applicant_email", isEqualTo: emailAddress)
        .get();
  }

   static updateApplicantStatus(String  jobId, String applicantEmail, String status){
    firestore.collection('job_applications').where("applicant_email", isEqualTo: applicantEmail).where("job_id", isEqualTo: jobId).snapshots().first.then((value) {
      String id = value.docs.first.id.toString();
      firestore
          .collection('job_applications').doc(id).update({"status": status});
    });
  }

   static Future<QuerySnapshot> getQueryJobListByEmployerWithStatus(String companyName, String status) {

    return firestore
        .collection('job_applications')
        .where("company_name", isEqualTo: companyName)
        .where("status", isEqualTo: status)
        .get();
  }


  static Stream<QuerySnapshot<Map<String, dynamic>>> getJobDetailsByApplicantId(String emailAddress) {
    
    return firestore
      .collection('job_applications')
      .where("applicant_email", isEqualTo: emailAddress)
      .snapshots();
  }

  static Future<QuerySnapshot> getApplicationCount(String emailAddress){
    return firestore
      .collection('job_applications')
      .where("applicant_email", isEqualTo: emailAddress)
      .get();
  }

}