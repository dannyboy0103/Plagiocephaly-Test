import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:mybabyskull/auth/authmethods.dart';
import 'package:mybabyskull/auth/shared_preferences.dart';
import 'package:mybabyskull/auth/user_db.dart';
import 'package:toast/toast.dart';

import '../constants.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  bool isloading = false;
  AuthMethods authmethods = new AuthMethods();
  UserDBMethods userdbmethods = new UserDBMethods();

  final formkey = GlobalKey<FormState>(); //key for the Form state manipulation
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController pwTextEditingController = new TextEditingController();
  
  void login() async {
    await authmethods.signInWithEmailandPassword(emailTextEditingController.text, pwTextEditingController.text).then(
      (result) async {
        if(result != null){
          QuerySnapshot current_user = await userdbmethods.getUserByEmail(emailTextEditingController.text);
          Helperfunctions.saveUserLoggedInSharedPreference(true);
          Helperfunctions.saveUserEmailSharedPreference(current_user.docs[0].get('useremail'));
          Helperfunctions.saveUserNameSharedPreference(current_user.docs[0].get('username'));
          Toast.show(
            "로그인 성공", 
            context, 
            duration: 1, 
            gravity: Toast.BOTTOM,
            );
            
          Navigator.of(context).pushReplacementNamed('initialView');
        } else {
          Toast.show(
            "아이디와 비밀번호가 맞지 않습니다.", 
            context, 
            duration: 1, 
            gravity: Toast.BOTTOM,
            );
            setState(() {
              isloading = false;
            });
        }
      }
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (isloading) ? AppBar(backgroundColor: Colors.white,):AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        title: Text(
          '로그인',
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
      ),
      body: (isloading)? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height-56,
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(height: 56,),
              Form(
                key: formkey,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: emailTextEditingController,
                        decoration: const InputDecoration(
                          labelText: '이메일'
                        ),
                        validator: (value){
                          return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)
                              ? null
                              : "맞지않는 이메일 형식";
                        },
                      ),
                      TextFormField(
                        controller: pwTextEditingController,
                        decoration: const InputDecoration(labelText: '비밀번호'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return '비밀번호를 등록해주세요';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextButton(
                          child: AutoSizeText('Forgot Password?'),
                          onPressed: (){
                            Navigator.pushNamed(context, 'forgotpwView');
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        alignment: Alignment.center,
                        child: SignInButtonBuilder(
                          icon: Icons.login,
                          iconColor: Colors.white,
                          textColor: Colors.white,
                          backgroundColor: Colors.black,
                          onPressed: () async {                   
                            if (formkey.currentState.validate()) {
                              setState(() {
                                isloading = true;
                              });
                              Toast.show(
                                "로그인 중입니다. 잠시만 기다려주세요.", 
                                context, 
                                duration: 2, 
                                gravity: Toast.BOTTOM,
                                );
                              login();
                              
                            }
                          },
                          text: '로그인',
                        ),
                      ),
                    ],
                  ),
                )
                ),

              
              /*OutlineButton(//Google Login
                onPressed: (){

                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                highlightElevation: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(image: AssetImage("google_png.png"), height: 35.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          '구글 계정으로 로그인',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              OutlineButton(//Google Login
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SignInPage()
                  ));
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                highlightElevation: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.phone),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          '전화번호로 로그인',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),*/
              
            ]
          ),
        ),
      ),
    );
  }
}