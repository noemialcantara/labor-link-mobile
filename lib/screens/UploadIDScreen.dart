import 'package:flutter/material.dart';

class UploadIDScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Your ID'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            UploadSection(
              title: 'Upload 1 Primary ID',
              subtitle: 'Please check this link for more info',
            ),
            SizedBox(height: 20),
            UploadSection(
              title: 'Upload 1 Secondary Government ID (Optional)',
              subtitle: 'Please check this link for more info',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement save functionality
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class UploadSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const UploadSection({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement upload functionality
              },
              child: Text('Upload a PNG/JPG'),
            ),
          ],
        ),
      ),
    );
  }
}
