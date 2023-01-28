import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class StudentSignup extends StatefulWidget {
  static const routeName = 'StudentSignup';

  @override
  State<StudentSignup> createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup> {
  final _auth = FirebaseAuth.instance;

  bool _showPwd = true;

  final pwd = TextEditingController();

  final cnfrmpwd = TextEditingController();

  late bool hasDigits;

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  var _userEmail = '';

  var _userPassword = '';

  bool right = false;

  bool _showCnfrmPwd = true;

  void validation() {
    hasDigits = (pwd.text).contains(new RegExp(r'[0-9]'));

    (pwd.text).contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (hasDigits) {
      setState(() {
        right = true;
      });
      return;
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              elevation: 10,
              content: FittedBox(
                  child: Column(
                children: <Widget>[
                  Text('  Passwords must have :',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Atleast one number from 0-9!',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              )),
            );
          });
    }
  }

  // void saveAll() async {
  //   AuthResult authResult;
  //   final isValid = _formKey.currentState.validate();
  //   FocusScope.of(context).unfocus();
  //
  //   if (isValid) {
  //     _formKey.currentState.save();
  //
  //     try {
  //       setState(() {
  //         isLoading = true;
  //       });
  //       authResult = await _auth.createUserWithEmailAndPassword(
  //           email: _userEmail, password: _userPassword);
  //       if (isDonor) {
  //         await Firestore.instance
  //             .collection('donors')
  //             .document(authResult.user.uid)
  //             .setData({
  //           'username': _userName.trim(),
  //           'email': _userEmail.trim(),
  //           'type of donor': 'Restaurant',
  //           'address': _city.trim(),
  //           'reportCount': 0,
  //         });
  //       } else {
  //         await Firestore.instance
  //             .collection('receiver')
  //             .document(authResult.user.uid)
  //             .setData({
  //           'username': _userName.trim(),
  //           'email': _userEmail.trim(),
  //           'address': _city.trim(),
  //           'password': _userPassword.trim(),
  //         });
  //       }
  //       await Firestore.instance
  //           .collection('users')
  //           .document(authResult.user.uid)
  //           .setData({'Donor': isDonor});
  //
  //       isDonor
  //           ? Navigator.of(context).pushReplacementNamed(DonorMain.routeName)
  //           : Navigator.of(context)
  //               .pushReplacementNamed(ReceiverHomeScreen.routeName);
  //
  //       // Navigator.of(context).pushReplacement(
  //       //     MaterialPageRoute(builder: (ctx) => TCpage(isDonor)));
  //
  //     } on PlatformException catch (err) {
  //       var message = 'An error occurred, please check your credentials!';
  //
  //       if (err.message != null) {
  //         message = err.message;
  //       }
  //       showDialog(
  //           context: context,
  //           builder: (ctx) {
  //             return AlertDialog(
  //                 title: Text("Oops something went wrong"),
  //                 content: FittedBox(
  //                     child: Column(children: <Widget>[
  //                   Text(err.message == null
  //                       ? "sorry for inconvenience"
  //                       : message),
  //                   IconButton(
  //                       icon: Icon(Icons.arrow_back),
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       })
  //                 ])));
  //           });
  //
  //       setState(() {
  //         isLoading = false;
  //       });
  //       print(err.message);
  //     } catch (err) {
  //       showDialog(
  //           context: context,
  //           builder: (ctx) {
  //             return AlertDialog(
  //                 title: Text("Oops something went wrong"),
  //                 content: FittedBox(
  //                     child: Column(children: <Widget>[
  //                   Text("sorry for inconvenience"),
  //                   IconButton(
  //                       icon: Icon(Icons.arrow_back),
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       })
  //                 ])));
  //           });
  //
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Student Sign Up'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
            // .pushReplacementNamed(MyHomePage.routeName),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/background_top.png',
                height: 150,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // this line centers the title
                  children: [
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
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.black),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white70,
                                    labelText: 'Email',
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                TextField(
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.black),
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
                                TextField(
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.black),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white70,
                                    labelText: 'Confirm Password',
                                  ),
                                  obscureText: true,
                                ),
                                SizedBox(height: 16.0),
                                ElevatedButton(
                                  child: Text('Create Account'),
                                  onPressed: () {
                                    // code for log in action
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
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
    //     title: Text('Student Sign Up'),
    //   ),
    //   body: Column(
    //     mainAxisAlignment:
    //         MainAxisAlignment.center, // this line centers the title

    //     children: [
    //       Container(
    //         padding: const EdgeInsets.all(16.0),
    //         child: Text(
    //           'Student Sign Up',
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
    //                     TextField(
    //                       decoration: InputDecoration(
    //                         labelText: 'Confirm Password',
    //                       ),
    //                       obscureText: true,
    //                     ),
    //                     SizedBox(height: 16.0),
    //                     ElevatedButton(
    //                       child: Text('Create Account'),
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
