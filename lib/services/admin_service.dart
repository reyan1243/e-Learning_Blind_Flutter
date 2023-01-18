import 'package:cloud_firestore/cloud_firestore.dart';

// note
// design choice: named arguments are used to avoid unnecessary debugging when
// communicating with frontend

class AdminService {
  static Future<DocumentReference<Map<String, dynamic>>> createAnnouncement({
    required String announcementTitle,
    required String announcementDescription,
    required String announcementDate,
  }) async {
    Map<String, dynamic> announcementData = {
      'announcementTitle': announcementTitle,
      'announcementDescription': announcementDescription,
      'announcementDate': announcementDate
    };

    var ref = await FirebaseFirestore.instance
        .collection('announcements')
        .add(announcementData);
    return ref;
  }

  static void updateAnnouncement(
      // note
      // only those args are passed in the method call which are required to be
      // updated
      // for example, if for an announcement, only the description needs to
      // be changed then updateAnnouncement(announcementDescription: "new description");
      {
    required String id,
    String? announcementTitle,
    String? announcementDescription,
    String? announcementDate,
  }) async {
    Map<String, dynamic> updateData = {};

    if (announcementTitle != null) {
      updateData['announcementTitle'] = announcementTitle;
    }
    if (announcementDescription != null) {
      updateData['announcementDescription'] = announcementDescription;
    }
    if (announcementDate != null) {
      updateData['announcementDate'] = announcementDate;
    }

    // note
    // update returns void https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/DocumentReference/update.html,
    // might want to handle it on frontend by showing a snack bar
    await FirebaseFirestore.instance
        .collection('announcements')
        .doc(id)
        .update(updateData);
  }

  static Future<DocumentReference<Map<String, dynamic>>> createAssTest(
    String assTestTitle,
    String assTestDescription,
    String assTestDate,
    int questionNo,
    List<dynamic> studentId,
  ) async {
    Map<String, dynamic> assTestData = {
      'assTestTitle': assTestTitle,
      'assTestDescription': assTestDescription,
      'assTestDate': assTestDate,
      'questionNo': questionNo,
      'studentId': studentId
    };

    var ref = await FirebaseFirestore.instance
        .collection('assignments')
        .add(assTestData);

    return ref;
  }

  static void updateAssTest(
      {required String id,
      String? assTestTitle,
      String? assTestDescription,
      String? assTestDate,
      int? questionNo,
      List<dynamic>? studentId}) async {
    Map<String, dynamic> updateData = {};

    if (assTestTitle != null) {
      updateData['assTestTitle'] = assTestTitle;
    }

    if (assTestDescription != null) {
      updateData['assTestDescription'] = assTestDescription;
    }

    if (assTestDate != null) {
      updateData['assTestDate'] = assTestDate;
    }

    if (questionNo != null) {
      updateData['questionNo'] = questionNo;
    }

    if (studentId != null) {
      updateData['studentId'] = studentId;
    }

    await FirebaseFirestore.instance
        .collection('assignments')
        .doc(id)
        .update(updateData);
  }

  static Future<DocumentReference<Map<String, dynamic>>> createGrade({
    required String gradeDescription,
    required List<dynamic> assTestId,
  }) async {
    Map<String, dynamic> gradeData = {
      'gradeDescription': gradeDescription,
      'assTestId': assTestId
    };

    var ref =
        await FirebaseFirestore.instance.collection('grades').add(gradeData);

    return ref;
  }

  static void updateGrade({
    required String id,
    String? gradeDescription,
    List<dynamic>? assTestId,
  }) async {
    Map<String, dynamic> updateData = {};

    if (gradeDescription != null) {
      updateData['gradeDescription'] = gradeDescription;
    }
    if (assTestId != null) {
      updateData['assTestId'] = assTestId;
    }

    await FirebaseFirestore.instance
        .collection('grades')
        .doc(id)
        .update(updateData);
  }

  static Future<DocumentReference<Map<String, dynamic>>> createLecture({
    required String lectureTitle,
    required String lectureDescription,
    required String lectureDate,
    required List<dynamic> studentId,
  }) async {
    Map<String, dynamic> lectureData = {
      'lectureTitle': lectureTitle,
      'lectureDescription': lectureDescription,
      'lectureDate': lectureDate,
      'studentId': studentId
    };

    var ref = await FirebaseFirestore.instance
        .collection('lectures')
        .add(lectureData);
    return ref;
  }

  static void updateLecture({
    required String id,
    String? lectureTitle,
    String? lectureDescription,
    String? lectureDate,
    List<dynamic>? studentId,
  }) async {
    Map<String, dynamic> gradeData = {
      'lectureTitle': lectureTitle,
      'lectureDescription': lectureDescription,
      'lectureDate': lectureDate,
      'studentId': studentId
    };

    await FirebaseFirestore.instance
        .collection('lectures')
        .doc(id)
        .update(gradeData);
  }
}
