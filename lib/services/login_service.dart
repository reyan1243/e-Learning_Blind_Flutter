import 'package:cloud_firestore/cloud_firestore.dart';

class LoginService{
  static Future<QuerySnapshot<Map<String, dynamic>>> adminLogIn(String adminId, String password) async {
    return await FirebaseFirestore.instance
        .collection('admins')
        .where('admin_id', isEqualTo: adminId)
        .where('password', isEqualTo: password)
        .get();
  }
}