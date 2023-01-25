import 'package:flutter/material.dart';
import "AdminMenu.dart";

class AdminLogin extends StatelessWidget {
  static const routeName = 'AdminLogin';

  const AdminLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Admin Log In'),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: 150,
              width: 600,
              // decoration: new BoxDecoration(
              //   image: new DecorationImage(
              //     image: new AssetImage("images/background_top.png"),
              //     fit: BoxFit.fill,
              //     alignment: Alignment.topRight,
              //   ),
              // ),
            ),
            Container(),
            Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // this line centers the title

                children: [
                  // Container(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: Text(
                  //     'Admin Sign In',
                  //     style: TextStyle(
                  //       fontSize: 24.0,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                ),
                              ),
                              SizedBox(height: 16.0),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                ),
                                obscureText: true,
                              ),
                              SizedBox(height: 16.0),
                              ElevatedButton(
                                child: Text('Log In'),
                                onPressed: () {
                                  // code for log in action
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminMenu(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 80,
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: Column(
                  //     children: <Widget>[
                  //       Text(
                  //         'Please enter your choice',
                  //         style: TextStyle(
                  //           fontSize: 24.0,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         height: 16.0,
                  //       ),
                  //       InkWell(
                  //         child: Icon(Icons.mic),
                  //         onTap: () {
                  //           // code for mic icon press action
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ));

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Admin Log In'),
    //   ),
    //   body: Column(
    //     mainAxisAlignment:
    //         MainAxisAlignment.center, // this line centers the title

    //     children: [
    //       Container(
    //         padding: const EdgeInsets.all(16.0),
    //         child: Text(
    //           'Admin Sign In',
    //           style: TextStyle(
    //             fontSize: 24.0,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ),
    //       Center(
    //         child: Card(
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.all(16.0),
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: <Widget>[
    //                     TextField(
    //                       decoration: InputDecoration(
    //                         labelText: 'Email',
    //                       ),
    //                     ),
    //                     SizedBox(height: 16.0),
    //                     TextField(
    //                       decoration: InputDecoration(
    //                         labelText: 'Password',
    //                       ),
    //                       obscureText: true,
    //                     ),
    //                     SizedBox(height: 16.0),
    //                     ElevatedButton(
    //                       child: Text('Log In'),
    //                       onPressed: () {
    //                         // code for log in action
    //                       },
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       SizedBox(
    //         height: 80,
    //       ),
    //       Container(
    //         padding: const EdgeInsets.all(16.0),
    //         child: Column(
    //           children: <Widget>[
    //             Text(
    //               'Please enter your choice',
    //               style: TextStyle(
    //                 fontSize: 24.0,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //             SizedBox(
    //               height: 16.0,
    //             ),
    //             InkWell(
    //               child: Icon(Icons.mic),
    //               onTap: () {
    //                 // code for mic icon press action
    //               },
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
