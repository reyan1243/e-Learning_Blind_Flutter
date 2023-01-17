// import 'package:elearningblind/pages/StudentLogIn.dart';
import 'package:flutter/material.dart';
import 'pages/StudentLogIn.dart';
import 'pages/AdminLogin.dart';
import 'pages/StudentSignup.dart';

void main() => runApp(MyApp());

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white10,
        appBar: AppBar(
          title: const Text('eLearning for blind'),
        ),
        body: new Stack(
          children: <Widget>[
            new Container(
              height: 150,
              width: 600,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("images/background_top.png"),
                  fit: BoxFit.fill,
                  alignment: Alignment.topLeft,
                ),
              ),
            ),
            new Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // this line centers the title

                children: [
                  // Container(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: Text(
                  //     'eLearning for blind',
                  //     style: TextStyle(
                  //       fontSize: 32.0,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(13.0),
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
                                          builder: (context) => StudentLogin(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(13.0),
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
                                      foregroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(13.0),
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
                                      foregroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
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
                  SizedBox(
                    height: 80,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Please enter your choice',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        InkWell(
                          child: Icon(Icons.mic),
                          onTap: () {
                            // code for mic icon press action
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));

//     return Scaffold(
//         backgroundColor: Image.asset('images/background_top.png').color,
//         // body: Container(
//         //   decoration: defaultAppBoxDecoration(),
//         // ),

//         appBar: AppBar(
//           title: const Text('eLearning for blind'),
//         ),
//         body: Column(
//           mainAxisAlignment:
//               MainAxisAlignment.center, // this line centers the title

//           children: [
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'eLearning for blind',
//                 style: TextStyle(
//                   fontSize: 32.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Center(
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(40.0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       // const ListTile(
//                       //   title: Text('Select Option'),
//                       // ),
//                       Column(
//                         children: [
//                           Container(
//                             width: 200,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: ElevatedButton(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(13.0),
//                                   child: FittedBox(
//                                     child: Text(
//                                       'Student Log In',
//                                       style: TextStyle(
//                                         fontSize: 18.0,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => StudentLogin(),
//                                     ),
//                                   );
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   foregroundColor: Colors.blue,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(18.0),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             width: 200,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: ElevatedButton(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(13.0),
//                                   child: FittedBox(
//                                       child: Text('Student Sign Up',
//                                           style: TextStyle(
//                                               fontSize: 18.0,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white))),
//                                 ),
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           const StudentSignup(),
//                                     ),
//                                   );
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   foregroundColor: Colors.blue,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(18.0),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             width: 200,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: ElevatedButton(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(13.0),
//                                   child: FittedBox(
//                                       child: Text('Admin Log In',
//                                           style: TextStyle(
//                                               fontSize: 18.0,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white))),
//                                 ),
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => const AdminLogin(),
//                                     ),
//                                   );
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   foregroundColor: Colors.blue,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(18.0),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 80,
//             ),
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: <Widget>[
//                   Text(
//                     'Please enter your choice',
//                     style: TextStyle(
//                       fontSize: 24.0,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(height: 16.0),
//                   InkWell(
//                     child: Icon(Icons.mic),
//                     onTap: () {
//                       // code for mic icon press action
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ));
  }
}
