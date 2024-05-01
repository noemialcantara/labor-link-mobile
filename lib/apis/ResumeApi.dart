import 'package:cloud_firestore/cloud_firestore.dart';

class ResumeApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getResumeByUser(String emailAddress) {

    return firestore
        .collection('resumes')
        .where("email_address",isEqualTo: emailAddress)
        .snapshots();
  }

}