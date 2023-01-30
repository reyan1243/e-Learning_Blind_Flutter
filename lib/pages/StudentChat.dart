import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:text_to_speech/text_to_speech.dart' as tts;
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../constants.dart';

class StudentChat extends StatefulWidget {
  static const routeName = 'StudentChat';

  String? username;
  bool isAdmin;

  StudentChat(this.isAdmin, this.username);

  @override
  _StudentChatState createState() => _StudentChatState();
}

class _StudentChatState extends State<StudentChat> {
  final textFieldController = TextEditingController();
  late String messageText;

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
  var _ttsMessages = [];
  var _ttsMessages1 = [];
  late Stream<QuerySnapshot> stream2;

  @override
  void initState() {
    tt_speech = tts.TextToSpeech();
    _speech = stt.SpeechToText();
    _tts("Messages Screen");

    stream2 = FirebaseFirestore.instance
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    if (!widget.isAdmin) {
      void getData() async {
        await FirebaseFirestore.instance
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .get()
            .then((doc) {
          for (int i = 0; i < 4; i++) {
            print(doc.docs[i]['text']);
            _ttsMessages.add(doc.docs[i]['text']);
            _ttsMessages1.add(doc.docs[i]['sender']);
          }
        });
      }

      getData();

      void speak_messages() async {
        for (int i = 0; i <= _ttsMessages.length; i++) {
          // t1 = Timer(Duration(seconds: 3), () {
          //   _tts(_ttsMessages[i]);
          // });
          await Future.delayed(const Duration(milliseconds: 3000), () {
            _tts(_ttsMessages[i]);
          });
          await Future.delayed(const Duration(milliseconds: 2000), () {
            _tts(_ttsMessages1[i]);
          });
        }
      }

      speak_messages();
      //

    }

    super.initState();
  }

  @override
  void dispose() {
    setState(() {
      tt_speech.stop();
      _isListening = false;
    });
    textFieldController.dispose();
    // _text = "";
    // _isListening = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_text == "listen message") {
      _tts("Speak");

      _text = "";

      // setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) => setState(() {
          _text = val.recognizedWords;

          textFieldController.text = _text;
          messageText = textFieldController.text;
          _tts(_text);
          // if (val.hasConfidenceRating && val.confidence > 0) {
          //   _confidence = val.confidence;
          // }
        }),
      );
    } else if (_text == "send") {
      _tts("Sending Message");
      print(_text);
      print(textFieldController.text);
      FirebaseFirestore.instance.collection('messages').add({
        'text': messageText,
        'sender': widget.username,
        'timestamp': FieldValue.serverTimestamp(),
        // 'sender': loggedinUser.email,
      }).then((value) => {_tts("Message Sent")});
      textFieldController.clear();
    } else if (_text == "back") {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: stream2,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                final messages = snapshot.data?.docs;
                List<MessageBubble> messageBubbles = [];

                for (DocumentSnapshot message in messages!) {
                  Map<String, dynamic> message1 =
                      message.data()! as Map<String, dynamic>;

                  final messageText = message1['text'];
                  final messageSender = message1['sender'] ?? "User";

                  final messageBubble = MessageBubble(
                    text: messageText,
                    sender: messageSender,
                    // isMe: ,
                    // isMe: false,
                    isMe: widget.username == messageSender,
                  );

                  messageBubbles.add(messageBubble);
                }

                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    children: messageBubbles,
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: textFieldController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      textFieldController.clear();

                      await FirebaseFirestore.instance
                          .collection('messages')
                          .add({
                        'text': messageText,
                        'sender': widget.username,
                        'timestamp': FieldValue.serverTimestamp(),
                        // 'sender': loggedinUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
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
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.text, required this.sender, required this.isMe});

  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Material(
            elevation: 5,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
            color: isMe ? Colors.lightBlueAccent : Colors.grey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 10,
                  color: isMe ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
