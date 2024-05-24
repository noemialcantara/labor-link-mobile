import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/FirebaseChatApi.dart';
import 'package:labor_link_mobile/apis/UsersApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/components/CustomTextField.dart';
import 'package:labor_link_mobile/components/SquareTile.dart';
import 'package:labor_link_mobile/screens/AuthRedirector.dart';
import 'package:labor_link_mobile/screens/LoginScreen.dart';

class RegistrationScreen extends StatefulWidget {
  bool isApplicantFirstMode;

  RegistrationScreen({Key? key, required this.isApplicantFirstMode})
      : super(key: key);

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
          return AlertDialog(
              backgroundColor: Color(0xffffffff),
              title: Text(
                errorMessage,
                style: GoogleFonts.poppins(fontSize: 18),
              ));
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

      await FirebaseChatApi.createUser(
          _fullNameController.text, widget.isApplicantFirstMode);

      Map<String, dynamic> userPayload = {};

      if (widget.isApplicantFirstMode) {
        userPayload = {
          "address": "",
          "email_address": _emailController.text,
          "full_name": _fullNameController.text,
          "job_role": "",
          "minimum_expected_salary": "",
          "maximum_expected_salary": "",
          "profile_url":
              "https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/app_image_assets%2Fpngwing.com.png?alt=media&token=ab84abf3-f915-4422-a711-00314197b9ae",
          "years_of_experience": ""
        };
      } else {
        userPayload = {
          "employer_name": _fullNameController.text,
          "employer_address": "",
          "employer_about": "",
          "year_founded": "",
          "industry": "",
          "owner": "",
          "company_size": "",
          "phone": "",
          "logo_url":
              "https://firebasestorage.googleapis.com/v0/b/labor-link-f9424.appspot.com/o/company_images%2Fdefault-company-avatar-removebg-preview.png?alt=media&token=a3649b8b-5034-406c-95b0-2d289e558be2",
          "email_address": _emailController.text,
        };
      }

      UsersApi.createUser(widget.isApplicantFirstMode, userPayload);

      Navigator.push(
          context, fadeTransitionBuilder(child: const AuthRedirector()));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      //wrong Email
      showmessage(e.message.toString());
    }
  }

  PageRouteBuilder fadeTransitionBuilder({required Widget child}) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final _scale = animation.drive(Tween<double>(begin: 0, end: 1));

          return ScaleTransition(scale: _scale, child: child);
        });
  }

  _switchUser() {
    if (widget.isApplicantFirstMode) {
      setState(() {
        registrationDescription = 'Let\'s register. Apply to jobs!';
      });
    } else {
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
            Padding(
              child: Text(
                'LaborLink',
                style: GoogleFonts.poppins(
                    color: Color(0xff356899),
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
              padding: EdgeInsets.only(left: 10, right: 10),
            ),
            const SizedBox(height: 10),
            Padding(
              child: Text(
                'Registration',
                style: GoogleFonts.poppins(
                    color: Color(0xff000000),
                    fontSize: 28,
                    fontWeight: FontWeight.w600),
              ),
              padding: EdgeInsets.only(left: 10, right: 10),
            ),
            const SizedBox(height: 10),
            Padding(
              child: Text(registrationDescription,
                  style: GoogleFonts.poppins(
                      color: Color(0xff0D0D26),
                      fontSize: 15,
                      fontWeight: FontWeight.normal)),
              padding: EdgeInsets.only(left: 10, right: 10),
            ),
            const SizedBox(height: 45),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomTextField(
                  prefixIcon: Icon(Icons.person_outline),
                  controller: _fullNameController,
                  hintText: widget.isApplicantFirstMode
                      ? 'Full Name'
                      : 'Company Name',
                  obscureText: false,
                )),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomTextField(
                  prefixIcon: Icon(Icons.email_outlined),
                  controller: _emailController,
                  hintText: 'E-mail',
                  obscureText: false,
                )),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomTextField(
                  prefixIcon: Icon(Icons.key_outlined),
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                )),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomTextField(
                  prefixIcon: Icon(Icons.key_outlined),
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                )),
            const SizedBox(height: 30),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomButton(
                  text: "Register",
                  onTap: () => _signUserup(context),
                )),
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
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => LoginScreen(
                                  isApplicantFirstMode:
                                      widget.isApplicantFirstMode,
                                )));
                  },
                  child: Text(
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
