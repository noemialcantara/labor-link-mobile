import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/screens/widgets/SearchAppBar.dart';
import 'package:labor_link_mobile/screens/widgets/SearchList.dart';

class SearchListScreen extends StatefulWidget {
  const SearchListScreen({Key? key}) : super(key: key);

  @override
  _SearchListScreenState createState() => _SearchListScreenState();
}

class _SearchListScreenState extends State<SearchListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          
          Column(
            children: [
              SizedBox(height:25),
              SearchAppBar(),
              Padding(padding: EdgeInsets.only(left:25, right:25, top: 15),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Text("3 Jobs Found", style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500)),
                    Container(
                    height: 50,
                    width: 50,
                    padding: EdgeInsets.all(13),
                    child: Image.asset('assets/icons/filter.png'),
                  ),
              ],)),
              Expanded(child: SearchList()),
            ],
          )
        ],
      ),
    );
  }
}