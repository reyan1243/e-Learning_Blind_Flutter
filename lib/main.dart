// import 'package:elearningblind/pages/StudentLogIn.dart';
// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'pages/StudentLogIn.dart';
import 'pages/AdminLogin.dart';
import 'pages/StudentSignup.dart';

// firebase
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // * make sure all widgets are bound
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('eLearning for blind'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: 150,
            width: 600,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/background_top.png"),
                fit: BoxFit.fill,
                alignment: Alignment.topLeft,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // this line centers the title

              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // const ListTile(
                        //   title: Text('Select Option'),
                        // ),
                        Column(
                          children: [
                            Container(
                              width: 300,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  child: const Padding(
                                    padding: EdgeInsets.all(13.0),
                                    child: FittedBox(
                                      child: Text(
                                        'Student Log In',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const StudentLogin(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 300,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  child: const Padding(
                                    padding: EdgeInsets.all(13.0),
                                    child: FittedBox(
                                        child: Text('Admin Log In',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AdminLogin(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 300,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  child: const Padding(
                                    padding: EdgeInsets.all(13.0),
                                    child: FittedBox(
                                        child: Text('Student Sign Up',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const StudentSignup(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Please enter your choice',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      InkWell(
                        child: const Icon(Icons.mic),
                        onTap: () {
                          // code for mic icon press action
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
