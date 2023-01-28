import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearningblind/pages/EditLectureScreen.dart';
import 'package:elearningblind/pages/UploadPdf.dart';
import 'package:text_to_speech/text_to_speech.dart' as tts;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';

class LecturesMenu extends StatefulWidget {
  LecturesMenu({this.isAdmin, this.courseId});

  static const routeName = 'LecturesMenu';

  bool? isAdmin;
  String? courseId;

  @override
  State<LecturesMenu> createState() => _LecturesMenuState();
}

class _LecturesMenuState extends State<LecturesMenu> {
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

  late bool isAdmin;

  @override
  void initState() {
    tt_speech = tts.TextToSpeech();
    super.initState();
  }

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

  // var items = [
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
                    .doc(widget.courseId)
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
                            widget.isAdmin!
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => EditLectureScreen({
                                              "topic": data['topic'],
                                              "url": data['url'],
                                              "courseID": widget.courseId,
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
                              builder: (context) => UploadPdf(widget.courseId),
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
