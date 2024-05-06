import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:labor_link_mobile/models/Certification.dart';
import 'package:labor_link_mobile/models/IDUpload.dart';
import 'package:labor_link_mobile/models/Resume.dart';

class CertificationApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUploadedIDByUserEmail(String emailAddress) {

    return firestore
        .collection('certifications')
        .where("email_address",isEqualTo: emailAddress)
        .snapshots();
  }

  static uploadID(PlatformFile file, String emailAddress) async{
    final File convertedFile = File(file.path!);
    await FirebaseStorage.instance.ref('certifications/${file.name}').putFile(convertedFile);

    final Reference ref = FirebaseStorage.instance.ref().child('certifications/${file.name}');
    String link = await ref.getDownloadURL();

    Certification payload = Certification(file.name, link, emailAddress);
    firestore
        .collection('certifications')
        .add(payload.toJson());
  }

  static deleteIDByLinkId(String linkId) async{
    firestore.collection('certifications').where("link", isEqualTo: linkId).snapshots().first.then((value) {
      String id = value.docs.first.id.toString();
      firestore
          .collection('certifications').doc(id).delete();
    });
    FirebaseStorage.instance.refFromURL(linkId).delete();
  }
}