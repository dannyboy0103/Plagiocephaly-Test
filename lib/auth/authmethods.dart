import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mybabyskull/auth/shared_preferences.dart';
import 'package:mybabyskull/auth/user_db.dart';
import 'package:mybabyskull/auth/user_model.dart';
import 'package:toast/toast.dart';

class AuthMethods{
  final FirebaseAuth auth = FirebaseAuth.instance;
  User thisuser;
/*
  CUser userfromFirebaseUser (User user){
    return user != null ? CUser(
      userID: user.uid,
      useremail: user.email,
      phonenumber: user.phoneNumber,
      ) : null;
  }*/

  

  Future signUpwithEmailandPassword(String email, String pw) async {
    try{
      UserCredential result = await auth.createUserWithEmailAndPassword(email: email, password: pw);
      User user = result.user;
      thisuser = user;
      return user;
    } catch (e){
      return null;
    }
  }

  Future signInWithEmailandPassword(String email, String pw) async{
    try{
      UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: pw);
      User user = result.user;
      thisuser = user;
      return user;
    } catch (e) {
      return null;
    }
  }
  
  /*signInWithGoogle(BuildContext context) async {
    final GoogleSignIn _googleSignIn = new GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    /*final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );*/
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({
      'login_hint': 'user@example.com'
    });
    UserCredential result = await auth.signInWithPopup(googleProvider);
    User user = result.user;
    //if(result !=null){
      // ignore: unnecessary_statements
        //Helperfunctions.saveUserLoggedInSharedPreference(true);
        //Helperfunctions.saveUserEmailSharedPreference(user.email);
        //Helperfunctions.saveUserNameSharedPreference(user.email.replaceAll("@gmail.com", ""));
        //Map<String, dynamic> googleuserMap = {
        //  "username": user.email.replaceAll("@gmail.com", ""),
        //  "useremail": user.email,
        //};
        
        bool exist = false;
        String username="";
        QuerySnapshot allUsers = await FirebaseFirestore.instance.collection('Users').get();

        for(int i=0; i<allUsers.docs.length;i++){
          if(allUsers.docs[i].get('useremail') == user.email){
            exist = true;
            username = allUsers.docs[i].get('username');
          }
        }

        if(exist){
          Helperfunctions.saveUserLoggedInSharedPreference(true);
          Helperfunctions.saveUserEmailSharedPreference(user.email);
          Helperfunctions.saveUserNameSharedPreference(username);
          Navigator.of(context).pushReplacementNamed('initialView');
          Toast.show(
            "로그인 완료",
            context, 
                duration: 1,
                gravity: Toast.BOTTOM,
          );
        } else {
          Helperfunctions.saveUserLoggedInSharedPreference(true);
          Helperfunctions.saveUserEmailSharedPreference(user.email);
          //Helperfunctions.saveUserNameSharedPreference(user.email.replaceAll("@gmail.com", ""));
          
          Navigator.of(context).pushReplacementNamed('googleloginPage');
        }
        
        //return user;
      //} else{
        //return null;
      //}

  }*/

  Future signOut() async {
    try{
      return auth.signOut();
    } catch (e) {
      return null;
    }
  }
}