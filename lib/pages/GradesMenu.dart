import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearningblind/pages/AddCourse.dart';
import 'package:elearningblind/pages/AddGrade.dart';
import 'package:elearningblind/pages/AdminLectures.dart';
import 'package:elearningblind/pages/AdminMenu.dart';
import 'package:elearningblind/pages/EditGrade.dart';
import 'package:elearningblind/pages/LecturesMenu.dart';
import 'package:flutter/material.dart';

import 'UploadPdf.dart';
import 'package:text_to_speech/text_to_speech.dart' as tts;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class GradesMenu extends StatefulWidget {
  GradesMenu(this.isAdmin, this.courseID, this.studentid);

  static const routeName = 'GradesMenu';

  String studentid, courseID;
  bool isAdmin;

  @override
  State<GradesMenu> createState() => _GradesMenuState();
}

class _GradesMenuState extends State<GradesMenu> {
  late tts.TextToSpeech tt_speech;
  late stt.SpeechToText _speech;

  bool _isListening = false;
  double rate = 0.5;

  _tts(String message) {
    tt_speech.setRate(rate);
    tt_speech.speak(message);
  }

  String _text = 'Speech Text';
  late Stream<QuerySnapshot> _mystream;
  var _ttsMessages = [];
  var _ttsMessages1 = [];

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

  // = "GRh0HYFhGk106N7qOzTH";

  // @override
  // void deactivate() {
  //   setState(() {
  //     _isListening = false;
  //   });
  //   tt_speech.stop();
  //
  //   super.deactivate();
  // }

  @override
  void dispose() {
    setState(() {
      tt_speech.stop();
      _isListening = false;
    });
    // _text = "";
    // _isListening = false;
    super.dispose();
  }

  @override
  void initState() {
    tt_speech = tts.TextToSpeech();
    _speech = stt.SpeechToText();
    _mystream = FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseID)
        .collection('grades')
        .where("studentID", isEqualTo: widget.studentid)
        .snapshots();

    if (!widget.isAdmin!) {
      void getData() async {
        await FirebaseFirestore.instance
            .collection('courses')
            .doc(widget.courseID)
            .collection('grades')
            .where("studentID", isEqualTo: widget.studentid)
            .get()
            .then((doc) {
          doc.docs.forEach((data) {
            _ttsMessages.add(data['assignmentID']);
            _ttsMessages1.add(data['desc']);
          });
        });
      }

      _tts("Grades Menu");
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_text == "go back") {
      setState(() {
        tt_speech.stop();
        _isListening = false;
      });
      Navigator.pop(context);
    } else if (_text == "repeat") {
      setState(() {
        tt_speech.stop();
        _isListening = false;
      });
      // setState(() {});
    }

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
                stream: _mystream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  print(widget.courseID);

                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  if (snapshot.hasData) {
                    // if (!widget.isAdmin) {
                    //   var _ttsMessages =
                    //       snapshot.data!.docs.map((DocumentSnapshot document) {
                    //     Map<String, dynamic> data =
                    //         document.data()! as Map<String, dynamic>;
                    //     return data['desc'].toString();
                    //   }).toList();
                    //
                    //   void speak_messages() async {
                    //     for (int i = 0; i <= _ttsMessages.length; i++) {
                    //       await Future.delayed(
                    //           const Duration(milliseconds: 3000), () {
                    //         _tts(_ttsMessages[i]);
                    //       });
                    //     }
                    //     //
                    //     // await Future.delayed(const Duration(milliseconds: 2000), () {
                    //     //   _listen();
                    //     // });
                    //   }
                    //
                    //   speak_messages();
                    // }

                    return Expanded(
                      child: ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return Column(
                            children: [
                              // Text(
                              //   data['isTest'] ? "Test" : "Assignment",
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.bold, fontSize: 25),
                              // ),
                              GestureDetector(
                                onTap: () {
                                  if (widget.isAdmin) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => EditGrade({
                                                  "studentID": widget.studentid,
                                                  "assignmentID":
                                                      data['assignmentID'],
                                                  "answerID": data['answerID'],
                                                  "courseID": widget.courseID,
                                                  "desc": data['desc'],
                                                  "docID": document.id
                                                })));
                                  }
                                },
                                child: Container(
                                  height: 100.0,
                                  child: Card(
                                    child: ListTile(
                                      title: Text(
                                          'Assignment Id: ${data['assignmentID']}'),
                                      subtitle: Text('Desc: ${data['desc']}'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      //},
                    );
                  }
                  return Text("No Grades Found");
                }),
            SizedBox(
              height: 15.0,
            ),
            // !widget.isAdmin!
            //     ?
            !widget.isAdmin
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
                          },
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 0,
                    width: 0,
                  ),
            //     : SizedBox(
            //   height: 0,
            //   width: 0,
            // ),
          ],
        ),
      ),
    );
  }
}
