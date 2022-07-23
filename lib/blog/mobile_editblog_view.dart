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
import 'package:mybabyskull/blog/mobile_post_detail.dart';
import 'package:mybabyskull/services/CRUD.dart';
import 'package:random_string/random_string.dart';
import 'package:toast/toast.dart';
import '';

import '../constants.dart';

class EditBlogView extends StatefulWidget {

  final String title;
  final String content;
  final String author;
  final List<dynamic> imgURLs;
  final String postid;
  EditBlogView({@required this.postid, @required this.title, @required this.content, @required this.author, @required this.imgURLs});

  @override
  _EditBlogViewState createState() => _EditBlogViewState();
}

class _EditBlogViewState extends State<EditBlogView> {
  
  TextEditingController titlecontroller = new TextEditingController();
  TextEditingController contentcontroller = new TextEditingController();

  bool isloading = false;
  String title, content, author;
  CRUD crudmethods = new CRUD();
  List<Uint8List> files = [];
  List<dynamic> urls = [];

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
      urls.add(null);
    });
  }

  changeImage(int i) async{
    Uint8List bytefrompicker = await ImagePickerWeb.getImage(outputType: ImageType.bytes);
    setState((){
      files[i] = bytefrompicker;
    });
  }

  update(String postid) async {
    List<dynamic> updatedurls = [];
    for(int i=0;i<files.length;i++){
      if(files[i]!=null){
        Reference rootreference = FirebaseStorage.instance.ref().child('postImages').child("${randomAlphaNumeric(10)}.jpg");
        UploadTask uploadTask = rootreference.putData(files[i]);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
        var downloadurl = await snapshot.ref.getDownloadURL();
        updatedurls.add(downloadurl);
      }else{
        updatedurls.add(urls[i]);
      }
    }

    Map <String, dynamic> updatedata = {
      "title": titlecontroller.text,
      "author": author,
      "content": contentcontroller.text,
      "time": DateTime.now(),
      "imgURL": updatedurls,
    };
    Toast.show(
      "게시글을 수정중입니다...\n 잠시만 기다려주세요.", 
      context, 
      duration: 1, 
      gravity: Toast.BOTTOM,
    );
    crudmethods.updateData(widget.postid, updatedata).then((value) {
      Navigator.pop(context);
      Navigator.pushReplacement(
      context, MaterialPageRoute(
        builder: (BuildContext context) => PostDetailView(
                            title: titlecontroller.text,
                            author: author,
                            content: contentcontroller.text,
                            postid: widget.postid,
                            imgURL: updatedurls,
                          )));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    titlecontroller.text = widget.title;
    contentcontroller.text = widget.content;
    author = widget.author;
    for(int i=0;i<widget.imgURLs.length;i++){
      urls.add(widget.imgURLs[i]);
    }
    for(int i=0;i<widget.imgURLs.length;i++){
      files.add(null);
    }
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
              setState(() {
                pickandaddImage();
              });
            },
            child: Icon(
              Icons.add_a_photo_outlined,
              color: Colors.white,
            ),
          ),
          FlatButton(
            onPressed:(){
              setState(() {
                isloading = true;
              });
              update(widget.postid);
            },
            child: AutoSizeText(
              '수정',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent),),
            
            )
          
        ],
      ),
      
      body: (isloading)? Center(child: CircularProgressIndicator()) :SingleChildScrollView(
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
                  controller: titlecontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: '제목',
                    hintText: '여기에 제목을 적어주세요'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: contentcontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: '내용',
                    hintText: '여기에 질문내용을 적어주세요'
                  ),
                ),
              ),

              (urls.length==0)? Container(
                child: AutoSizeText('사진이 없습니다'),
              ) :
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey
                  )
                ),
                child: ListView.builder(
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
                              margin: EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height/4,
                              //width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: (files.elementAt(index)==null) ? Image.network(urls.elementAt(index)) : Image.memory(files.elementAt(index))
                              ),
                            )
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: FlatButton(
                            height: MediaQuery.of(context).size.height/4,
                            child: Center(child: Icon(Icons.delete)),
                            onPressed: (){
                              setState(() {
                                files.removeAt(index);
                                urls.removeAt(index);
                              });
                            },
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}