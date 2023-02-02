import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearningblind/pages/AddCourse.dart';
import 'package:elearningblind/pages/AdminCoursesHomePage.dart';
import 'package:elearningblind/pages/AdminLectures.dart';
import 'package:elearningblind/pages/AdminMenu.dart';
import 'package:elearningblind/pages/EditCourse.dart';
import 'package:elearningblind/pages/LecturesMenu.dart';
import 'package:elearningblind/pages/StudentCoursesHomePage.dart';
import 'package:elearningblind/pages/TestsMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:text_to_speech/text_to_speech.dart' as tts;
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'UploadPdf.dart';

class CoursesMenu extends StatefulWidget {
  static const routeName = 'CoursesMenu';

  bool isAdmin;
  String? studentID;

  CoursesMenu({required this.isAdmin, this.studentID});

  @override
  State<CoursesMenu> createState() => _CoursesMenuState();
}

class _CoursesMenuState extends State<CoursesMenu> {
  var courses = [];

  late tts.TextToSpeech tt_speech;
  late stt.SpeechToText _speech;

  bool _isListening = false;
  double rate = 0.5;

  _tts(String message) {
    tt_speech.setRate(rate);
    tt_speech.speak(message);
  }

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

  String _text = 'Speech Text';
  late Stream<QuerySnapshot> stream2;
  var _ttsMessages = [];

  @override
  void initState() {
    stream2 = FirebaseFirestore.instance.collection('courses').snapshots();
    tt_speech = tts.TextToSpeech();
    _speech = stt.SpeechToText();

    if (!widget.isAdmin) {
      void getData() async {
        await FirebaseFirestore.instance
            .collection('courses')
            .get()
            .then((doc) {
          doc.docs.forEach((data) {
            _ttsMessages.add(data['name']);
          });
        });
      }

      getData();
      _tts("Courses Menu");

      void speak_messages() async {
        for (int i = 0; i <= _ttsMessages.length; i++) {
          // t1 = Timer(Duration(seconds: 3), () {
          //   _tts(_ttsMessages[i]);
          // });
          await Future.delayed(const Duration(milliseconds: 3000), () {
            _tts(_ttsMessages[i]);
          });
        }
      }

      speak_messages();
      //

    }

    super.initState();
  }

  @override
  void dispose() {
    tt_speech.stop();
    _isListening = false;
    // _text = "";
    // _isListening = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_text == "go back") {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }

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
                stream: stream2,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  courses =
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return data;
                  }).toList();

                  return Expanded(
                    child: ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        if (!widget.isAdmin) {
                          print(_text);
                          if (_text.replaceAll(RegExp(r"\s+"), "") ==
                              data['name']) {
                            tt_speech.stop();
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => StudentCoursesHomePage(
                                          widget.studentID!,
                                          data['courseID'],
                                          data['name'])));
                            });
                          }
                        }

                        return GestureDetector(
                          onTap: () {
                            widget.isAdmin
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
                                                widget.studentID!,
                                                data['courseID'],
                                                data['name'])));
                          },
                          onLongPress: () {
                            if (widget.isAdmin) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => EditCourse({
                                            'name': data['name'],
                                            'desc': data['desc'],
                                            'courseID': data['courseID']
                                          })));
                            }
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
            widget.isAdmin
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
