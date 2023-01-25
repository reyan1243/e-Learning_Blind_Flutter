import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearningblind/pages/EditLectureScreen.dart';
import 'package:elearningblind/pages/UploadPdf.dart';
import 'package:flutter/material.dart';

class LecturesMenu extends StatelessWidget {
  LecturesMenu({this.isAdmin, this.courseId});

  static const routeName = 'LecturesMenu';

  bool? isAdmin;
  String? courseId;

  var items = [
    "Lectutres 1",
    "Lectutres 2",
    "Lectutres 3",
    "Lectutres 4",
    "Lectutres 5",
    "Lectutres 6",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lecture's Menu"),
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
                    .doc(courseId)
                    .collection('lectures')
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
                          onLongPress: () {
                            isAdmin!
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => EditLectureScreen({
                                              "topic": data['topic'],
                                              "url": data['url'],
                                              "courseID": courseId,
                                              "docID": document.id
                                            }, "lectures")))
                                : "";
                          },
                          child: Expanded(
                            // height: 100.0,
                            child: Card(
                              child: ListTile(
                                title: Text(data['topic']),
                                subtitle: Text(data['url']),
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
            isAdmin!
                ? Container(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(13.0),
                          child: FittedBox(
                              child: Text('Add Lecture',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UploadPdf(courseId),
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
