import 'package:cloud_firestore/cloud_firestore.dart';

class Crud {
  Future<void> addData(blogData) async {
    await FirebaseFirestore.instance
        .collection('blogs')
        .add(blogData)
        .catchError((e) {
      print(e);
    });
  }
}
