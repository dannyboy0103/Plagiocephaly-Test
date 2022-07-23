import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:mybabyskull/auth/shared_preferences.dart';
import 'package:mybabyskull/blog/mobile_editblog_view.dart';
import 'package:mybabyskull/services/CRUD.dart';
import 'package:toast/toast.dart';
import 'package:expandable/expandable.dart';
import '../constants.dart';

class PostDetailView extends StatefulWidget {

  final String title;
  final String author;
  final String content;
  final String postid;
  final List<dynamic> imgURL;
  
  PostDetailView({@required this.title, @required this.author, @required this.content, @required this.postid, this.imgURL});

  @override
  _PostDetailViewState createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {

  bool isloading = true;
  String userid = "";
  String currentUsername = "";
  Stream commentstream;
  TextEditingController commentcontroller = new TextEditingController();
  CRUD crudmethods = new CRUD();
  bool _isfavorite = false;
  CollectionReference post_address = FirebaseFirestore.instance.collection('Posts');

  final CarouselController _controller = CarouselController();
  int _current = 0;
  int n_comments= 0;



  checkUserFavorite(String uid) async {
    await FirebaseFirestore.instance.collection('Users').doc(uid).collection('MyFavorite').get()
    .then((QuerySnapshot querysnapshot){
      if(querysnapshot.docs.length == 0){
        setState(() {
          isloading = false;
        });
      }else{
      querysnapshot.docs.forEach((element) {
        if(element["postid"] == widget.postid){
          _isfavorite = true;
        }
        print("This is " + _isfavorite.toString());
      });
      setState(() {
          isloading = false;
        });
      }

    });
  }

  getMyUserid() async {
    await FirebaseFirestore.instance.collection('Users').get()
    .then((QuerySnapshot querysnapshot){
      querysnapshot.docs.forEach((element){
        if(element["username"] == currentUsername){
          userid = element.id;
          setState(() {
              checkUserFavorite(element.id);
          });
        }
      });
    });
  }

  add_my_favorite(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('Users').doc(userid).collection('MyFavorite').add(data);
  }

  delete_my_favorite() async {
    FirebaseFirestore.instance.collection('Users')
    .doc(userid)
    .collection('MyFavorite').get()
    .then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((element) {
        if(element["postid"] == widget.postid){
          element.reference.delete();
        }
      });
    });
  }

  getUserName() async {
    return Helperfunctions.getUserNameSharedPreference().then((value){
      setState((){
        currentUsername = value;
      });
    });
  }

  uploadComment() async{
    Map<String, dynamic> commentdata = {
      "commenter": currentUsername,
      "commentcontent": commentcontroller.text,
      "time": DateTime.now(),
      "subcomments":[],
    };
    crudmethods.addComments(widget.postid, commentdata).then((value){
      Toast.show(
        "댓글이 성공적으로 업로드 되었습니다.", 
        context, 
        duration: 1, 
        gravity: Toast.BOTTOM,
      );
    });
  }

  createAlertDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: AutoSizeText('게시글 삭제', style: TextStyle(fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('정말로 게시글을 삭제하시겠습니까?'),
          ],
        ),
      ),
          actions: [
            FlatButton(
              onPressed: (){
                crudmethods.deleteData(widget.postid);
                Navigator.pop(context);
                Navigator.pop(context);
              }, 
              child: AutoSizeText('네')
            ),
            FlatButton(
              child: AutoSizeText('아니요'),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ]
        );
      }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserName();
    crudmethods.getComments(widget.postid).then((result){
      setState((){
        //isloading = true;
        commentstream = result;
        //isloading = false;
      });
    });
    setState(() {
      getMyUserid();
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return (isloading)? Scaffold(
      body: SingleChildScrollView(
        child: Center(child: CircularProgressIndicator(),),
      ),
    ) : Scaffold(
      extendBodyBehindAppBar: true,
      appBar: (widget.author == currentUsername) ? AppBar(
        actions:[
          FlatButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => EditBlogView(
                  postid: widget.postid,
                  title: widget.title,
                  content: widget.content,
                  author: widget.author,
                  imgURLs: widget.imgURL,
                )
              ));
            }, 
            child: AutoSizeText(
              '수정',
              style: TextStyle(
                fontSize: 18,
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            )
          ),
          FlatButton(
            onPressed: (){
              /*crudmethods.deleteData(widget.postid);
              Navigator.pop(context);*/
              createAlertDialog(context);
            }, 
            child: AutoSizeText(
              '삭제',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:Colors.red
                ),
            )
          )
        ],
        elevation: 0,
        backgroundColor:  Colors.black.withOpacity(0.8),
        leading: FlatButton(
          child: Icon( 
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ): AppBar(
        elevation: 0,
        backgroundColor:  Colors.black.withOpacity(0.8),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FavoriteButton(
              isFavorite: _isfavorite,
              valueChanged: (isfavorite) async {
                if (isfavorite) {
                  add_my_favorite({'postid' : widget.postid});
                } else {
                  delete_my_favorite();
                }
              },
            ),
            
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10) ,
              margin: const EdgeInsets.all(10),
              child: AutoSizeText(
                widget.title,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(child: const Divider(color: Colors.grey, thickness: 0.1)),
            Container(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height/7,
                    ),
                    child: AutoSizeText(
                      widget.content,
                      style: TextStyle(
                        color: Colors.black
                      ),
                    ),
                  ),
                  (widget.imgURL.length==0)? Container():
                  Container(
                    height: MediaQuery.of(context).size.height/2,
                    width: MediaQuery.of(context).size.width,
                    //padding: const EdgeInsets.all(10),
                    //alignment: Alignment.centerLeft,
                    /*constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height/5,
                    ),*/
                    child: Column(
                      children: [
                        Expanded(
                          child: CarouselSlider(
                                items: widget.imgURL.map((item) => 
                                  Card(
                                    margin: EdgeInsets.all(0),
                                    child: Image.network(
                                      item,
                                      fit: BoxFit.fitHeight,
                                      scale: 3,
                                      width: MediaQuery.of(context).size.width,
                                      ),
                                  )
                                ).toList(),
                                carouselController: _controller,
                                options: CarouselOptions(
                                  enableInfiniteScroll: false,
                                    autoPlay: false,
                                    enlargeCenterPage: true,
                                    //aspectRatio: 2.0,
                                    viewportFraction: 1.0,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _current = index;
                                      });
                                    }),
                              ),
                              
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: widget.imgURL.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => _controller.animateToPage(entry.key),
                              child: Container(
                                width: 10.0,
                                height: 10.0,
                                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (Theme.of(context).brightness == Brightness.dark
                                            ? Colors.white
                                            : Colors.black)
                                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    )
                    
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                //color: Colors.black12,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  Container(child: Divider(thickness:1, color: Colors.grey.shade400, height: 1.0)),
                  Container(
                    height: 56,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          child: AutoSizeText(
                            '댓글',
                            style: TextStyle(
                              //fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          child: AutoSizeText(
                            n_comments.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                Container(child: Divider(thickness:1, color: Colors.grey.shade400, height: 1.0)),                  
                StreamBuilder(
                    stream: commentstream,
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator(),);
                      }
                      if(snapshot.hasError){
                        return Center(
                          child: AutoSizeText('Error: Comments cannot be loaded', style: TextStyle(fontWeight: FontWeight.bold, color: kDarkBlueColor)),
                        );
                      }
                      if(snapshot.data.docs.length ==0){
                        return Container(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              '아직 댓글이 없습니다.\n 첫 댓글을 달아주세요.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.blueAccent
                              ),
                            ),
                          ),
                        );
                      }
                      if(snapshot.hasData){
                        return ListView.separated(
                          separatorBuilder: (BuildContext context, int index) => Container(child: Divider(thickness:1, color: Colors.grey.shade400,endIndent: 36.0, indent: 36.0, height: 1.0)),
                          padding: EdgeInsets.all(2),
                          physics: NeverScrollableScrollPhysics(),
                          //reverse: true,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true, 
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index){
                            ExpandableController econtroller;
                            bool subcommentloading = false;
                            List<dynamic> subcomments  = snapshot.data.docs[index].get("subcomments");
                            TextEditingController subcommentcontroller = new TextEditingController();
                            return Column(
                              children: [
                                Container(
                                  //padding: EdgeInsets.all(15),
                                  constraints: BoxConstraints(maxHeight: double.infinity, minHeight: MediaQuery.of(context).size.height/10),
                                  width: MediaQuery.of(context).size.width,
                                  child: ExpandablePanel(
                                    controller: econtroller,
                                    header: Container(
                                          padding: EdgeInsets.all(10),
                                          width: MediaQuery.of(context).size.width,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(snapshot.data.docs[index].get("commenter"), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                              AutoSizeText(snapshot.data.docs[index].get("commentcontent"),style: TextStyle(color: Colors.black)),
                                              AutoSizeText(snapshot.data.docs[index].get("time").toDate().toString().substring(0,snapshot.data.docs[index].get("time").toDate().toString().length-7), style: TextStyle(color: Colors.grey),),
                                            ],
                                          ),
                                        ),
                                    expanded: Container(
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          (subcomments != null)?(subcommentloading!=true)?
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  alignment: Alignment.topCenter,
                                                  //width: MediaQuery.of(context).size.width*1/7,
                                                  child: Icon(Icons.subdirectory_arrow_right),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 9,
                                                child: Container(
                                                  margin: const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  alignment: Alignment.centerRight,
                                                  //width: MediaQuery.of(context).size.width*4/5,
                                                  child: Column(
                                                    children: [
                                                      ListView.builder(
                                                        padding: EdgeInsets.all(2),
                                                        physics: NeverScrollableScrollPhysics(),
                                                        scrollDirection: Axis.vertical,
                                                        shrinkWrap: true, 
                                                        itemCount: snapshot.data.docs[index].get("subcomments").length,
                                                        itemBuilder: (context, ind){
                                                          return ListTile(
                                                            title: AutoSizeText(subcomments[ind]["subcommenter"], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                                            subtitle: Column(
                                                            //mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              AutoSizeText(subcomments[ind]["subcomment"],style: TextStyle(color: Colors.black)),
                                                              AutoSizeText(subcomments[ind]["subcommenttime"].toDate().toString().substring(0,snapshot.data.docs[index].get("time").toDate().toString().length-7), style: TextStyle(color: Colors.grey),),
                                                            ],
                                                          ),
                                                          );
                                                        }
                                                      ),
                                                      Container(
                                                        constraints: BoxConstraints(maxHeight: double.infinity, minHeight: MediaQuery.of(context).size.height/20),
                                                          width: MediaQuery.of(context).size.width,
                                                          //height: MediaQuery.of(context).size.height/20,
                                                          child: Container(
                                                            margin: const EdgeInsets.all(10),
                                                            decoration: BoxDecoration(
                                                              color: Colors.black12,
                                                              borderRadius: BorderRadius.circular(8)
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                    flex: 8,
                                                                    child: TextField(
                                                                    keyboardType: TextInputType.multiline,
                                                                    maxLines: null,
                                                                    controller: subcommentcontroller,
                                                                    decoration: InputDecoration(
                                                                      hintText: '댓글을 달아주세요',
                                                                      border: InputBorder.none,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                    flex: 2,
                                                                    child: IconButton(
                                                                      icon: Icon(Icons.send),
                                                                      color: Colors.black,
                                                                      onPressed: () async {
                                                                        if(subcommentcontroller.text == ""){
                                                                        Toast.show(
                                                                          "댓글을 입력해주세요.", 
                                                                          context, 
                                                                          duration: 2, 
                                                                          gravity: Toast.BOTTOM,
                                                                        );
                                                                        } else{
                                                                        subcommentloading = true;
                                                                        Map<String, dynamic> data = {
                                                                          "subcommenter": currentUsername,
                                                                          "subcomment": subcommentcontroller.text,
                                                                          "subcommenttime": DateTime.now(),
                                                                        }; 
                                                                        setState(() async {
                                                                          await FirebaseFirestore.instance.collection('Posts').doc(widget.postid).collection('Comments').doc(snapshot.data.docs[index].id).update({'subcomments':FieldValue.arrayUnion([data])}).then((value) => subcommentloading = false);
                                                                          subcomments  = snapshot.data.docs[index].get("subcomments");
                                                                        });
                                                                        subcommentcontroller.text = "";
                                                                        }
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ):Center(child: CircularProgressIndicator()):Container(),
                                          
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                
                              ],
                            );

                          },
                          //DateTime.fromMillisecondsSinceEpoch(snapshot.data.docs[index].get("time") * 1000).toString()
                        );
                      } else {
                        return Container(
                          child: Center(
                            child: AutoSizeText(
                              '댓글이 없습니다',
                              style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                            ),
                          )
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.all(15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 8,
                        child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: commentcontroller,
                        decoration: InputDecoration(
                          hintText: (commentstream == null)? '첫 댓글을 써주세요':'댓글을 써주세요',
                          border: InputBorder.none,
                        )                        
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: IconButton(
                          icon: Icon(Icons.send),
                          color: Colors.black,
                          onPressed: (){
                            if(commentcontroller.text == ""){
                            Toast.show(
                              "댓글을 입력해주세요.", 
                              context, 
                              duration: 2, 
                              gravity: Toast.BOTTOM,
                            );}
                            else{
                            uploadComment();
                            crudmethods.getComments(widget.postid).then((result){
                              //setState((){
                                commentstream = result;
                              //});
                            });
                            commentcontroller.text = "";
                            }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}