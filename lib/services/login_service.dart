import 'package:cloud_firestore/cloud_firestore.dart';

class LoginService{
  static Future<QuerySnapshot<Map<String, dynamic>>> adminLogIn(String adminId, String password) async {
    return await FirebaseFirestore.instance
        .collection('admins')
        .where('admin_id', isEqualTo: adminId)
        .where('password', isEqualTo: password)
        .get();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> studentLogIn(String email, String password) async {
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

    return await FirebaseFirestore.instance
        .collection('user')
        .where('studentEmail', isEqualTo: studentEmail)
        .where('studentPassword', isEqualTo: password)
        .get();
  }
}