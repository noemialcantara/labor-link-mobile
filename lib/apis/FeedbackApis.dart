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

}