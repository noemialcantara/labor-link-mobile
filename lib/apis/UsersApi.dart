import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:labor_link_mobile/apis/FirebaseChatApi.dart';

class UsersApi {

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static createUser(bool isApplicantFirstMode, Map<String, dynamic>  user) {

    if(!isApplicantFirstMode){
       firestore
        .collection('employers')
        .add(user);
    }else{
       firestore
        .collection('applicants')
        .add(user);
    }
  }


  //this is for the existing applicants who is needed to have applicant data for user profile
  static Future<bool> urgentlyCreateUser(String emailAddress) async{
    Map<String, dynamic>  userPayload = {
          "address": "",
          "email_address": emailAddress,
          "full_name": await FirebaseChatApi.getCurrentUserData(emailAddress),
          "job_role": "",
          "minimum_expected_salary": "",
          "maximum_expected_salary": "",
          "profile_url": "https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fpngwing.com.png?alt=media&token=ab84abf3-f915-4422-a711-00314197b9ae",
          "years_of_experience": ""
    };

    return await firestore.collection('applicants').where("email_address", isEqualTo: emailAddress).get().then((value) {
      int applicantCount = value.docs.length;
      if(applicantCount == 0){
        firestore
              .collection('applicants')
              .add(userPayload);
      }

      return true;
    });
   
  }

  static updateUserProfile(Map<String, dynamic>  userData) {
    firestore.collection('applicants').where("email_address", isEqualTo: userData["email_address"]).snapshots().first.then((value) {
      String id = value.docs.first.id.toString();
      firestore
          .collection('applicants')
          .doc(id)
          .update(userData);
    });
  }

  static Future<QuerySnapshot> getApplicantData(String emailAddress){
    return firestore
      .collection('applicants')
      .where("email_address", isEqualTo: emailAddress)
      .get();
  }

  static Future<QuerySnapshot> getCompanyNameByEmail(String emailAddress){
    return firestore
      .collection('employers')
      .where("email_address", isEqualTo: emailAddress)
      .get();
  }

  static Future<QuerySnapshot> getEmployerDataByName(String companyName){
    return firestore
      .collection('employers')
      .where("employer_name", isEqualTo: companyName)
      .get();
  }

  static Future<QuerySnapshot> getCompanyDetailsByName(String companyName){
    return firestore
      .collection('employers')
      .where("employer_name", isEqualTo: companyName)
      .get();
  }
}