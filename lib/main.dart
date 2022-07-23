import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mybabyskull/auth/forgot_pw.dart';
import 'package:mybabyskull/auth/google_login.dart';
import 'package:mybabyskull/blog/mobile_post_detail.dart';
import 'package:mybabyskull/mobile_mypage.dart';
import 'package:mybabyskull/pages/helmet_info_view.dart';
//import 'package:mybabyskull/pages/image_edit_view.dart';
//import 'package:mybabyskull/pages/result_view.dart';
import 'package:mybabyskull/pages/subproducts_info_view.dart';
import 'package:mybabyskull/blog/mobile_addblog_view.dart';
import 'package:mybabyskull/pages/tummytime_view.dart';
import 'package:mybabyskull/pageview_mobile/image_medicaltest.dart';
import 'package:mybabyskull/pageview_mobile/mobile_cure_method.dart';
import 'package:mybabyskull/pageview_mobile/mobile_hospitals_view.dart';
import 'package:mybabyskull/pageview_mobile/mobile_intro_view.dart';
import 'package:mybabyskull/blog/mobile_mainblog_view.dart';
import 'package:mybabyskull/pageview_mobile/rules.dart';
import 'auth/login.dart';
import 'auth/register.dart';
import 'pages/initial_view.dart';
import 'package:async/async.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        baseColor: Color(0xFFFFFFFF),
        lightSource: LightSource.topLeft,
        depth: 10,
      ),
      darkTheme: NeumorphicThemeData(
        baseColor: Color(0xFF3E3E3E),
        lightSource: LightSource.topLeft,
        depth: 6,
      ),
      debugShowCheckedModeBanner: false,
      title: '우리아기두상',
      // initialRoute: 'initialView',
      initialRoute: 'annotationView',
      routes: {
        'initialView': (context) => InitialView(), //첫홈페이지
        'loginView': (context) => LoginView(), //로그인 페이지
        'registerView': (context) => RegisterPage(), //회원가입 페이지
        //'imageEditView': (context) => ImageEditView(),
        //'/resultView': (context) => ResultView(), //사진진단 결과 페이지
        'curemethodView': (context) => CureMethodView(), //단계별 치료 설명 페이지
        'introView': (context) => WebsiteIntroView(),
        'helmetView': (context) => HelmetView(), //사두증 헬멧 페이지
        'tummyView': (context) => TummyView(), //터미타임 리스트
        'subproductView': (context) => SubproductsView(), //사두증 관련제품 리스트
        'hospitalView': (context) => HospitalView(), //병원 페이지
        'mainblogView': (context) => MainBlogView(), //게시글 첫 페이지
        'addblogView': (context) => AddBlogView(), //게시글 추가 페이지
        'annotationView': (context) => AnnotationView(), //사진진단 페이지
        'forgotpwView': (context) => Forgotpw(),
        //'googleloginPage': (context) => GoogleLoginPage(), //구글 유저 첫 방문시 사용자이름 설정
        //'mypageView': (context) => MyPage(),
        'rulesView': (context) => Rules()
      },
    );
  }
}
