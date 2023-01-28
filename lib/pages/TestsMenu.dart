import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearningblind/pages/AddAnswer.dart';
import 'package:elearningblind/pages/AddTestAssignment.dart';
import 'package:elearningblind/pages/EditTestAssignment.dart';
import 'package:flutter/material.dart';

class TestsMenu extends StatefulWidget {
  static const routeName = 'TestsMenu';

  TestsMenu({this.isAdmin, this.courseId});

  bool? isAdmin;
  String? courseId;

  @override
  State<TestsMenu> createState() => _TestsMenuState();
}

class _TestsMenuState extends State<TestsMenu> {
  // var items = [
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tests & Assignments Menu'),
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
                    .doc(widget.courseId)
                    .collection('testsassignments')
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

                        return Column(
                          children: [
                            Text(
                              data['isTest'] ? "Test" : "Assignment",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddAnswer(
                                          data: {
                                            "docID": document.id,
                                            "studentID": ""//todo: student id,
                                          },
                                          courseID: widget.courseId!,
                                        )
                                  ),
                                );
                              },
                              onLongPress: () {
                                widget.isAdmin!
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditTestAssignment(
                                            data: {
                                              "question": data['question'],
                                              "desc": data['desc'],
                                              "docID": document.id
                                            },
                                            courseID: widget.courseId!,
                                          ),
                                        ),
                                      )
                                    : "";
                              },
                              child: Card(
                                child: ListTile(
                                  isThreeLine: true,
                                  title: Text("Question: ${data['question']}"),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Description:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(data['desc']),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      // Text(
                                      //   "Date:",
                                      //   style: TextStyle(fontWeight: FontWeight.bold),
                                      // ),
                                      // Text(data['date']
                                      //     .toDate()
                                      //     .toString()
                                      //     .substring(0, 16))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
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
            widget.isAdmin!
                ? Container(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(13.0),
                          child: FittedBox(
                              child: Text('Add Data',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTestAssignment(
                                courseID: widget.courseId!,
                              ),
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
