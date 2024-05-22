import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/UsersApi.dart';
import 'package:labor_link_mobile/components/CustomButton.dart';
import 'package:labor_link_mobile/components/CustomTextField.dart';
import 'package:labor_link_mobile/components/SquareTile.dart';
import 'package:labor_link_mobile/screens/AuthRedirector.dart';
import 'package:labor_link_mobile/screens/HomeDashboardScreen.dart';
import 'package:labor_link_mobile/screens/RegistrationScreen.dart';

class LoginScreen extends StatefulWidget {
  bool isApplicantFirstMode;
  LoginScreen({super.key, required this.isApplicantFirstMode});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String switchLoginText = '';
  String loginDescription = '';

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

  _switchUser(bool isClicked) {
    if (isClicked) {
      widget.isApplicantFirstMode = !widget.isApplicantFirstMode;
    }

    if (widget.isApplicantFirstMode) {
      setState(() {
        loginDescription = "Let\'s log in. Apply to jobs!";
        switchLoginText = 'Switch to Employer';
      });
    } else {
      setState(() {
        loginDescription = "Let's log in. Post your jobs!";
        switchLoginText = 'Switch to Applicant';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _switchUser(false);
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
                'Welcome Back',
                style: GoogleFonts.poppins(
                    color: Color(0xff000000),
                    fontSize: 28,
                    fontWeight: FontWeight.w600),
              ),
              padding: EdgeInsets.only(left: 10, right: 10),
            ),
            const SizedBox(height: 10),
            Padding(
              child: Text(loginDescription,
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
            const SizedBox(height: 10),
            const SizedBox(height: 25),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomButton(
                  text: "Log in",
                  onTap: () => _signUserIn(context),
                )),
            const SizedBox(height: 20),
            Text(
              'Forgot Password?',
              style: GoogleFonts.poppins(
                  color: Color(0xff356899), fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            GestureDetector(
                onTap: () {
                  _switchUser(true);
                },
                child: Text(
                  switchLoginText,
                  style: GoogleFonts.poppins(
                      color: Color(0xff356899), fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                )),
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
                    child: Text(
                      'Or continue with',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: Color(0xffAFB0B6),
                          fontWeight: FontWeight.w600),
                    ),
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
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => RegistrationScreen(
                                  isApplicantFirstMode:
                                      widget.isApplicantFirstMode,
                                )));
                  },
                  child: Text(
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
