import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearningblind/pages/AddAnnouncements.dart';
import 'package:elearningblind/pages/AddGrade.dart';
import 'package:elearningblind/pages/EditAnnouncements.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:text_to_speech/text_to_speech.dart' as tts;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AdminAnswersMenu extends StatefulWidget {
  AdminAnswersMenu({required this.data});

  Map<String, dynamic> data;

  static const routeName = 'AdminAssignmentsMenu';

  @override
  State<AdminAnswersMenu> createState() => _AdminAnswersMenuState();
}

class _AdminAnswersMenuState extends State<AdminAnswersMenu> {
  String? courseID, assignmentID;
  List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    courseID = widget.data['courseID'];
    // studentID = widget.data['studentID'];
    // descController.text = widget.data['desc'];
    assignmentID = widget.data['docID'];
    students = widget.data['students'];

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
        child: SingleChildScrollView(
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

                    if (snapshot.hasData) {
                      return ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          String? name;
                          try {
                            name = students.firstWhere((element) =>
                                element['studentID'] ==
                                data['studentID'])['name'];
                          } catch (err) {
                            print(err.toString());
                          }

                          return GestureDetector(
                            onTap: () async {
                              bool exists = false;

                              await FirebaseFirestore.instance
                                  .collection('courses')
                                  .doc(courseID)
                                  .collection('grades')
                                  .where("assignmentID",
                                      isEqualTo: assignmentID)
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
                                        'name': name
                                      }),
                                    ),
                                  );
                                }
                              });
                            },
                            child: Flex(direction: Axis.horizontal, children: [
                              Expanded(
                                child: Card(
                                  child: ListTile(
                                    title: Text(name == null
                                        ? "No Data"
                                        : "Student: $name"),
                                    //FittedBox(
                                    // child:
                                    // child: Column(
                                    //   children: [
                                    //     Text("Student: $name"),
                                    //     // SizedBox(
                                    //     //   height: 10,
                                    //     // ),
                                    //     // Text(
                                    //     //     "AssignmentID: ${data['assignmentID']}"),
                                    //     // SizedBox(
                                    //     //   height: 10,
                                    //     // ),
                                    //   ],
                                    // ),
                                    //),
                                    subtitle: Text("Answer: ${data['answer']}"),
                                  ),
                                ),
                              ),
                            ]),
                          );
                        }).toList(),
                      );
                    }

                    return Text("No Data Found!");
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
