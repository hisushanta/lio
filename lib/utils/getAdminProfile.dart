import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProfile {
  List<String> adminEmails = [];
  
  Future<void> getAllAdminEmails() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('admin')
          .doc('allAdmin')
          .get();

      if (doc.exists) {
        List<dynamic> emailsDynamic = doc.get('email');
        adminEmails = emailsDynamic.cast<String>();
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error getting admin emails: $e');
    }
  }

  bool isAdmin(String email) {
    return adminEmails.contains(email);
  }
}