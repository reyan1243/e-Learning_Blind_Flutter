import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../components/input_field.dart';

class AddAnswer extends StatefulWidget {
  static const routeName = 'AddAnswer';

  AddAnswer({required this.data});

  Map<String, dynamic> data;

  @override
  State<AddAnswer> createState() => _AddAnswerState();
}

class _AddAnswerState extends State<AddAnswer> {
  String? courseID, docID, studentID;

  @override
  void initState() {
    courseID = widget.data['courseID'];
    studentID = widget.data['studentID'];
    // descController.text = widget.data['desc'];
    docID = widget.data['docID'];
    super.initState();
  }

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
        title: Text("Add Answer"),
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
                      maxLine: 10,
                      textValueController: descController,
                      node: descNode,
                      label: 'Answer',
                      hint: 'Add Answer',
                      suffixIcon: const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                      onValidate: (val) {
                        if (val.isEmpty) {
                          return 'Please provide an answer';
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
                              // Fluttertoast.showToast(
                              //     msg: 'Please fill the text boxe!',
                              //     toastLength: Toast.LENGTH_SHORT,
                              //     gravity: ToastGravity.BOTTOM,
                              //     backgroundColor: Colors.blueGrey,
                              //     textColor: Colors.white);
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
      // var doc = FirebaseFirestore.instance
      //     .collection('courses')
      //     .doc(courseID)
      //     .collection('testsassignments')
      //     .doc(docID)
      //     .collection('answers')
      //     .doc();
      // print(doc.id);

      bool exists = false;

      await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseID)
          .collection('testsassignments')
          .doc(docID)
          .collection('answers')
          .where("studentID", isEqualTo: studentID)
          .get()
          .then((doc) {
        if (doc.docs.isNotEmpty) {
          print("answer Exists"); //todo: add message
          exists = true;
        }
      });

      if (!exists) {
        await FirebaseFirestore.instance
            .collection('courses')
            .doc(courseID)
            .collection('testsassignments')
            .doc(docID)
            .collection('answers')
            .add({
          "studentID": studentID,
          "assignmentID": docID,
          "courseID": courseID,
          "answer": descController.text
        }).then((value) => Fluttertoast.showToast(
                msg: 'Answer Submitted!',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.blueGrey,
                textColor: Colors.white));
      }

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
