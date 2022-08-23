import 'dart:math';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text;

  const CustomDialogBox({Key key, this.title, this.descriptions, this.text})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
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

  _launchURL() async {
    // 튜토리얼 영상이 있는 링크로 접속하게 해주는 버튼
    const videourl = 'https://cafe.naver.com/drchangvely/272';
    if (await canLaunch(videourl)) {
      await launch(videourl);
    } else {
      throw 'Could not launch $videourl';
    }
  }

  contentBox(context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 10),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                min(screenWidth * (1 / 15), screenHeight * (1 / 15)),
                min(screenWidth * (1 / 30), screenHeight * (1 / 30)),
                min(screenWidth * (1 / 15), screenHeight * (1 / 15)),
                min(screenWidth * (1 / 30), screenHeight * (1 / 30))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(
                      fontSize:
                          min(screenWidth * (1 / 30), screenHeight * (1 / 30)),
                      fontWeight: FontWeight.w600),
                ),
                // Container(
                //   // height: MediaQuery.of(context).size.height * 2 / 3,
                //   padding: EdgeInsets.all(5),
                //   alignment: Alignment.centerLeft,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       SizedBox(
                //         height: screenHeight * (1 / 20),
                //       ),
                //       Text(
                //         '안내사항: 점을 잘못 찍은 경우 왼쪽에 있는 뒤로 가기 버튼을 눌러 점을 다시 찍을 수 있습니다.',
                //         style: TextStyle(
                //             fontSize: min(screenWidth * (1 / 30),
                //                 screenHeight * (1 / 30)),
                //             color: Colors.black),
                //       ),
                //       SizedBox(
                //         height: screenHeight * (1 / 20),
                //       ),
                //       Text(
                //         '검사 방법',
                //         style: TextStyle(
                //             fontSize: min(screenWidth * (1 / 30),
                //                 screenHeight * (1 / 30)),
                //             color: Colors.black,
                //             fontWeight: FontWeight.bold),
                //       ),
                //       Text(
                //         '1. 아이의 코가 아래쪽으로 오도록 한 다음 머리 위에서 사진을 찍습니다.',
                //         style: TextStyle(
                //             fontSize: min(screenWidth * (1 / 30),
                //                 screenHeight * (1 / 30)),
                //             color: Colors.black),
                //       ),
                //       Text(
                //         '2. 오른쪽 아래 버튼을 눌러 찍은 사진을 고릅니다.',
                //         style: TextStyle(
                //             fontSize: min(screenWidth * (1 / 30),
                //                 screenHeight * (1 / 30)),
                //             color: Colors.black),
                //       ),
                //       Text(
                //         '3. 화면 상 아이의 양쪽 귀, 앞통수, 뒤통수에 점(총 4개의 점)을 찍습니다.',
                //         style: TextStyle(
                //             fontSize: min(screenWidth * (1 / 30),
                //                 screenHeight * (1 / 30)),
                //             color: Colors.black),
                //       ),
                //       Text(
                //         '4. 그리고 \'다음\' 버튼을 누른 후, X 자가 생성되면 X자와 머리의 끝부분이 교차하는 지점들에 또 각각 점(총 4개의 점)을 찍습니다.',
                //         style: TextStyle(
                //             fontSize: min(screenWidth * (1 / 30),
                //                 screenHeight * (1 / 30)),
                //             color: Colors.black),
                //       ),
                //       Text(
                //         '5. 마지막으로 점들을 모두 찍고 \'다음\' 버튼을 누르면 결과가 나옵니다.',
                //         style: TextStyle(
                //             fontSize: min(screenWidth * (1 / 30),
                //                 screenHeight * (1 / 30)),
                //             color: Colors.black),
                //       ),
                //       SizedBox(
                //         height: screenHeight * (1 / 20),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: screenHeight * (1 / 20),
                ),
                Padding(
                  // 파란색 "튜토리얼 영상 확인" 버튼
                  padding: const EdgeInsets.all(3.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: NeumorphicButton(
                      // margin: EdgeInsets.all(10),
                      style: NeumorphicStyle(
                        color: Colors.blueAccent,
                        depth: 3,
                        shadowDarkColor: Colors.grey,
                        shape: NeumorphicShape.convex,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(10)),
                      ),
                      onPressed: _launchURL,
                      child: Text(
                        // widget.text,
                        "튜토리얼 영상 확인",
                        style: TextStyle(
                            fontSize: min(screenWidth * (1 / 30),
                                screenHeight * (1 / 30)),
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
