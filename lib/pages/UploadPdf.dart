import 'package:flutter/material.dart';
import 'dart:io';
// import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_document_picker/flutter_document_picker.dart';

class UploadPdf extends StatefulWidget {
  @override
  _UploadPdfState createState() => _UploadPdfState();
}

class _UploadPdfState extends State<UploadPdf> {



  Future<firebase_storage.UploadTask?> uploadFile(File? file) async {
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
        .child('/some-file2.pdf');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'file/pdf',
        customMetadata: {'picked-file-path': file.path});
    print("Uploading..!");

    uploadTask = ref.putData(await file.readAsBytes(), metadata);

    print("done..!");

    return Future.value(uploadTask);
  }

  @override
  void initState() {

    void getUrl() async{
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('playground/some-file.pdf')
          .getDownloadURL();
      print(downloadURL);
    }
    getUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("FlutterFire PDF"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {

            final path = await FlutterDocumentPicker.openDocument();
            print(path);
            File file = File(path.toString());
            firebase_storage.UploadTask? task =  await uploadFile(file);


        },
      ),
    );
  }
}