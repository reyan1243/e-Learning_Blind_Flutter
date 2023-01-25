import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../components/input_field.dart';

class EditLectureScreen extends StatefulWidget {
  Map<String, dynamic> data;
  String type;
  EditLectureScreen(this.data, this.type);

  @override
  State<EditLectureScreen> createState() => _EditLectureScreenState();
}

class _EditLectureScreenState extends State<EditLectureScreen> {
  late Map<String, dynamic> data;
  late String type;
  late String courseID, docID;

  @override
  void initState() {
    data = widget.data;
    type = widget.type;
    courseID = data['courseID'];
    docID = data['docID'];

    topicController.text = data['topic'];
    urlController.text = data['url'];

    super.initState();
  }

  @override
  void dispose() {
    topicNode.dispose();
    topicController.clear();
    urlController.clear();

    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  TextEditingController topicController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  FocusNode topicNode = FocusNode();
  FocusNode urlNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final double screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Lecture"),
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
                      textValueController: topicController,
                      node: topicNode,
                      label: 'Topic',
                      hint: 'Add Topic',
                      suffixIcon: const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                      onValidate: (val) {
                        if (val.isEmpty) {
                          return 'Please provide a value';
                        } else {
                          return null;
                        }
                      },
                    ),
                    InputField(
                      textValueController: urlController,
                      node: urlNode,
                      label: 'Url',
                      hint: 'Add Url',
                      suffixIcon: const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                      onValidate: (val) {
                        if (val.isEmpty) {
                          return 'Please provide a value';
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
                                child: Text('Update',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                          ),
                          onPressed: () async {
                            if (topicController.text.isNotEmpty &&
                                urlController.text.isNotEmpty) {
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
      // var doc = FirebaseFirestore.instance.collection("courses").doc();
      // print(doc.id);

      await FirebaseFirestore.instance
          .collection("courses")
          .doc(courseID)
          .collection("lectures")
          .doc(docID)
          .update({
        "topic": topicController.text,
        "url": urlController.text
      }).then((value) => Fluttertoast.showToast(
              msg: 'Lecture Updated!',
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
