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
    {
      0: "Test & Assignments",
      1: CoursesMenu(
        isAdmin: true,
        isTestMenu: true,
      )
    },
    {0: "Grades", 1: AdminGradesMenu()},
    {0: "Messages", 1: StudentChat(true, "admin")},
    // {0: "Meeting", 1: StudentChat()},
    {
      0: "Lectures",
      1: CoursesMenu(
        isAdmin: true,
        isTestMenu: false,
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
                                Navigator.of(context)
                                    .pushReplacementNamed(MyHomePage.routeName);
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
      body: Container(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          children: [
            Row(
              children: [
                // const SizedBox(
                //   width: 6.0,
                // ),
                // Container(
                //   // padding: EdgeInsets.all(4),
                //   width: 50,
                //   height: 50,
                //   // decoration: BoxDecoration(
                //   //   shape: BoxShape.circle,
                //   //   image: DecorationImage(
                //   //     fit: BoxFit.fill,
                //   //     image: NetworkImage(
                //   //       'data:image/jpeg;base64,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',
                //   //     ),
                //   //   ),
                //   // ),
                // ),
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
    );
  }
}
