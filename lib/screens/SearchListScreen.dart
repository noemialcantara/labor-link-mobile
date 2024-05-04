import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/JobApi.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/screens/widgets/SearchAppBar.dart';
import 'package:labor_link_mobile/screens/widgets/SearchList.dart';

class SearchListScreen extends StatefulWidget {
  final String searchKeyword;
  const SearchListScreen({Key? key, required this.searchKeyword}) : super(key: key);

  @override
  _SearchListScreenState createState() => _SearchListScreenState();
}

class _SearchListScreenState extends State<SearchListScreen> {
  TextEditingController searchJobController = TextEditingController();
  List<Job> _jobList = [];
  int jobCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchJobsByKeyword();
  }

  _fetchJobsByKeyword() async{
    setState(() {
      searchJobController.text = widget.searchKeyword;
      JobApi.querySearchJobByKeyword(searchJobController.text == "" ? "_" : searchJobController.text).then((value) {
        setState(() {
          jobCount = value;
        });
      });
    });;
  }


  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(child: 
            Column(
              children: [
                SizedBox(height:25),
                SearchAppBar(controller: searchJobController),
                Padding(padding: EdgeInsets.only(left:25, right:25, top: 20, bottom:20),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text("$jobCount Jobs Found", style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500)),
                     
                ],)),
                StreamBuilder(
                    stream:  JobApi.searchJobByKeyword(searchJobController.text == "" ? "_" : searchJobController.text),
                    builder: (context, snapshot) {
                       final data = snapshot.data?.docs;
                      _jobList = data?.map((e) => Job.fromJson(e.data())).toList() ?? [];
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        case ConnectionState.active:
                        case ConnectionState.done: 
                        if(_jobList.length > 0)
                          return SearchList(jobDetails: _jobList);
                        
                        return  Center(
                          child:Padding(
                          padding: EdgeInsets.only(top:50),
                          child:  Text('No jobs found',
                              style: GoogleFonts.poppins(fontSize: 18)),
                        ));
                      }

                    }
                )
              ],
            
        )),
      );
  }
}