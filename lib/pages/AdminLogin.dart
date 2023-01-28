import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "AdminMenu.dart";
import 'HomePage.dart';

class AdminLogin extends StatefulWidget {
  static const routeName = 'AdminLogin';

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  var passwordController = TextEditingController();

  var userController = TextEditingController();

  bool _showPwd = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Admin Log In'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
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
                                  controller: userController,
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
                                    labelText: 'Username',
                                    hintText: "Enter username",
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                TextField(
                                  controller: passwordController,
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
                                    labelText: 'Password',
                                    hintText: "Enter password",
                                    suffixIcon: IconButton(
                                      icon: _showPwd
                                          ? Icon(Icons.visibility_off,
                                              color: Colors.black)
                                          : Icon(Icons.visibility,
                                              color: Colors.black),
                                      onPressed: () => setState(() {
                                        _showPwd = !_showPwd;
                                      }),
                                    ),
                                  ),
                                  obscureText: _showPwd,
                                ),
                                SizedBox(height: 16.0),
                                ElevatedButton(
                                  child: Text('Log In'),
                                  onPressed: () async {
                                    if (userController.text.isNotEmpty &&
                                        passwordController.text.isNotEmpty) {
                                      var pass;
                                      try {
                                        await FirebaseFirestore.instance
                                            .collection("admins")
                                            .where("username",
                                                isEqualTo: userController.text)
                                            .get()
                                            .then((doc) {
                                          if (doc.docs.isEmpty) {
                                            showDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  return AlertDialog(
                                                      title: const Text(
                                                          "Login Error"),
                                                      content: FittedBox(
                                                          child:
                                                              Column(children: <
                                                                  Widget>[
                                                        const Text(
                                                            "No user found with these credentials."),
                                                        IconButton(
                                                            icon: const Icon(
                                                              Icons.arrow_back,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            })
                                                      ])));
                                                });
                                          } else {
                                            pass = doc.docs.first["password"];
                                            if (pass ==
                                                passwordController.text) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdminMenu(),
                                                ),
                                              );
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) {
                                                    return AlertDialog(
                                                        title: const Text(
                                                            "Login Error"),
                                                        content: FittedBox(
                                                            child: Column(
                                                                children: <
                                                                    Widget>[
                                                              const Text(
                                                                  "Incorrect username or password"),
                                                              IconButton(
                                                                  icon:
                                                                      const Icon(
                                                                    Icons
                                                                        .arrow_back,
                                                                    size: 20,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  })
                                                            ])));
                                                  });
                                            }
                                          }
                                        });
                                      } on PlatformException catch (err) {
                                        // If any error
                                        String? message;
                                        if (err.message != null) {
                                          message = err.message;
                                        }

                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AlertDialog(
                                                  title: const Text(
                                                      "Oops something went wrong"),
                                                  content: FittedBox(
                                                      child: Column(children: <
                                                          Widget>[
                                                    Text(err.message == null
                                                        ? "sorry for inconvenience"
                                                        : message!),
                                                    IconButton(
                                                        icon: const Icon(
                                                            Icons.arrow_back),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        })
                                                  ])));
                                            });
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'Please fill the text boxes!',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.blueGrey,
                                          textColor: Colors.white);
                                    }
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
              ),
            ],
          ),
        ));
  }
}
