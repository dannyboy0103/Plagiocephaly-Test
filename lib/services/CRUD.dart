import 'package:cloud_firestore/cloud_firestore.dart';

class CRUD{
  //게시판 관련
  Future<void> uploadData(data) async{
    FirebaseFirestore.instance.collection('Posts').add(data).catchError((e){
      print(e);
    });
  }

  Future<void> updateData(selectedDoc, newValues) async{
    FirebaseFirestore.instance.collection('Posts').doc(selectedDoc)
    .update(newValues)
    .catchError((e){print(e);});
  }

  deleteData(docid) async {
    FirebaseFirestore.instance.collection('Posts').doc(docid).delete().catchError((e){print(e);});
    var collection = FirebaseFirestore.instance.collection('Posts').doc(docid).collection('Comments');
    var snapshots = await collection.get();
    for(var doc in snapshots.docs){
      await doc.reference.delete();
    }
  }

  getMyPosts(String currentUser) async{
    return await FirebaseFirestore.instance.collection('Posts').
    where('author',isEqualTo: currentUser).orderBy('time');
  }

  getData() async {
    return await FirebaseFirestore.instance.collection('Posts')
    .orderBy('time')
    .snapshots();
  }

  //사진으로 진단 관련
  Future<void> upload_Values(data) async{ //사진으로 진단에서 수치및 머리사진링크 업로드
    FirebaseFirestore.instance.collection('Values').add(data).catchError((e){
      print(e);
    });
  }

  Future<void> update_Values(selecteddoc, newValues) async{// 수치및 사진 업데이트
    FirebaseFirestore.instance.collection('Values').doc(selecteddoc)
    .update(newValues)
    .catchError((e){print(e);});
  }

  getValuesByEmail(String email) async {
    return await FirebaseFirestore.instance.collection('Values')
    .where("useremail", isEqualTo: email)
    .get();
  }

  //게시판 댓글 관련
  Future<void> addComments(String postid, Map<String, dynamic> comment) async{
    FirebaseFirestore.instance.collection('Posts').doc(postid).collection('Comments').add(comment).catchError((e){
      print(e);
    });
  }
  

  getComments(String postid) async{
    return FirebaseFirestore.instance.collection('Posts').doc(postid).collection('Comments')
    .orderBy('time')
    .snapshots();
  }


  //지원병원 검색 관련
  getHospitals() async {
    return await FirebaseFirestore.instance.collection('Hospitals').get();
  }

}