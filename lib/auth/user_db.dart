import 'package:cloud_firestore/cloud_firestore.dart';

class UserDBMethods{
  Future<void> uploadUserInfo(userMap) async {
    await FirebaseFirestore.instance.collection("Users").add(userMap)
    .catchError((e){
      print(e);
    });
  }

  getUserByEmail(String email) async {
    return await FirebaseFirestore.instance.collection("Users")
    .where("useremail", isEqualTo: email)
    .get().catchError((e){print(e);});
  }
  
}