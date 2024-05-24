import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:labor_link_mobile/models/IDUpload.dart';
import 'package:labor_link_mobile/models/Resume.dart';

class IDUploadApi {
  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUploadedIDByUserEmail(
      String emailAddress, String idType) {
    return firestore
        .collection('id_verifications')
        .where("email_address", isEqualTo: emailAddress)
        .where("id_type", isEqualTo: idType)
        .snapshots();
  }

  static uploadID(PlatformFile file, String emailAddress, String idType,
      String userType) async {
    final File convertedFile = File(file.path!);
    await FirebaseStorage.instance
        .ref('id_uploads/$idType/${file.name}')
        .putFile(convertedFile);

    final Reference ref =
        FirebaseStorage.instance.ref().child('id_uploads/$idType/${file.name}');
    String resumeLink = await ref.getDownloadURL();

    IDUpload payload =
        IDUpload(file.name, resumeLink, emailAddress, idType, userType);
    firestore.collection('id_verifications').add(payload.toJson());
  }

  static deleteIDByLinkId(String linkId) async {
    firestore
        .collection('id_verifications')
        .where("link", isEqualTo: linkId)
        .snapshots()
        .first
        .then((value) {
      String id = value.docs.first.id.toString();
      firestore.collection('id_verifications').doc(id).delete();
    });
    FirebaseStorage.instance.refFromURL(linkId).delete();
  }
}
