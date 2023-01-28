import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearningblind/pages/AddCourse.dart';
import 'package:elearningblind/pages/AdminLectures.dart';
import 'package:elearningblind/pages/AdminMenu.dart';
import 'package:elearningblind/pages/LecturesMenu.dart';
import 'package:flutter/material.dart';

import 'UploadPdf.dart';
import 'package:text_to_speech/text_to_speech.dart' as tts;

import 'package:text_to_speech/text_to_speech.dart' as tts;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class GradesMenu extends StatefulWidget {
  GradesMenu(this.studentid);

  static const routeName = 'GradesMenu';

  String studentid;

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

  @override
  void dispose() {
    tt_speech.stop();
    // _text = "";
    // _isListening = false;
    super.dispose();
  }

  @override
  void initState() {
    tt_speech = tts.TextToSpeech();
    super.initState();
  }

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
                    .doc(widget.studentid)
                    .collection('studentgrades')
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
                    var _ttsMessages =
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return data['desc'].toString();
                    }).toList();

                    void speak_messages() async {
                      for (int i = 0; i <= _ttsMessages.length; i++) {
                        await Future.delayed(const Duration(milliseconds: 3000),
                            () {
                          _tts(_ttsMessages[i]);
                        });
                      }
                      //
                      // await Future.delayed(const Duration(milliseconds: 2000), () {
                      //   _listen();
                      // });
                    }

                    speak_messages();

                    return Expanded(
                      child: ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
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
                  }
                  return Text("No Grades Found");
                }),
            SizedBox(
              height: 15.0,
            ),
            // !widget.isAdmin!
            //     ?
            Container(
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
                            size: MediaQuery.of(context).size.height * 0.3,
                          )
                        : Icon(Icons.mic_off,
                            size: MediaQuery.of(context).size.height * 0.3),
                    onTap: () {
                      tt_speech.stop();
                      _text = "";
                      _listen();
                    },
                  ),
                ],
              ),
            )
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
