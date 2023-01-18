import 'package:cloud_firestore/cloud_firestore.dart';

// note
// Stream<QuerySnapshot<Map<String, dynamic>>>

class StudentService {
  static Future<QuerySnapshot<Map<String, dynamic>>> getAnnouncements() async {
    var data =
        await FirebaseFirestore.instance.collection('announcements').get();

    return data;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getLectures() async {
    var data = await FirebaseFirestore.instance.collection('lectures').get();

    return data;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getGrades() async {
    var data = await FirebaseFirestore.instance.collection('grades').get();

    return data;
  }

  static void submitAssTest() async {
    //todo
  }
}
