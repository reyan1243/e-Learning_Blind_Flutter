import 'package:flutter/material.dart';

class TestsMenu extends StatelessWidget {
  var items = [
    "Test 1",
    "Assignment 1",
    "Test 2",
    "Assignment 2",
    "Test 3",
    "Assignment 3",
    "Test 4",
    "Assignment 4",
    "Test 5",
    "Assignment 5",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tests & Assignments Menu'),
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
