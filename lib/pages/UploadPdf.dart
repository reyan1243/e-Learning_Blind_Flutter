import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'dart:io';
// import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_document_picker/flutter_document_picker.dart';

import '../components/input_field.dart';

class UploadPdf extends StatefulWidget {
  var courseId;
  UploadPdf(this.courseId);

  @override
  _UploadPdfState createState() => _UploadPdfState();
}

class _UploadPdfState extends State<UploadPdf> {
  // String courseId = "Q4H65HlThvpvCZUR7Jla";

  String? courseId;

  void signIn() async {
    await FirebaseAuth.instance
        .signInAnonymously()
        .then((value) => print(value));
  }

  // mAuth.signInAnonymously();

  Future<firebase_storage.UploadTask?> uploadFile(
      File? file, String filename, String topic) async {
    if (file == null) {
      // Scaffold.of(context).showSnackBar(SnackBar(content: Text("Unable to Upload")));
      print("no file exist");
      return null;
    }

    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('playground')
        .child('/${filename}');

    // final metadata = firebase_storage.SettableMetadata(
    //     contentType: 'file/pdf',
    //     customMetadata: {'picked-file-path': file.path});
    print("Uploading..!");

    uploadTask = ref.putData(await file.readAsBytes());

    print("done..!");

    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('playground/${filename}')
        .getDownloadURL();
    print(downloadURL);

    print(courseId);

    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('lectures')
        .add({"url": downloadURL, "topic": topic}).then((value) =>
            Fluttertoast.showToast(
                msg: 'Lecture Added!',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.blueGrey,
                textColor: Colors.white));

    return Future.value(uploadTask);
  }

  @override
  void initState() {
    courseId = widget.courseId;
    signIn();
    // getUrl();
    super.initState();
  }

  @override
  void dispose() {
    nameNode.dispose();
    nameController.clear();

    super.dispose();
  }

  _submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      // _uploadTask();
    }
  }

  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  FocusNode nameNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final double screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Upload Lecture"),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.purple,
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      //   onPressed: () async {
      //     final path = await FlutterDocumentPicker.openDocument();
      //     print(path);
      //
      //     File file = File(path.toString());
      //     String filename = file.path.split('/').last;
      //     print(filename);
      //
      //     firebase_storage.UploadTask? task = await uploadFile(file, filename, );
      //   },
      // ),
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
                      label: 'Topic',
                      hint: 'Enter Lecture Topic',
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
                                child: Text('Add Lecture',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                          ),
                          onPressed: () async {
                            if (nameController.text.isNotEmpty) {
                              final path =
                                  await FlutterDocumentPicker.openDocument();
                              print(path);

                              File file = File(path.toString());
                              String filename = file.path.split('/').last;
                              print(filename);

                              firebase_storage.UploadTask? task =
                                  await uploadFile(
                                      file, filename, nameController.text);
                              _submit();
                              setState(() {});

                              Navigator.pop(context);
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
}
