import 'dart:html';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_web_image_picker/flutter_web_image_picker.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';
import 'package:mybabyskull/auth/shared_preferences.dart';
import 'package:mybabyskull/services/CRUD.dart';
import 'package:random_string/random_string.dart';
import 'package:toast/toast.dart';
import '';

import '../constants.dart';

class AddBlogView extends StatefulWidget {
  @override
  _AddBlogViewState createState() => _AddBlogViewState();
}

class _AddBlogViewState extends State<AddBlogView> {
  
  bool isloading = false;
  String title ="";
  String content = "";
  String author;
  CRUD crudmethods = new CRUD();
  List<Uint8List> files = [];

  getUserName() async {
    return Helperfunctions.getUserNameSharedPreference().then((value){
      setState((){
        author = value;
      });
    });
  }


  pickandaddImage() async{
    Uint8List bytefrompicker = await ImagePickerWeb.getImage(outputType: ImageType.bytes);
    setState((){
      files.add(bytefrompicker);
    });
  }

  changeImage(int i) async {
    Uint8List bytefrompicker = await ImagePickerWeb.getImage(outputType: ImageType.bytes);
    setState((){
      files[i] = bytefrompicker;
    });
  }

  

  upload() async {
    List<dynamic> urls = [];
    for(int i=0;i<files.length;i++){
      if(files[i]!=null){
        Reference rootreference = FirebaseStorage.instance.ref().child('postImages').child("${randomAlphaNumeric(10)}.jpg");
        UploadTask uploadTask = rootreference.putData(files[i]);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
        var downloadurl = await snapshot.ref.getDownloadURL();
        urls.add(downloadurl);
      }
    }

    Map <String, dynamic> postdata = {
      "title": title,
      "author": author,
      "content": content,
      "time": DateTime.now(),
      "imgURL": urls,
    };
    crudmethods.uploadData(postdata).then((value) {Navigator.pushReplacementNamed(context, 'mainblogView');});
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:  Colors.black.withOpacity(0.8),
        title: Text(
          '게시글 추가',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: FlatButton(
          child: Icon( 
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          FlatButton(
            onPressed: (){
              pickandaddImage();
              setState(() {
                
              });
            },
            child: Icon(
              Icons.add_a_photo_outlined,
              color: Colors.white,
            ),
          ),
          FlatButton(
            onPressed:(){
              Toast.show(
                "게시글을 업로드 중입니다...\n 잠시만 기다려주세요.", 
                context, 
                duration: 2, 
                gravity: Toast.BOTTOM,
              );
              if(content == "" || title == "")
              {Toast.show(
                "제목과 내용을 모두 입력해주세요.", 
                context, 
                duration: 2, 
                gravity: Toast.BOTTOM,
              );}
              else
              {
              setState(() {
                isloading = true;
              });
              upload();}
            },
          child: Text(
            '등록',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.blueAccent),),
        )
        ],
      ),
      body: (isloading)? Center(child: CircularProgressIndicator(),) :SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 56,
                width: MediaQuery.of(context).size.width,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: '제목',
                    hintText: '제목을 입력하세요'
                  ),
                  onChanged: (value){
                    title = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: '내용',
                    hintText: '내용을 입력하세요'
                  ),
                  onChanged: (value){
                    content = value;
                  },
                ),
              ),
              (files.length==0)? Container() :
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey
                  )
                ),
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.all(10), child: AutoSizeText('사진을 터치하여 선택된 사진을 바꿀 수 있습니다.', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),),
                    ListView.builder(
                      padding: const EdgeInsets.all(5),
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true, 
                      itemCount: files.length,
                      itemBuilder: (context, index){
                        return Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: GestureDetector(
                                onTap: (){
                                  changeImage(index);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  height: MediaQuery.of(context).size.height/4,
                                  //width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.memory(files[index])
                                  ),
                                )
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: FlatButton(
                                height: MediaQuery.of(context).size.height/4,
                                child: Column(
                                  children: [
                                    Center(child: Icon(Icons.delete)),
                                    SizedBox(height: 5,),
                                    Center(child: AutoSizeText('삭제', style: TextStyle(color: Colors.red),),)
                                  ],
                                ),
                                onPressed: (){
                                  files.removeAt(index);
                                  setState(() {});
                                },
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),    
            ],
          ),
        ),
      ),
    );
  }
}