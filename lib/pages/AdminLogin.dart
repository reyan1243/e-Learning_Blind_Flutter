import 'package:flutter/material.dart';
import "AdminMenu.dart";
import 'package:elearningblind/services/login_service.dart';

class AdminLogin extends StatelessWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('Admin Log In'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: 150,
            width: 600,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_top.png"),
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
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                              ),
                            ),
                            SizedBox(height: 16.0),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 16.0),
                            ElevatedButton(
                              child: const Text('Log In'),
                              onPressed: () async {
                                // code for log in action
                                var response = await LoginService.adminLogIn("admin1", "password1");
                                print("debug print statement");
                                print(response);
                                Navigator.pushReplacement(
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
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
