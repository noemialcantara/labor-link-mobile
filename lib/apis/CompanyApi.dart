import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCompanyDetailsByName(String companyName) {

    return firestore
        .collection('employers')
        .where("employer_name",isEqualTo: companyName)
        .snapshots();
  }

}