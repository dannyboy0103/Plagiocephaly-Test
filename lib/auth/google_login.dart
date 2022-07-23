import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybabyskull/auth/authmethods.dart';
import 'package:mybabyskull/auth/shared_preferences.dart';
import 'package:mybabyskull/auth/user_db.dart';
import 'package:toast/toast.dart';

class GoogleLoginPage extends StatefulWidget {
  @override
  _GoogleLoginPageState createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController usernameEditor = new TextEditingController();
  QuerySnapshot allUsers;
  AuthMethods authMethods = new AuthMethods();

  getAllUsers() async {
    return await FirebaseFirestore.instance.collection("Users").get();
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllUsers().then((result) {
      allUsers = result;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text(
            '구글로 로그인',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          /*leading: FlatButton(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),*/
        ),
        body: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 56,
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                          key: formkey,
                          child: Card(
                            margin: EdgeInsets.all(25),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  TextFormField(
                                    controller: usernameEditor,
                                    decoration: const InputDecoration(
                                        labelText: '사용자 아이디 설정'),
                                    validator: (String value) {
                                      if (value.length > 40) {
                                        return '아이디 길이가 너무 깁니다.';
                                      } else if (value.length < 5) {
                                        return '아이디가 너무 짧습니다';
                                      }
                                      for (int i = 0;
                                          i < allUsers.docs.length;
                                          i++) {
                                        if (allUsers.docs[i].get('username') ==
                                            value) {
                                          return '이미 존재하는 아이디입니다';
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                  OutlineButton(
                                    //Google Login
                                    onPressed: () async {
                                      if (formkey.currentState.validate()) {
                                        Helperfunctions
                                            .saveUserNameSharedPreference(
                                                usernameEditor.text);
                                        String email = await Helperfunctions
                                            .getUserEmailSharedPreference();
                                        Map<String, dynamic> googleuserMap = {
                                          "username": usernameEditor.text,
                                          "useremail": email,
                                        };
                                        UserDBMethods()
                                            .uploadUserInfo(googleuserMap);
                                        Toast.show(
                                          "구글 계정으로 로그인 중...",
                                          context,
                                          duration: 1,
                                          gravity: Toast.BOTTOM,
                                        );
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                'initialView');
                                        Toast.show(
                                          "로그인 완료",
                                          context,
                                          duration: 1,
                                          gravity: Toast.BOTTOM,
                                        );
                                      }
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    highlightElevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image(
                                              image: AssetImage(
                                                  "assets/google_png.png"),
                                              height: 35.0),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
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
                                ],
                              ),
                            ),
                          )),
                    ]))));
  }
}
