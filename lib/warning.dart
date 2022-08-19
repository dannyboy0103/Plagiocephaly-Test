import 'dart:math';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:word_break_text/word_break_text.dart';

class CustomWarningBox extends StatefulWidget {
  final String title, descriptions, text;

  const CustomWarningBox({Key key, this.title, this.descriptions, this.text})
      : super(key: key);

  @override
  _CustomWarningBoxState createState() => _CustomWarningBoxState();
}

class _CustomWarningBoxState extends State<CustomWarningBox> {
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
                Container(
                  // height: MediaQuery.of(context).size.height * 2 / 3,
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight * (1 / 20),
                      ),
                      WordBreakText(
                        '이 검사 방법은 실제 사두증과 단두증의 비율을 재는 공식을 바탕으로 한 진단 방법으로 검사 방법의 정당성이 검증되어 있습니다.\n',
                        style: TextStyle(
                            fontSize: min(screenWidth * (1 / 30),
                                screenHeight * (1 / 30)),
                            color: Colors.black),
                      ),
                      WordBreakText(
                        '튜토리얼 참조하여 정확하게 점을 찍으시면 정밀한 결과를 확인하실 수 있습니다',
                        style: TextStyle(
                          fontSize: min(
                              screenWidth * (1 / 30), screenHeight * (1 / 30)),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * (1 / 20),
                      ),
                      Text(
                        '유의 사항\n',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: min(screenWidth * (1 / 30),
                                screenHeight * (1 / 30)),
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      WordBreakText(
                        '이 검사는 간단하게 아이의 두상을 확인해 보는 실험으로써 점 위치 선정의 정확성에 따라 검사 결과가 실제와 다르게 나올 수 있습니다.\n',
                        style: TextStyle(
                            fontSize: min(screenWidth * (1 / 30),
                                screenHeight * (1 / 30)),
                            color: Colors.black),
                      ),
                      WordBreakText(
                        '더 정밀한 검사를 위해서는 병원을 직접 방문해 주기 바랍니다',
                        style: TextStyle(
                            fontSize: min(screenWidth * (1 / 30),
                                screenHeight * (1 / 30)),
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: screenHeight * (1 / 20),
                      ),
                    ],
                  ),
                ),
                Padding(
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
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        widget.text,
                        style: TextStyle(
                            fontSize: min(screenWidth * (1 / 30),
                                screenHeight * (1 / 30)),
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    // child: FlatButton(
                    //     color: Colors.black,
                    //     onPressed: () {
                    //       Navigator.of(context).pop();
                    //     },
                    //     child: Padding(
                    //       padding: EdgeInsets.all(min(
                    //           screenWidth * (1 / 50), screenHeight * (1 / 50))),
                    //       child: AutoSizeText(
                    //         widget.text,
                    //         style: TextStyle(
                    //             fontSize: min(screenWidth * (1 / 30),
                    //                 screenHeight * (1 / 30)),
                    //             color: Colors.white,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //     )),
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
