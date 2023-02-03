import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearningblind/pages/AddAnswer.dart';
import 'package:elearningblind/pages/AddTestAssignment.dart';
import 'package:elearningblind/pages/AdminAssinmentsMenu.dart';
import 'package:elearningblind/pages/EditTestAssignment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:text_to_speech/text_to_speech.dart' as tts;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TestsMenu extends StatefulWidget {
  static const routeName = 'TestsMenu';

  TestsMenu({this.isAdmin, this.courseID, this.studentID, this.name});

  bool? isAdmin;
  String? courseID, studentID, name;

  @override
  State<TestsMenu> createState() => _TestsMenuState();
}

class _TestsMenuState extends State<TestsMenu> {
  // var items = [
  late tts.TextToSpeech tt_speech;
  late stt.SpeechToText _speech;
  List<Map<String, dynamic>> students = [];

  bool _isListening = false;
  double rate = 0.5;

  _tts(String message) {
    tt_speech.stop();
    tt_speech.setRate(rate);
    tt_speech.speak(message);
  }

  String _text = 'Speech Text';

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => {print('onError: $val')},
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            // if (val.hasConfidenceRating && val.confidence > 0) {
            //   _confidence = val.confidence;
            // }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  late Stream<QuerySnapshot> _mystream;
  // = "GRh0HYFhGk106N7qOzTH";

  void validate(docID) async {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseID)
        .collection('testsassignments')
        .doc(docID)
        .collection("answers")
        // .where("assignmentID",
        //     isEqualTo: document.id)
        .where("studentID", isEqualTo: widget.studentID)
        .get()
        .then((doc) {
      if (doc.docs.isNotEmpty) {
        _tts("Answer already submitted");
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddAnswer(
                    data: {
                      "docID": docID,
                      "studentID": widget.studentID,
                      "courseID": widget.courseID!,
                    },
                  )),
        );
      }
    });
  }

  @override
  void dispose() {
    tt_speech.stop();
    // _text = "";
    // _isListening = false;
    super.dispose();
  }

  var _ttsMessages = [];
  var _ttsMessages1 = [];

  @override
  void initState() {
    _mystream = FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseID)
        .collection('testsassignments')
        .snapshots();

    tt_speech = tts.TextToSpeech();
    _speech = stt.SpeechToText();

    if (!widget.isAdmin!) {
      void getData() async {
        await FirebaseFirestore.instance
            .collection('courses')
            .doc(widget.courseID)
            .collection('testsassignments')
            .get()
            .then((doc) {
          doc.docs.forEach((data) {
            _ttsMessages.add(data['code']);
            _ttsMessages1.add(data['desc']);
          });
        });
      }

      _tts("Tests and Assignments Menu");
      getData();

      void speak_messages() async {
        for (int i = 0; i <= _ttsMessages.length; i++) {
          // t1 = Timer(Duration(seconds: 3), () {
          //   _tts(_ttsMessages[i]);
          // });
          await Future.delayed(const Duration(milliseconds: 3000), () {
            _tts(_ttsMessages[i]);
          });
          await Future.delayed(const Duration(milliseconds: 2000), () {
            _tts(_ttsMessages1[i]);
          });
        }
      }

      speak_messages();
      //

    }

    if (widget.isAdmin!) {
      void getData() async {
        await FirebaseFirestore.instance.collection('users').get().then((doc) {
          doc.docs.forEach((data) {
            students.add({
              "name": data['name'],
              "studentID": data['studentID'],
            });
          });
        });
      }

      getData();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_text == "go back") {
      tt_speech.stop();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }

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
                stream: _mystream,
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

                        // if (!widget.isAdmin!) {

                        if (_text == data['code'].toString()) {
                          print("matched");
                          tt_speech.stop();
                          validate(document.id);

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (ctx) => StudentCoursesHomePage(
                          //             widget.studentID!,
                          //             data['courseID'],
                          //             data['name'])));

                        }

                        return Column(
                          children: [
                            Text(
                              data['isTest'] ? "Test" : "Assignment",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            GestureDetector(
                              onTap: () async {
                                widget.isAdmin!
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AdminAssignmentsMenu(
                                                  data: {
                                                    "docID": document.id,
                                                    // "studentID": widget.studentID,
                                                    "courseID":
                                                        widget.courseID!,
                                                    "students": students
                                                  },
                                                )),
                                      )
                                    : validate(document.id);
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
                                            courseID: widget.courseID!,
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
                                      Text(
                                        "Code: ${data['code']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
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
            !widget.isAdmin!
                ? Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Please enter your choice',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        InkWell(
                          child: _isListening == true
                              ? Icon(
                                  Icons.mic,
                                  size:
                                      MediaQuery.of(context).size.height * 0.3,
                                )
                              : Icon(Icons.mic_off,
                                  size:
                                      MediaQuery.of(context).size.height * 0.3),
                          onTap: () {
                            tt_speech.stop();
                            _text = "";
                            _listen();
                            print(_text);
                          },
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 0,
                    width: 0,
                  ),
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
                                courseID: widget.courseID!,
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
