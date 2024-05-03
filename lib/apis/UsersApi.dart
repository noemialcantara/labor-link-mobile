import 'package:cloud_firestore/cloud_firestore.dart';

class UsersApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static createUser(bool isApplicantFirstMode, Map<String, dynamic>  user) {

    if(!isApplicantFirstMode){
       firestore
        .collection('employers')
        .add(user);
    }else{
       firestore
        .collection('applicants')
        .add(user);
    }
  }

  static Future<QuerySnapshot> getCompanyNameByEmail(String emailAddress){
    return firestore
      .collection('employers')
      .where("email_address", isEqualTo: emailAddress)
      .get();
  }

  static Future<QuerySnapshot> getCompanyDetailsByName(String companyName){
    return firestore
      .collection('employers')
      .where("employer_name", isEqualTo: companyName)
      .get();
  }
}