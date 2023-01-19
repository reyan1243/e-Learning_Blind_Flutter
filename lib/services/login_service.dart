import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static Future<QuerySnapshot<Map<String, dynamic>>> adminLogIn(
      String adminId, String password) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('admins')
        .where('admin_id', isEqualTo: adminId)
        .where('password', isEqualTo: password)
        .get();

    // note
    // in case of a successful login, auth:true is stored in local storage
    // when the app is started, if a key named auth having value true
    // is found then user should stay logged in
    if (querySnapshot.docs.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auth', true);
    }

    return querySnapshot;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> studentLogIn(
      String email, String password) async {
    // note
    /*
    * we will take email from student as just his username (everything before @)
    * and we will append that part
    *
    * design choice 1: user emails have the same domain name since the students are from same college
    * so for example user1@college.edu.eu or hansDockter@college.eu
    *
    * design choice 2: for the speech recognition system to not get confused (for example it might easily
    * get confused between @ and at) and to make it work for students from any language background
    * or geographical region, we can assume the passwords are a string of numbers
    *
    * for example, password = 12345 or password is 437861
    *
    * */
    var studentEmail = email + "@college.eu";

    final querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('studentEmail', isEqualTo: studentEmail)
        .where('studentPassword', isEqualTo: password)
        .get();

    // note
    // in case of a successful login, auth:true is stored in local storage
    // when the app is started, if a key named auth having value true
    // is found then user should stay logged in
    if (querySnapshot.docs.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auth', true);
    }

    return querySnapshot;
  }
}
