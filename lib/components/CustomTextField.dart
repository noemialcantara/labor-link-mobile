import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon prefixIcon;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            prefixIcon: prefixIcon,
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
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(color: Color(0xffAFB0B6))),
      ),
    );
  }
}