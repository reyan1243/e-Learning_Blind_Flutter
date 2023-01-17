import 'package:flutter/material.dart';

class StudentChat extends StatefulWidget {
  @override
  _StudentChatState createState() => _StudentChatState();
}

class _StudentChatState extends State<StudentChat> {
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
        title: Text('Chat'),
      ),
      body: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return ChatMessage(
            text: _messages[index]['text'],
            sender: _messages[index]['sender'],
          );
        },
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String? text;
  final String? sender;

  ChatMessage({this.text, this.sender});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sender!,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text!,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
