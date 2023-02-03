import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../components/input_field.dart';

class AddAnnouncements extends StatefulWidget {
  @override
  State<AddAnnouncements> createState() => _AddAnnouncementsState();
}

class _AddAnnouncementsState extends State<AddAnnouncements> {
  //
  // @override
  // void initState() {
  //   widget.id != null ? getTask() : super.initState();
  // }

  @override
  void dispose() {
    // nameNode.dispose();
    // nameController.clear();
    descController.clear();

    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  // TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  // FocusNode nameNode = FocusNode();
  FocusNode descNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final double screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Announcement"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InputField(
                      textValueController: descController,
                      node: descNode,
                      label: 'Description',
                      hint: 'Add Announcement Description',
                      suffixIcon: const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                      onValidate: (val) {
                        if (val.isEmpty) {
                          return 'Please provide a desc';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: screenH * 0.05,
                    ),
                    Container(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: const Padding(
                            padding: EdgeInsets.all(13.0),
                            child: FittedBox(
                                child: Text('Add',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                          ),
                          onPressed: () async {
                            if (
                                // nameController.text.isNotEmpty &&
                                descController.text.isNotEmpty) {
                              _submit();
                              setState(() {});
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Please fill the text boxe!',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.blueGrey,
                                  textColor: Colors.white);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      _uploadTask();
    }
  }

  _uploadTask() async {
    try {
      var doc = FirebaseFirestore.instance.collection("announcements").doc();
      print(doc.id);

      await FirebaseFirestore.instance
          .collection("announcements")
          .doc(doc.id)
          .set({
        "id": doc.id,
        "desc": descController.text,
        "createdAt": DateTime.now(),
      }).then((value) => Fluttertoast.showToast(
              msg: 'Announcement Added!',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white));

      // fire notification
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('device_tokens').get();

      List<String> tokens = [];

      print(snapshot.docs[1]['token']);

      // for (int i = 0; i < snapshot.docs.length; i++) {
      //   tokens.add(snapshot.docs[i]['token']);
      // }

      // now call api to show notification on all devices
      const String SERVER_KEY =
          "AAAAWCZlrro:APA91bEi0dwElLkIqsT2JIzUayebbwnDVbp1g_YhE2uVk-N9vu-7LnBG9KdQMiEzPgCmw000N1D75EJObTDNEpUTHQoQUJMHLrErGJyHg89uy71MyuHC3Qc0Ufvv_KZfSaRXJPMQapW-";

      // const String APIEndpoint = "https://fcm.googleapis.com/fcm/send";

      final Map<String, dynamic> data = {
        'registration_ids': tokens,
        'notification': {
          "body": "New Announcement has been shared",
          "title": "Update",
          "android_channel_id": "elearning-blind",
          "sound": false
        },
      };

      final String body = json.encode(data);

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=$SERVER_KEY',
      };

      await http
          .post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: headers,
            body: body,
          )
          .then((value) => Fluttertoast.showToast(
              msg: 'Announcement Notification created!',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white));

      Navigator.pop(context);
    } on PlatformException catch (er) {
      print(er.message);
    }

    // Category category = Category(
    //   catName: taskTitleController.text,
    // );

    // await _taskController.addCategory(category: category);
  }
}
