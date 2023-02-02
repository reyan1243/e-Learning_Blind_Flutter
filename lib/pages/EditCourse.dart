import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../components/input_field.dart';

class EditCourse extends StatefulWidget {
  Map<String, dynamic> data;
  EditCourse(this.data);
  @override
  State<EditCourse> createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {
  String? courseID;
  @override
  void initState() {
    nameController.text = widget.data['name'];
    descController.text = widget.data['desc'];
    courseID = widget.data['courseID'];
    super.initState();
  }

  @override
  void dispose() {
    nameNode.dispose();
    nameController.clear();
    descController.clear();

    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  FocusNode nameNode = FocusNode();
  FocusNode descNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final double screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Course"),
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
                      textValueController: nameController,
                      node: nameNode,
                      label: 'Name',
                      hint: 'Add Course Name',
                      suffixIcon: const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                      onValidate: (val) {
                        if (val.isEmpty) {
                          return 'Please provide a name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    InputField(
                      textValueController: descController,
                      node: descNode,
                      label: 'Description',
                      hint: 'Add Course Description',
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
                                child: Text('Edit',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                          ),
                          onPressed: () async {
                            if (nameController.text.isNotEmpty &&
                                descController.text.isNotEmpty) {
                              _submit();
                              setState(() {});

                              Navigator.pop(context);
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

      await FirebaseFirestore.instance.collection("courses").doc(courseID).set({
        "courseID": courseID,
        "name": nameController.text,
        "desc": descController.text
      }).then((value) => Fluttertoast.showToast(
          msg: 'Course Updated!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white));
    } on PlatformException catch (er) {
      print(er.message);
    }

    // Category category = Category(
    //   catName: taskTitleController.text,
    // );

    // await _taskController.addCategory(category: category);
  }
}
