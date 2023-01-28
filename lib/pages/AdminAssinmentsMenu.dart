import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearningblind/pages/AddAnnouncements.dart';
import 'package:elearningblind/pages/AddGrade.dart';
import 'package:elearningblind/pages/EditAnnouncements.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:text_to_speech/text_to_speech.dart' as tts;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AdminAssignmentsMenu extends StatefulWidget {
  AdminAssignmentsMenu({required this.data});

  Map<String, dynamic> data;

  static const routeName = 'AdminAssignmentsMenu';

  @override
  State<AdminAssignmentsMenu> createState() => _AdminAssignmentsMenuState();
}

class _AdminAssignmentsMenuState extends State<AdminAssignmentsMenu> {
  String? courseID, assignmentID;

  @override
  void initState() {
    courseID = widget.data['courseID'];
    // studentID = widget.data['studentID'];
    // descController.text = widget.data['desc'];
    assignmentID = widget.data['docID'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Answers Menu'),
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
                    .doc(courseID)
                    .collection('testsassignments')
                    .doc(assignmentID)
                    .collection('answers')
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
                          onTap: () async {
                            bool exists = false;

                            await FirebaseFirestore.instance
                                .collection('courses')
                                .doc(courseID)
                                .collection('grades')
                                .where("assignmentID", isEqualTo: assignmentID)
                                .where("studentID",
                                    isEqualTo: data['studentID'])
                                .get()
                                .then((doc) {
                              if (doc.docs.isNotEmpty) {
                                exists = true;
                                Fluttertoast.showToast(
                                    msg: 'Grade Exists!',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.blueGrey,
                                    textColor: Colors.white);
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddGrade({
                                      "answerID": document.id,
                                      "assignmentID": assignmentID,
                                      "studentID": data['studentID'],
                                      "courseID": courseID,
                                    }),
                                  ),
                                );
                              }
                            });
                          },
                          // onLongPress: () {
                          //   isAdmin
                          //       ?
                          //       Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (context) => EditAnnouncements({
                          //               "docID": document.id,
                          //               "desc": data['desc'],
                          //             }),
                          //           ),
                          //         )
                          //       : "";
                          // },
                          //todo: add checklist to check if answer exists
                          child: Expanded(
                            child: Container(
                              height: 100.0,
                              child: Card(
                                child: ListTile(
                                  title: FittedBox(
                                    child: Column(
                                      children: [
                                        Text("StudentID: ${data['studentID']}"),
                                        Text(
                                            "AssignmentID: ${data['assignmentID']}")
                                      ],
                                    ),
                                  ),
                                  subtitle: Text("Answer: ${data['answer']}"),
                                ),
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
          ],
        ),
      ),
    );
  }
}
