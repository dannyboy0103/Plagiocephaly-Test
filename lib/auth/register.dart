
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:mybabyskull/auth/authmethods.dart';
import 'package:mybabyskull/auth/shared_preferences.dart';
import 'package:mybabyskull/auth/user_db.dart';
import 'package:toast/toast.dart';

import '../constants.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

/// Entrypoint example for registering via Email/Password.
class RegisterPage extends StatefulWidget {
  /// The page title.

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthMethods authmethods = new AuthMethods();
  UserDBMethods userdb = new UserDBMethods();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController pwTextController = TextEditingController();
  final TextEditingController pwTextController1 = TextEditingController();
  final TextEditingController usernameTextController = TextEditingController();

  QuerySnapshot allUsers;
  bool isloading = false;
  String _userEmail = '';
  bool isverified = false;
  bool membership = false;
  bool personal_info = false;

  String _now;
  Timer _everySecond;
  Timer checkverification;

  getAllUsers() async {
    return await FirebaseFirestore.instance.collection("Users").get();
  }

  void sendverification() async {
    await authmethods.signUpwithEmailandPassword(emailTextController.text, pwTextController.text).then(
      (value){authmethods.thisuser.sendEmailVerification();}
      );
  }

  void _register() async {
            Map<String, dynamic> userDataMap = {
              "username": usernameTextController.text,
              "useremail": emailTextController.text,
            };
            Toast.show(
              "회원가입 중...", 
              context, 
              duration: 1, 
              gravity: Toast.BOTTOM,
            );
            userdb.uploadUserInfo(userDataMap);
            Helperfunctions.saveUserLoggedInSharedPreference(true);
            Helperfunctions.saveUserEmailSharedPreference(emailTextController.text);
            Helperfunctions.saveUserNameSharedPreference(usernameTextController.text);
            Navigator.of(context).pushReplacementNamed('initialView');
            Toast.show(
              "회원가입 완료", 
              context, 
              duration: 1, 
              gravity: Toast.BOTTOM,
            );
    }

    @override
  void initState() {
    // TODO: implement initState
    getAllUsers().then((result){
      allUsers = result;
    });

  // sets first value
    _now = DateTime.now().second.toString();
    // defines a timer 
    _everySecond = Timer.periodic(Duration(seconds: 2), (Timer t) {
      setState(() {
        _now = DateTime.now().second.toString();
        if(isverified){
          _register();
        }
      });
    });

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
          '회원가입',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: (isloading)?
        FlatButton(
          child: Icon( 
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              isloading = false;              
            });
          },
        )
        :FlatButton(
          child: Icon( 
            Icons.home_outlined,
            color: Colors.white,
          ),
          onPressed: () async {
            //Navigator.pop(context);
            if(authmethods.thisuser !=null){
              await authmethods.thisuser.delete();
              dispose();
            }
            Navigator.pushReplacementNamed(context, 'initialView');
            
            },
        ),
      ),
      body: (isloading)? 
      Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                '해당 이메일 주소로 인증 이메일이 발송되었습니다.\n 이메일이 발송되지 않았다면 뒤로가기를 눌러 주소가 제대로 입력되었는지 다시 확인해주세요.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        ):
      SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 56,),
            Form(
                key: formKey,
                child: Container(
                  margin: EdgeInsets.all(25),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: AutoSizeText(
                            '* 아이디, 이메일, 비밀번호를 모두 입력하시고 이메일 인증을 진행해주세요',
                            style: TextStyle(
                              color: Colors.red
                            ),
                          ) ,
                        ),
                        TextFormField(
                          controller: usernameTextController,
                          decoration: const InputDecoration(
                            labelText: '아이디'
                          ),
                          validator: (String value) {
                            if (value.length>21) {
                              return '아이디 길이가 너무 깁니다.';
                            } else if(value.length<4){
                              return  '아이디가 너무 짧습니다';
                            }
                            for(int i=0;i<allUsers.docs.length;i++){
                              //print(allUsers.docs[i].get('username'));
                              if(allUsers.docs[i].get('username') == value){
                                return '이미 존재하는 아이디입니다';
                              }
                            }    
                            return null;
                            
                          },
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: TextFormField(
                                  controller: emailTextController,
                                  decoration: const InputDecoration(
                                    labelText: '이메일'
                                  ),
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return '이메일을 등록해주세요';
                                    }
                                    for(int i=0;i<allUsers.docs.length;i++){
                                      if(allUsers.docs[i].get('useremail') == value){
                                        return '이미 존재하는 이메일입니다';
                                      }
                                    }                      
                                    return null;
                                  },
                                ),
                              ),
                              /*Expanded(
                                flex: 2,
                                child: FlatButton(
                                  onPressed: (){
                                    if (formKey.currentState.validate()) {}
                                  },
                                  color: Colors.black,
                                  child: AutoSizeText(
                                    '중복확인',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )*/
                            ],
                          ),
                        ),
                        TextFormField(
                          controller: pwTextController,
                          decoration: const InputDecoration(labelText: '비밀번호'),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return '비밀번호를 등록해주세요';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        TextFormField(
                          controller: pwTextController1,
                          decoration: const InputDecoration(labelText: '비밀번호 확인'),
                          validator: (String value){
                            if (value.isEmpty) {
                              return '비밀번호를 등록해주세요';
                            }
                            if (value != pwTextController.text) {
                              return '비밀번호를 재확인해주세요';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        (isverified)? Container(
                          alignment: Alignment.center,
                          child: Center(
                            child: Row(
                            children: [
                              AutoSizeText('이메일 인증이 완료되었습니다', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                              Icon(Icons.verified_outlined, color: Colors.greenAccent,),
                            ],
                          )),
                        ):Container(),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: membership, 
                                    onChanged: (bool membership){
                                      setState(() {
                                        this.membership = membership;    
                                      });
                                    }),
                                    Container(
                                      child: AutoSizeText(
                                        '개인회원 이용약관 동의(필수)'
                                      ),
                                    )
                                ],
                              ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: personal_info, 
                                      onChanged: (bool personal_info){
                                        setState(() {
                                        this.personal_info = personal_info;    
                                      });
                                      }),
                                      Container(
                                          child: AutoSizeText(
                                            '개인정보 처리방침 동의(필수)'
                                          ),
                                        ),
                                  ],
                                )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          alignment: Alignment.center,
                          child: SignInButtonBuilder(
                            icon: Icons.person_add,
                            iconColor: Colors.white,
                            textColor: Colors.white,
                            backgroundColor: Colors.black,
                            onPressed: () async {
                              if (formKey.currentState.validate()) {
                              if(!isverified && membership && personal_info){
                                    Toast.show(
                                      "이메일 인증메일이 발송되었습니다.\n이메일을 확인해주세요.", 
                                      context, 
                                      duration: 2, 
                                      gravity: Toast.BOTTOM,
                                    );
                                      sendverification();
                                      setState(() {
                                        isloading = true;
                                        checkverification = Timer.periodic(Duration(seconds: 2), (timer) {
                                          authmethods.thisuser.reload();
                                          authmethods.auth.currentUser.reload();
                                          print(authmethods.auth.currentUser.emailVerified);
                                          if(authmethods.auth.currentUser.emailVerified){
                                            isverified = true;
                                          }
                                        });
                                      });                                
                              }else if(!membership && !personal_info){
                                Toast.show(
                                  "이용약관 및 개인정보 처리방침에 동의해주세요.", 
                                  context, 
                                  duration: 2, 
                                  gravity: Toast.BOTTOM,
                                );
                              }
                              }
                            },
                            text: '이메일 인증 및 회원가입',
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    emailTextController.dispose();
    pwTextController.dispose();
    usernameTextController.dispose();
    _everySecond.cancel();
    checkverification.cancel();

    super.dispose();
  }

  // Example code for registration.
}