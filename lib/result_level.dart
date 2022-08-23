import 'dart:math';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultLevelBox extends StatefulWidget {
  final String title, descriptions, text;

  const ResultLevelBox({Key key, this.title, this.descriptions, this.text})
      : super(key: key);

  @override
  _ResultLevelBoxState createState() => _ResultLevelBoxState();
}

class _ResultLevelBoxState extends State<ResultLevelBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var min30 = min(screenWidth * (1 / 30), screenHeight * (1 / 30));
    var min20 = min(screenWidth * (1 / 20), screenHeight * (1 / 20));
    var min10 = min(screenWidth * (1 / 10), screenHeight * (1 / 10));

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  // 창 닫기 "X" 버튼
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Image(
                height: screenHeight * (5 / 6),
                image: AssetImage(
                  // 사두증 단계별 치료 사진
                  'assets/result_img.png',
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: min10, vertical: min30),
              child: NeumorphicButton(
                // 파란색 "질문하기" 버튼
                style: NeumorphicStyle(
                  color: Colors.blueAccent,
                  depth: 3,
                  // shadowDarkColor: Colors.grey,
                  // shape: NeumorphicShape.convex,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(10),
                  ),
                ),
                onPressed: _launchURL,
                child: Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: min20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

_launchURL() async {
  // 카페로 연결해주는 링크
  const url = 'https://cafe.naver.com/drchangvely/14';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class Constants {
  Constants._();
  static const double padding = 10;
  static const double avatarRadius = 45;
}
