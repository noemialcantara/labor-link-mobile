import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/components/CustomTextField.dart';
import 'package:labor_link_mobile/components/SquareTile.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;

  LoginScreen({super.key,required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  void showmessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog( backgroundColor: Color(0xffffffff), title: Text(errorMessage, style: GoogleFonts.poppins(fontSize: 18),));
        });
  }

  void _signUserIn(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      //wrong Email
      showmessage(e.message.toString());
    }
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
              Padding(child: Text('Welcome Back', style: GoogleFonts.poppins(color: Color(0xff000000), fontSize:28,fontWeight: FontWeight.w600),), padding: EdgeInsets.only(left:10,right:10),),
              const SizedBox(height:10),
              Padding(child: Text('Let\'s Login. Apply to jobs!', style: GoogleFonts.poppins(color: Color(0xff0D0D26), fontSize:15,fontWeight: FontWeight.normal)), padding: EdgeInsets.only(left:10,right:10),),
              
              const SizedBox(height: 45),
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
              const SizedBox(height: 10),
              const SizedBox(height: 25),
              CustomButton(
                text: "Log in",
                onTap: () => _signUserIn(context),
              ),
              const SizedBox(height: 20),
              Text(
                    'Forgot Password?',
                    style: GoogleFonts.poppins(color: Color(0xff356899), fontWeight: FontWeight.w600), textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              Text(
                    'Switch to Employer',
                    style: GoogleFonts.poppins(color: Color(0xff356899), fontWeight: FontWeight.w600), textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
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
                    'Don\'t have an account?',
                    style: GoogleFonts.poppins(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child:  Text(
                      'Register',
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