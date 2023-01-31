import 'package:elearningblind/pages/CoursesMenu.dart';
import 'package:elearningblind/pages/GradesMenu.dart';
import 'package:elearningblind/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'AnnouncementsMenu.dart';
import 'TestsMenu.dart';
import 'ResultMenu.dart';
import 'StudentChat.dart';
import 'LecturesMenu.dart';
import 'package:text_to_speech/text_to_speech.dart' as tts;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class StudentCoursesHomePage extends StatefulWidget {
  static const routeName = 'StudentCoursesHomePage';

  String? studentID, courseID, name;

  StudentCoursesHomePage(this.studentID, this.courseID, this.name);

  @override
  State<StudentCoursesHomePage> createState() => _StudentCoursesHomePageState();
}

class _StudentCoursesHomePageState extends State<StudentCoursesHomePage> {
  var items = [
    {
      0: "Test & Assignments",
      1: TestsMenu(
        isAdmin: false,
        courseID: "",
      )
    },
    {0: "Grades", 1: GradesMenu(false, "", "")},
    {0: "Lectures", 1: LecturesMenu()},
  ];

  String name = "";

  late stt.SpeechToText _speech;
  bool _isListening = false;

  late tts.TextToSpeech tt_speech;

  double rate = 0.5;

  final List<String> _ttsMessages = [
    "Tests and Assignments",
    "Grade",
    "Lectures",
    "Select Your Choice"
  ];

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

  @override
  void initState() {
    tt_speech = tts.TextToSpeech();
    _speech = stt.SpeechToText();
    name = widget.name!;

    items[0][1] = TestsMenu(
      isAdmin: false,
      courseID: widget.courseID,
      studentID: widget.studentID,
    );

    items[1][1] = GradesMenu(false, widget.courseID!, widget.studentID!);
    items[2][1] = LecturesMenu(isAdmin: false, courseID: widget.courseID);

    void speak_messages() async {
      _tts("Course ${name}");
      for (int i = 0; i <= _ttsMessages.length; i++) {
        await Future.delayed(const Duration(milliseconds: 3000), () {
          _tts(_ttsMessages[i]);
        });
      }

      //
      // await Future.delayed(const Duration(milliseconds: 2000), () {
      //   _listen();
      // });
    }

    speak_messages();
    super.initState();
  }

  @override
  void dispose() {
    tt_speech.stop();
    _text = "";
    _isListening = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_text == "go back") {
      setState(() {
        _isListening = false;
      });
      tt_speech.stop();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    } else if (_text == 'assignments') {
      setState(() {
        _isListening = false;
      });
      tt_speech.stop();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TestsMenu(
              isAdmin: false,
              courseID: widget.courseID,
              studentID: widget.studentID,
            ),
          ),
        );
      });
    } else if (_text == 'lectures') {
      setState(() {
        _isListening = false;
      });
      tt_speech.stop();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                LecturesMenu(isAdmin: false, courseID: widget.courseID),
          ),
        );
      });
    } else if (_text == 'grades') {
      setState(() {
        _isListening = false;
      });
      tt_speech.stop();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                GradesMenu(false, widget.courseID!, widget.studentID!),
          ),
        );
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Homepage'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 20.0,
                ),
                Column(
                  children: [
                    const Text(
                      "Course Name:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      name,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                padding: const EdgeInsets.all(16),
                // color: Colors.grey,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(5),
                      height: 100.0,
                      child: GestureDetector(
                        onTap: () => {
                          // TODO make this dynamic for each option
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => items[index][1] as Widget,
                            ),
                          )
                        },
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(items[index][0].toString()),
                              ),
                              // InkWell(
                              //   child: Icon(Icons.mic),
                              //   onTap: () {
                              //     // code for mic icon press action
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
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
                  const SizedBox(height: 16.0),
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
            ),
          ],
        ),
      ),
    );
  }
}
