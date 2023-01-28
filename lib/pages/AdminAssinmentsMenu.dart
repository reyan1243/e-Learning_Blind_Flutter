import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearningblind/pages/AddAnnouncements.dart';
import 'package:elearningblind/pages/EditAnnouncements.dart';
import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart' as tts;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AdminAssignentsMenu extends StatefulWidget {
  bool? isAdmin;

  AdminAssignentsMenu(this.isAdmin);

  static const routeName = 'AnnouncementsMenu';

  @override
  State<AdminAssignentsMenu> createState() => _AdminAssignentsMenuState();
}

class _AdminAssignentsMenuState extends State<AdminAssignentsMenu> {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments Menu'),
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
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  var _ttsMessages =
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return data['desc'].toString();
                  }).toList();

                  // void speak_messages() async {
                  //   for (int i = 0; i <= _ttsMessages.length; i++) {
                  //     await Future.delayed(const Duration(milliseconds: 3000),
                  //         () {
                  //       _tts(_ttsMessages[i]);
                  //     });
                  //   }
                    //
                    // await Future.delayed(const Duration(milliseconds: 2000), () {
                    //   _listen();
                    // });
                  // }

                  // speak_messages();

                  return Expanded(
                    child: ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return GestureDetector(
                          // onLongPress: () {
                          //   isAdmin
                          //       ? Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (context) => EditAnnouncements({
                          //               "docID": document.id,
                          //               "desc": data['desc'],
                          //             }),
                          //           ),
                          //         )
                          //       : "";
                          // },
                          child: Container(
                            height: 100.0,
                            child: Card(
                              child: ListTile(
                                title: Text(data['desc']),
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

          ],
        ),
      ),
    );
  }
}
