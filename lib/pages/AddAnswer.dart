import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:text_to_speech/text_to_speech.dart' as tts;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../components/input_field.dart';

class AddAnswer extends StatefulWidget {
  static const routeName = 'AddAnswer';

  AddAnswer({required this.data});

  Map<String, dynamic> data;

  @override
  State<AddAnswer> createState() => _AddAnswerState();
}

class _AddAnswerState extends State<AddAnswer> {
  String? courseID, docID, studentID;

  late stt.SpeechToText _speech;
  bool _isListening = false;

  late tts.TextToSpeech tt_speech;

  double rate = 0.5;

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

  _tts(String message) {
    tt_speech.setRate(rate);
    tt_speech.speak(message);
  }

  @override
  void initState() {
    tt_speech = tts.TextToSpeech();
    _speech = stt.SpeechToText();
    courseID = widget.data['courseID'];
    studentID = widget.data['studentID'];
    // descController.text = widget.data['desc'];
    docID = widget.data['docID'];

    _tts("Submit Answer Screen");

    super.initState();
  }

  @override
  void dispose() {
    // nameNode.dispose();
    // nameController.clear();
    answerController.clear();

    super.dispose();
  }

  void submitanswer() async {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseID)
        .collection('testsassignments')
        .doc(docID)
        .collection('answers')
        .add({
      "studentID": studentID,
      "assignmentID": docID,
      "courseID": courseID,
      "answer": answerController.text
    }).then((value) => _tts("Answer Submitted"));
  }

  final formKey = GlobalKey<FormState>();

  // TextEditingController nameController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  // FocusNode nameNode = FocusNode();
  FocusNode answerNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final double screenH = MediaQuery.of(context).size.height;

    if (_text == "listen answer") {
      _text = "";
      _tts("Speak Answer");

      _speech.listen(
        onResult: (val) => setState(() {
          _text = val.recognizedWords;

          answerController.text = _text;
          _tts(_text);
          // if (val.hasConfidenceRating && val.confidence > 0) {
          //   _confidence = val.confidence;
          // }
        }),
      );
    } else if (_text == "submit answer") {
      if (answerController.text.isEmpty) {
        _tts("Please say your answer.");
      } else {
        submitanswer();
        answerController.clear();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context);
        });
      }
    } else if (_text == "go back") {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Answer"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InputField(
                      maxLine: 10,
                      textValueController: answerController,
                      node: answerNode,
                      label: 'Answer',
                      hint: 'Add Answer',
                      suffixIcon: const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                      onValidate: (val) {
                        if (val.isEmpty) {
                          return 'Please provide an answer';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: screenH * 0.05,
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
                    Container(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: const Padding(
                            padding: EdgeInsets.all(13.0),
                            child: FittedBox(
                                child: Text('Add',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                          ),
                          onPressed: () async {
                            // if (
                            //     // nameController.text.isNotEmpty &&
                            //     answerController.text.isNotEmpty) {
                            //   _submit();
                            //   setState(() {});
                            // } else {
                            //   // Fluttertoast.showToast(
                            //   //     msg: 'Please fill the text boxe!',
                            //   //     toastLength: Toast.LENGTH_SHORT,
                            //   //     gravity: ToastGravity.BOTTOM,
                            //   //     backgroundColor: Colors.blueGrey,
                            //   //     textColor: Colors.white);
                            // }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      _uploadTask();
    }
  }

  _uploadTask() async {
    try {
      // var doc = FirebaseFirestore.instance
      //     .collection('courses')
      //     .doc(courseID)
      //     .collection('testsassignments')
      //     .doc(docID)
      //     .collection('answers')
      //     .doc();
      // print(doc.id);

      bool exists = false;

      await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseID)
          .collection('testsassignments')
          .doc(docID)
          .collection('answers')
          .where("studentID", isEqualTo: studentID)
          .get()
          .then((doc) {
        if (doc.docs.isNotEmpty) {
          print("answer Exists"); //todo: add message
          exists = true;
        }
      });

      if (!exists) {
        await FirebaseFirestore.instance
            .collection('courses')
            .doc(courseID)
            .collection('testsassignments')
            .doc(docID)
            .collection('answers')
            .add({
          "studentID": studentID,
          "assignmentID": docID,
          "courseID": courseID,
          "answer": answerController.text
        }).then((value) => Fluttertoast.showToast(
                msg: 'Answer Submitted!',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.blueGrey,
                textColor: Colors.white));
      }

      Navigator.pop(context);
    } on PlatformException catch (er) {
      print(er.message);
    }

    // Category category = Category(
    //   catName: taskTitleController.text,
    // );

    // await _taskController.addCategory(category: category);
  }
}
