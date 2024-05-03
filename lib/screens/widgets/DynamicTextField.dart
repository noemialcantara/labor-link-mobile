import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DynamicTextField extends StatefulWidget {
  final String? initialValue;
  final void Function(String) onChanged;
  final String hintText;

  const DynamicTextField({
    super.key,
    this.initialValue,
    required this.onChanged,
    required this.hintText
  });

  @override
  State createState() => _DynamicTextfieldState();
}

class _DynamicTextfieldState extends State<DynamicTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.initialValue ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
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
            hintText: widget.hintText,
            hintStyle: GoogleFonts.poppins(color: Color(0xffAFB0B6))),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}