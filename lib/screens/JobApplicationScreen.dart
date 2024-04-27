import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/screens/widgets/IconText.dart';


class JobApplicationScreen extends StatefulWidget {
  final Job job; // Pass the Job object containing job details

  const JobApplicationScreen({Key? key, required this.job}) : super(key: key);

  @override
  _JobApplicationScreenState createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {
  String _selectedProfile = 'John Doe'; // Initialize selected profile
  String _selectedResume = 'John Doe Resume'; // Initialize selected resume
  bool _coverLetter = false; // Initialize cover letter checkbox
  final TextEditingController _coverLetterController = TextEditingController(); // Cover letter text field controller

  @override
  Widget build(BuildContext context) {
    final Job job = widget.job; // Access passed Job object

    return Scaffold(
      appBar: AppBar(
        title: Text('Job Application: ${job.title}'), // Display job title
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Handle form submission logic (consider validation, network calls)
              print('Submitted application for ${job.title}');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job details section
            Text(
              job.title,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                IconText(icon: Icons.attach_money, text: "32"),
                SizedBox(width: 16.0),
                IconText(icon: Icons.location_on, text: job.location),
              ],
            ),
            SizedBox(height: 16.0),
            Text(job.company), // Display company name
            SizedBox(height: 16.0),

            // Application form section
            Text('Select a profile:'),
            DropdownButton<String>(
              value: _selectedProfile,
              items: const [
                // Add dropdown menu items for profiles
                DropdownMenuItem(
                  child: Text('John Doe'),
                  value: 'John Doe',
                ),
                // ...more profile items
              ],
              onChanged: (value) => setState(() => _selectedProfile = value!),
            ),
            SizedBox(height: 16.0),
            Text('Select a resume:'),
            DropdownButton<String>(
              value: _selectedResume,
              items: const [
                // Add dropdown menu items for resumes
                DropdownMenuItem(
                  child: Text('John Doe Resume'),
                  value: 'John Doe Resume',
                ),
                // ...more resume items
              ],
              onChanged: (value) => setState(() => _selectedResume = value!),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: _coverLetter,
                  onChanged: (value) => setState(() => _coverLetter = value!),
                ),
                Text('Cover Letter (Optional)'),
              ],
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _coverLetterController,
              decoration: InputDecoration(
                hintText: 'Write a cover letter',
                enabled: _coverLetter,
              ),
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Handle upload functionality (file picker, etc.)
                    print('Upload functionality not yet implemented');
                  },
                  child: Text('Upload'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Submit the application (call the onPressed function from AppBar's IconButton)
                  },
                  child: Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
