import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearningblind/pages/AddCourse.dart';
import 'package:elearningblind/pages/AdminLectures.dart';
import 'package:elearningblind/pages/AdminMenu.dart';
import 'package:elearningblind/pages/LecturesMenu.dart';
import 'package:flutter/material.dart';

import 'UploadPdf.dart';

class GradesMenu extends StatelessWidget {
  static const routeName = 'GradesMenu';

  String studentid = "GRh0HYFhGk106N7qOzTH";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grades Menu"),
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
                    .collection('grades')
                    .doc(studentid)
                    .collection('grades')
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
                          child: Container(
                            height: 100.0,
                            child: Card(
                              child: ListTile(
                                title: Text('Grade Id: ${data['id']}'),
                                subtitle: Text('Desc: ${data['desc']}'),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    //},
                  );
                }),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}
