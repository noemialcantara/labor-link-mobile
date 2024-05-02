import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/FirebaseChatApi.dart';
import 'package:labor_link_mobile/apis/UsersApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/components/CustomTextField.dart';
import 'package:labor_link_mobile/components/SquareTile.dart';
import 'package:labor_link_mobile/screens/LoginScreen.dart';

class RegistrationScreen extends StatefulWidget {
  bool isApplicantFirstMode;

  RegistrationScreen({Key? key, required this.isApplicantFirstMode}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String registrationDescription = '';

  void showmessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(backgroundColor: Color(0xffffffff), title: Text(errorMessage,style: GoogleFonts.poppins(fontSize: 18),));
        });
  }

  void _signUserup(BuildContext context) async {
    if (_passwordController.text != _confirmPasswordController.text) {
      showmessage("Password does not match");
      return;
    }

    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      await FirebaseChatApi.createUser(_fullNameController.text, widget.isApplicantFirstMode);

       Map<String, dynamic> userPayload = {};

      if(widget.isApplicantFirstMode){
        userPayload = {
          "full_name": _fullNameController.text,
          "address": "No data yet",
          "about_me": "No data yet",
          "skills": [],
          "email_address": _emailController.text,
        };
      }else{
         userPayload = {
          "employer_name": _fullNameController.text,
          "employer_address": "No data yet",
          "employer_about": "No data yet",  
          "year_founded": "No data yet",
          "owner": "No data yet",
          "email_address": _emailController.text,
        };
      }

       UsersApi.createUser(widget.isApplicantFirstMode, userPayload);
      
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      //wrong Email
      showmessage(e.message.toString());
    }
  }

  _switchUser(){
    if(widget.isApplicantFirstMode){
      setState(() {
        registrationDescription = 'Let\'s register. Apply to jobs!';
      });
      
    }
    else{
      setState(() {
        registrationDescription = 'Let\'s register. Post your jobs!';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _switchUser();
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFD),
      body: SafeArea(
        child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 50),
              Padding(child: Text('LaborLink', style: GoogleFonts.poppins(color: Color(0xff356899), fontSize:24,fontWeight: FontWeight.w600),), padding: EdgeInsets.only(left:10,right:10),),
              const SizedBox(height:10),
              Padding(child: Text('Registration', style: GoogleFonts.poppins(color: Color(0xff000000), fontSize:28,fontWeight: FontWeight.w600),), padding: EdgeInsets.only(left:10,right:10),),
              const SizedBox(height:10),
              Padding(child: Text(registrationDescription, style: GoogleFonts.poppins(color: Color(0xff0D0D26), fontSize:15,fontWeight: FontWeight.normal)), padding: EdgeInsets.only(left:10,right:10),),
              
              const SizedBox(height: 45),
              CustomTextField(
                prefixIcon: Icon(Icons.person_outline),
                controller: _fullNameController,
                hintText: widget.isApplicantFirstMode ? 'Full Name' : 'Company Name',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                prefixIcon: Icon(Icons.email_outlined),
                controller: _emailController,
                hintText: 'E-mail',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                 prefixIcon: Icon(Icons.key_outlined),
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              
              const SizedBox(height: 20),
              CustomTextField(
                 prefixIcon: Icon(Icons.key_outlined),
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),

              const SizedBox(height: 30),
              CustomButton(
                text: "Register",
                onTap: () => _signUserup(context),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Color(0xffAFB0B6),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Or continue with',  
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(color: Color(0xffAFB0B6), fontWeight: FontWeight.w600),),
                    ),
                    Expanded(
                      child: Divider(
                        color: Color(0xffAFB0B6),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
             
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SquareTile(imagePath: 'assets/images/apple.png'),
                  SizedBox(width: 25),
                  SquareTile(imagePath: 'assets/images/google.png'),
                  SizedBox(width: 25),
                  SquareTile(imagePath: 'assets/images/facebook.png'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Have an account?',
                    style: GoogleFonts.poppins(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap:(){
                       Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => LoginScreen(isApplicantFirstMode: widget.isApplicantFirstMode,)));
                    } ,
                    child:  Text(
                      'Log in',
                      style: GoogleFonts.poppins(
                        color: Color(0xff356899),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
      ),
    );
  }
}