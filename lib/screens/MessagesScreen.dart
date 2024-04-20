import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // Reverse the order of children to position search icon on right
          children: [
            Expanded(
            child: Text(
              'Messages',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            ),
            const SizedBox(width:185), // Add spacing between text and icon
            const Icon(Icons.search, color: Colors.blue,),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              //Employer Message Section (Can be replaced with your message list)
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  //icon: const Icon(Icons.search), // Leading search icon
                  hintText: "Search a chat or message",
                  hintStyle: const TextStyle(color: Colors.grey), // Hint text color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
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
