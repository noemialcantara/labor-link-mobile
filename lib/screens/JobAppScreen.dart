import 'package:flutter/material.dart';


void main() {
  runApp(JobAppScreen());
}

class JobAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Apply', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Open Position',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 2.0),
              Text(
                'Company Name',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Salary per month',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    'Company Address',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.0),
              Text(
                'Select Profile',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: SingleChildScrollView(
                  child: ProfileSelection(),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Select a Resume',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: SingleChildScrollView(
                  child: ResumeSelection(),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Cover Letter (optional)',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height:15.0),
              Expanded(
                child: TextFormField(
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Write a cover letter...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add functionality to upload cover letter
                    },
                    icon: Icon(Icons.file_upload),
                    label: Text('Upload PDF', style: TextStyle(fontFamily: 'Poppins')),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Apply', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xff356899)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(15)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileSelection extends StatefulWidget {
  @override
  _ProfileSelectionState createState() => _ProfileSelectionState();
}

class _ProfileSelectionState extends State<ProfileSelection> {
  int _selectedProfile = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('Profile 1', style: TextStyle(fontFamily: 'Poppins')),
          leading: Radio(
            value: 1,
            groupValue: _selectedProfile,
            onChanged: (int? value) {
              setState(() {
                _selectedProfile = value!;
              });
            },
          ),
        ),
        ListTile(
          title: Text('Profile 2', style: TextStyle(fontFamily: 'Poppins')),
          leading: Radio(
            value: 2,
            groupValue: _selectedProfile,
            onChanged: (int? value) {
              setState(() {
                _selectedProfile = value!;
              });
            },
          ),
        ),
      ],
    );
  }
}

class ResumeSelection extends StatefulWidget {
  @override
  _ResumeSelectionState createState() => _ResumeSelectionState();
}

class _ResumeSelectionState extends State<ResumeSelection> {
  int _selectedResume = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('Resume 1', style: TextStyle(fontFamily: 'Poppins')),
          leading: Radio(
            value: 1,
            groupValue: _selectedResume,
            onChanged: (int? value) {
              setState(() {
                _selectedResume = value!;
              });
            },
          ),
        ),
        ListTile(
          title: Text('Resume 2', style: TextStyle(fontFamily: 'Poppins')),
          leading: Radio(
            value: 2,
            groupValue: _selectedResume,
            onChanged: (int? value) {
              setState(() {
                _selectedResume = value!;
              });
            },
          ),
        ),
      ],
    );
  }
}
