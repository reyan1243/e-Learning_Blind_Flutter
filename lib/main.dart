// import 'package:elearningblind/pages/StudentLogIn.dart';
import 'package:elearningblind/pages/AdminLectures.dart';
import 'package:elearningblind/pages/AdminLogin.dart';
import 'package:elearningblind/pages/AdminMenu.dart';
import 'package:elearningblind/pages/AnnouncementsMenu.dart';
import 'package:elearningblind/pages/CoursesMenu.dart';
import 'package:elearningblind/pages/HomePage.dart';
import 'package:elearningblind/pages/LecturesMenu.dart';
import 'package:elearningblind/pages/ResultMenu.dart';
import 'package:elearningblind/pages/StudentChat.dart';
import 'package:elearningblind/pages/StudentLogIn.dart';
import 'package:elearningblind/pages/StudentMenu.dart';
import 'package:elearningblind/pages/StudentSignup.dart';
import 'package:elearningblind/pages/TestsMenu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'eLearning for blind',
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // A widget which will be started on application startup
      home: MyHomePage(),
      routes: {
        MyHomePage.routeName: (ctx) => MyHomePage(),
        StudentLogin.routeName: (ctx) => StudentLogin(),
        StudentSignup.routeName: (ctx) => StudentSignup(),
        StudentMenu.routeName: (ctx) => StudentMenu(),
        AdminLogin.routeName: (ctx) => AdminLogin(),
        AdminMenu.routeName: (ctx) => AdminMenu(),
        AdminLectures.routeName: (ctx) => AdminLectures(),
        AnnouncementsMenu.routeName: (ctx) => AnnouncementsMenu(false),
        LecturesMenu.routeName: (ctx) => LecturesMenu(),
        CoursesMenu.routeName: (ctx) => CoursesMenu(
              isAdmin: false,
              isTestMenu: false,
            ),
        ResultMenu.routeName: (ctx) => ResultMenu(),
        TestsMenu.routeName: (ctx) => TestsMenu(),
        StudentChat.routeName: (ctx) => StudentChat(),
      },
    );
  }
}
