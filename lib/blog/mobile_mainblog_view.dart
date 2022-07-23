import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybabyskull/auth/shared_preferences.dart';
import 'package:mybabyskull/blog/mobile_post_detail.dart';
import 'package:mybabyskull/blog/post_tile_view.dart';
import 'package:mybabyskull/services/CRUD.dart';

import '../constants.dart';

class MainBlogView extends StatefulWidget {
  @override
  _MainBlogViewState createState() => _MainBlogViewState();
}

class _MainBlogViewState extends State<MainBlogView> {

  CRUD crudmethods = new CRUD();
  Stream poststream;
  bool isloggedIn = false;
  bool isloading = true;

  getloggedInState() async {
    return Helperfunctions.getUserLoggedInSharedPreference().then((value){
      setState((){
        isloggedIn = value;
      });
    });
  }
  

  @override
  void initState(){
    getloggedInState();
    crudmethods.getData().then((result){
      setState((){
        poststream = result;
        isloading = false;
      });
    });
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return (isloggedIn == true) ? Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 20,
        onPressed:(){
          Navigator.pushNamed(context, 'addblogView');
        },
        label: Text('글 게시',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        icon:Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.blueAccent
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0.8),
        title: Text(
          '게시판',
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
            Navigator.pushReplacementNamed(context, 'initialView');
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                  
                );
              },
            ),
          ),
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
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(15),
              child: AutoSizeText(
                '모든 게시글',
                minFontSize: 20,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black, 
                  fontWeight: FontWeight.bold
                  ),
                ),
            ),
            (isloading)?Container(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width,child: Center(child: CircularProgressIndicator()),):Container(
              padding: EdgeInsets.all(2),
              child: StreamBuilder<QuerySnapshot>(
                stream: poststream,
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  if(snapshot.hasError){
                    print(snapshot.connectionState);
                    return Center(child: AutoSizeText('An Error has happened', style: TextStyle(fontWeight: FontWeight.bold, color: kDarkBlueColor)),);
                  }
                  if (snapshot.hasData){
                    return ListView.separated(
                      separatorBuilder: (context, index) => Container(child: const Divider(color: Colors.grey, thickness: 1, height: 1,)),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      physics: NeverScrollableScrollPhysics(),//to make singlescrollchild scrollable
                      reverse: true,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true, 
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index){
                        return ListTile(
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children:[
                            (snapshot.data.docs[index].get("imgURL").length > 0)? 
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerRight,
                                    height: 33,
                                    width: 33, 
                                    child: Image.network(
                                      snapshot.data.docs[index].get("imgURL")[0],
                                      fit: BoxFit.fitHeight,
                                      )
                                    ),
                                    
                                ],
                              ),
                            )
                              :
                              Container(height: 0, width: 0,),
                              ]),
                          title: AutoSizeText(
                            snapshot.data.docs[index].get("title"),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                            ),
                          subtitle: Container(
                            width: MediaQuery.of(context).size.width/2,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoSizeText(
                                  snapshot.data.docs[index].get("author"),
                                  minFontSize: 10,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blueGrey
                                  ),
                                  ),
                                  SizedBox(width: 10,),
                                (snapshot.data.docs[index].get("time").toDate().toString().substring(0,10) != DateTime.now().toString().substring(0,10))?
                                    AutoSizeText(
                                            snapshot.data.docs[index].get("time").toDate().toString().substring(2,snapshot.data.docs[index].get("time").toDate().toString().length-13), 
                                            style: TextStyle(color: Colors.grey),
                                          ):
                                    AutoSizeText(
                                      "최신", 
                                      style: TextStyle(color: Colors.grey),
                                    )
                              ],
                            ),
                          ),
                            /*AutoSizeText(
                                snapshot.data.docs[index].get("time").toDate().toString().substring(0,snapshot.data.docs[index].get("time").toDate().toString().length-7), 
                                style: TextStyle(color: Colors.grey),
                              ),*/
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => PostDetailView(
                                title: snapshot.data.docs[index].get("title"),
                                author: snapshot.data.docs[index].get("author"),
                                content: snapshot.data.docs[index].get("content"),
                                postid: snapshot.data.docs[index].id,
                                imgURL: snapshot.data.docs[index].get("imgURL"),
                              )
                              ));
                          },
                        );
                      },
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: AutoSizeText(
                          '게시글이 없습니다',
                          style: TextStyle(
                            color: kDarkBlueColor,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ); 
                  }
                },
              ),
            ),
            SizedBox(height: 112,)
          ],
        ),
      ),
    ) : Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0.8),
        title: Text(
          '게시판',
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
      ),
      body: Column(
        children: [
          SizedBox(height: 56,),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  '로그인 후 사용하여 주세요.',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(50),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: FlatButton(
                        onPressed: (){
                          Navigator.pushReplacementNamed(context, 'registerView');
                        },
                        child: Column(children: [
                          Icon(Icons.person_add, color: Colors.black,),
                          SizedBox(height: 4,),
                          AutoSizeText('회원가입', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)
                        ],),
                        ),
                      ),
                         Expanded(
                           flex: 5,
                           child: FlatButton(
                               onPressed: (){
                                 Navigator.pushReplacementNamed(context, 'loginView');
                               },
                               child: Column(children: [
                                 Icon(Icons.login_sharp, color: Colors.black,),
                                 SizedBox(height: 4,),
                                 AutoSizeText('로그인', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)
                               ],),
                               ),
                         ),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => "우리 아이를 위한 게시물 검색";

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        query,
        style: TextStyle(
            color: Colors.blue, fontWeight: FontWeight.w900, fontSize: 30),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Posts').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData){
          return new Text('검색해주세요');
        }
        final results = snapshot.data.docs.where((DocumentSnapshot a) => a['title'].toString().contains(query)); 
        
        return ListView(
          children: results.map<Widget>((DocumentSnapshot a) => 
            Card(
              child: ListTile(
                  leading: (a.get("imgURL").length > 0)? Container(width:MediaQuery.of(context).size.width/5 , child: Image.network(a.get("imgURL")[0])):Container(width: MediaQuery.of(context).size.width/5 ,child: Icon(Icons.child_care, color: Colors.blueAccent,)),        
                  title: AutoSizeText(
                    a.get('title'),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    ),
                  subtitle: AutoSizeText(
                    a.get('author'),
                    style: TextStyle(
                      color: Colors.blueGrey
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
                ),
            )
            ).toList()
          );
      },
    );
  }
}