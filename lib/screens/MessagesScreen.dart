import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/FirebaseChatApi.dart';
import 'package:labor_link_mobile/components/CustomTextField.dart';
import 'package:labor_link_mobile/helper/dialogs.dart';
import 'package:labor_link_mobile/main.dart';
import 'package:labor_link_mobile/models/ChatUser.dart';
import 'package:labor_link_mobile/screens/widgets/ChatUserCard.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<ChatUser> _chatUserList = [];
  final List<ChatUser> _searchUserList = [];
  TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  
  @override
  void initState() {
    super.initState();

    FirebaseChatApi.getSelfInfo();

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (FirebaseChatApi.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          FirebaseChatApi.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          FirebaseChatApi.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  // for adding new chat user
  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: const Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Message a user')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Enter the email address',
                    prefixIcon: const Icon(Icons.email, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.blue, fontSize: 16))),

                //add button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      if (email.isNotEmpty) {
                        await FirebaseChatApi.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'User does not exists!');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          // Reverse children order for right-aligned search icon
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
            const SizedBox(width: 185), // Spacing between text and icon
            const Icon(Icons.search, color: Colors.blue),
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
              const SizedBox(height: 100),
              TextField(
                decoration: InputDecoration(
                  icon: const Icon(Icons.search), // Leading search icon (not needed)
                  hintText: "Search a chat or message",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Padding(child: Text("Messages", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 25)), padding: EdgeInsets.only(left:25,right:25),),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left:25,right:25),
                child: SizedBox(height: 50 , child: TextField(
                  controller: _searchController,
                  obscureText: false,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      prefixIconColor: Color(0xffAFB0B6),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffAFB0B6)),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffAFB0B6)),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      filled: false,
                      hintText: "Search a chat or message",
                      hintStyle: GoogleFonts.poppins(color: Color(0xffAFB0B6))),
                )),
              ),
              SizedBox(height: 25),
              Padding(child: Text("Employers", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 21)), padding: EdgeInsets.only(left:25,right:25),),
              SizedBox(height:20),
              Container(
              height: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height * .32),
              child: StreamBuilder(
            stream: FirebaseChatApi.getMyUsersId(),

            //get id of only known users
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

                //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                    stream: FirebaseChatApi.getAllUsers(
                        snapshot.data?.docs.map((e) => e.id).toList() ?? []),

                    //get only those user, who's ids are provided
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        // return const Center(
                        //     child: CircularProgressIndicator());

                        //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _chatUserList = data
                                  ?.map((e) => ChatUser.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_chatUserList.isNotEmpty) {
                            return ListView.builder(
                                itemCount: _isSearching
                                    ? _chatUserList.length
                                    : _chatUserList.length,
                                padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ChatUserCard(
                                      user: _isSearching
                                          ? _chatUserList[index]
                                          : _chatUserList[index]);
                                });
                          } else {
                            return const Center(
                              child: Text('No chat messages found yet',
                                  style: TextStyle(fontSize: 20)),
                            );
                          }
                      }
                    },
                  );
              }
            },
          ),
            )
        ])),
      ),
    );
  }
}