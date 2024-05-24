import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labor_link_mobile/apis/JobCategoryApi.dart';
import 'package:labor_link_mobile/models/Job.dart';
import 'package:labor_link_mobile/models/JobCategory.dart';
import 'package:labor_link_mobile/screens/JobListByCategoryScreen.dart';
import 'package:labor_link_mobile/screens/widgets/JobItem.dart';

class FullCategoriesListScreen extends StatelessWidget {
  FullCategoriesListScreen({Key? key}) : super(key: key);
  List<JobCategory> _jobCategoryList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 80,
            bottomOpacity: 0.0,
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            title: Text(
              "Job Categories",
              style: GoogleFonts.poppins(
                  color: Color(0xff0D0D26),
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent),
        body: SingleChildScrollView(
            child: Padding(
                padding:
                    EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 10),
                child: StreamBuilder(
                  stream: JobCategoryApi.getJobCategories(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _jobCategoryList = data
                                ?.map((e) => JobCategory.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_jobCategoryList.isNotEmpty) {
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: _jobCategoryList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => JobListByCategoryScreen(
                                              categoryTitle:
                                                  _jobCategoryList[index]
                                                      .category,
                                            )));
                              },
                              child: Column(children: [
                                Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Color(0xffEAEAEA),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.network(
                                      _jobCategoryList[index].categoryLogo),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  _jobCategoryList[index].category,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      color: Color(0xff356899),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ]),
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 0.85),
                          );
                        } else {
                          return const Center(
                            child: Text('No job categories found yet',
                                style: TextStyle(fontSize: 20)),
                          );
                        }
                    }
                  },
                ))));
  }
}
