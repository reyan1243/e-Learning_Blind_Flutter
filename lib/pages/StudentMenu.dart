import 'package:flutter/material.dart';
import 'AnnouncementsMenu.dart';
import 'TestsMenu.dart';
import 'ResultMenu.dart';
import 'StudentChat.dart';
import 'LecturesMenu.dart';

class StudentMenu extends StatelessWidget {
  var items = [
    {0: "Announcements", 1: AnnouncementsMenu()},
    {0: "Test & Assignments", 1: TestsMenu()},
    {0: "Grades", 1: ResultMenu()},
    {0: "Messages", 1: StudentChat()},
    {0: "Meeting", 1: StudentChat()},
    {0: "Lectures", 1: LecturesMenu()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Menu'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 4),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 6.0,
                ),
                Container(
                  // padding: EdgeInsets.all(4),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        'https://media.licdn.com/dms/image/C4D03AQFLPbgktVGZBQ/profile-displayphoto-shrink_800_800/0/1656325697250?e=1678320000&v=beta&t=Cyn-c8j-csmO-Nuc6vhOWX1uoKPRYHv5Qe7GXwLeKXo',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  children: [
                    Text("Welcome Back"),
                    Text("ABC User"),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Expanded(
              child: Container(
                decoration: new BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                padding: EdgeInsets.all(16),
                // color: Colors.grey,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(5),
                      height: 100.0,
                      child: GestureDetector(
                        onTap: () => {
                          // TODO make this dynamic for each option
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => items[index][1] as Widget,
                            ),
                          )
                        },
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(items[index][0].toString()),
                              ),
                              InkWell(
                                child: Icon(Icons.mic),
                                onTap: () {
                                  // code for mic icon press action
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
