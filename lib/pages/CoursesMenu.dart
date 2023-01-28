import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearningblind/pages/AddCourse.dart';
import 'package:elearningblind/pages/AdminLectures.dart';
import 'package:elearningblind/pages/AdminMenu.dart';
import 'package:elearningblind/pages/LecturesMenu.dart';
import 'package:elearningblind/pages/TestsMenu.dart';
import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart' as tts;
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'UploadPdf.dart';

class CoursesMenu extends StatefulWidget {
  static const routeName = 'CoursesMenu';

  bool isAdmin, isTestMenu;

  CoursesMenu({required this.isAdmin, required this.isTestMenu});

  @override
  State<CoursesMenu> createState() => _CoursesMenuState();
}

class _CoursesMenuState extends State<CoursesMenu> {
  late tts.TextToSpeech tt_speech;
  late stt.SpeechToText _speech;

  bool _isListening = false;
  double rate = 0.5;

  _tts(String message) {
    tt_speech.setRate(rate);
    tt_speech.speak(message);
  }

  late bool isAdmin;
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
                            widget.isTestMenu
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => TestsMenu(
                                              isAdmin: widget.isAdmin,
                                              courseId: data['courseID'],
                                            )))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => LecturesMenu(
                                              isAdmin: widget.isAdmin,
                                              courseId: data['courseID'],
                                            )));
                            // LecturesMenu.routeName);
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
