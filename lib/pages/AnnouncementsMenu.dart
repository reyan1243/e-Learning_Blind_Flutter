import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart' as tts;

class AnnouncementsMenu extends StatefulWidget {
  static const routeName = 'AnnouncementsMenu';

  @override
  State<AnnouncementsMenu> createState() => _AnnouncementsMenuState();
}

class _AnnouncementsMenuState extends State<AnnouncementsMenu> {
  late tts.TextToSpeech tt_speech;
  double rate = 0.5;

  _tts(String message) {
    tt_speech.setRate(rate);
    tt_speech.speak(message);
  }

  var items = [
    "Announcement 1",
    "Announcement 2",
    "Announcement 3",
    "Announcement 4",
    "Announcement 5",
    "Announcement 6",
    "Announcement 7",
    "Announcement 8",
    "Announcement 9",
    "Announcement 10",
  ];

  @override
  void initState() {
    tt_speech = tts.TextToSpeech();
    // _speech = stt.SpeechToText();
    //
    // void speak_messages() async {
    //   for (int i = 0; i <= 5; i++) {
    //     await Future.delayed(const Duration(milliseconds: 3000), () {
    //       _tts(_ttsMessages[i]);
    //     });
    //   }
    //   //
    //   // await Future.delayed(const Duration(milliseconds: 2000), () {
    //   //   _listen();
    //   // });
    // }
    //
    // speak_messages();
    super.initState();
  }



  @override
  void dispose() {
    tt_speech.stop();
    // _text = "";
    // _isListening = false;
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements Menu'),
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
                  .collection('announcements')
                  .snapshots(),

              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

               var _ttsMessages = snapshot.data!.docs.map((
                    DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return data['desc'].toString();
                }).toList();

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

                return Expanded(
                    child: ListView(
                      children: snapshot.data!.docs.map((
                          DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        return Container(
                          height: 100.0,
                          child: Card(
                            child: ListTile(
                              title: Text(data['desc']),
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
              }
        ),
        ],
      ),
      ),
    );
  }
}
