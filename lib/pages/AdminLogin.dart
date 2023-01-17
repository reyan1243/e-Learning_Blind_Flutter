import 'package:flutter/material.dart';
import "AdminMenu.dart";
// ignore: import_of_legacy_library_into_null_safe
import 'package:elearningblind/services/login_service.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController _idController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  // prevent memory leaks
  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                image: AssetImage("images/background_top.png"),
                fit: BoxFit.fill,
                alignment: Alignment.topRight,
              ),
            ),
          ),
          Container(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                              controller: _idController,
                              decoration: const InputDecoration(
                                labelText: 'Id',
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            ElevatedButton(
                              child: const Text('Log In'),
                              onPressed: () async {
                                try {
                                  var response = await LoginService.adminLogIn(
                                      _idController.text,
                                      _passwordController.text);
                                  // print what we get
                                  debugPrint(response.toString());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminMenu(),
                                    ),
                                  );
                                } catch (e) {
                                  final snackbar =
                                      SnackBar(content: Text(e.toString()));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackbar);
                                }
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
