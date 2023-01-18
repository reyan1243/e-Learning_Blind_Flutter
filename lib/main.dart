// import 'package:elearningblind/pages/StudentLogIn.dart';
import 'package:flutter/material.dart';
import 'pages/StudentLogIn.dart';
import 'pages/AdminLogin.dart';
import 'pages/StudentSignup.dart';
import 'package:text_to_speech/text_to_speech.dart' as tts;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'eLearning for blind',
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // A widget which will be started on application startup
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Speech Text';

  // double _confidence = 1.0;

  late tts.TextToSpeech tt_speech;
  double rate = 0.5;
  List<String> _ttsMessages =[
    'Welcome to E-Learning Blind App',
    "Student Log In",
    "Student Signup",
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
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
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
      await Future.delayed(const Duration(milliseconds: 2000), () {
        _listen();
      });
      await Future.delayed(const Duration(milliseconds: 2000), () {
        _speech.stop();
      });
    }

    speak_messages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_text == "student login") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentLogin(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('eLearning for blind'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background_top.png"),
                  fit: BoxFit.fill,
                  alignment: Alignment.topLeft,
                ),
              ),
            ),
            Center(
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StudentLogin(),
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
                              Container(
                                width: 300,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    child: const Padding(
                                      padding: const EdgeInsets.all(13.0),
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
                                          builder: (context) =>
                                              const AdminLogin(),
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
                              Container(
                                width: 300,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    child: const Padding(
                                      padding: EdgeInsets.all(13.0),
                                      child: FittedBox(
                                          child: Text('Student Sign Up',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const StudentSignup(),
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          _text,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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
                          child: _isListening
                              ? const Icon(Icons.mic)
                              : const Icon(Icons.mic_off_outlined),
                          onTap: () {
                            _listen();
                            // code for mic icon press action
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
