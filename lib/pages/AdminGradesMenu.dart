import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearningblind/components/input_field.dart';
import 'package:elearningblind/pages/AddCourse.dart';
import 'package:elearningblind/pages/AdminLectures.dart';
import 'package:elearningblind/pages/AdminMenu.dart';
import 'package:elearningblind/pages/LecturesMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'UploadPdf.dart';

class AdminGradesMenu extends StatefulWidget {
  static const routeName = 'GradesMenu';

  @override
  State<AdminGradesMenu> createState() => _AdminGradesMenuState();
}

class _AdminGradesMenuState extends State<AdminGradesMenu> {
  String? dropdownValue;

  @override
  void dispose() {
    idNode.dispose();
    idController.clear();
    descController.clear();

    super.dispose();
  }

  _submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      _uploadTask();
    }
  }

  _uploadTask() async {
    try {
      // // var doc = FirebaseFirestore.instance.collection("grades").doc();
      // print(doc.id);
      // print(dropdownValue);

      await FirebaseFirestore.instance
          .collection("grades")
          .doc(dropdownValue)
          .set({
        "studentID": dropdownValue,
      });

      await FirebaseFirestore.instance
          .collection("grades")
          .doc(dropdownValue)
          .collection("studentgrades")
          .add({"id": idController.text, "desc": descController.text}).then(
              (value) => Fluttertoast.showToast(
                  msg: 'Grade Added!',
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

  final formKey = GlobalKey<FormState>();

  TextEditingController idController = TextEditingController();
  TextEditingController descController = TextEditingController();

  FocusNode idNode = FocusNode();
  FocusNode descNode = FocusNode();
  bool isSelected = false;
  // var items = [
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grades Menu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 15.0,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return Column(
                      children: [
                        const Text(
                          "Select Student:",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.all(40),
                          height: 70,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 0.80),
                          ),
                          child: DropdownButton<String>(
                            hint: Text("Select"),
                            borderRadius: BorderRadius.circular(8),
                            value: null,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 8,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                            underline: DropdownButtonHideUnderline(
                              child: Container(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                isSelected = true;
                                dropdownValue = value!;
                              });
                            },
                            items: snapshot.data!.docs
                                .map<DropdownMenuItem<String>>((value) {
                              Map<String, dynamic> data =
                                  value.data()! as Map<String, dynamic>;

                              return DropdownMenuItem<String>(
                                value: data['studentID'],
                                child:
                                    FittedBox(child: Text(data['studentID'])),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  }),
              SizedBox(
                height: 15.0,
              ),
              isSelected
                  ? Form(
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
                                  label: 'Grade ID',
                                  hint: 'Add Grade ID',
                                  suffixIcon: const SizedBox(
                                    height: 0.0,
                                    width: 0.0,
                                  ),
                                  onValidate: (val) {
                                    if (val.isEmpty) {
                                      return 'Please provide an ID';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                InputField(
                                  textValueController: descController,
                                  node: descNode,
                                  label: 'Description',
                                  hint: 'Add Grade Description',
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
                                  height: 10,
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
                                        if (idController.text.isNotEmpty &&
                                            descController.text.isNotEmpty) {
                                          _submit();
                                          setState(() {});
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  'Please fill the text boxes!',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.blueGrey,
                                              textColor: Colors.white);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
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
                    )
                  : SizedBox(
                      height: 0,
                      width: 0,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
