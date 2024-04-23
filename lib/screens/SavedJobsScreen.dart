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
      appBar: AppBar(
        title: Text(
          'Saved Jobs',
          style: GoogleFonts.poppins(), // Using Google Fonts for the app bar text style
        ),
      ),
      body: Center(
        child: Text(
          'No saved jobs yet!',
          style: GoogleFonts.poppins( // Using Google Fonts for the text style
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
