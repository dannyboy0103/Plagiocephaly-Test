import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'package:rxdart/rxdart.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybabyskull/auth/shared_preferences.dart';
import 'package:mybabyskull/blog/mobile_post_detail.dart';
import 'package:mybabyskull/services/CRUD.dart';

class MyPage extends StatefulWidget {
  final String myname;
  final String myemail;

  MyPage({this.myname, this.myemail});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  CRUD crudmethods = new CRUD();
  bool isloggedIn = false;
  double crvalue;
  double cvaivalue;
  String myimgURL;
  bool tested = false;
  QuerySnapshot mysnapshot;
  String userid = "";
  int count = 0;
  List<DocumentSnapshot> myfavdocs = [];
  //List<String> postids = [];
  bool isloading = true;
  //final myfavorites = <Widget>[];


  getMyUserid() async {
    await FirebaseFirestore.instance.collection('Users').get()
    .then((QuerySnapshot querysnapshot){
      querysnapshot.docs.forEach((element){
        if(element["username"] == widget.myname){
          userid = element.id;
          setState(() {
            getMyFavoritePostsID(element.id);
          });
        }
      });
    });
  }

  getMyFavoritePostsID(String uid) async {
    await FirebaseFirestore.instance.collection('Users').doc(uid).collection('MyFavorite').get()
    .then((QuerySnapshot querySnapshot){
      count = querySnapshot.docs.length;
      if(querySnapshot.docs.length == 0){
        setState(() {
          isloading = false;
        });
      }else{
        querySnapshot.docs.forEach((element) async {
          //postids.add(element["postid"]);
          await FirebaseFirestore.instance.collection('Posts').doc(element["postid"]).get().then((value){
            if(!value.exists){
              count--;
            }
            if(value.exists){
              myfavdocs.add(value);
            }
            if(myfavdocs.length == count){
              setState(() {
                isloading = false;
              });
            }
          });
        });
      }
    });
  }

  getloggedInState() async {
    return Helperfunctions.getUserLoggedInSharedPreference().then((value){
      setState((){
        isloggedIn = value;
      });
    });
  }

  getmyValues() async{
    await crudmethods.getValuesByEmail(widget.myemail).then((result){
      mysnapshot = result;
    });
    setState(() {
      if (mysnapshot!=null) {
        crvalue = mysnapshot.docs[0].get('cr');
        cvaivalue = mysnapshot.docs[0].get('cvai');
        myimgURL = mysnapshot.docs[0].get('myURL');
        if(crvalue != null){
          tested = true;
        }
      }
    });
  }

  @override
  void initState(){
    getloggedInState();
    getmyValues();
    getMyUserid();
    super.initState();
  }

  @override
    void dispose() {
      // TODO: implement dispose
      //myfavorites.close();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return (isloading)? Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      ),
    ) :Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0.8),
        title: AutoSizeText(
          '마이페이지',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: FlatButton(
          child: Icon( 
            Icons.home_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            //Navigator.pop(context);
            Navigator.pushReplacementNamed(context, 'initialView');
          },
        ),
      ),
      body: (isloggedIn==true) ? SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              width: screenWidth,
              height: screenHeight/4,
              child: Stack(
                children: [
                  Container(
                    width: screenWidth,
                    child: ClipRect(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1503431760783-91f2569f6802?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
                        fit: BoxFit.cover,
                      )
                    ),
                  ),
                  Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.black54.withOpacity(0.3),
                    )
                  ),
                  Container(
                    width: screenWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          widget.myname,
                          minFontSize: 20,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        AutoSizeText(
                          widget.myemail,
                          minFontSize: 20,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  )

                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal:20),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
              child: AutoSizeText(
                '우리 아이 두상 정보',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),

              ),
            ),
            SizedBox(height: 25,),
            Container(
              height: screenWidth*0.6,
              width: screenWidth,
              child: (tested) ? Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.topCenter,
                      child: Image.network(
                        myimgURL,
                        fit: BoxFit.fill,
                        ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                AutoSizeText(
                                  '단두증 수치',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                AutoSizeText(
                                  crvalue.toInt().toString(),
                                  minFontSize: 20,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                AutoSizeText(
                                  '사두증 수치',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                AutoSizeText(
                                  cvaivalue.toInt().toString(),
                                  minFontSize: 20,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                ],
              ):Container(
                child: Center(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushReplacementNamed(context, 'annotationView');
                    },
                    child: AutoSizeText(
                      '사진으로 진단을 해보세요!', 
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),)),
                ),
              )
              ),
            Container(
                    margin: EdgeInsets.symmetric(horizontal:20),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    child: AutoSizeText(
                      '내 게시글',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                      ),

                    ),
                  ),

            Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Posts').orderBy('time').snapshots(),
                builder: (context, snapshot){
                  if(snapshot.hasError){
                    return Center(
                      child: AutoSizeText(
                        '게시글이 없습니다',
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.bold
                          )
                        )
                      );
                    }
                  if(!snapshot.hasData){
                    return Center(
                      child: AutoSizeText(
                        '게시글이 없습니다',
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.bold
                          ),
                        )
                      );
                  }
                  final results = snapshot.data.docs.where((DocumentSnapshot a)=>a['author'].toString()==widget.myname);
                  return ListView(
                    padding: EdgeInsets.all(1),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: results.map<Widget>((DocumentSnapshot a) => 
                      ListTile(
                          //leading: Icon(Icons.child_care, color: Colors.blueAccent),
                          title: AutoSizeText(
                            a.get('title'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            ),
                          subtitle:Container(
                            width: MediaQuery.of(context).size.width/2,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoSizeText(
                                  a.get("author"),
                                  minFontSize: 10,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blueGrey
                                  ),
                                  ),
                                  SizedBox(width: 10,),
                                (a.get("time").toDate().toString().substring(0,10) != DateTime.now().toString().substring(0,10))?
                                    AutoSizeText(
                                            a.get("time").toDate().toString().substring(2,a.get("time").toDate().toString().length-13), 
                                            style: TextStyle(color: Colors.grey),
                                          ):
                                    AutoSizeText(
                                      "최신", 
                                      style: TextStyle(color: Colors.grey),
                                    )
                              ],
                            ),
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => PostDetailView(
                                title: a['title'],
                                author: a['author'],
                                content: a['content'],
                                postid: a.id,
                                imgURL: a['imgURL'],
                              )
                              ));
                          },
                        )
                    ).toList()
                  );
                },
              )
            ),
            SizedBox(height: 25,),

            Container(
              margin: EdgeInsets.symmetric(horizontal:20),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
              child: AutoSizeText(
                '내가 좋아하는 게시글',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),

              ),
            ),
            

            
            Container(
              child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(color: Colors.grey, thickness: 0.1, indent: 20, endIndent: 20,),
                      padding: EdgeInsets.all(1),
                      physics: NeverScrollableScrollPhysics(),//to make singlescrollchild scrollable
                      reverse: true,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true, 
                      itemCount: myfavdocs.length,
                      itemBuilder: (context, index){
                        return ListTile(
                            //leading: Icon(Icons.child_care, color: Colors.blueAccent),
                            title: AutoSizeText(
                              myfavdocs[index].get('title'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              ),
                            subtitle: Container(
                            width: MediaQuery.of(context).size.width/2,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoSizeText(
                                  myfavdocs[index].get("author"),
                                  minFontSize: 10,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blueGrey
                                  ),
                                  ),
                                  SizedBox(width: 10,),
                                (myfavdocs[index].get("time").toDate().toString().substring(0,10) != DateTime.now().toString().substring(0,10))?
                                    AutoSizeText(
                                            myfavdocs[index].get("time").toDate().toString().substring(2,myfavdocs[index].get("time").toDate().toString().length-13), 
                                            style: TextStyle(color: Colors.grey),
                                          ):
                                    AutoSizeText(
                                      "최신", 
                                      style: TextStyle(color: Colors.grey),
                                    )
                              ],
                            ),
                          ),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => PostDetailView(
                                  title: myfavdocs[index].get('title'),
                                  author: myfavdocs[index].get('author'),
                                  content: myfavdocs[index].get('content'),
                                  postid: myfavdocs[index].id,
                                  imgURL: myfavdocs[index].get('imgURL'),
                                )
                                ));
                            },
                          );
                        
                   })
                        
            ),

            SizedBox(height: 112,)





          ],
        ),
      ):Container(
        child: Center(
          child: AutoSizeText(
            '계정이 없습니다\n로그인 해주세요'
          ),
        ),
      )

    );
  }
}