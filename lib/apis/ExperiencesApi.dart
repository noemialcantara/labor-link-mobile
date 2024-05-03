import 'package:cloud_firestore/cloud_firestore.dart';

class ExperiencesApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getExperiences(String emailAddress) {

    return firestore
        .collection('experiences')
        .where("email_address",isEqualTo: emailAddress)
        .snapshots();
  }

  static addExperience(Map<String, dynamic> experiencePayload) {

    return firestore
        .collection('experiences')
        .add(experiencePayload);
  }

  static deleteExperience(String experienceId){
    firestore.collection('experiences').where("id", isEqualTo: experienceId).snapshots().first.then((value) {
      String id = value.docs.first.id.toString();
      firestore
          .collection('experiences').doc(id).delete();
    });
  }

}