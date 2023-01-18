import 'package:cloud_firestore/cloud_firestore.dart';

class LoginService {
  static Future<DocumentReference<Map<String, dynamic>>> createUserAccount(
      String studentName,
      String password,
      String mobileNumber,
      String studentEmail) async {

    Map<String, dynamic> studentData = {
      'studentName': studentName,
      'password': password,
      'studentEmail': studentEmail,
      'studentMobileNo': mobileNumber
    };

    // note: ref will have the returned document reference of the newly created document
    // this ref can be used to create, read, update, delete data in future
    // eg ref.update({'password': 'newPassword'});
    // ref.delete();
    var ref = await FirebaseFirestore.instance.collection('users').add(studentData);

    return ref;
  }
}
