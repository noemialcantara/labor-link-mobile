import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:labor_link_mobile/models/Resume.dart';

class ResumeApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getResumeByUser(String emailAddress) {

    return firestore
        .collection('resumes')
        .where("email_address",isEqualTo: emailAddress)
        .snapshots();
  }
  

  static uploadResume(PlatformFile file, String profileJob, String profileName, String emailAddress) async{
    final File convertedFile = File(file.path!);
    await FirebaseStorage.instance.ref('resumes/${file.name}').putFile(convertedFile);

    final Reference ref = FirebaseStorage.instance.ref().child('resumes/${file.name}');
    final String resumeLink = await ref.getDownloadURL();

    Resume payload = Resume(file.name, resumeLink, profileJob, profileName, emailAddress);
    firestore
        .collection('resumes')
        .add(payload.toJson());
  }

  static deleteResumePerLinkId(String resumeLinkId) async{
    firestore.collection('resumes').where("link", isEqualTo: resumeLinkId).snapshots().first.then((value) {
      String id = value.docs.first.id.toString();
      firestore
          .collection('resumes').doc(id).delete();
    });
    FirebaseStorage.instance.refFromURL(resumeLinkId).delete();

  }

}