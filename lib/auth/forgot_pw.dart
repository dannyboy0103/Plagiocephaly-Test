import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:toast/toast.dart';

class Forgotpw extends StatefulWidget {

  @override
  _ForgotpwState createState() => _ForgotpwState();
}

class _ForgotpwState extends State<Forgotpw> {

  TextEditingController emailTextEditingController = new TextEditingController();
  final auth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: AutoSizeText(
          '비밀번호 찾기',
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
      body: Form(
        child: Card(
          margin: EdgeInsets.all(25),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
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
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: SignInButtonBuilder(
                    text: '이메일 발송',
                    icon: Icons.email_outlined,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    backgroundColor: Colors.black,
                    onPressed: () async {     
                      auth.sendPasswordResetEmail(email: emailTextEditingController.text);              
                      Toast.show(
                        "이메일이 발송되었습니다. 잠시만 기다려주세요.", 
                        context, 
                        duration: 2, 
                        gravity: Toast.BOTTOM,
                      );
                      Navigator.pop(context);
                        
                      }
                  ),
                ),
            ],),
          ),
        ),
      ),
    );
  }
}