import 'package:cloud_firestore/cloud_firestore.dart';

class SubscribersApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getPlanDetails(String emailAddress) {

    return firestore
        .collection('subscribers')
        .orderBy('created_on', descending: true)
        .where("employer_email_address",isEqualTo: emailAddress)
        .snapshots();
  }

  static  getUserPlan(String emailAddress) {

    return firestore
        .collection('subscribers')
        .orderBy('created_on', descending: true)
        .where("employer_email_address",isEqualTo: emailAddress)
        .get();
  }

  static addSubscription(Map<String, dynamic> subscriptionPayload) {
    return firestore
        .collection('subscribers')
        .add(subscriptionPayload);
  }

  static cancelSubscription(String subscriberId){
    firestore.collection('subscribers').where("id", isEqualTo: subscriberId).snapshots().first.then((value) {
      String id = value.docs.first.id.toString();
      firestore
          .collection('subscribers').doc(id).update({
            "is_cancelled": "true"
          });
    });
  }

}