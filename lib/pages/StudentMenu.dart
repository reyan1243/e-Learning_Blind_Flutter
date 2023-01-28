import 'package:elearningblind/pages/CoursesMenu.dart';
import 'package:elearningblind/pages/GradesMenu.dart';
import 'package:elearningblind/pages/HomePage.dart';
import 'package:elearningblind/pages/StudentLogIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'AnnouncementsMenu.dart';
import 'TestsMenu.dart';
import 'ResultMenu.dart';
import 'StudentChat.dart';
import 'LecturesMenu.dart';
import 'package:text_to_speech/text_to_speech.dart' as tts;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class StudentMenu extends StatefulWidget {
  static const routeName = 'StudentMenu';

  late Map<String, dynamic> data;

  StudentMenu(this.data, {Key? key}) : super(key: key);

  @override
  State<StudentMenu> createState() => _StudentMenuState();
}

class _StudentMenuState extends State<StudentMenu> {
  late String? studentID, name, username;
  late stt.SpeechToText _speech;

  bool _isListening = false;
  late tts.TextToSpeech tt_speech;

  double rate = 0.5;

  final List<String> _ttsMessages = [
    'Student Menu',
    "Welcome Student",
    "Announcements",
    "Tests and Assignments",
    "Grades",
    "Messages",
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
    studentID = widget.data['studentID'];
    name = widget.data['name'];
    username = widget.data['username'];

    items[2][1] = GradesMenu(studentID!);
    items[3][1] = StudentChat(false, username);

    void speak_messages() async {
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

  var items = [
    {0: "Announcements", 1: AnnouncementsMenu(false)},
    {
      0: "Test & Assignments",
      1: CoursesMenu(
        isAdmin: false,
        isTestMenu: true,
      )
    },
    {0: "Grades", 1: GradesMenu("")},
    {0: "Messages", 1: StudentChat(false, "")},
    // {0: "Meeting", 1: StudentChat()},
    {
      0: "Lectures",
      1: CoursesMenu(
        isAdmin: false,
        isTestMenu: false,
      )
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (_text == "logout" || _text == "back") {
      setState(() {
        tt_speech.stop();
        _isListening = false;
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, MyHomePage.routeName);
      });
    } else if (_text == 'announcements') {
      setState(() {
        tt_speech.stop();
        _isListening = false;
      });

      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, AnnouncementsMenu.routeName);
      });
    } else if (_text == 'tests') {
      setState(() {
        tt_speech.stop();
        _isListening = false;
      });

      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, TestsMenu.routeName);
      });
    } else if (_text == 'lectures') {
      setState(() {
        tt_speech.stop();
        _isListening = false;
      });

      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, LecturesMenu.routeName);
      });
    } else if (_text == 'test' || _text == 'assignments') {
      setState(() {
        tt_speech.stop();
        _isListening = false;
      });

      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, TestsMenu.routeName);
      });
    } else if (_text == 'messages') {
      setState(() {
        tt_speech.stop();
        _isListening = false;
      });

      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, StudentChat.routeName);
      });
    } else if (_text == 'grades') {
      setState(() {
        tt_speech.stop();
        _isListening = false;
      });
      // SchedulerBinding.instance.addPostFrameCallback((_) {
      //   Navigator.pushNamed(context, Grad.routeName);
      // });
    }

    _tts("Welcome ${name}");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Menu'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        content: const Text('Do you want to logout?'),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () async {
                                // final user = await FirebaseAuth
                                //     .instance
                                //     .currentUser();
                                tt_speech.stop();
                                Navigator.of(context)
                                    .pushReplacementNamed(MyHomePage.routeName);
                              },
                              child: const Text(
                                'Yes',
                                style: TextStyle(color: Colors.black),
                              )),
                          TextButton(
                            onPressed: () {
                              tt_speech.stop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('No',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ))

              // .pushReplacementNamed(MyHomePage.routeName),
              ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  children: [
                    Text(
                      "Welcome,",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      name!,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                padding: EdgeInsets.all(16),
                // color: Colors.grey,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(5),
                      height: 100.0,
                      child: GestureDetector(
                        onTap: () {
                          tt_speech.stop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => items[index][1] as Widget,
                            ),
                          );
                        },
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(items[index][0].toString()),
                              ),
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
            ),
          ],
        ),
      ),
    );
  }
}
