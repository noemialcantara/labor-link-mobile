import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionsApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static addTransaction(Map<String, dynamic> transactionPayload) {
    return firestore
        .collection('transactions')
        .add(transactionPayload);
  }

  static cancelTransaction(String transactionId){
    firestore.collection('transactions').where("transaction_id", isEqualTo: transactionId).snapshots().first.then((value) {
      String id = value.docs.first.id.toString();
      firestore
          .collection('transactions').doc(id).update({
            "status": "Cancelled"
          });
    });
  }

}