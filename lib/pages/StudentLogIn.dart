import 'package:elearningblind/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import "StudentMenu.dart";
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:text_to_speech/text_to_speech.dart' as tts;



class StudentLogin extends StatefulWidget {
  static const routeName = 'StudentLogin';

  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {

  late stt.SpeechToText _speech;
  bool _isListening = false;

  late tts.TextToSpeech tt_speech;
  double rate = 0.5;
  List<String> _ttsMessages = [
    'Login Page',
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

  @override
  void initState() {
    _speech = stt.SpeechToText();
    tt_speech = tts.TextToSpeech();

    void speak_messages() async {
      for (int i = 0; i <= 1; i++) {
        await Future.delayed(const Duration(milliseconds: 3000), () {
          _tts(_ttsMessages[i]);
        });
      }
      //
      // await Future.delayed(const Duration(milliseconds: 2000), () {
      //   _listen();
      // });

      // await Future.delayed(const Duration(milliseconds: 6000), () {
      //   _isListening = false;
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

  String _text = 'Speech Text';

  @override
  Widget build(BuildContext context) {

    if (_text == "back") {
      setState(() {
        _isListening = false;
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }
    else if(_text == 'login'){
      setState(() {
        _isListening = false;
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, StudentMenu.routeName);
      });
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Student Log In'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pushReplacementNamed(MyHomePage.routeName),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image:  DecorationImage(
                    image:  AssetImage("assets/images/background_top.png"),
                    fit: BoxFit.fill,
                    alignment: Alignment.topRight,
                  ),
                ),
              ),
              Container(),
              Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // this line centers the title

                  children: [
                    // Container(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: Text(
                    //     'Student Sign In',
                    //     style: TextStyle(
                    //       fontSize: 24.0,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextField(
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(width: 3, color: Colors.black),
                                    ),

                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white70,
                                    labelText: 'Email',
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                TextField(
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(width: 3, color: Colors.black),
                                    ),

                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white70,
                                    labelText: 'Password',
                                  ),
                                  obscureText: true,
                                ),
                                SizedBox(height: 16.0),
                                ElevatedButton(
                                  child: Text('Log In'),
                                  onPressed: () {
                                    // code for log in action
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StudentMenu(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
                                ? Icon(Icons.mic, size: MediaQuery.of(context).size.height * 0.3,)
                                : Icon(Icons.mic_off, size: MediaQuery.of(context).size.height * 0.3),

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
            ],
          ),
        ));

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Student Log In'),
    //   ),
    //   body: Column(
    //     mainAxisAlignment:
    //         MainAxisAlignment.center, // this line centers the title

    //     children: [
    //       Container(
    //         padding: const EdgeInsets.all(16.0),
    //         child: Text(
    //           'Student Sign In',
    //           style: TextStyle(
    //             fontSize: 24.0,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ),
    //       Center(
    //         child: Card(
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.all(16.0),
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: <Widget>[
    //                     TextField(
    //                       decoration: InputDecoration(
    //                         labelText: 'Email',
    //                       ),
    //                     ),
    //                     SizedBox(height: 16.0),
    //                     TextField(
    //                       decoration: InputDecoration(
    //                         labelText: 'Password',
    //                       ),
    //                       obscureText: true,
    //                     ),
    //                     SizedBox(height: 16.0),
    //                     ElevatedButton(
    //                       child: Text('Log In'),
    //                       onPressed: () {
    //                         // code for log in action
    //                         Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                             builder: (context) => StudentMenu(),
    //                           ),
    //                         );
    //                       },
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       SizedBox(
    //         height: 80,
    //       ),
    //       Container(
    //         padding: const EdgeInsets.all(16.0),
    //         child: Column(
    //           children: <Widget>[
    //             Text(
    //               'Please enter your choice',
    //               style: TextStyle(
    //                 fontSize: 24.0,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //             SizedBox(
    //               height: 16.0,
    //             ),
    //             InkWell(
    //               child: Icon(Icons.mic),
    //               onTap: () {
    //                 // code for mic icon press action
    //               },
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
