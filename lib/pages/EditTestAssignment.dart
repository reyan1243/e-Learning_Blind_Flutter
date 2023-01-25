import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../components/input_field.dart';

class EditTestAssignment extends StatefulWidget {
  String? courseID;
  Map<String, dynamic> data;

  EditTestAssignment({required this.courseID, required this.data});
  @override
  State<EditTestAssignment> createState() => _EditTestAssignmentState();
}

class _EditTestAssignmentState extends State<EditTestAssignment> {
  String? courseID, docID;

  @override
  void initState() {
    courseID = widget.courseID;
    questionController.text = widget.data['question'];
    descController.text = widget.data['desc'];
    docID = widget.data['docID'];
    super.initState();
  }

  @override
  void dispose() {
    // nameNode.dispose();
    // nameController.clear();
    questionController.clear();
    // nameController.clear();
    descController.clear();

    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  // TextEditingController nameController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController descController = TextEditingController();

  // FocusNode nameNode = FocusNode();
  FocusNode questionNode = FocusNode();
  FocusNode descNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final double screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Tests and Assignments"),
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
                      textValueController: questionController,
                      node: questionNode,
                      label: 'Question',
                      hint: 'Add Question',
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
                      textValueController: descController,
                      node: descNode,
                      label: 'Description',
                      hint: 'Add Description',
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
                            if (questionController.text.isNotEmpty &&
                                descController.text.isNotEmpty) {
                              _submit();
                              setState(() {});
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Please fill the text boxes!',
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
          .collection("testsassignments")
          .doc(docID)
          .update({
        "question": questionController.text,
        "desc": descController.text,
      }).then((value) => Fluttertoast.showToast(
              msg: 'Data Updated!',
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
