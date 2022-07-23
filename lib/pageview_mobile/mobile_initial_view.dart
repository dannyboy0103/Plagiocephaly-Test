import 'dart:html';
import 'dart:math';
import 'package:animated_text/animated_text.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybabyskull/auth/authmethods.dart';
import 'package:mybabyskull/auth/shared_preferences.dart';
import 'package:mybabyskull/auth/user_db.dart';
import 'package:mybabyskull/auth/user_model.dart';
import 'package:mybabyskull/mobile_mypage.dart';
import 'package:toast/toast.dart';
import '../constants.dart';
//import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileInitialView extends StatefulWidget {
  @override
  _MobileInitialViewState createState() => _MobileInitialViewState();
}

class _MobileInitialViewState extends State<MobileInitialView> {
  bool isloading = false;
  bool isloggedin = false;
  String username = "";
  String useremail = "";
  AuthMethods authmethods = new AuthMethods();

  getloggedInState() async {
    return Helperfunctions.getUserLoggedInSharedPreference().then((result) {
      setState(() {
        if (result != null) {
          isloggedin = result;
        }
      });
    });
  }

  getUserName() async {
    return Helperfunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        username = value;
      });
    });
  }

  getUserEmail() async {
    return Helperfunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        useremail = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getloggedInState();
    getUserName();
    getUserEmail();
    print(isloggedin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * (1 / 20)),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.black.withOpacity(0.8),
          actions: [
            (isloggedin == true)
                ? GestureDetector(
                    onTap: () {
                      //마이페이지로 연결
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyPage(
                                    myname: username,
                                    myemail: useremail,
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: GestureDetector(
                        child: AutoSizeText(
                          '$username 님 마이페이지',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                : Row(
                    // mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, 'loginView');
                          },
                          child: Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Icon(
                                    Icons.login_sharp,
                                    color: Colors.white,
                                    // size: screenWidth * (1 / 22),
                                  ),
                                ),
                                Expanded(
                                  child: AutoSizeText('로그인',
                                      style: TextStyle(
                                          // fontSize: 10,
                                          // fontSize: min(screenWidth * (1 / 50),
                                          //     screenHeight * (1 / 50)),
                                          color: Colors.white)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: min(
                      //       screenHeight * (1 / 50), screenWidth * (1 / 50)),
                      //   height: min(
                      //       screenHeight * (1 / 50), screenWidth * (1 / 50)),
                      // ),
                      Container(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, 'registerView');
                          },
                          child: Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Icon(
                                    Icons.person_add,
                                    color: Colors.white,
                                    // size: screenWidth * (1 / 22),
                                  ),
                                ),
                                Expanded(
                                  child: AutoSizeText('회원가입',
                                      style: TextStyle(
                                          // fontSize: 10,
                                          // fontSize: min(screenWidth * (1 / 50),
                                          //     screenHeight * (1 / 50)),
                                          color: Colors.white)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.yellow,
        icon: Image.asset('assets/kakaotalk.png', height: 35, width: 35,),
        label: Text('질문하기', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),),
        elevation: 10,
        onPressed: (){
          //카카오톡으로 연결하는 링크 걸기

        },
      ),*/
      drawer: (isloading)
          ? Drawer(
              child: Center(
              child: CircularProgressIndicator(),
            ))
          : Drawer(
              child: ListView(children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: (isloggedin == true)
                          ? [
                              GestureDetector(
                                onTap: () {
                                  //마이 페이지
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyPage(
                                                myname: username,
                                                myemail: useremail,
                                              )));
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Container(
                                        child: FittedBox(
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    AutoSizeText(
                                      '$username 님 마이페이지',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  //setState((){isloading=true;});
                                  authmethods.signOut();
                                  setState(() {
                                    Helperfunctions
                                        .saveUserLoggedInSharedPreference(
                                            false);
                                    Helperfunctions
                                        .saveUserEmailSharedPreference("");
                                    Helperfunctions
                                        .saveUserNameSharedPreference("");
                                    getloggedInState();
                                  });
                                  Toast.show(
                                    "로그아웃 완료",
                                    context,
                                    duration: 1,
                                    gravity: Toast.BOTTOM,
                                  );
                                  //Navigator.pushNamed(context, 'signinView');
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Container(
                                        child: FittedBox(
                                          child: Icon(
                                            Icons.logout,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    AutoSizeText(
                                      '로그아웃',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          : [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, 'loginView');
                                },
                                child: Row(
                                  children: [
                                    AutoSizeText(
                                      '로그인',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Container(
                                        child: FittedBox(
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, 'registerView');
                                },
                                child: Row(
                                  children: [
                                    AutoSizeText(
                                      '회원가입',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Container(
                                        child: FittedBox(
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                ),
                /*(isloggedin==false)?
              ListTile(
                title: OutlineButton(//Google Login
                  onPressed: () async {
                    Toast.show(
                      "잠시만 기다려주세요.",
                      context,
                          duration: 2,
                          gravity: Toast.BOTTOM,
                    );
                    setState((){
                      isloading=true;
                      });
                    await authmethods.signInWithGoogle(context);
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  highlightElevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(image: AssetImage("assets/google_png.png"), height: 35.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            '구글 계정으로 로그인',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ):Container(),*/
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'introView');
                  },
                  child: ListTile(
                    title: AutoSizeText('서비스 소개',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'rulesView');
                  },
                  child: ListTile(
                    title: AutoSizeText('개인정보 처리방침 및 개인회원 이용약관',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ]),
            ),
      body: (isloading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /*
            Container(
              height: 56,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Colors.black
              ),
            ),*/
                  Container(
                    width: screenWidth,
                    height: 56 + screenHeight / 4,
                    child: Stack(children: [
                      Container(
                        width: screenWidth,
                        child: ClipRect(
                            child: Image.asset(
                          'assets/bby_head.jpg',
                          fit: BoxFit.cover,
                        )),
                      ),
                      Container(
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.black87.withOpacity(0.3),
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 4,
                        child: AnimatedText(
                          alignment: Alignment.bottomCenter,
                          speed: Duration(milliseconds: 1000),
                          controller: AnimatedTextController.loop,
                          displayTime: Duration(milliseconds: 1000),
                          wordList: [
                            '소중한 우리 아기',
                            '편리한 두상 검사',
                            '이쁜 두상 만들기',
                            '우리 아기두상'
                          ],
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
                  ),
                  Container(
                    height: screenHeight / 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: AutoSizeText(
                            '우리 아기두상에 관하여 \n지금 바로 궁금한 점을 물어보세요',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: min(screenWidth * (1 / 30),
                                  screenHeight * (1 / 30)),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'hospitalView');
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black87),
                            child: AutoSizeText(
                              '치료 지원병원 알아보기',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: min(screenWidth * (1 / 30),
                                      screenHeight * (1 / 30)),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    //height: screenHeight*3/10,
                    margin: EdgeInsets.symmetric(horizontal: screenWidth / 6),
                    child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                        padding: const EdgeInsets.all(1),
                        children: [
                          NeumorphicButton(
                            margin: EdgeInsets.all(10),
                            style: NeumorphicStyle(
                              depth: 3,
                              shape: NeumorphicShape.convex,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, 'annotationView');
                            },
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.center_focus_strong,
                                      color: Colors.blueAccent,
                                      size: screenWidth * (1 / 8)),
                                  Text('두상검사',
                                      style: TextStyle(
                                          fontSize: min(screenWidth * (1 / 30),
                                              screenHeight * (1 / 30)),
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          NeumorphicButton(
                            margin: EdgeInsets.all(10),
                            style: NeumorphicStyle(
                              depth: 3,
                              shadowDarkColorEmboss: Colors.grey,
                              shape: NeumorphicShape.convex,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, 'mainblogView');
                            },
                            child: Center(
                              child: Column(
                                // mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.question_answer,
                                    color: Colors.blueAccent,
                                    size: screenWidth * (1 / 8),
                                    // size: 30,
                                  ),
                                  Text('게시판',
                                      style: TextStyle(
                                          fontSize: min(screenWidth * (1 / 30),
                                              screenHeight * (1 / 30)),
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                          NeumorphicButton(
                            margin: EdgeInsets.all(10),
                            style: NeumorphicStyle(
                              depth: 3,
                              shadowDarkColorEmboss: Colors.grey,
                              shape: NeumorphicShape.convex,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, 'introView');
                            },
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.help,
                                    color: Colors.blueAccent,
                                    size: screenWidth * (1 / 8),
                                  ),
                                  Text('Q&A',
                                      style: TextStyle(
                                          fontSize: min(screenWidth * (1 / 30),
                                              screenHeight * (1 / 30)),
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                          NeumorphicButton(
                            margin: EdgeInsets.all(10),
                            style: NeumorphicStyle(
                              depth: 3,
                              shadowDarkColorEmboss: Colors.grey,
                              shape: NeumorphicShape.convex,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, 'curemethodView');
                            },
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.medical_services,
                                    color: Colors.blueAccent,
                                    size: screenWidth * (1 / 8),
                                  ),
                                  Text('치료방법',
                                      style: TextStyle(
                                          fontSize: min(screenWidth * (1 / 30),
                                              screenHeight * (1 / 30)),
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                  //SizedBox(height: screenHeight*0.1,),
                  Container(
                    height: screenHeight / 2,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 40),
                                alignment: Alignment.centerLeft,
                                child: AutoSizeText(
                                  '우리 아이에게 딱 맞는\n두상 교정모를 알고 싶다면?',
                                  minFontSize: 20,
                                  //textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, 'helmetView');
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  margin: EdgeInsets.symmetric(horizontal: 40),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 3,
                                      )),
                                  child: AutoSizeText(
                                    '교정모 자세히 알아보기',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, 'subproductView');
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  margin: EdgeInsets.symmetric(horizontal: 40),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 3,
                                      )),
                                  child: AutoSizeText(
                                    '보조제품 자세히 알아보기',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'tummyView');
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                      padding: EdgeInsets.all(10),
                      height: screenHeight * 0.3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffbE8E8E8)),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      '우리 아이 건강을 위한\n터미 타임',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AutoSizeText(
                                          '자세히 알아보기',
                                          style: TextStyle(
                                              color: Color(0xffA9A9A9),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Container(
                                            child: FittedBox(
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              child: Image.asset(
                                'assets/tummy_baby.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  Container(
                    height: screenHeight * 0.1,
                    decoration: BoxDecoration(color: Color(0xffbF5F5F5)),
                    child: Container(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        '회사소개 | 이용약관 | 개인정보처리방침\nCOPYRIGHT (C) Innoyard ALL RIGHTS RESERVED',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xffD3D3D3)),
                      ),
                    ),
                  ),

                  /*
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, 'introView');
              },
                child: Container(
                width: screenWidth,
                height: screenWidth / 3,
                decoration: BoxDecoration(
                  color: kPinkColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 7,
                    //padding: const EdgeInsets.all(20.0),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20,20,0,20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              child: AutoSizeText(
                                '우리아기두상에 대해 궁금한 점\n의사선생님에게 물어보세요!',
                                style: TextStyle(
                                  color: Colors.pink[200],
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Row(
                              children: [
                                AutoSizeText(
                                  '질문하러 가기',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: kDarkBlueColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: kDarkBlueColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: FittedBox(
                                      child: Icon(
                                        Icons.arrow_right,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                      ),
                    Expanded(
                      //padding: const EdgeInsets.all(20.0),
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Image(
                          image: AssetImage('assets/doctor.png'),
                          width: screenWidth / 4,
                          height: screenHeight / 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              width: screenWidth,
              height: screenHeight*1.2,
              decoration: BoxDecoration(
                color: kPinkColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        AutoSizeText(
                          ' 우리아기두상 알아보기 ',
                          style: TextStyle(
                            color: kDarkBlueColor,
                            fontWeight: FontWeight.w500,
                            //fontSize: 20,
                          ),
                        ),
                        Icon(
                          Icons.not_listed_location,
                          color: kDarkBlueColor,
                        ),
                      ],
                    ),
                    Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(top:20, bottom: 20),
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        width: screenWidth,
                        height: screenWidth / 4,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context,"annotationView");
                          },
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: FittedBox(
                                  child: Icon(
                                    Icons.camera_front,
                                    color: kDarkBlueColor,
                                    size: screenWidth / 5,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      '사진으로 진단',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    AutoSizeText(
                                      '아기두상 사진을 찍어서 진단해보세요',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(top:20, bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                        ),
                        width: screenWidth,
                        height: screenWidth / 4,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, 'mainblogView');
                          },
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: FittedBox(
                                  child: Icon(
                                    Icons.question_answer,
                                    color: kDarkBlueColor,
                                    size: screenWidth / 5,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      '게시판',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    AutoSizeText(
                                      '다른 아기 엄마들과 소통해보세요',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(top:20, bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        width: screenWidth,
                        height: screenWidth / 4,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, 'curemethodView');
                          },
                            child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: FittedBox(
                                  child: Icon(
                                    Icons.local_hospital,
                                    color: kDarkBlueColor,
                                    size: screenWidth / 5,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      '치료방법',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    AutoSizeText(
                                      '우리아기두상 치료방법을 알아보세요',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(top:20, bottom: 20),
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        width: screenWidth,
                        height: screenWidth / 4,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, 'hospitalView');
                          },
                            child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: FittedBox(
                                  child: Icon(
                                    Icons.medical_services,
                                    color: kDarkBlueColor,
                                    size: screenWidth / 5,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      '치료 지원 병원',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    AutoSizeText(
                                      '헬멧 치료 지원 병원들을 알아보세요',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top:30),
              width: screenWidth,
              height: 200,
              decoration: BoxDecoration(
                color: kPinkColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        AutoSizeText(
                          ' 두상 교정모 및 보조 제품 ',
                          style: TextStyle(
                            color: kDarkBlueColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.not_listed_location,
                          color: kDarkBlueColor,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 5,
                          child: GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, 'helmetView');
                              },
                              child: Container(
                              height: 110,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: AutoSizeText(
                                '두상 교정모 안내',
                                style: TextStyle(
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.w700,
                                      ),
                              ),
                            ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, 'subproductView');
                              },
                              child: Container(
                              height: 110,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                        ),
                        child: Center(
                            child: AutoSizeText(
                              '사두증 보조 제품',
                              style: TextStyle(
                                          color: Colors.blue[900],
                                          fontWeight: FontWeight.w700,
                                        ),
                            ),
                        ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:30),
              width: screenWidth,
              height: 200,
              decoration: BoxDecoration(
                color: kPinkColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        AutoSizeText(
                          ' 우리 아이 건강을 위한 활동 ',
                          style: TextStyle(
                            color: kDarkBlueColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.not_listed_location,
                          color: kDarkBlueColor,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 10,
                          child: GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, 'tummyView');
                              },
                              child: Container(
                              height: 110,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: AutoSizeText(
                                '터미타임 안내',
                                style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.w700,
                                      ),
                              ),
                            ),
                            ),
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ),
            ),
          */
                ],
              ),
            ),
    );
  }
}
