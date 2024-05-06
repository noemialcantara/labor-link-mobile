import 'package:cloud_firestore/cloud_firestore.dart';

class SavedJobsApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getSavedJobsByEmail(String emailAddress) {

    return firestore
        .collection('saved_jobs')
        .where("email_address",isEqualTo: emailAddress)
        .snapshots();
  }
  

   static Future<bool> getSaveJobStatusByJobId(String jobId, String email) {
    var data = firestore
        .collection('saved_jobs')
        .where("email_address", isEqualTo: email)
        .where("job_id",isEqualTo: jobId)
        .get();

      return data.then((value) {
        int job  = value.docs.length;
        return job > 0 ? true : false;
      });

  }

  static addSaveJob(Map<String, dynamic> payload) {
    return firestore
        .collection('saved_jobs')
        .add(payload);
  }


  static deleteSavedJob(String id){
    return  firestore.collection('saved_jobs').where("job_id", isEqualTo: id).snapshots().first.then((value) {
      String id = value.docs.first.id.toString();
      firestore
          .collection('saved_jobs').doc(id).delete();
    });
  }

}