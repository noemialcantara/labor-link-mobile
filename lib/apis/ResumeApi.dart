import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ResumeApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getResumeByUser(String emailAddress) {

    return firestore
        .collection('resumes')
        .where("email_address",isEqualTo: emailAddress)
        .snapshots();
  }
  

  static uploadResume(PlatformFile file) async{
    await FirebaseStorage.instance.ref('resumes/${file.name}').putData(file.bytes!);
  }

}