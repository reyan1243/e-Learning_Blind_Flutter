import 'package:flutter/material.dart';

class AnnouncementsMenu extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements Menu'),
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
