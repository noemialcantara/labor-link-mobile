import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon? prefixIcon;
  final List<TextInputFormatter>? textInputFormatter;
  final TextInputType? textInputType;
  final int maxLines;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.prefixIcon,
    this.textInputFormatter,
    this.textInputType,
    this.maxLines  = 1
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: TextField(
        maxLines: maxLines,
        controller: controller,
        obscureText: obscureText,
        keyboardType: textInputType,
        inputFormatters: textInputFormatter,
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