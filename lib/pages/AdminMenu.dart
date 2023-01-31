import 'package:elearningblind/pages/CoursesMenu.dart';
import 'package:flutter/material.dart';
import 'AdminGradesMenu.dart';
import 'AnnouncementsMenu.dart';
import 'HomePage.dart';
import 'TestsMenu.dart';
import 'ResultMenu.dart';
import 'StudentChat.dart';
// import 'LecturesMenu.dart';
import 'AdminLectures.dart';

class AdminMenu extends StatelessWidget {
  static const routeName = 'AdminMenu';

  var items = [
    {0: "Announcements", 1: AnnouncementsMenu(true)},
    {0: "Messages", 1: StudentChat(true, "admin")},
    {
      0: "Courses",
      1: CoursesMenu(
        isAdmin: true,
      )
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Menu'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        content: const Text('Do you want to logout?'),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MyHomePage()),
                                    (route) => false);
                              },
                              child: const Text(
                                'Yes',
                                style: TextStyle(color: Colors.black),
                              )),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('No',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ))),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    children: const [
                      Text(
                        "Welcome,",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Admin",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 15.0,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  padding: const EdgeInsets.only(left: 16, top: 40, right: 16),
                  // color: Colors.grey,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        height: 100.0,
                        child: GestureDetector(
                          onTap: () => {
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
      ),
    );
  }
}
