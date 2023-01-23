import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class StudentChat extends StatefulWidget {
  static const routeName = 'StudentChat';

  @override
  _StudentChatState createState() => _StudentChatState();
}

class _StudentChatState extends State<StudentChat> {
  // final loggedinUser = FirebaseAuth.instance.currentUser;
  final textFieldController = TextEditingController();

  late String messageText;
  final _messages = [
    {
      'text': 'Hi, I have some questions regarding this assignment?',
      'sender': 'user1',
    },
    {
      'text': 'Hi. Sure, ask away?',
      'sender': 'user2',
    },
    {
      'text':
          "lorem ipsum dolor lorem ipsum dolor lorem ipsum dolor lorem ipsum dolor",
      'sender': 'user1',
    },
    {
      'text':
          'lorem ipsum dolor lorem ipsum dolor lorem ipsum dolor lorem ipsum dolor',
      'sender': 'user2',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('messages').snapshots(),
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
                  Map<String, dynamic> message1 = message.data()! as Map<String, dynamic>;
                  final messageText = message1['text'];
                  final messageSender = message1['sender'] ?? "User";

                  final messageBubble = MessageBubble(
                    text: messageText,
                    sender: messageSender,
                    isMe: false,
                    // isMe: loggedinUser?.email == messageSender,
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
                    onPressed: () {
                      textFieldController.clear();

                      FirebaseFirestore.instance.collection('messages').add({
                        'text': messageText,
                        'sender': "admin"
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

          ],
        ),
      ),

      // ListView.builder(
      //   itemCount: _messages.length,
      //   itemBuilder: (context, index) {
      //     return ChatMessage(
      //       text: _messages[index]['text'],
      //       sender: _messages[index]['sender'],
      //     );
      //   },
      // ),
    );
  }
}

// class ChatMessage extends StatelessWidget {
//   final String? text;
//   final String? sender;
//
//   ChatMessage({this.text, this.sender});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             sender!,
//             style: Theme.of(context).textTheme.subtitle1,
//           ),
//           SizedBox(width: 10.0),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   text!,
//                   style: Theme.of(context).textTheme.bodyText1,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
