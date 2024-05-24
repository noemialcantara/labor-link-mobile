import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labor_link_mobile/apis/IDUploadApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/constants/IDTypesConstants.dart';
import 'package:labor_link_mobile/screens/MainNavigationHandler.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:random_avatar/random_avatar.dart';
import 'dart:math' show min;

import 'package:url_launcher/url_launcher.dart';

class EmployerIDVerificationScreen extends StatefulWidget {
  EmployerIDVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmployerIDVerificationScreen> createState() =>
      _EmployerIDVerificationScreenState();
}

class _EmployerIDVerificationScreenState
    extends State<EmployerIDVerificationScreen> {
  Future<void> launch(String url, {bool isNewTab = true}) async {
    await launchUrl(
      Uri.parse(url),
      webOnlyWindowName: isNewTab ? '_blank' : '_self',
    );
  }

  Widget uploadedFiles(BuildContext parentContext, String idType) {
    return StreamBuilder(
        stream: IDUploadApi.getUploadedIDByUserEmail(
            FirebaseAuth.instance.currentUser?.email ?? "", idType),
        builder: (context, snapshot) {
          var streamDataLength = snapshot.data?.docs.length ?? 0;

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.done:
              if (streamDataLength > 0)
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (ctx, index) => Container(
                    margin: EdgeInsets.only(left: 30, right: 30, bottom: 15),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            spreadRadius: 2,
                          )
                        ]),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      child: Text(
                                    snapshot.data?.docs[index].get("file_name"),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black),
                                  )),
                                  GestureDetector(
                                      onTap: () {
                                        String linkId = snapshot
                                            .data?.docs[index]
                                            .get("link");
                                        IDUploadApi.deleteIDByLinkId(linkId);
                                        AwesomeDialog(
                                          context: parentContext,
                                          dialogType: DialogType.success,
                                          animType: AnimType.rightSlide,
                                          title: 'Alert!',
                                          desc: 'Successfully deleted this ID.',
                                          btnOkOnPress: () {},
                                        )..show();
                                      },
                                      child: Icon(Icons.remove_circle))
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                );

              return Text(
                "There are no uploaded files yet",
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 16),
              );
          }
        });
  }

  uploadID(PlatformFile file, String idType) {
    IDUploadApi.uploadID(file, FirebaseAuth.instance.currentUser?.email ?? "",
        idType, "employer");
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Alert!',
      desc: "Successfully uploaded the ${idType.replaceAll("_", " ")}",
      btnOkOnPress: () {},
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 80,
            bottomOpacity: 0.0,
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            title: Text(
              "ID Verification",
              style: GoogleFonts.poppins(
                  color: Color(0xff0D0D26),
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Text(
                  'Upload 1 Primary Govt. ID of Owner',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                      color: Color(0xff0D0D26),
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 30),
              Container(
                decoration: const BoxDecoration(
                    border: DashedBorder.fromBorderSide(
                        dashLength: 8,
                        side: BorderSide(color: Color(0xff356899), width: 2)),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                padding: EdgeInsets.only(top: 30, bottom: 30),
                width: double.infinity,
                child: Stack(
                  children: [
                    Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Text(
                            "Upload 1 Primary ID",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                color: Color(0xff95969D), fontSize: 16),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "(Please check this ",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      color: Color(0xff95969D), fontSize: 16),
                                ),
                                GestureDetector(
                                    onTap: () => {
                                          launch(
                                              'https://governmentph.com/list-valid-id-in-the-philippines/',
                                              isNewTab: true)
                                        },
                                    child: Text(
                                      "link",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Color(0xff356899),
                                        fontSize: 16,
                                      ),
                                    )),
                                Text(
                                  " for more info)",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      color: Color(0xff95969D), fontSize: 16),
                                )
                              ]),
                          SizedBox(height: 25),
                          Text(
                            "Uploaded Files",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                                color: Color(0xff95969D), fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          uploadedFiles(context, PRIMARY),
                          SizedBox(height: 25),
                          Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: CustomButton(
                                text: "Upload a PNG/JPG",
                                onTap: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['png', 'jpg', 'jpeg'],
                                  );

                                  if (result != null) {
                                    PlatformFile file = result.files.first;

                                    uploadID(file, PRIMARY);
                                  }
                                },
                              )),
                        ]))
                  ],
                ),
              ),
              SizedBox(height: 40),
              Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload the Business Permit',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                              color: Color(0xff0D0D26),
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ])),
              SizedBox(height: 30),
              Container(
                decoration: const BoxDecoration(
                    border: DashedBorder.fromBorderSide(
                        dashLength: 8,
                        side: BorderSide(color: Color(0xff356899), width: 2)),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: EdgeInsets.only(left: 30, right: 30, bottom: 30),
                padding: EdgeInsets.only(top: 30, bottom: 30),
                width: double.infinity,
                child: Stack(
                  children: [
                    Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Text(
                            "Upload 1 Business Permit",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                color: Color(0xff95969D), fontSize: 16),
                          ),
                          SizedBox(height: 25),
                          Text(
                            "Uploaded Files",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                                color: Color(0xff95969D), fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          uploadedFiles(context, BUSINESS_PERMIT),
                          SizedBox(height: 25),
                          Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: CustomButton(
                                text: "Upload a PNG/JPG",
                                onTap: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['png', 'jpg', 'jpeg'],
                                  );

                                  if (result != null) {
                                    PlatformFile file = result.files.first;

                                    uploadID(file, BUSINESS_PERMIT);
                                  }
                                },
                              )),
                        ]))
                  ],
                ),
              ),
              SizedBox(height: 30),
            ])));
  }
}
