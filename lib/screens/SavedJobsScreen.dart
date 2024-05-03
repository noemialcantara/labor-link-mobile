import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedJobsScreen extends StatefulWidget {
  const SavedJobsScreen({Key? key}) : super(key: key);

  @override
  _SavedJobsScreenState createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(height: 50),
              Padding(child: Text("Saved Jobs", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 25)), padding: EdgeInsets.only(left:25,right:25),),
        SizedBox(height: 50),
        Center(child:  Text(
          'No saved jobs yet!',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(0xff0D0D26)
          ),
        )),
      
      ])
    );
  }
}
