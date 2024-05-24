import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/JobApi.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/screens/widgets/SearchAppBar.dart';
import 'package:labor_link_mobile/screens/widgets/SearchList.dart';

class SearchListScreen extends StatefulWidget {
  final String searchKeyword;
  const SearchListScreen({Key? key, required this.searchKeyword})
      : super(key: key);

  @override
  _SearchListScreenState createState() => _SearchListScreenState();
}

class _SearchListScreenState extends State<SearchListScreen> {
  TextEditingController searchJobController = TextEditingController();
  final StreamController<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _searchStreamController = StreamController.broadcast();
  StreamSubscription? _searchSubscription;
  List<Job> _jobList = [];
  int jobCount = 0;

  @override
  void initState() {
    super.initState();
    searchJobController.text = widget.searchKeyword;
    searchJobController.addListener(_search);
    _loadData(widget.searchKeyword == "" ? "_" : widget.searchKeyword);
  }

  @override
  void dispose() {
    searchJobController.removeListener(_search);
    searchJobController.dispose();
    _searchStreamController.close();
    _searchSubscription?.cancel();
    super.dispose();
  }

  void _search() {
    String searchTerm = searchJobController.text.toLowerCase();
    _loadData(searchTerm);
  }

  Future<void> _loadData(String searchField) async {
    _searchSubscription?.cancel();
    _searchSubscription =
        JobApi.searchJobByKeyword(searchField).listen((filteredSearch) {
      _searchStreamController.add(filteredSearch);
      setState(() {
        jobCount = filteredSearch.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(height: 25),
          SearchAppBar(controller: searchJobController),
          Padding(
              padding:
                  EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("$jobCount Jobs Found",
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              )),
          StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
              stream: _searchStreamController.stream,
              builder: (context, snapshot) {
                final data = snapshot.data;
                _jobList =
                    data?.map((e) => Job.fromJson(e.data())).toList() ?? [];
                jobCount = _jobList.length;
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (_jobList.length > 0)
                      return SearchList(jobDetails: _jobList);

                    return Center(
                        child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Text('No jobs found',
                          style: GoogleFonts.poppins(fontSize: 18)),
                    ));
                }
              })
        ],
      )),
    );
  }
}
