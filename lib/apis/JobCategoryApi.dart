import 'package:cloud_firestore/cloud_firestore.dart';

class JobCategoryApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getJobCategories() {

    return firestore
        .collection('job_categories')
        .snapshots();
  }

}