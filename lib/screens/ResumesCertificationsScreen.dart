import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labor_link_mobile/apis/ResumeApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/models/Resume.dart';
import 'package:labor_link_mobile/screens/MainNavigationHandler.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:random_avatar/random_avatar.dart';
import 'dart:math' show min;

class ResumesCertificationsScreen extends StatefulWidget {
  final String userName;

  ResumesCertificationsScreen({Key? key, required this.userName}) : super(key: key);

  @override
  State<ResumesCertificationsScreen> createState() => _ResumesCertificationsScreenState();
}

class _ResumesCertificationsScreenState extends State<ResumesCertificationsScreen> {
  TextEditingController profileJobEditingController = TextEditingController();
  TextEditingController profileNameEditingController = TextEditingController();
  final List<XFile> _certificationsList = [];
  String userEmail = "test@gmail.com";

  bool _dragging = false;

  Offset? offset;

  uploadResume(PlatformFile file, String profileJob, String profileName) {
    ResumeApi.uploadResume(file, profileJob, profileName, userEmail);
  }

  Widget uploadedResumeList(BuildContext parentContext) {
    return StreamBuilder(
        stream: ResumeApi.getResumeByUser(userEmail),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    snapshot.data?.docs[index].get("file_name"),
                                    style: TextStyle(fontSize: 13, color: Colors.black),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        String linkId = snapshot.data?.docs[index].get("link");
                                        ResumeApi.deleteResumePerLinkId(linkId);
                                        AwesomeDialog(
                                          context: parentContext,
                                          dialogType: DialogType.success,
                                          animType: AnimType.rightSlide,
                                          title: 'Alert!',
                                          desc: 'Successfully deleted this resume',
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
                "There is no uploaded files yet",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 16),
              );
          }
        });
  }

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  void _getUserEmail() {
    setState(() {
      userEmail = FirebaseAuth.instance.currentUser!.email ?? "test@gmail.com";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 80,
            bottomOpacity: 0.0,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              "Resume & Certifications",
              style: GoogleFonts.poppins(color: Color(0xff0D0D26), fontSize: 22, fontWeight: FontWeight.w600),
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
                'Resume',
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(color: Color(0xff0D0D26), fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 30),
            Container(
                decoration: const BoxDecoration(
                    border: DashedBorder.fromBorderSide(dashLength: 8, side: BorderSide(color: Color(0xff356899), width: 2)),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: EdgeInsets.only(left: 30, right: 30),
                padding: EdgeInsets.only(top: 30, bottom: 30),
                width: double.infinity,
                child: Column(children: [
                  Text(
                    "Upload your CV or Resume and",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 16),
                  ),
                  Text(
                    "use it when you apply for jobs",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 16),
                  ),
                  SizedBox(height: 25),
                  Text(
                    "Uploaded Files",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  uploadedResumeList(context),
                  SizedBox(height: 10),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: CustomButton(
                        text: "Upload a Doc/Docx/PDF",
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['docx', 'pdf', 'doc'],
                          );
                          if (result != null) {
                            PlatformFile file = result.files.first;
                            profileJobEditingController.text = "";
                            profileNameEditingController.text = "";

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Add reference to your resume'),
                                  content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: profileJobEditingController,
                                          decoration: InputDecoration(hintText: "Enter the job title"),
                                        ),
                                        TextField(
                                          controller: profileNameEditingController,
                                          decoration: InputDecoration(hintText: "Enter your name"),
                                        ),
                                      ]),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Submit'),
                                      onPressed: () {
                                        uploadResume(file, profileJobEditingController.text, profileNameEditingController.text);
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.success,
                                          animType: AnimType.rightSlide,
                                          title: 'Alert!',
                                          desc: 'Successfully uploaded the resume',
                                          btnOkOnPress: () {
                                            Navigator.pop(context);
                                          },
                                        )..show();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      )),
                ])),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Row(children: [
                Text(
                  'Certification',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(color: Color(0xff0D0D26), fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  ' (Optional)',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(color: Color(0xffAFB0B6), fontSize: 17, fontWeight: FontWeight.w600),
                )
              ]),
            ),
            SizedBox(height: 30),
            DropTarget(
              onDragDone: (detail) async {
                setState(() {
                  _certificationsList.addAll(detail.files);
                });

                debugPrint('onDragDone:');
                for (final file in detail.files) {
                  debugPrint('  ${file.path} ${file.name}'
                      '  ${await file.lastModified()}'
                      '  ${await file.length()}'
                      '  ${file.mimeType}');
                }
              },
              onDragUpdated: (details) {
                setState(() {
                  offset = details.localPosition;
                });
              },
              onDragEntered: (detail) {
                setState(() {
                  _dragging = true;
                  offset = detail.localPosition;
                });
              },
              onDragExited: (detail) {
                setState(() {
                  _dragging = false;
                  offset = null;
                });
              },
              child: Container(
                decoration: const BoxDecoration(
                    border: DashedBorder.fromBorderSide(dashLength: 8, side: BorderSide(color: Color(0xff356899), width: 2)),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: EdgeInsets.only(left: 30, right: 30),
                height: 250,
                width: double.infinity,
                child: Stack(
                  children: [
                    if (_certificationsList.isEmpty)
                      Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Upload your certification",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 16),
                          ),
                          SizedBox(height: 25),
                          Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: CustomButton(
                                text: "Upload a PNG/JPG",
                                onTap: () async {
                                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['png', 'jpg', 'jpeg'],
                                  );
                                  if (result != null) {
                                    PlatformFile file = result.files.first;
                                    profileJobEditingController.text = "";
                                    profileNameEditingController.text = "";

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Add reference to your certification'),
                                          content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                              ]),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Submit'),
                                              onPressed: () {
                                                uploadResume(file, profileJobEditingController.text, profileNameEditingController.text);
                                                AwesomeDialog(
                                                  context: context,
                                                  dialogType: DialogType.success,
                                                  animType: AnimType.rightSlide,
                                                  title: 'Alert!',
                                                  desc: 'Successfully uploaded the resume',
                                                  btnOkOnPress: () {
                                                    Navigator.pop(context);
                                                  },
                                                )..show();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              )),
                        ],
                      ))
                    else
                      Text(_certificationsList.map((e) => e.path).join("\n")),
                    if (offset != null)
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          '$offset',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        )));
  }
}
