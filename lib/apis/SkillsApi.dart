import 'package:cloud_firestore/cloud_firestore.dart';

class SkillsApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getSkills(String emailAddress) {

    return firestore
        .collection('skills')
        .where("email",isEqualTo: emailAddress)
        .snapshots();
  }

  static getSkillsData(String emailAddress) {

    return firestore
        .collection('skills')
        .where("email",isEqualTo: emailAddress)
        .get();
  }

  static addSkill(Map<String, dynamic> skillPayload) {

    return firestore
        .collection('skills')
        .add(skillPayload);
  }


  static Future<bool> deleteSkill(String email, String skillName){
    return  firestore.collection('skills').where("email", isEqualTo: email).where("skill_name", isEqualTo: skillName).snapshots().first.then((value) {
      String id = value.docs.first.id.toString();
      firestore
          .collection('skills').doc(id).delete();
      return true;
    });
  }

}