import 'package:flutter/material.dart';
import "StudentMenu.dart";

class StudentLogin extends StatelessWidget {
  const StudentLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Student Log In'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/background_top.png"),
                    fit: BoxFit.fill,
                    alignment: Alignment.topRight,
                  ),
                ),
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
                    //     'Student Sign In',
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
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(width: 3, color: Colors.black),
                                    ),

                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white70,
                                    labelText: 'Email',
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                TextField(
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(width: 3, color: Colors.black),
                                    ),

                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white70,
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
                                        builder: (context) => StudentMenu(),
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
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Please enter your choice',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
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
                  ],
                ),
              ),
            ],
          ),
        ));

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Student Log In'),
    //   ),
    //   body: Column(
    //     mainAxisAlignment:
    //         MainAxisAlignment.center, // this line centers the title

    //     children: [
    //       Container(
    //         padding: const EdgeInsets.all(16.0),
    //         child: Text(
    //           'Student Sign In',
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
    //                         Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                             builder: (context) => StudentMenu(),
    //                           ),
    //                         );
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
