import 'dart:math';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mybabyskull/auth/shared_preferences.dart';
import 'package:mybabyskull/services/CRUD.dart';
import 'package:mybabyskull/testvalues.dart';
import 'package:toast/toast.dart';
import 'package:word_break_text/word_break_text.dart';

import '../constants.dart';
import '../mobile_mypage.dart';
import '../result_level.dart';

class TestResultView extends StatefulWidget {
  final double crvalue;
  final double cvaivalue;
  final Uint8List myimage;
  TestResultView({this.crvalue, this.cvaivalue, this.myimage});

  @override
  _TestResultViewState createState() => _TestResultViewState();
}

class _TestResultViewState extends State<TestResultView> {
  bool isloading = false;
  CRUD crudmethods = new CRUD();
  bool isloggedIn = false;
  String useremail;
  String username;
  bool snapshot_present = false;
  QuerySnapshot current_user_doc_ref;

  getloggedInState() async {
    return Helperfunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        isloggedIn = value;
        print('check isloggedin');
      });
    });
  }

  getuserEmail() async {
    return Helperfunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        useremail = value;
      });
    });
  }

  getuserName() async {
    return Helperfunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        username = value;
      });
    });
  }

  getDocumentRef(String email) async {
    print("inside getDocumentRef function");
    return await crudmethods.getValuesByEmail(email); // 이게 뭐지?
  }

  @override
  // void initState() {
  //   // TODO: implement initState
  //   getuserName();
  //   getuserEmail();
  //   print('got logged in state - start');
  //   getloggedInState();
  //   print('got logged in state - end');
  //   getDocumentRef(useremail).then((result) {
  //     current_user_doc_ref = result;
  //     print(current_user_doc_ref);
  //     print(result);
  //     //print("this is flag ${current_user_doc_ref}");
  //     if (current_user_doc_ref != null) {
  //       print(current_user_doc_ref);
  //       print(result);
  //       //print(current_user_doc_ref.docs[0].id);
  //       if (current_user_doc_ref.docs[0].get('uploaded') == true) {
  //         print(current_user_doc_ref.docs[0].get('uploaded'));
  //         print('check snapshot_present');
  //         snapshot_present = true;
  //         print(snapshot_present);
  //       }
  //     }
  //   });
  //   //Helperfunctions.getUserLoggedInSharedPreference().then((value) => print(value));
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var min30 = min(screenWidth * (1 / 30), screenHeight * (1 / 30));
    var min20 = min(screenWidth * (1 / 20), screenHeight * (1 / 20));
    var min10 = min(screenWidth * (1 / 10), screenHeight * (1 / 10));
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
            elevation: 0,
            backgroundColor: Colors.black.withOpacity(0.8),
            title: Text(
              '결과',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            // leading: FlatButton(
            //   child: Icon(
            //     Icons.home_outlined,
            //     color: Colors.white,
            //   ),
            //   onPressed: () {
            //     Navigator.pushReplacementNamed(context, 'initialView');
            //   },
            // ),
            actions: (isloggedIn)
                ? [
                    // FlatButton(
                    //     onPressed: () {
                    //       Navigator.pushReplacement(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => MyPage(
                    //                     myname: username,
                    //                     myemail: useremail,
                    //                   )));
                    //     },
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Column(
                    //         children: [
                    //           Icon(Icons.my_library_books, color: Colors.white),
                    //           AutoSizeText('마이페이지',
                    //               style: TextStyle(
                    //                   color: Colors.white, fontSize: 10)),
                    //         ],
                    //       ),
                    //     )),
                    // FlatButton(
                    //   onPressed: () async {
                    //     setState(() {
                    //       isloading = true;
                    //     });
                    //     Toast.show(
                    //       '업로드 중',
                    //       context,
                    //       duration: 2,
                    //       gravity: Toast.BOTTOM,
                    //     );
                    //     Reference rootreference = FirebaseStorage.instance
                    //         .ref()
                    //         .child('headImages')
                    //         .child("${useremail}.jpg");
                    //     UploadTask uploadTask =
                    //         rootreference.putData(widget.myimage);
                    //     TaskSnapshot snapshot =
                    //         await uploadTask.whenComplete(() => null);
                    //     var downloadurl = await snapshot.ref.getDownloadURL();
                    //
                    //     Map<String, dynamic> data = {
                    //       "useremail": useremail,
                    //       "cr": widget.crvalue,
                    //       "cvai": widget.cvaivalue,
                    //       "myURL": downloadurl,
                    //       "uploaded": true,
                    //     };
                    //     if (snapshot_present && current_user_doc_ref != null) {
                    //       print('check snapshot_present 2');
                    //       crudmethods.update_Values(
                    //           current_user_doc_ref.docs[0].id, data);
                    //
                    //       //print(current_user_doc_ref.docs[0].id);
                    //     } else {
                    //       crudmethods.upload_Values(data);
                    //     }
                    //     Toast.show(
                    //       '업로드 완료',
                    //       context,
                    //       duration: 2,
                    //       gravity: Toast.BOTTOM,
                    //     );
                    //     setState(() {
                    //       isloading = false;
                    //     });
                    //   },
                    //   child: Row(
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.all(5.0),
                    //         child: Column(
                    //           children: [
                    //             Icon(
                    //               Icons.upload_file,
                    //               color: Colors.white,
                    //             ),
                    //             AutoSizeText(
                    //               'MyPage 저장',
                    //               style: TextStyle(
                    //                   color: Colors.white, fontSize: 10),
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // )
                  ]
                : [
                    // FlatButton(
                    //   onPressed: () {
                    //     Navigator.pushReplacementNamed(context, 'registerView');
                    //   },
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Column(
                    //       children: [
                    //         Icon(
                    //           Icons.person_add,
                    //           color: Colors.white,
                    //         ),
                    //         AutoSizeText('회원가입',
                    //             style:
                    //                 TextStyle(fontSize: 10, color: Colors.white))
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ]),
      ),
      body: (isloading)
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: screenHeight * (1 / 20),
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Image.memory(
                      widget.myimage,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        // Padding(
                        //   padding: EdgeInsets.all(20),
                        //   child: AutoSizeText(
                        //     '마이페이지에 저장 후 마이페이지로 가시면 수치를 확인하실 수 있습니다.',
                        //     style: TextStyle(fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                        Builder(
                          builder: (context) {
                            if (widget.cvaivalue < 5.0 && widget.crvalue < 90) {
                              return ResultCard(
                                result_level: '1단계: 안심단계',
                                result_detail:
                                    '만약 아이가 이 수치에 배당 된다면 안심하셔도 됩니다.\n낮에 아이와 Tummy time를(엎어 놓기 놀이) 자주해 주세요.\n엎어 놓기 놀이는 아이의 행동 발달에도 도움이 되고 두상 비대칭 예방도 되어 일석이조의 효과를 얻을수 있습니다.',
                                result_cure: '치료: 낮에 2시간 엎어 놓기',
                                route: 'level1View',
                              );
                            } else if (widget.cvaivalue > 5.0 &&
                                widget.cvaivalue < 8.0 &&
                                widget.crvalue < 90) {
                              return ResultCard(
                                result_level: '2단계: 관심단계',
                                result_detail:
                                    '이 수치에 해당 된다면 정상에 가깝고, 이마 및 두상의 비대칭이 심하지 않아 잘 관리 해주시면 심한 얼굴 비대칭까지 오지는 않습니다.\n다만, 아이의 두상 모양은 성장하면서 좋아지지 않는 경우도 많습니다.\n 따라서, 방심은 금물!\n이 상태를 유지하기 위해 잘때 머리위치를 자주 변경해주시고 낮에는 엎어놓기를 통해서 이쁜 두상을 유지하도록 해주세요!',
                                result_cure: '치료:잘때 위치 변경 + 낮에 자주 엎어 놓기',
                                route: 'level2View',
                              );
                            } else if ((widget.cvaivalue > 8.0 &&
                                    widget.cvaivalue < 12.0) ||
                                widget.crvalue > 90) {
                              return ResultCard(
                                result_level: '3단계: 행동단계',
                                result_detail:
                                    '이 수치에 해당 된다면 이마 비대칭도 육안적으로 보이고 심하면 양 귀 위치의 관계에도 차이가 있습니다.\n이는 어릴 때 바르게 잡아주지 않으면 심한 비대칭이 발생하고 더 큰 건강 문제도 초래 할 수 있으므로 예방 및 치료가 필요합니다.\n빠른 시일 내에 사두증 전문 병원을 방문 하여 검사를 받아 보세요!',
                                result_cure: '치료: 교정모 치료 고려, 위치 변경 배개 필수',
                                route: 'level3View',
                              );
                            } else if (widget.cvaivalue > 12.0) {
                              return ResultCard(
                                result_level: '4단계: 걱정단계',
                                result_detail:
                                    '이단계는 귀의 위치뿐만 아니라 정면에서 눈썹 및 눈의 위치도 다르게 보입니다.\n이 경우에는 두개의 비대칭이 심하여 추후 턱 관절 문제와 더불어 목 사경까지 이르를 수 있어서 상당한 건강 문제를 초래할 수도 있습니다.\n이 단계는 자연적 치료가 어려우니 적극적으로 치료를 해주세요. 어떻게 시작할지 모르실 경우는 반드시 병원을 방문하거나 전문가에게 도움을 요청해야합니다.',
                                result_cure: '치료: 두상모 교정 치료 필수',
                                route: 'level4View',
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class ResultCard extends StatelessWidget {
  String result_level;
  String result_detail;
  String result_cure;
  String route;

  ResultCard({
    this.result_level,
    this.result_detail,
    this.result_cure,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var min30 = min(screenWidth * (1 / 30), screenHeight * (1 / 30));
    var min20 = min(screenWidth * (1 / 20), screenHeight * (1 / 20));
    var min10 = min(screenWidth * (1 / 10), screenHeight * (1 / 10));
    var min15 = min(screenWidth * (1 / 15), screenHeight * (1 / 15));
    var min25 = min(screenWidth * (1 / 25), screenHeight * (1 / 25));
    var min17 = min(screenWidth * (1 / 17), screenHeight * (1 / 17));
    return Card(
      margin: EdgeInsets.all(25),
      child: Column(children: [
        Neumorphic(
            style: NeumorphicStyle(
              color: Colors.blueAccent.withOpacity(0.5),
              depth: 3,
              shape: NeumorphicShape.convex,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              // alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.emoji_objects,
                      size: min10,
                      color: Colors.transparent,
                    ),
                  ),
                  Text(
                    result_level,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: min15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ResultLevelBox(
                                title: "사두증 단계",
                                descriptions: "사두증 단계들에 대한 설명",
                                text: "질문하기",
                              );
                            });
                      },
                      child: Icon(
                        Icons.emoji_objects,
                        size: min10,
                        color: Colors.black,
                      )),
                ],
              ),
            )),
        // Container(
        //   padding: EdgeInsets.all(30),
        //   alignment: Alignment.center,
        //   child: AutoSizeText(
        //     result_level,
        //     minFontSize: 20,
        //     style: TextStyle(
        //       color: Colors.black,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        Container(
          // padding: EdgeInsets.all(30),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          alignment: Alignment.center,
          child: WordBreakText(
            result_cure,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: min25,
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          // alignment: Alignment.center,
          child: Text(
            result_detail,
            // textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: min25,
              color: Colors.black,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Container(
        //   // color: Colors.black,
        //   height: MediaQuery.of(context).size.height / 6,
        //   padding: EdgeInsets.all(30),
        //   alignment: Alignment.center,
        //   child: Container(
        //       // color: Colors.black,
        //       child: NeumorphicButton(
        //     style: NeumorphicStyle(
        //       color: Colors.black,
        //       depth: 3,
        //       shape: NeumorphicShape.convex,
        //       boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
        //     ),
        //     padding: EdgeInsets.all(
        //       min(screenWidth * (1 / 30), screenHeight * (1 / 30)),
        //     ),
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Icon(
        //           Icons.search,
        //           color: Colors.white,
        //         ),
        //         SizedBox(
        //           width: 2,
        //         ),
        //         Text('치료병원 알아보기',
        //             style: TextStyle(
        //               fontSize: min20,
        //               color: Colors.white,
        //             ))
        //       ],
        //     ),
        //   )
        //       // child: RaisedButton.icon(
        //       //     color: Colors.black,
        //       //     onPressed: () {
        //       //       Navigator.pushNamed(context, 'hospitalView');
        //       //     },
        //       //     icon: Icon(
        //       //       Icons.search,
        //       //       color: Colors.white,
        //       //     ),
        //       //     label: AutoSizeText(
        //       //       '치료병원 알아보기',
        //       //       style: TextStyle(
        //       //         fontSize: min20,
        //       //         color: Colors.white,
        //       //       ),
        //       //     )),
        //       ),
        // ),
      ]),
    );
  }
}
