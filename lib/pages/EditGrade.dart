import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../components/input_field.dart';

class EditGrade extends StatefulWidget {
  Map<String, dynamic> data;

  EditGrade(this.data);

  @override
  State<EditGrade> createState() => _EditGradeState();
}

class _EditGradeState extends State<EditGrade> {
  String? studentID, answerID, assignmentID, courseID, desc, docID;

  @override
  void dispose() {
    nameNode.dispose();
    nameController.clear();

    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  FocusNode nameNode = FocusNode();
  bool exists = false;
  @override
  void initState() {
    courseID = widget.data['courseID'];
    studentID = widget.data['studentID'];
    answerID = widget.data['answerID'];
    assignmentID = widget.data['assignmentID'];
    desc = widget.data['desc'];
    docID = widget.data['docID'];

    nameController.text = desc!;

    // docID = widget.data['docID'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Grade"),
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
                    Text("Student ID: ${studentID!}"),
                    InputField(
                      textValueController: nameController,
                      node: nameNode,
                      label: 'Grade',
                      hint: 'Add Grade',
                      suffixIcon: const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                      onValidate: (val) {
                        if (val.isEmpty) {
                          return 'Please provide a Grade';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: screenH * 0.05,
                    ),
                    !exists
                        ? Container(
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
                                  if (nameController.text.isNotEmpty) {
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
                          )
                        : SizedBox(
                            height: 0,
                            width: 0,
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
      // var doc = FirebaseFirestore.instance
      //     .collection('courses')
      //     .doc(courseID)
      //     .collection('grades')
      //     .doc();
      // print(doc.id);
      // bool exists = false;
      //
      // await FirebaseFirestore.instance
      //     .collection('courses')
      //     .doc(courseID)
      //     .collection('grades')
      //     .where("studentID", isEqualTo: studentID)
      //     .get()
      //     .then((doc) {
      //   if (doc.docs.isNotEmpty) {
      //     print("answer Exists"); //todo: add message
      //     exists = true;
      //     Fluttertoast.showToast(
      //         msg: 'Grade Exists!',
      //         toastLength: Toast.LENGTH_SHORT,
      //         gravity: ToastGravity.BOTTOM,
      //         backgroundColor: Colors.blueGrey,
      //         textColor: Colors.white);
      //   }
      // });

      // if (!exists) {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseID)
          .collection('grades')
          .doc(docID)
          .update({
        "courseID": courseID,
        "assignmentID": assignmentID,
        "answerID": answerID,
        "studentID": studentID,
        "desc": nameController.text,
      }).then((value) => Fluttertoast.showToast(
              msg: 'Grade Updated!',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white));
      // }
    } on PlatformException catch (er) {
      print(er.message);
    }

    // Category category = Category(
    //   catName: taskTitleController.text,
    // );

    // await _taskController.addCategory(category: category);
  }
}
