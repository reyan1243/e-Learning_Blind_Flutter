import 'package:flutter/material.dart';

class ResultMenu extends StatelessWidget {
  var items = [
    "Subject A Grades",
    "Subject B Grades",
    "Subject C Grades",
    "Subject D Grades",
    "Subject E Grades",
    "Subject F Grades",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Menu'),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 15.0,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 100.0,
                      child: Card(
                        child: ListTile(
                          title: Text(items[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
