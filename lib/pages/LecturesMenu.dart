import 'package:flutter/material.dart';

class LecturesMenu extends StatelessWidget {
  var items = [
    "Lectutres 1",
    "Lectutres 2",
    "Lectutres 3",
    "Lectutres 4",
    "Lectutres 5",
    "Lectutres 6",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lecture's Menu"),
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
