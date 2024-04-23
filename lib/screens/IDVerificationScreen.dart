import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/screens/MainNavigationHandler.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:random_avatar/random_avatar.dart';
import 'dart:math' show min;

import 'package:url_launcher/url_launcher.dart';

class IDVerificationScreen extends StatefulWidget {
 
  IDVerificationScreen({Key? key}) : super(key: key);

  @override
  State<IDVerificationScreen> createState() => _IDVerificationScreenState();
}

class _IDVerificationScreenState extends State<IDVerificationScreen> {
  final List<XFile> _resumeList = [];
  final List<XFile> _certificationsList = [];

  bool _dragging = false;

  Offset? offset;

  Future<void> launch(String url, {bool isNewTab = true}) async {
    await launchUrl(
      Uri.parse(url),
      webOnlyWindowName: isNewTab ? '_blank' : '_self',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
                bottomOpacity: 0.0,
                elevation: 0.0,
                iconTheme: IconThemeData( color: Colors. black, ), title: Text("ID Verification", style: GoogleFonts.poppins(color:Color(0xff0D0D26), fontSize: 22,fontWeight: FontWeight.w600),),centerTitle: true,backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height:30),
              Padding(
                padding: EdgeInsets.only(left:30,right:30),
                child: Text('Upload 1 Primary Government ID',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 20, fontWeight: FontWeight.w600),),
              ),
              SizedBox(height: 30),
              DropTarget(
                  onDragDone: (detail) async {
                    setState(() {
                      _resumeList.addAll(detail.files);
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
                        border: DashedBorder.fromBorderSide(
                            dashLength: 8, side: BorderSide(color: Color(0xff356899), width: 2)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    margin: EdgeInsets.only(left:30,right:30),
                    height: 200,
                    width: double.infinity,
                    // color: _dragging ? Colors.blue.withOpacity(0.4) : Colors.black26,
                    child: Stack(
                      children: [
                        if (_resumeList.isEmpty)
                           Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Upload 1 Primary ID",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 16),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                        Text("(Please check this ",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 16),),
                                        GestureDetector(
                                          onTap: () => {
                                            launch('https://governmentph.com/list-valid-id-in-the-philippines/', isNewTab: true)
                                          },
                                          child: Text("link",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff356899), fontSize: 16,),)),
                                        Text(" for more info)",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 16),)
                                      ]),
                                      SizedBox(height: 25),
                                      Padding(
                                        padding: EdgeInsets.only(left:20,right:20),
                                        child: CustomButton(
                                        text: "Upload a PNG/JPG",
                                        onTap: () => (){},
                                      )),
                                    ]
                                  )
                                )
                        else
                          Text(_resumeList.map((e) => e.path).join("\n")),
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
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.only(left:30,right:30),
                child: 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text('Upload 1 Secondary Government ID',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xff0D0D26),fontSize: 20, fontWeight: FontWeight.w600),),
                    Text('(Optional)',textAlign: TextAlign.left, style: GoogleFonts.poppins(color: Color(0xffAFB0B6),fontSize: 17, fontWeight: FontWeight.w600))
                  ])
                ),
              SizedBox(height:30),
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
                        border: DashedBorder.fromBorderSide(
                            dashLength: 8, side: BorderSide(color: Color(0xff356899), width: 2)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    margin: EdgeInsets.only(left:30,right:30,bottom: 30),
                    height: 200,
                    width: double.infinity,
                    // color: _dragging ? Colors.blue.withOpacity(0.4) : Colors.black26,
                    child: Stack(
                      children: [
                        if (_certificationsList.isEmpty)
                           Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Upload 1 Secondary ID",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 16),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                        Text("(Please check this ",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 16),),
                                        GestureDetector(
                                          onTap: () => {
                                            launch('https://governmentph.com/list-valid-id-in-the-philippines/', isNewTab: true)
                                          },
                                          child: Text("link",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff356899), fontSize: 16,),)),
                                        Text(" for more info)",textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Color(0xff95969D), fontSize: 16),)
                                      ]),
                                      SizedBox(height: 25),
                                      Padding(
                                        padding: EdgeInsets.only(left:20,right:20),
                                        child: CustomButton(
                                        text: "Upload a PNG/JPG",
                                        onTap: () => (){},
                                      )),
                                    ]
                                  )
                                )
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
                Padding(
                  padding: EdgeInsets.only(left:20,right:20),
                  child: CustomButton(
                  text: "Save",
                  onTap: () => (){},
                )),
                SizedBox(height:30),
             
            ]
          )
      )
    );
  }
}
