import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:elearningblind/notificationservice/notification_service.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'StudentLogIn.dart';
import 'AdminLogin.dart';
import 'package:text_to_speech/text_to_speech.dart' as tts;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MyHomePage extends StatefulWidget {
  static const routeName = 'HomePage';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // const MyHomePage({Key? key}) : super(key: key);

  late stt.SpeechToText _speech; // created object of speechToText class
  bool _isListening = false;
  String _text = 'Speech Text';

  late tts.TextToSpeech tt_speech;
  double rate = 0.5;
  List<String> _ttsMessages = [
    'Welcome to E-Learning Blind App',
    "Student Log In",
    "Select Your Choice"
  ];

  _tts(String message) {
    tt_speech.setRate(rate);
    tt_speech.speak(message);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        // onStatus: (val) => debugPrint('onStatus: $val'),
        // onError: (val) => {debugPrint('onError: $val')},
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
      for (int i = 0; i <= 2; i++) {
        await Future.delayed(const Duration(milliseconds: 3000), () {
          _tts(_ttsMessages[i]);
        });
      }

      // await Future.delayed(const Duration(milliseconds: 2000), () {
      //   _listen();
      // });
      //
      // await Future.delayed(const Duration(milliseconds: 6000), () {
      //   _isListening = false;
      // });
    }

    speak_messages();

    super.initState();
  //
  //   // notifications
  //   // when app is closed
  //   FirebaseMessaging.instance.getInitialMessage().then(
  //     (message) {
  //       debugPrint("FirebaseMessaging.instance.getInitialMessage");
  //       if (message != null) {
  //         debugPrint("New Notification");
  //       }
  //     },
  //   );
  //
  //   // when app is opened
  //   FirebaseMessaging.onMessage.listen(
  //     (message) {
  //       debugPrint("FirebaseMessaging.onMessage.listen");
  //       if (message.notification != null) {
  //         debugPrint(message.notification!.title);
  //         debugPrint(message.notification!.body);
  //         debugPrint("message.data11 ${message.data}");
  //         NotificationService.createAndDisplayNotification(message);
  //       }
  //     },
  //   );
  //
  //   // when app is in background (not closed)
  //   FirebaseMessaging.onMessageOpenedApp.listen(
  //     (message) {
  //       debugPrint("FirebaseMessaging.onMessageOpenedApp.listen");
  //       if (message.notification != null) {
  //         debugPrint(message.notification!.title);
  //         debugPrint(message.notification!.body);
  //         debugPrint("message.data22 ${message.data['_id']}");
  //       }
  //     },
  //   );
  // }
  //
  // Future<void> getDeviceTokenToSendNotification() async {
  //   // get device token and add to db
  //   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  //   final token = await _fcm.getToken().toString();
  //
  //   // add to collection if doesnt exist already
  //   DocumentReference ref =
  //       await FirebaseFirestore.instance.collection('device_tokens').doc(token);
  //
  //   DocumentSnapshot snapshot = await ref.get();
  //   if (!snapshot.exists) {
  //     await ref.set({
  //       'token': token,
  //     });
  //   }
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
    if (_text == "student login") {
      setState(() {
        _isListening = false;
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, StudentLogin.routeName);
      });
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('eLearning for blind'),
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/background_top.png',
                height: 150,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // this line centers the title

                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // const ListTile(
                            //   title: Text('Select Option'),
                            // ),
                            Column(
                              children: [
                                Container(
                                  width: 300,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: const Padding(
                                        padding: EdgeInsets.all(13.0),
                                        child: FittedBox(
                                          child: Text(
                                            'Student Log In',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, StudentLogin.routeName);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 300,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: const Padding(
                                        padding: EdgeInsets.all(13.0),
                                        child: FittedBox(
                                            child: Text('Admin Log In',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white))),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AdminLogin(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Container(
                                //   width: 300,
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(8.0),
                                //     child: ElevatedButton(
                                //       child: Padding(
                                //         padding: const EdgeInsets.all(13.0),
                                //         child: FittedBox(
                                //             child: Text('Student Sign Up',
                                //                 style: TextStyle(
                                //                     fontSize: 18.0,
                                //                     fontWeight: FontWeight.bold,
                                //                     color: Colors.white))),
                                //       ),
                                //       onPressed: () {
                                //         Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //             builder: (context) =>
                                //                 const StudentSignup(),
                                //           ),
                                //         );
                                //       },
                                //       style: ElevatedButton.styleFrom(
                                //         foregroundColor: Colors.blue,
                                //         shape: RoundedRectangleBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(18.0),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
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
          )),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'StudentLogIn.dart';
// import 'AdminLogin.dart';
// import 'StudentSignup.dart';
// import 'package:text_to_speech/text_to_speech.dart' as tts;
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:speech_to_text/speech_recognition_error.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
//
// class MyHomePage extends StatefulWidget {
//   static const routeName = 'HomePage';
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   // const MyHomePage({Key? key}) : super(key: key);
//   //
//   bool _hasSpeech = false;
//   bool _onDevice = false;
//   final TextEditingController _pauseForController =
//       TextEditingController(text: '3');
//   final TextEditingController _listenForController =
//       TextEditingController(text: '30');
//   double level = 0.0;
//   double minSoundLevel = 50000;
//   double maxSoundLevel = -50000;
//   String lastWords = '';
//   String lastError = '';
//   String lastStatus = '';
//   String _currentLocaleId = '';
//   // List<LocaleName> _localeNames = [];
//   late stt.SpeechToText speech = stt.SpeechToText();
//   bool _isListening = false;
//   String _text = 'Speech Text';
//
//   // double _confidence = 1.0;
//
//   late tts.TextToSpeech tt_speech = tts.TextToSpeech();
//   double rate = 0.5;
//   List<String> _ttsMessages = [
//     'Welcome to E-Learning Blind App',
//     "Student Log In",
//     "Student Signup",
//     "Select Your Choice"
//   ];
//
//   @override
//   void initState() {
//     // _speech = stt.SpeechToText();
//     // tt_speech = tts.TextToSpeech();
//
//     void speak_messages() async {
//       for (int i = 0; i <= 1; i++) {
//         await Future.delayed(const Duration(milliseconds: 3000), () {
//           _tts(_ttsMessages[i]);
//         });
//       }
//
//       // await Future.delayed(const Duration(milliseconds: 2000), () {
//       //   if(mounted){
//       //     _listen();
//       //   }
//       // });
//
//       // await Future.delayed(const Duration(milliseconds: 2000), () {
//       //   _speech.stop();
//       // });
//     }
//
//     speak_messages();
//     // _isListening = true;
//     // _listen();
//     super.initState();
//   }
//
//   _tts(String message) {
//     tt_speech.setRate(rate);
//     tt_speech.speak(message);
//   }
//
//   // void _listen() async {
//   //   if (!_isListening) {
//   //     bool available = await _speech.initialize(
//   //       onStatus: (val) => debugPrint('onStatus: $val'),
//   //       onError: (val) => debugPrint('onError: $val'),
//   //     );
//   //     if (available) {
//   //       setState(() => _isListening = true);
//   //       _speech.listen(
//   //         onResult: (val) => setState(() {
//   //           _text = val.recognizedWords;
//   //           // if (val.hasConfidenceRating && val.confidence > 0) {
//   //           //   _confidence = val.confidence;
//   //           // }
//   //         }),
//   //       );
//   //     }
//   //   } else {
//   //     setState(() => _isListening = false);
//   //     _speech.stop();
//   //   }
//   // }
//
//   Future<void> initSpeechState() async {
//     try {
//       var hasSpeech = await speech.initialize(
//         onError: (val) => debugPrint('onError: $val'),
//         onStatus: (val) => debugPrint('onStatus: $val'),
//       );
//       if (hasSpeech) {
//         // Get the list of languages installed on the supporting platform so they
//         // can be displayed in the UI for selection by the user.
//         // _localeNames = await speech.locales();
//
//         var systemLocale = await speech.systemLocale();
//         _currentLocaleId = systemLocale?.localeId ?? '';
//       }
//       if (!mounted) return;
//
//       setState(() {
//         _hasSpeech = hasSpeech;
//       });
//     } catch (e) {
//       setState(() {
//         // lastError = 'Speech recognition failed: ${e.toString()}';
//         _hasSpeech = false;
//       });
//     }
//   }
//
//   void startListening() {
//     lastWords = '';
//     lastError = '';
//     final pauseFor = int.tryParse(_pauseForController.text);
//     final listenFor = int.tryParse(_listenForController.text);
//     // Note that `listenFor` is the maximum, not the minimun, on some
//     // systems recognition will be stopped before this value is reached.
//     // Similarly `pauseFor` is a maximum not a minimum and may be ignored
//     // on some devices.
//     speech.listen(
//       onResult: resultListener,
//       listenFor: Duration(seconds: listenFor ?? 30),
//       pauseFor: Duration(seconds: pauseFor ?? 3),
//       partialResults: true,
//       localeId: _currentLocaleId,
//       cancelOnError: true,
//       listenMode: stt.ListenMode.confirmation,
//       onDevice: _onDevice,
//     );
//     setState(() {});
//   }
//
//   void stopListening() {
//     speech.stop();
//   }
//
//   void cancelListening() {
//     speech.cancel();
//   }
//
//   /// This callback is invoked each time new recognition results are
//   /// available after `listen` is called.
//   void resultListener(SpeechRecognitionResult result) {
//     setState(() {
//       lastWords = '${result.recognizedWords} - ${result.finalResult}';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_text == "student login") {
//       _isListening = false;
//       Navigator.of(context).pushNamed(StudentLogin.routeName);
//     }
//
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: const Text('eLearning for blind'),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               Container(
//                 height: 200,
//                 // width: MediaQuery.of(context).size.width,
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage("assets/images/background_top.png"),
//                     fit: BoxFit.fill,
//                     alignment: Alignment.topLeft,
//                   ),
//                 ),
//               ),
//               Center(
//                 child: Column(
//                   mainAxisAlignment:
//                       MainAxisAlignment.center, // this line centers the title
//
//                   children: [
//                     // Container(
//                     //   padding: const EdgeInsets.all(16.0),
//                     //   child: Text(
//                     //     'eLearning for blind',
//                     //     style: TextStyle(
//                     //       fontSize: 32.0,
//                     //       fontWeight: FontWeight.bold,
//                     //     ),
//                     //   ),
//                     // ),
//                     Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(40.0),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             // const ListTile(
//                             //   title: Text('Select Option'),
//                             // ),
//                             Column(
//                               children: [
//                                 Container(
//                                   width: 300,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: ElevatedButton(
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(13.0),
//                                         child: FittedBox(
//                                           child: Text(
//                                             'Student Log In',
//                                             style: TextStyle(
//                                               fontSize: 18.0,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       onPressed: () {
//                                         Navigator.of(context)
//                                             .pushNamed(StudentLogin.routeName);
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         foregroundColor: Colors.blue,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(18.0),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   width: 300,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: ElevatedButton(
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(13.0),
//                                         child: FittedBox(
//                                             child: Text('Admin Log In',
//                                                 style: TextStyle(
//                                                     fontSize: 18.0,
//                                                     fontWeight: FontWeight.bold,
//                                                     color: Colors.white))),
//                                       ),
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const AdminLogin(),
//                                           ),
//                                         );
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         foregroundColor: Colors.blue,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(18.0),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   width: 300,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: ElevatedButton(
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(13.0),
//                                         child: FittedBox(
//                                             child: Text('Student Sign Up',
//                                                 style: TextStyle(
//                                                     fontSize: 18.0,
//                                                     fontWeight: FontWeight.bold,
//                                                     color: Colors.white))),
//                                       ),
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const StudentSignup(),
//                                           ),
//                                         );
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         foregroundColor: Colors.blue,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(18.0),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: <Widget>[
//                           Text(
//                             _text,
//                             style: TextStyle(
//                               fontSize: 24.0,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     GestureDetector(
//                       onTap: () {
//                         startListening();
//                         // debugPrint(_isListening);
//                         // if (_isListening) {
//                         //   debugPrint("inside 1");
//                         //
//                         //   stopListening;
//                         // }
//                         // else if ( !_hasSpeech || _isListening){
//                         //   debugPrint("inside 2");
//                         //   startListening;
//                         // }
//                         // !_hasSpeech || _isListening ? null : startListening;
//
//                         // _isListening ? stopListening : null;
//                         // isListening ? cancelListening : null,
//
//                         // _listen();
//                       },
//                       child: Card(
//                         elevation: 0,
//                         child: Column(
//                           children: <Widget>[
//                             const ListTile(
//                               title: Text(
//                                 'Please enter your choice',
//                                 style: TextStyle(
//                                   fontSize: 24.0,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 16.0),
//                             IconButton(
//                               alignment: Alignment.center,
//                               icon: _isListening
//                                   ? Icon(
//                                       Icons.mic,
//                                       size: 100,
//                                     )
//                                   : Icon(Icons.mic_off_outlined, size: 100),
//                               onPressed: () {},
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     // Container(
//                     //   width: MediaQuery.of(context).size.width,
//                     //   padding: const EdgeInsets.all(16.0),
//                     //   child: GestureDetector(
//                     //     onTap: (){
//                     //       _listen();
//                     //     },
//                     //     child: Column(
//                     //       children: <Widget>[
//                     //         const Text(
//                     //           'Please enter your choice',
//                     //           style: TextStyle(
//                     //             fontSize: 24.0,
//                     //             fontWeight: FontWeight.w700,
//                     //           ),
//                     //         ),
//                     //         SizedBox(height: 16.0),
//                     //         IconButton(
//                     //           alignment: Alignment.center,
//                     //           icon: _isListening ?  Icon(Icons.mic, size: 100,) : Icon(Icons.mic_off_outlined, size: 100), onPressed: () {
//                     //         },
//                     //         ),
//                     //       ],
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ));
//
// //     return Scaffold(
// //         backgroundColor: Image.asset('images/background_top.png').color,
// //         // body: Container(
// //         //   decoration: defaultAppBoxDecoration(),
// //         // ),
//
// //         appBar: AppBar(
// //           title: const Text('eLearning for blind'),
// //         ),
// //         body: Column(
// //           mainAxisAlignment:
// //               MainAxisAlignment.center, // this line centers the title
//
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Text(
// //                 'eLearning for blind',
// //                 style: TextStyle(
// //                   fontSize: 32.0,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //             ),
// //             Center(
// //               child: Card(
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(16.0),
// //                 ),
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(40.0),
// //                   child: Column(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: <Widget>[
// //                       // const ListTile(
// //                       //   title: Text('Select Option'),
// //                       // ),
// //                       Column(
// //                         children: [
// //                           Container(
// //                             width: 200,
// //                             child: Padding(
// //                               padding: const EdgeInsets.all(8.0),
// //                               child: ElevatedButton(
// //                                 child: Padding(
// //                                   padding: const EdgeInsets.all(13.0),
// //                                   child: FittedBox(
// //                                     child: Text(
// //                                       'Student Log In',
// //                                       style: TextStyle(
// //                                         fontSize: 18.0,
// //                                         fontWeight: FontWeight.bold,
// //                                         color: Colors.white,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 onPressed: () {
// //                                   Navigator.push(
// //                                     context,
// //                                     MaterialPageRoute(
// //                                       builder: (context) => StudentLogin(),
// //                                     ),
// //                                   );
// //                                 },
// //                                 style: ElevatedButton.styleFrom(
// //                                   foregroundColor: Colors.blue,
// //                                   shape: RoundedRectangleBorder(
// //                                     borderRadius: BorderRadius.circular(18.0),
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                           Container(
// //                             width: 200,
// //                             child: Padding(
// //                               padding: const EdgeInsets.all(8.0),
// //                               child: ElevatedButton(
// //                                 child: Padding(
// //                                   padding: const EdgeInsets.all(13.0),
// //                                   child: FittedBox(
// //                                       child: Text('Student Sign Up',
// //                                           style: TextStyle(
// //                                               fontSize: 18.0,
// //                                               fontWeight: FontWeight.bold,
// //                                               color: Colors.white))),
// //                                 ),
// //                                 onPressed: () {
// //                                   Navigator.push(
// //                                     context,
// //                                     MaterialPageRoute(
// //                                       builder: (context) =>
// //                                           const StudentSignup(),
// //                                     ),
// //                                   );
// //                                 },
// //                                 style: ElevatedButton.styleFrom(
// //                                   foregroundColor: Colors.blue,
// //                                   shape: RoundedRectangleBorder(
// //                                     borderRadius: BorderRadius.circular(18.0),
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                           Container(
// //                             width: 200,
// //                             child: Padding(
// //                               padding: const EdgeInsets.all(8.0),
// //                               child: ElevatedButton(
// //                                 child: Padding(
// //                                   padding: const EdgeInsets.all(13.0),
// //                                   child: FittedBox(
// //                                       child: Text('Admin Log In',
// //                                           style: TextStyle(
// //                                               fontSize: 18.0,
// //                                               fontWeight: FontWeight.bold,
// //                                               color: Colors.white))),
// //                                 ),
// //                                 onPressed: () {
// //                                   Navigator.push(
// //                                     context,
// //                                     MaterialPageRoute(
// //                                       builder: (context) => const AdminLogin(),
// //                                     ),
// //                                   );
// //                                 },
// //                                 style: ElevatedButton.styleFrom(
// //                                   foregroundColor: Colors.blue,
// //                                   shape: RoundedRectangleBorder(
// //                                     borderRadius: BorderRadius.circular(18.0),
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(
// //               height: 80,
// //             ),
// //             Container(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Column(
// //                 children: <Widget>[
// //                   Text(
// //                     'Please enter your choice',
// //                     style: TextStyle(
// //                       fontSize: 24.0,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //                   SizedBox(height: 16.0),
// //                   InkWell(
// //                     child: Icon(Icons.mic),
// //                     onTap: () {
// //                       // code for mic icon press action
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ));
//   }
// }
