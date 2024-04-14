import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchAppBar extends StatefulWidget {
  const SearchAppBar({Key? key}) : super(key: key);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, right: 25, left: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff356899),
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
             cursorColor: Color(0xff000000),
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,

              decoration: InputDecoration(
               fillColor: Color(0xffF2F2F3),
                filled: true,
                contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide.none),
                hintText: 'Search a job or position',
                 hintStyle: GoogleFonts.poppins(fontSize: 15.0, color: Color(0xff95969D)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                       color: Color(0xffF2F2F3),
                      width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                     color: Color(0xffF2F2F3),
                      width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                prefixIcon: Container(
                  padding: EdgeInsets.all(15.0),
                  child: Image.asset(
                    'assets/icons/search.png',
                    width: 20.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}