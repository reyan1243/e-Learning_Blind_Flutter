import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearningblind/pages/AddCourse.dart';
import 'package:elearningblind/pages/AdminCoursesHomePage.dart';
import 'package:elearningblind/pages/AdminLectures.dart';
import 'package:elearningblind/pages/AdminMenu.dart';
import 'package:elearningblind/pages/LecturesMenu.dart';
import 'package:elearningblind/pages/StudentCoursesHomePage.dart';
import 'package:elearningblind/pages/TestsMenu.dart';
import 'package:flutter/material.dart';

import 'UploadPdf.dart';

class CoursesMenu extends StatelessWidget {
  static const routeName = 'CoursesMenu';

  bool isAdmin;
  String? studentID;

  CoursesMenu({required this.isAdmin, this.studentID});

  // var items = [
  //   "Lectutres 1",
  //   "Lectutres 2",
  //   "Lectutres 3",
  //   "Lectutres 4",
  //   "Lectutres 5",
  //   "Lectutres 6",
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Courses Menu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 15.0,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return Expanded(
                    child: ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () {
                            isAdmin
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => AdminCoursesHomePage(
                                            data['name'], data['courseID'])))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            StudentCoursesHomePage(
                                                studentID!,
                                                data['courseID'],
                                                data['name'])));
                            // isTestMenu
                            //     ? Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (ctx) => TestsMenu(
                            //                   isAdmin: isAdmin,
                            //                   courseId: data['courseID'],
                            //                 )))
                            //     : Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (ctx) => LecturesMenu(
                            //                   isAdmin: isAdmin,
                            //                   courseId: data['courseID'],
                            //                 )));
                            // // LecturesMenu.routeName);
                          },
                          child: Container(
                            height: 100.0,
                            child: Card(
                              child: ListTile(
                                title: Text('Course: ${data['name']}'),
                                subtitle: Text('Desc: ${data['desc']}'),
                              ),
                            ),
                          ),
                        );
                      }).toList(),

                      // itemCount: items.length,
                      // itemBuilder: (context, index) {
                      //
                      // },
                      // ),
                    ),
                    //},
                  );
                }),
            SizedBox(
              height: 15.0,
            ),
            isAdmin
                ? Container(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(13.0),
                          child: FittedBox(
                              child: Text('Add Course',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddCourse(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 0,
                    width: 0,
                  ),
          ],
        ),
      ),
      // Container(
      //   child: Padding(
      //     padding: EdgeInsets.all(10),
      //     child: Column(
      //       children: [
      //         SizedBox(
      //           height: 15.0,
      //         ),
      //         Expanded(
      //           child: ListView.builder(
      //             itemCount: items.length,
      //             itemBuilder: (context, index) {
      //               return Container(
      //                 height: 100.0,
      //                 child: Card(
      //                   child: ListTile(
      //                     title: Text(items[index]),
      //                   ),
      //                 ),
      //               );
      //             },
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
