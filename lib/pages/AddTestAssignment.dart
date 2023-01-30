import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../components/input_field.dart';

class AddTestAssignment extends StatefulWidget {
  String? courseID;

  AddTestAssignment({required this.courseID});
  @override
  State<AddTestAssignment> createState() => _AddTestAssignmentState();
}

class _AddTestAssignmentState extends State<AddTestAssignment> {
  String? courseID, dropdownValue;
  bool isSelected = false;
  List<String> itemtypes = ["Test", "Assignment"];

  @override
  void initState() {
    courseID = widget.courseID;
    super.initState();
  }

  @override
  void dispose() {
    nameNode.dispose();
    nameController.clear();
    idController.clear();
    questionController.clear();
    // nameController.clear();
    descController.clear();

    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController idController = TextEditingController();

  FocusNode nameNode = FocusNode();
  FocusNode idNode = FocusNode();
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
                      textValueController: idController,
                      node: idNode,
                      label: 'ID',
                      hint: 'Add ID',
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
                    // InputField(
                    //   textValueController: descController,
                    //   node: descNode,
                    //   label: 'Description',
                    //   hint: 'Add Course Description',
                    //   suffixIcon: const SizedBox(
                    //     height: 0.0,
                    //     width: 0.0,
                    //   ),
                    //   onValidate: (val) {
                    //     if (val.isEmpty) {
                    //       return 'Please provide a desc';
                    //     } else {
                    //       return null;
                    //     }
                    //   },
                    // ),
                    SizedBox(
                      height: screenH * 0.05,
                    ),
                    DropdownButton<String>(
                      hint: Text("Select"),
                      borderRadius: BorderRadius.circular(8),
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 8,
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      // underline: DropdownButtonHideUnderline(
                      //   child: Container(),
                      // ),
                      onChanged: (value) {
                        setState(() {
                          isSelected = true;
                          dropdownValue = value!;
                        });
                      },
                      items: itemtypes
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: FittedBox(child: Text(item)),
                              ))
                          .toList(),
                      //   {
                      //
                      //   return DropdownMenuItem<String>(
                      //     value: data['studentID'],
                      //     child:
                      //     FittedBox(child: Text(data['studentID'])),
                      //   );
                      // }).toList(),
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
                            if (questionController.text.isNotEmpty &&
                                descController.text.isNotEmpty &&
                                idController.text.isNotEmpty &&
                                dropdownValue != null) {
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
                    //todo: checkbox for type of data
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
      var doc = FirebaseFirestore.instance
          .collection("courses")
          .doc(courseID)
          .collection("testsassignments")
          .doc();
      print(doc.id);

      await FirebaseFirestore.instance
          .collection("courses")
          .doc(courseID)
          .collection("testsassignments")
          .doc(doc.id)
          .set({
        "id": doc.id,
        'code': idController.text,
        "question": questionController.text,
        "desc": descController.text,
        "isTest": dropdownValue == "Test" ? true : false,
      }).then((value) => Fluttertoast.showToast(
              msg: 'Data Added!',
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
