import 'package:elearningblind/pages/AdminGradesMenu.dart';
import 'package:elearningblind/pages/CoursesMenu.dart';
import 'package:elearningblind/pages/GradesMenu.dart';
import 'package:elearningblind/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'AnnouncementsMenu.dart';
import 'TestsMenu.dart';
import 'ResultMenu.dart';
import 'StudentChat.dart';
import 'LecturesMenu.dart';

class AdminCoursesHomePage extends StatefulWidget {
  static const routeName = 'StudentCoursesHomePage';

  String courseID, name;

  AdminCoursesHomePage(this.name, this.courseID);

  @override
  State<AdminCoursesHomePage> createState() => _AdminCoursesHomePageState();
}

class _AdminCoursesHomePageState extends State<AdminCoursesHomePage> {
  var items = [
    //Announcement,courses(lectures-update-to-courses),Messages
    // {0: "Announcements", 1: AnnouncementsMenu(false)},
    {
      0: "Test & Assignments",
      1: TestsMenu(
        isAdmin: true,
        courseID: "",
      )
    },
    {0: "Grades", 1: AdminGradesMenu("")},
    {
      0: "Lectures",
      1: LecturesMenu(
        isAdmin: true,
        courseID: "",
      )
    },
  ];

  @override
  void initState() {
    items[0][1] = TestsMenu(
      isAdmin: true,
      courseID: widget.courseID,
    );
    items[1][1] = AdminGradesMenu(
      widget.courseID,
    );

    items[2][1] = LecturesMenu(
      isAdmin: true,
      courseID: widget.courseID,
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Course Menu'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 20.0,
                ),
                Column(
                  children: [
                    Text(
                      "Course Name,",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      widget.name!,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
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
                              // InkWell(
                              //   child: Icon(Icons.mic),
                              //   onTap: () {
                              //     // code for mic icon press action
                              //   },
                              // ),
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
