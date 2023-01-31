import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearningblind/pages/HomePage.dart';
import 'package:elearningblind/pages/StudentCoursesHomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  var passwordController = TextEditingController();
  var userController = TextEditingController();

  var passwordNode = FocusNode();
  var usernameNode = FocusNode();

  bool _showPwd = true;

  late tts.TextToSpeech tt_speech;
  double rate = 0.7;
  List<String> _ttsMessages = ['Login Page', "Select Your Choice"];

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

  void signinuser() async {
    print(userController.text);
    if (userController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var pass;
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .where("username", isEqualTo: userController.text)
            .get()
            .then((doc) {
          if (doc.docs.isEmpty) {
            _tts("No User found");
          } else {
            pass = doc.docs.first["pin"];
            if (pass == passwordController.text) {
              _tts("Logged In");
              // SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentMenu({
                      "studentID": doc.docs.first["studentID"],
                      "name": doc.docs.first["name"],
                      "username": doc.docs.first["username"],
                    }),
                  ),
                );
              // });
            } else {
              _tts("Incorrect username or pin");
            }
          }
        });
      } on PlatformException catch (err) {
        // If any error
        String? message;
        if (err.message != null) {
          message = err.message;
        }
        print(message);
        _tts("Oops something went wrong");
      }
    } else {
      _tts('Please enter all the details!');
    }
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
    } else if (_text == 'login') {
      setState(() {
        _isListening = false;
      });

      signinuser();

      // SchedulerBinding.instance.addPostFrameCallback((_) {
      //   Navigator.pushReplacementNamed(context, StudentMenu.routeName);
      // });

    } else if (_text == 'listen username') {
      tt_speech.stop();
      // if (_text == "listen message") {
      _tts("Speak");
      _text = "";
      // userController.text = _text.toLowerCase();
      // setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) => setState(() {
          _text = val.recognizedWords;

          userController.text = _text.toLowerCase();
          _tts(_text);

          Future.delayed(Duration(seconds: 4), () { // <-- Delay here
            setState(() {
              _isListening = false; // <-- Code run after delay
            });
          });

          // setState(() {
          //   _isListening = false;
          // });
          // if (val.hasConfidenceRating && val.confidence > 0) {
          //   _confidence = val.confidence;
          // }
        }),
      );

      // } else if (_text == "send") {
      //   _tts("Sending Message");
      //   print(_text);
      //   print(textFieldController.text);
      //   FirebaseFirestore.instance.collection('messages').add({
      //     'text': textFieldController.text,
      //     'sender': widget.username
      //     // 'sender': loggedinUser.email,
      //   });
      //   textFieldController.clear();
      // }

      // listenData();

      // setState(() {
      //   print("listen false");
      //   _isListening = false;
      // });

      print("setting username");
    }
    else if (_text == 'listen password') {
      tt_speech.stop();

      _tts("Speak");
      _text = "";

      // passwordController.text = _text;
      _speech.listen(
        onResult: (val) => setState(() {
          _text = val.recognizedWords;

          passwordController.text = _text;
          _tts(_text);

          Future.delayed(Duration(seconds: 4), () { // <-- Delay here
            setState(() {
              _isListening = false; // <-- Code run after delay
            });
          });

          // setState(() {
          //   _isListening = false;
          // });
          // if (val.hasConfidenceRating && val.confidence > 0) {
          //   _confidence = val.confidence;
          // }
        }),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Student Log In'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pushReplacementNamed(
                  context, MyHomePage.routeName)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/background_top.png',
                height: 150,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
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
                                  focusNode: usernameNode,
                                  controller: userController,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.black),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white70,
                                    labelText: 'Username',
                                    hintText: "Enter username",
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                TextField(
                                  focusNode: passwordNode,
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.black),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white70,
                                    labelText: 'PIN',
                                    hintText: "Enter PIN",
                                    suffixIcon: IconButton(
                                      icon: _showPwd
                                          ? Icon(Icons.visibility_off,
                                              color: Colors.black)
                                          : Icon(Icons.visibility,
                                              color: Colors.black),
                                      onPressed: () => setState(() {
                                        _showPwd = !_showPwd;
                                      }),
                                    ),
                                  ),
                                  obscureText: _showPwd,
                                ),
                                const SizedBox(height: 16.0),
                                ElevatedButton(
                                  child: Text('Log In'),
                                  onPressed: () async {
                                    if (userController.text.isNotEmpty &&
                                        passwordController.text.isNotEmpty) {
                                      var pass;
                                      try {
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .where("username",
                                                isEqualTo: userController.text)
                                            .get()
                                            .then((doc) {
                                          if (doc.docs.isEmpty) {
                                            _tts("No User found");
                                          } else {
                                            pass = doc.docs.first["pin"];
                                            if (pass ==
                                                passwordController.text) {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StudentMenu({
                                                    "studentID": doc.docs
                                                        .first["studentID"],
                                                    "name":
                                                        doc.docs.first["name"],
                                                    "username": doc
                                                        .docs.first["username"],
                                                  }),
                                                ),
                                              );
                                            } else {
                                              _tts("Incorrect username or pin");
                                            }
                                          }
                                        });
                                      } on PlatformException catch (err) {
                                        // If any error
                                        String? message;
                                        if (err.message != null) {
                                          message = err.message;
                                        }
                                        print(message);
                                        _tts("Oops something went wrong");
                                      }
                                    } else {
                                      _tts('Please enter all the details!');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
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
                          const SizedBox(height: 16.0),
                          InkWell(
                            child: _isListening == true
                                ? Icon(
                                    Icons.mic,
                                    size: MediaQuery.of(context).size.height *
                                        0.3,
                                  )
                                : Icon(Icons.mic_off,
                                    size: MediaQuery.of(context).size.height *
                                        0.3),
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
