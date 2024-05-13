import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbacksApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static addFeedback(Map<String, dynamic> feedbackPayload, String type) {
    if(type == "applicant"){
       return firestore
        .collection('applicant_feedbacks')
        .add(feedbackPayload);
    }

    return firestore
        .collection('employer_feedbacks')
        .add(feedbackPayload);
  }

  static updateFeedback(Map<String, dynamic> feedbackPayload, String type, String email) {
   

    if(type == "applicant"){
      firestore.collection('applicant_feedbacks').where("applicant_email_address", isEqualTo: email).snapshots().first.then((value) {
        String id = value.docs.first.id.toString();
        firestore
            .collection('applicant_feedbacks').doc(id).update(feedbackPayload);
      });
    }

    firestore.collection('employer_feedbacks').where("employer_email_address", isEqualTo: email).snapshots().first.then((value) {
        String id = value.docs.first.id.toString();
        firestore
            .collection('employer_feedbacks').doc(id).update(feedbackPayload);
    });
  }

   static  Future<QuerySnapshot>  fetchFeedbackDetails(String applicantEmailAddress, String employerEmailAddress, String type, String jobId) {

    if(type == "applicant"){
       return firestore
        .collection('applicant_feedbacks')
        .where("applicant_email_address",isEqualTo: applicantEmailAddress)
        .where("employer_email_address", isEqualTo: employerEmailAddress)
        .where("job_id", isEqualTo: jobId)
        .get();
    }

    return firestore
        .collection('employer_feedbacks')
        .where("employer_email_address",isEqualTo: employerEmailAddress)
        .where("applicant_email_address",isEqualTo: applicantEmailAddress)
        .where("job_id", isEqualTo: jobId)
        .get();
  }

}